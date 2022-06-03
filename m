Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9EED553D029
	for <lists+stable@lfdr.de>; Fri,  3 Jun 2022 20:01:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346134AbiFCR74 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 Jun 2022 13:59:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47556 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235650AbiFCR7T (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 3 Jun 2022 13:59:19 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 42D71580F0;
        Fri,  3 Jun 2022 10:55:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D3543611F3;
        Fri,  3 Jun 2022 17:55:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D5FF5C385A9;
        Fri,  3 Jun 2022 17:55:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654278917;
        bh=uf9pTjSuXYWYbCLXbCd0JbmrBplJSmfFzxTrZwwpggU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nEFqnQPi0+GO1XeIFKecPUC14YTQEqaDLfRmxwga+kYoQtGyXmm7QpWLNDYkrvutr
         mvExAJhBafkNlgKk9iG+Y0/BCweNvrdGmJwFavR8AFOTVgs+BtC1DR/EHMI72SSOix
         HZNP55fpxplCG94NZCyWc+F1L2cPDPCaVDrnL0aA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>
Subject: [PATCH 5.17 18/75] drm/i915: Fix -Wstringop-overflow warning in call to intel_read_wm_latency()
Date:   Fri,  3 Jun 2022 19:43:02 +0200
Message-Id: <20220603173822.265865290@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220603173821.749019262@linuxfoundation.org>
References: <20220603173821.749019262@linuxfoundation.org>
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
@@ -2876,7 +2876,7 @@ static void ilk_compute_wm_level(const s
 }
 
 static void intel_read_wm_latency(struct drm_i915_private *dev_priv,
-				  u16 wm[8])
+				  u16 wm[])
 {
 	struct intel_uncore *uncore = &dev_priv->uncore;
 


