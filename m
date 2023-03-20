Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EA80C6C0E90
	for <lists+stable@lfdr.de>; Mon, 20 Mar 2023 11:20:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230113AbjCTKUG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Mar 2023 06:20:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57522 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230082AbjCTKT7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Mar 2023 06:19:59 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED23512BE1
        for <stable@vger.kernel.org>; Mon, 20 Mar 2023 03:19:57 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5A5C76133F
        for <stable@vger.kernel.org>; Mon, 20 Mar 2023 10:19:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 61AE1C433D2;
        Mon, 20 Mar 2023 10:19:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1679307596;
        bh=vfopX1iW8HZjLRZodgDgxQbMRRNBntRK1XiMei6Lvus=;
        h=Subject:To:Cc:From:Date:From;
        b=TQV8dkC5gl/ZAnDH904aYTjEcBhX94KgdRxmFE9wyGYV5UZivbWec2wj06daMTo4Q
         GqsukhMt03ho9P20y8LkvPtCI1+Yq28mmotD2eh+4Jm+XmUhOCkKdOxnCCNe+l0qgu
         EzU8ydcaB5IxtLE5JYDPZOPpqgPYCqgC/REj/9SM=
Subject: FAILED: patch "[PATCH] drm/amd/display: Remove OTG DIV register write for Virtual" failed to apply to 6.1-stable tree
To:     SyedSaaem.Rizvi@amd.com, Alvin.Lee2@amd.com, Samson.Tam@amd.com,
        alexander.deucher@amd.com, daniel.wheeler@amd.com,
        mario.limonciello@amd.com, qingqing.zhuo@amd.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 20 Mar 2023 11:19:53 +0100
Message-ID: <1679307593223218@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 6.1-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

To reproduce the conflict and resubmit, you may use the following commands:

git fetch https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/ linux-6.1.y
git checkout FETCH_HEAD
git cherry-pick -x 709671ffb15dcd1b4f6afe2a9d8c67c7c4ead4a1
# <resolve conflicts, build, test, etc.>
git commit -s
git send-email --to '<stable@vger.kernel.org>' --in-reply-to '1679307593223218@kroah.com' --subject-prefix 'PATCH 6.1.y' HEAD^..

Possible dependencies:

709671ffb15d ("drm/amd/display: Remove OTG DIV register write for Virtual signals.")
3b214bb7185d ("drm/amd/display: fix k1 k2 divider programming for phantom streams")
368307cef69c ("drm/amd/display: Include virtual signal to set k1 and k2 values")

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 709671ffb15dcd1b4f6afe2a9d8c67c7c4ead4a1 Mon Sep 17 00:00:00 2001
From: Saaem Rizvi <SyedSaaem.Rizvi@amd.com>
Date: Mon, 27 Feb 2023 18:55:07 -0500
Subject: [PATCH] drm/amd/display: Remove OTG DIV register write for Virtual
 signals.

[WHY]
Hot plugging and then hot unplugging leads to k1 and k2 values to
change, as signal is detected as a virtual signal on hot unplug. Writing
these values to OTG_PIXEL_RATE_DIV register might cause primary display
to blank (known hw bug).

[HOW]
No longer write k1 and k2 values to register if signal is virtual, we
have safe guards in place in the case that k1 and k2 is unassigned so
that an unknown value is not written to the register either.

Cc: stable@vger.kernel.org
Cc: Mario Limonciello <mario.limonciello@amd.com>
Reviewed-by: Samson Tam <Samson.Tam@amd.com>
Reviewed-by: Alvin Lee <Alvin.Lee2@amd.com>
Acked-by: Qingqing Zhuo <qingqing.zhuo@amd.com>
Signed-off-by: Saaem Rizvi <SyedSaaem.Rizvi@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>

diff --git a/drivers/gpu/drm/amd/display/dc/dcn32/dcn32_hwseq.c b/drivers/gpu/drm/amd/display/dc/dcn32/dcn32_hwseq.c
index 16f892125b6f..9d14045cccd6 100644
--- a/drivers/gpu/drm/amd/display/dc/dcn32/dcn32_hwseq.c
+++ b/drivers/gpu/drm/amd/display/dc/dcn32/dcn32_hwseq.c
@@ -1104,7 +1104,7 @@ unsigned int dcn32_calculate_dccg_k1_k2_values(struct pipe_ctx *pipe_ctx, unsign
 			*k2_div = PIXEL_RATE_DIV_BY_2;
 		else
 			*k2_div = PIXEL_RATE_DIV_BY_4;
-	} else if (dc_is_dp_signal(stream->signal) || dc_is_virtual_signal(stream->signal)) {
+	} else if (dc_is_dp_signal(stream->signal)) {
 		if (two_pix_per_container) {
 			*k1_div = PIXEL_RATE_DIV_BY_1;
 			*k2_div = PIXEL_RATE_DIV_BY_2;

