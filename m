Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EDE426EBA6B
	for <lists+stable@lfdr.de>; Sat, 22 Apr 2023 18:44:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229580AbjDVQoX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 22 Apr 2023 12:44:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54062 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229510AbjDVQoX (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 22 Apr 2023 12:44:23 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C9E81FE4
        for <stable@vger.kernel.org>; Sat, 22 Apr 2023 09:44:22 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 079CC6109E
        for <stable@vger.kernel.org>; Sat, 22 Apr 2023 16:44:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 03DD5C433EF;
        Sat, 22 Apr 2023 16:44:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1682181861;
        bh=6/12/gu+D0ggRq9byBNyUgo9UhRemWrTQucjKnHaIHE=;
        h=Subject:To:Cc:From:Date:From;
        b=C34kc/FyCkg4B33ltv06aGPamBZFGfTTbwfKeIKSBDFetLFCwZo4tkuC3d+4HKQUr
         FrThkPJgS2PDYGuYdE1ZV9m5EKWCn5dOUKlweRbIgVE22vm6MJlW1rsMFHPMSo3E6t
         KsKM535WNu6qfUy64d5iKrI71l0raccNNKNJYIZ8=
Subject: FAILED: patch "[PATCH] drm/amd/display: fix a divided-by-zero error" failed to apply to 6.2-stable tree
To:     alex.hung@amd.com, Aurabindo.Pillai@amd.com,
        alexander.deucher@amd.com, daniel.wheeler@amd.com,
        qingqing.zhuo@amd.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sat, 22 Apr 2023 18:44:10 +0200
Message-ID: <2023042210-apache-rally-cc5e@gregkh>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 6.2-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

To reproduce the conflict and resubmit, you may use the following commands:

git fetch https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/ linux-6.2.y
git checkout FETCH_HEAD
git cherry-pick -x 0b5dfe12755f87ec014bb4cc1930485026167430
# <resolve conflicts, build, test, etc.>
git commit -s
git send-email --to '<stable@vger.kernel.org>' --in-reply-to '2023042210-apache-rally-cc5e@gregkh' --subject-prefix 'PATCH 6.2.y' HEAD^..

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
 

