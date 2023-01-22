Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 261EA676FE8
	for <lists+stable@lfdr.de>; Sun, 22 Jan 2023 16:26:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231425AbjAVP0a (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 22 Jan 2023 10:26:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54708 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231423AbjAVP03 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 22 Jan 2023 10:26:29 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AEB6822A28
        for <stable@vger.kernel.org>; Sun, 22 Jan 2023 07:26:28 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 459FA60C60
        for <stable@vger.kernel.org>; Sun, 22 Jan 2023 15:26:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 58636C433D2;
        Sun, 22 Jan 2023 15:26:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1674401187;
        bh=7iYNBw+UoGsVUwdthnKw5/xH26yi0/Y0uhcIv7WOqZg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UR5lCE841xUC0f6X9bjV7U0qId9uGb4NpcZkNw1xFCtyVp6dzOQZDVLpj+LDY4GFP
         qBHutdeL57sZfKKMSSbBEv/Sh1yHJNBX2QceYUBitjmKlSC00IGc5cxr+4ZNJ4jC14
         S+EO5sLD4tbltzInO6S1NgEOIJtx6c0QLAcXtz6U=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, roman.li@amd.com, yifan1.zhang@amd.com,
        =?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.1 144/193] drm/amd/display: disable S/G display on DCN 3.1.5
Date:   Sun, 22 Jan 2023 16:04:33 +0100
Message-Id: <20230122150252.963432735@linuxfoundation.org>
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

From: Alex Deucher <alexander.deucher@amd.com>

commit e78cc6a4c7486f50c2786d91dd7d9649a87d1dcb upstream.

Causes flickering or white screens in some configurations.
Disable it for now until we can fix the issue.

Bug: https://gitlab.freedesktop.org/drm/amd/-/issues/2354
Cc: roman.li@amd.com
Cc: yifan1.zhang@amd.com
Acked-by: Christian König <christian.koenig@amd.com>
Reviewed-by: Yifan Zhang <yifan1.zhang@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org # 6.1.x
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c |    1 -
 1 file changed, 1 deletion(-)

--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
@@ -1513,7 +1513,6 @@ static int amdgpu_dm_init(struct amdgpu_
 		case IP_VERSION(3, 1, 2):
 		case IP_VERSION(3, 1, 3):
 		case IP_VERSION(3, 1, 4):
-		case IP_VERSION(3, 1, 5):
 		case IP_VERSION(3, 1, 6):
 			init_data.flags.gpu_vm_support = true;
 			break;


