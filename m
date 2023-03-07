Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0E28F6AF2C8
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 19:56:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233506AbjCGS41 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 13:56:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35472 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233438AbjCGS4K (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 13:56:10 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 64D63A0F0A
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 10:43:39 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1FB466152E
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 18:43:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2758AC433D2;
        Tue,  7 Mar 2023 18:43:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678214613;
        bh=VtLbXyz5ye/mIhclWvS1u5cS2uo4WQHPs0l3+oy6/Ww=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eIT+r1ififmxN8nZ6N+tjgCIrT2bv1CFTiIbMFG74fIwSF968acWmEe4Pv2s+kBIJ
         KvFEcGGShiwJ1wQvo95f5XGx2btPkzm7/YoXTrD76coffo23LbzRJvfP88KcB8Bpyq
         BBKvnaZxsoshFZ/x+OChgKdShmAiyjHurhpzoZuA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Mavroudis Chatzilaridis <mavchatz@protonmail.com>,
        Jani Nikula <jani.nikula@intel.com>
Subject: [PATCH 6.1 879/885] drm/i915/quirks: Add inverted backlight quirk for HP 14-r206nv
Date:   Tue,  7 Mar 2023 18:03:33 +0100
Message-Id: <20230307170039.979333232@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170001.594919529@linuxfoundation.org>
References: <20230307170001.594919529@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mavroudis Chatzilaridis <mavchatz@protonmail.com>

commit 5e438bf7f9a1705ebcae5fa89cdbfbc6932a7871 upstream.

This laptop uses inverted backlight PWM. Thus, without this quirk,
backlight brightness decreases as the brightness value increases and
vice versa.

Closes: https://gitlab.freedesktop.org/drm/intel/-/issues/8013
Cc: stable@vger.kernel.org
Signed-off-by: Mavroudis Chatzilaridis <mavchatz@protonmail.com>
Reviewed-by: Jani Nikula <jani.nikula@intel.com>
Signed-off-by: Jani Nikula <jani.nikula@intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20230201184947.8835-1-mavchatz@protonmail.com
(cherry picked from commit 83e7d6fd330d413cb2064e680ffea91b0512a520)
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/i915/display/intel_quirks.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/gpu/drm/i915/display/intel_quirks.c
+++ b/drivers/gpu/drm/i915/display/intel_quirks.c
@@ -199,6 +199,8 @@ static struct intel_quirk intel_quirks[]
 	/* ECS Liva Q2 */
 	{ 0x3185, 0x1019, 0xa94d, quirk_increase_ddi_disabled_time },
 	{ 0x3184, 0x1019, 0xa94d, quirk_increase_ddi_disabled_time },
+	/* HP Notebook - 14-r206nv */
+	{ 0x0f31, 0x103c, 0x220f, quirk_invert_brightness },
 };
 
 void intel_init_quirks(struct drm_i915_private *i915)


