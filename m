Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BAD9F676D24
	for <lists+stable@lfdr.de>; Sun, 22 Jan 2023 14:24:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229788AbjAVNYz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 22 Jan 2023 08:24:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50450 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229768AbjAVNYz (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 22 Jan 2023 08:24:55 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F0091A4BF
        for <stable@vger.kernel.org>; Sun, 22 Jan 2023 05:24:54 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3DD34B80AD2
        for <stable@vger.kernel.org>; Sun, 22 Jan 2023 13:24:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8DA99C433EF;
        Sun, 22 Jan 2023 13:24:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1674393891;
        bh=qZQMTDcOhiL+krP0DbyWVQhRLLqMrsYdp+lmdJDcOlc=;
        h=Subject:To:Cc:From:Date:From;
        b=CuTXu442D8Vd9trvp72GDrg8Vno6LYu5gVwLZTn5VmCrkaaBBub4VSSyBoviCbNWo
         2ctWdaMS6BvLcifsYbPanJrJSS7xrGqvq4re9whA0jeTd7jBUVkONxRwmKVGI0AYaV
         v7uLfC+9hou0kY6QmXmJB4qED6eSDr7IXeybYZFA=
Subject: FAILED: patch "[PATCH] drm/amdgpu: correct MEC number for gfx11 APUs" failed to apply to 6.1-stable tree
To:     Lang.Yu@amd.com, aaron.liu@amd.com, alexander.deucher@amd.com,
        yifan1.zhang@amd.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 22 Jan 2023 14:24:49 +0100
Message-ID: <167439388959240@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 6.1-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

Possible dependencies:

0ddadc3a2208 ("drm/amdgpu: correct MEC number for gfx11 APUs")

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 0ddadc3a2208aedb1b27dbb76d0b4e722b5b527a Mon Sep 17 00:00:00 2001
From: Lang Yu <Lang.Yu@amd.com>
Date: Wed, 11 Jan 2023 09:52:11 +0800
Subject: [PATCH] drm/amdgpu: correct MEC number for gfx11 APUs

There is only one MEC on these APUs.

Signed-off-by: Lang Yu <Lang.Yu@amd.com>
Reviewed-by: Aaron Liu <aaron.liu@amd.com>
Reviewed-by: Yifan Zhang <yifan1.zhang@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org # 6.1.x

diff --git a/drivers/gpu/drm/amd/amdgpu/gfx_v11_0.c b/drivers/gpu/drm/amd/amdgpu/gfx_v11_0.c
index a56c6e106d00..b9b57a66e113 100644
--- a/drivers/gpu/drm/amd/amdgpu/gfx_v11_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/gfx_v11_0.c
@@ -1287,10 +1287,8 @@ static int gfx_v11_0_sw_init(void *handle)
 
 	switch (adev->ip_versions[GC_HWIP][0]) {
 	case IP_VERSION(11, 0, 0):
-	case IP_VERSION(11, 0, 1):
 	case IP_VERSION(11, 0, 2):
 	case IP_VERSION(11, 0, 3):
-	case IP_VERSION(11, 0, 4):
 		adev->gfx.me.num_me = 1;
 		adev->gfx.me.num_pipe_per_me = 1;
 		adev->gfx.me.num_queue_per_pipe = 1;
@@ -1298,6 +1296,15 @@ static int gfx_v11_0_sw_init(void *handle)
 		adev->gfx.mec.num_pipe_per_mec = 4;
 		adev->gfx.mec.num_queue_per_pipe = 4;
 		break;
+	case IP_VERSION(11, 0, 1):
+	case IP_VERSION(11, 0, 4):
+		adev->gfx.me.num_me = 1;
+		adev->gfx.me.num_pipe_per_me = 1;
+		adev->gfx.me.num_queue_per_pipe = 1;
+		adev->gfx.mec.num_mec = 1;
+		adev->gfx.mec.num_pipe_per_mec = 4;
+		adev->gfx.mec.num_queue_per_pipe = 4;
+		break;
 	default:
 		adev->gfx.me.num_me = 1;
 		adev->gfx.me.num_pipe_per_me = 1;

