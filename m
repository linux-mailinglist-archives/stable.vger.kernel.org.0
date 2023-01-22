Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C9C6E677012
	for <lists+stable@lfdr.de>; Sun, 22 Jan 2023 16:28:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231470AbjAVP2N (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 22 Jan 2023 10:28:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56248 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231468AbjAVP2M (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 22 Jan 2023 10:28:12 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9400720074
        for <stable@vger.kernel.org>; Sun, 22 Jan 2023 07:28:11 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2F60760BC5
        for <stable@vger.kernel.org>; Sun, 22 Jan 2023 15:28:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 44198C433EF;
        Sun, 22 Jan 2023 15:28:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1674401290;
        bh=ACi9bGeE56MbxBD51EC2LeNKmPVen7QG8lIDUQ0sR+4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=G/D8EnHsDCnehDxjKixs9Vzm9QelAQK76q1Fn7spjRWmj7jDDQtkxvij8BRypnR9h
         wNSQUSl2cdvMO7yR8kVR+OSAAYmddoe5ALNJK6dFkY9u1cYtKu+vtFxXsUQUU170KW
         Oq45xNBAI5MHlDpMgnohSiUrQ6DAGhl7fZhSdv3s=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Lang Yu <Lang.Yu@amd.com>,
        Aaron Liu <aaron.liu@amd.com>,
        Yifan Zhang <yifan1.zhang@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.1 182/193] drm/amdgpu: correct MEC number for gfx11 APUs
Date:   Sun, 22 Jan 2023 16:05:11 +0100
Message-Id: <20230122150254.751370633@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230122150246.321043584@linuxfoundation.org>
References: <20230122150246.321043584@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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

From: Lang Yu <Lang.Yu@amd.com>

commit 0ddadc3a2208aedb1b27dbb76d0b4e722b5b527a upstream.

There is only one MEC on these APUs.

Signed-off-by: Lang Yu <Lang.Yu@amd.com>
Reviewed-by: Aaron Liu <aaron.liu@amd.com>
Reviewed-by: Yifan Zhang <yifan1.zhang@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org # 6.1.x
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/gfx_v11_0.c |   11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

--- a/drivers/gpu/drm/amd/amdgpu/gfx_v11_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/gfx_v11_0.c
@@ -1288,10 +1288,8 @@ static int gfx_v11_0_sw_init(void *handl
 
 	switch (adev->ip_versions[GC_HWIP][0]) {
 	case IP_VERSION(11, 0, 0):
-	case IP_VERSION(11, 0, 1):
 	case IP_VERSION(11, 0, 2):
 	case IP_VERSION(11, 0, 3):
-	case IP_VERSION(11, 0, 4):
 		adev->gfx.me.num_me = 1;
 		adev->gfx.me.num_pipe_per_me = 1;
 		adev->gfx.me.num_queue_per_pipe = 1;
@@ -1299,6 +1297,15 @@ static int gfx_v11_0_sw_init(void *handl
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


