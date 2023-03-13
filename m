Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C36BA6B7451
	for <lists+stable@lfdr.de>; Mon, 13 Mar 2023 11:40:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230141AbjCMKkJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Mar 2023 06:40:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53294 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230164AbjCMKkG (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Mar 2023 06:40:06 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD4032A983
        for <stable@vger.kernel.org>; Mon, 13 Mar 2023 03:39:48 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7B330B80FE1
        for <stable@vger.kernel.org>; Mon, 13 Mar 2023 10:39:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E14BDC433D2;
        Mon, 13 Mar 2023 10:39:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678703986;
        bh=ZMiwAr9ki2f0u07WVjTNLKYVlNvFjCIoZ+yKGMV3phU=;
        h=Subject:To:Cc:From:Date:From;
        b=Fc5wWydWZgHU1KcOENvviSTaMWEwpjHMfUiorabCz2z1LgSVQ5+fewt1RHv2HsUK5
         s75hnSNRm52MXiJEVTGIgY7YZlmejwvoeUJIedo/lXwAW6VLLHHpm9UbMxSor+hybX
         UZ4p6l0FdOr2Mpvk17bYWxdoYVc+OyM3QFGKEIpg=
Subject: FAILED: patch "[PATCH] drm/amdgpu/soc21: Add video cap query support for VCN_4_0_4" failed to apply to 6.1-stable tree
To:     veerabadhran.gopalakrishnan@amd.com, alexander.deucher@amd.com,
        leo.liu@amd.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 13 Mar 2023 11:39:43 +0100
Message-ID: <167870398310479@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
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
git cherry-pick -x 6ce2ea07c5ff0a8188eab0e5cd1f0e4899b36835
# <resolve conflicts, build, test, etc.>
git commit -s
git send-email --to '<stable@vger.kernel.org>' --in-reply-to '167870398310479@kroah.com' --subject-prefix 'PATCH 6.1.y' HEAD^..

Possible dependencies:

6ce2ea07c5ff ("drm/amdgpu/soc21: Add video cap query support for VCN_4_0_4")
a6de636eb04f ("drm/amdgpu/soc21: don't expose AV1 if VCN0 is harvested")

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 6ce2ea07c5ff0a8188eab0e5cd1f0e4899b36835 Mon Sep 17 00:00:00 2001
From: Veerabadhran Gopalakrishnan <veerabadhran.gopalakrishnan@amd.com>
Date: Wed, 8 Mar 2023 19:33:53 +0530
Subject: [PATCH] drm/amdgpu/soc21: Add video cap query support for VCN_4_0_4

Added the video capability query support for VCN version 4_0_4

Signed-off-by: Veerabadhran Gopalakrishnan <veerabadhran.gopalakrishnan@amd.com>
Reviewed-by: Leo Liu <leo.liu@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org # 6.1.x

diff --git a/drivers/gpu/drm/amd/amdgpu/soc21.c b/drivers/gpu/drm/amd/amdgpu/soc21.c
index 9df2236007ab..061793d390cc 100644
--- a/drivers/gpu/drm/amd/amdgpu/soc21.c
+++ b/drivers/gpu/drm/amd/amdgpu/soc21.c
@@ -111,6 +111,7 @@ static int soc21_query_video_codecs(struct amdgpu_device *adev, bool encode,
 	switch (adev->ip_versions[UVD_HWIP][0]) {
 	case IP_VERSION(4, 0, 0):
 	case IP_VERSION(4, 0, 2):
+	case IP_VERSION(4, 0, 4):
 		if (adev->vcn.harvest_config & AMDGPU_VCN_HARVEST_VCN0) {
 			if (encode)
 				*codecs = &vcn_4_0_0_video_codecs_encode_vcn1;

