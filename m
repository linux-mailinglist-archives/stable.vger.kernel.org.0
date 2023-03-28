Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B02C96CC4B2
	for <lists+stable@lfdr.de>; Tue, 28 Mar 2023 17:07:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233890AbjC1PHa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Mar 2023 11:07:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46990 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233891AbjC1PHa (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 28 Mar 2023 11:07:30 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF0F5EB58
        for <stable@vger.kernel.org>; Tue, 28 Mar 2023 08:06:25 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 88DC261856
        for <stable@vger.kernel.org>; Tue, 28 Mar 2023 15:05:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 941A1C433D2;
        Tue, 28 Mar 2023 15:05:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1680015915;
        bh=OeeU9YgiFx8fz9MuFWqWfSigrs8q2ZzOsr+sISGjjM8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Cq3n87cN3LNR7sNiTgoZlXg6b+6IYymYd4rsbJ/n84mJ3w6qrb+BUz2hEKLo4nStK
         k087GXwIN8snWzdzLoRa1s9ZE87YU8c+DJV8yaQ6WdUuKX53So+xqmvHpz6TWzq8F2
         8Iv24IiBzQ1sTVFypc17+8GcBx5xgW9ggciyK5As=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Yifan Zhang <yifan1.zhang@amd.com>,
        Aaron Liu <aaron.liu@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        "Limonciello, Mario" <Mario.Limonciello@amd.com>
Subject: [PATCH 6.1 223/224] drm/amdkfd: add GC 11.0.4 KFD support
Date:   Tue, 28 Mar 2023 16:43:39 +0200
Message-Id: <20230328142626.579706827@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230328142617.205414124@linuxfoundation.org>
References: <20230328142617.205414124@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yifan Zhang <yifan1.zhang@amd.com>

commit 88c21c2b56aa21dd34290d43ada74033dc3bfe35 upstream.

Add initial support for GC 11.0.4 in KFD compute driver.

Signed-off-by: Yifan Zhang <yifan1.zhang@amd.com>
Reviewed-by: Aaron Liu <aaron.liu@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: "Limonciello, Mario" <Mario.Limonciello@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdkfd/kfd_crat.c   |    1 +
 drivers/gpu/drm/amd/amdkfd/kfd_device.c |    2 ++
 2 files changed, 3 insertions(+)

--- a/drivers/gpu/drm/amd/amdkfd/kfd_crat.c
+++ b/drivers/gpu/drm/amd/amdkfd/kfd_crat.c
@@ -1522,6 +1522,7 @@ int kfd_get_gpu_cache_info(struct kfd_de
 		case IP_VERSION(11, 0, 1):
 		case IP_VERSION(11, 0, 2):
 		case IP_VERSION(11, 0, 3):
+		case IP_VERSION(11, 0, 4):
 			num_of_cache_types =
 				kfd_fill_gpu_cache_info_from_gfx_config(kdev, *pcache_info);
 			break;
--- a/drivers/gpu/drm/amd/amdkfd/kfd_device.c
+++ b/drivers/gpu/drm/amd/amdkfd/kfd_device.c
@@ -154,6 +154,7 @@ static void kfd_device_info_set_event_in
 	case IP_VERSION(11, 0, 1):
 	case IP_VERSION(11, 0, 2):
 	case IP_VERSION(11, 0, 3):
+	case IP_VERSION(11, 0, 4):
 		kfd->device_info.event_interrupt_class = &event_interrupt_class_v11;
 		break;
 	default:
@@ -396,6 +397,7 @@ struct kfd_dev *kgd2kfd_probe(struct amd
 			f2g = &gfx_v11_kfd2kgd;
 			break;
 		case IP_VERSION(11, 0, 1):
+		case IP_VERSION(11, 0, 4):
 			gfx_target_version = 110003;
 			f2g = &gfx_v11_kfd2kgd;
 			break;


