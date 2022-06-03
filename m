Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0173C53CF81
	for <lists+stable@lfdr.de>; Fri,  3 Jun 2022 19:55:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239163AbiFCRxr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 Jun 2022 13:53:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46606 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346691AbiFCRv1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 3 Jun 2022 13:51:27 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ABF3E57157;
        Fri,  3 Jun 2022 10:49:11 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2D76E60F84;
        Fri,  3 Jun 2022 17:49:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D63CC385A9;
        Fri,  3 Jun 2022 17:49:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654278550;
        bh=DMacl7IqcY9xhZ6LfYAKsMrAmHpww3Czq1nsjIJ4w0g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QrxZztDQ/l4P6j3vBQ4Hn/G9ArFOz8dZ7vJwu1rqNAaAbPXOpkriNFIywQsAZFVLH
         ps75ECE+7jrki1FHtaUIg5majGpTvV8sLwQ06Q5vGxDYqYgXojFX1WHnqJHR9Gu82F
         x6O3dUaO9xNp7/vMh8C5nY+b49pKcrbJyoh/FZTg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>
Subject: [PATCH 5.15 16/66] drm/i915: Fix -Wstringop-overflow warning in call to intel_read_wm_latency()
Date:   Fri,  3 Jun 2022 19:42:56 +0200
Message-Id: <20220603173821.132147840@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220603173820.663747061@linuxfoundation.org>
References: <20220603173820.663747061@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Gustavo A. R. Silva <gustavoars@kernel.org>

commit 336feb502a715909a8136eb6a62a83d7268a353b upstream.

Fix the following -Wstringop-overflow warnings when building with GCC-11:

drivers/gpu/drm/i915/intel_pm.c:3106:9: warning: ‘intel_read_wm_latency’ accessing 16 bytes in a region of size 10 [-Wstringop-overflow=]
 3106 |         intel_read_wm_latency(dev_priv, dev_priv->wm.pri_latency);
      |         ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
drivers/gpu/drm/i915/intel_pm.c:3106:9: note: referencing argument 2 of type ‘u16 *’ {aka ‘short unsigned int *’}
drivers/gpu/drm/i915/intel_pm.c:2861:13: note: in a call to function ‘intel_read_wm_latency’
 2861 | static void intel_read_wm_latency(struct drm_i915_private *dev_priv,
      |             ^~~~~~~~~~~~~~~~~~~~~

by removing the over-specified array size from the argument declarations.

It seems that this code is actually safe because the size of the
array depends on the hardware generation, and the function checks
for that.

Notice that wm can be an array of 5 elements:
drivers/gpu/drm/i915/intel_pm.c:3109:   intel_read_wm_latency(dev_priv, dev_priv->wm.pri_latency);

or an array of 8 elements:
drivers/gpu/drm/i915/intel_pm.c:3131:   intel_read_wm_latency(dev_priv, dev_priv->wm.skl_latency);

and the compiler legitimately complains about that.

This helps with the ongoing efforts to globally enable
-Wstringop-overflow.

Link: https://github.com/KSPP/linux/issues/181
Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/i915/intel_pm.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/gpu/drm/i915/intel_pm.c
+++ b/drivers/gpu/drm/i915/intel_pm.c
@@ -2863,7 +2863,7 @@ static void ilk_compute_wm_level(const s
 }
 
 static void intel_read_wm_latency(struct drm_i915_private *dev_priv,
-				  u16 wm[8])
+				  u16 wm[])
 {
 	struct intel_uncore *uncore = &dev_priv->uncore;
 


