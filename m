Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 307D969447B
	for <lists+stable@lfdr.de>; Mon, 13 Feb 2023 12:29:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229941AbjBML34 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Feb 2023 06:29:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40436 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231270AbjBML3y (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Feb 2023 06:29:54 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B721B35A1
        for <stable@vger.kernel.org>; Mon, 13 Feb 2023 03:29:53 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 692B0B81197
        for <stable@vger.kernel.org>; Mon, 13 Feb 2023 11:29:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AEF86C4339C;
        Mon, 13 Feb 2023 11:29:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1676287791;
        bh=VKGpBN1z4cov/LXFxtnWA7/La1tKMqNXdEhhptVoFWs=;
        h=Subject:To:Cc:From:Date:From;
        b=BTVOUBM7fU49eG7dc4ZaHJ54zjIUJZTvujSIgLioIqP2yqTLcGglWFqIbF2GZZiDF
         8pQStjjzVRkxeGjp4i2SL7NgKVy8w8aW8MMvnU869bfc3TCdDlUad2Pu7PNrjureq0
         aGEwhigDc9lrOF4CbIxWJBwfkk1Jq3rU4Q36Umj0=
Subject: FAILED: patch "[PATCH] Revert "drm/amd/display: disable S/G display on DCN 3.1.4"" failed to apply to 6.1-stable tree
To:     alexander.deucher@amd.com, yifan1.zhang@amd.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 13 Feb 2023 12:29:48 +0100
Message-ID: <16762877882487@kroah.com>
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

Possible dependencies:

7ece674cd946 ("Revert "drm/amd/display: disable S/G display on DCN 3.1.4"")
077e9659581a ("drm/amd/display: disable S/G display on DCN 3.1.2/3")
a52287d66dfa ("drm/amd/display: disable S/G display on DCN 3.1.4")
e78cc6a4c748 ("drm/amd/display: disable S/G display on DCN 3.1.5")
fe6872adb05e ("drm/amd/display: Add DCN314 display SG Support")

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 7ece674cd9468ce740494f6108c39831cfc7eb4e Mon Sep 17 00:00:00 2001
From: Alex Deucher <alexander.deucher@amd.com>
Date: Tue, 31 Jan 2023 13:10:55 -0500
Subject: [PATCH] Revert "drm/amd/display: disable S/G display on DCN 3.1.4"

This reverts commit 9aa15370819294beb7eb67c9dcbf654d79ff8790.

This is fixed now so we can re-enable S/G display on DCN
3.1.4.

Reviewed-by: Yifan Zhang <yifan1.zhang@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org # 6.1.x

diff --git a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
index 7f6e27561899..78452856b2a3 100644
--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
@@ -1514,6 +1514,7 @@ static int amdgpu_dm_init(struct amdgpu_device *adev)
 				init_data.flags.gpu_vm_support = true;
 			break;
 		case IP_VERSION(3, 0, 1):
+		case IP_VERSION(3, 1, 4):
 		case IP_VERSION(3, 1, 6):
 			init_data.flags.gpu_vm_support = true;
 			break;

