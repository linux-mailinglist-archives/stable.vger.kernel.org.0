Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3FAC26EBA69
	for <lists+stable@lfdr.de>; Sat, 22 Apr 2023 18:44:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229555AbjDVQoT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 22 Apr 2023 12:44:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54034 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229510AbjDVQoS (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 22 Apr 2023 12:44:18 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E3A4212D
        for <stable@vger.kernel.org>; Sat, 22 Apr 2023 09:44:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3955C6109E
        for <stable@vger.kernel.org>; Sat, 22 Apr 2023 16:44:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 463AEC433EF;
        Sat, 22 Apr 2023 16:44:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1682181855;
        bh=iZKTAWrz3y6IMOJdSt8tmLEgjWZFe26fMAsay3ey8+w=;
        h=Subject:To:Cc:From:Date:From;
        b=vLFP0WFigrSQ06y+DkGDvWVO4D6/tloojOrcKF0jz3liZQJcVRwwbndRppjsEo8K0
         MKTXTgBgqA3PvTOueII5/xsM5z6GE/dkehIIaYbA8b8RR9ghyVZqJu0KVk+JPNoTot
         4JnnG6uL+mgJECZNnAhg7suz4+dl+fuDFJ0iXToI=
Subject: FAILED: patch "[PATCH] drm/amd/display: fix a divided-by-zero error" failed to apply to 6.1-stable tree
To:     alex.hung@amd.com, Aurabindo.Pillai@amd.com,
        alexander.deucher@amd.com, daniel.wheeler@amd.com,
        qingqing.zhuo@amd.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sat, 22 Apr 2023 18:44:09 +0200
Message-ID: <2023042209-scuff-accustom-83bb@gregkh>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
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
git cherry-pick -x 0b5dfe12755f87ec014bb4cc1930485026167430
# <resolve conflicts, build, test, etc.>
git commit -s
git send-email --to '<stable@vger.kernel.org>' --in-reply-to '2023042209-scuff-accustom-83bb@gregkh' --subject-prefix 'PATCH 6.1.y' HEAD^..

Possible dependencies:

0b5dfe12755f ("drm/amd/display: fix a divided-by-zero error")
13b90cf900ab ("drm/amd/display: fix PSR-SU/DSC interoperability support")

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 0b5dfe12755f87ec014bb4cc1930485026167430 Mon Sep 17 00:00:00 2001
From: Alex Hung <alex.hung@amd.com>
Date: Mon, 3 Apr 2023 17:45:41 +0800
Subject: [PATCH] drm/amd/display: fix a divided-by-zero error

[Why & How]

timing.dsc_cfg.num_slices_v can be zero and it is necessary to check
before using it.

This fixes the error "divide error: 0000 [#1] PREEMPT SMP NOPTI".

Reviewed-by: Aurabindo Pillai <Aurabindo.Pillai@amd.com>
Acked-by: Qingqing Zhuo <qingqing.zhuo@amd.com>
Signed-off-by: Alex Hung <alex.hung@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org

diff --git a/drivers/gpu/drm/amd/display/modules/power/power_helpers.c b/drivers/gpu/drm/amd/display/modules/power/power_helpers.c
index e39b133d05af..b56f07f99d09 100644
--- a/drivers/gpu/drm/amd/display/modules/power/power_helpers.c
+++ b/drivers/gpu/drm/amd/display/modules/power/power_helpers.c
@@ -934,6 +934,10 @@ bool psr_su_set_dsc_slice_height(struct dc *dc, struct dc_link *link,
 
 	pic_height = stream->timing.v_addressable +
 		stream->timing.v_border_top + stream->timing.v_border_bottom;
+
+	if (stream->timing.dsc_cfg.num_slices_v == 0)
+		return false;
+
 	slice_height = pic_height / stream->timing.dsc_cfg.num_slices_v;
 	config->dsc_slice_height = slice_height;
 

