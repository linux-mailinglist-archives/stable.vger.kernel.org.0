Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 935915480DD
	for <lists+stable@lfdr.de>; Mon, 13 Jun 2022 09:51:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232081AbiFMHtv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Jun 2022 03:49:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60808 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229875AbiFMHtu (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Jun 2022 03:49:50 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C6308AE78
        for <stable@vger.kernel.org>; Mon, 13 Jun 2022 00:49:48 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 86D85B80D7E
        for <stable@vger.kernel.org>; Mon, 13 Jun 2022 07:49:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D9AAAC34114;
        Mon, 13 Jun 2022 07:49:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655106586;
        bh=5Ej4W802Ooc1VS1YDrKGEGEPEbzH2w5hXPBq1bZzTGU=;
        h=Subject:To:Cc:From:Date:From;
        b=ciEPqhTCb4i78MOvpKplE3A3sGLZ/+3+U2sxFzPvv72OFRkFCHMZQ+cSCZSEITuyN
         p61EhGs1qg4KbK3DnBs7oA6is+LkF1+xmqioMWA68MH8VwqNtJVANdP2ICnvhGunKq
         h5dxyf5YPqcanQrZBn7Pfn4bzcVzg3+Rx7XlIhdM=
Subject: FAILED: patch "[PATCH] drm/amdkfd: Add GC 10.3.6 and 10.3.7 KFD definitions" failed to apply to 5.18-stable tree
To:     mario.limonciello@amd.com, Felix.Kuehling@amd.com,
        Jesse.Zhang@amd.com, alexander.deucher@amd.com, david.chang@amd.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 13 Jun 2022 09:49:43 +0200
Message-ID: <1655106583132253@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.18-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 7c4f4f197e0c5c93a70329627f17fcc5883f3593 Mon Sep 17 00:00:00 2001
From: Mario Limonciello <mario.limonciello@amd.com>
Date: Tue, 31 May 2022 18:56:41 -0500
Subject: [PATCH] drm/amdkfd: Add GC 10.3.6 and 10.3.7 KFD definitions

Loading amdgpu on GC 10.3.7 shows an ERR level message:
`kfd kfd: amdgpu: GC IP 0a0307 not supported in kfd`

Add these targets to match yellow carp structures.

Reported-by: David Chang <david.chang@amd.com>
Reviewed-by: Felix Kuehling <Felix.Kuehling@amd.com>
Tested-by: Jesse(Jie) Zhang <Jesse.Zhang@amd.com>
Signed-off-by: Mario Limonciello <mario.limonciello@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org # 5.18.x

diff --git a/drivers/gpu/drm/amd/amdkfd/kfd_crat.c b/drivers/gpu/drm/amd/amdkfd/kfd_crat.c
index 5e9adbc71bbd..cbfb32b3d235 100644
--- a/drivers/gpu/drm/amd/amdkfd/kfd_crat.c
+++ b/drivers/gpu/drm/amd/amdkfd/kfd_crat.c
@@ -1516,6 +1516,8 @@ static int kfd_fill_gpu_cache_info(struct kfd_dev *kdev,
 			num_of_cache_types = ARRAY_SIZE(beige_goby_cache_info);
 			break;
 		case IP_VERSION(10, 3, 3):
+		case IP_VERSION(10, 3, 6): /* TODO: Double check these on production silicon */
+		case IP_VERSION(10, 3, 7): /* TODO: Double check these on production silicon */
 			pcache_info = yellow_carp_cache_info;
 			num_of_cache_types = ARRAY_SIZE(yellow_carp_cache_info);
 			break;
diff --git a/drivers/gpu/drm/amd/amdkfd/kfd_device.c b/drivers/gpu/drm/amd/amdkfd/kfd_device.c
index 8667e3df2d0b..f8635e768513 100644
--- a/drivers/gpu/drm/amd/amdkfd/kfd_device.c
+++ b/drivers/gpu/drm/amd/amdkfd/kfd_device.c
@@ -73,6 +73,8 @@ static void kfd_device_info_set_sdma_info(struct kfd_dev *kfd)
 	case IP_VERSION(4, 1, 2):/* RENOIR */
 	case IP_VERSION(5, 2, 1):/* VANGOGH */
 	case IP_VERSION(5, 2, 3):/* YELLOW_CARP */
+	case IP_VERSION(5, 2, 6):/* GC 10.3.6 */
+	case IP_VERSION(5, 2, 7):/* GC 10.3.7 */
 	case IP_VERSION(6, 0, 1):
 		kfd->device_info.num_sdma_queues_per_engine = 2;
 		break;
@@ -127,6 +129,8 @@ static void kfd_device_info_set_event_interrupt_class(struct kfd_dev *kfd)
 	case IP_VERSION(9, 4, 2): /* ALDEBARAN */
 	case IP_VERSION(10, 3, 1): /* VANGOGH */
 	case IP_VERSION(10, 3, 3): /* YELLOW_CARP */
+	case IP_VERSION(10, 3, 6): /* GC 10.3.6 */
+	case IP_VERSION(10, 3, 7): /* GC 10.3.7 */
 	case IP_VERSION(10, 1, 3): /* CYAN_SKILLFISH */
 	case IP_VERSION(10, 1, 4):
 	case IP_VERSION(10, 1, 10): /* NAVI10 */
@@ -368,6 +372,16 @@ struct kfd_dev *kgd2kfd_probe(struct amdgpu_device *adev, bool vf)
 			if (!vf)
 				f2g = &gfx_v10_3_kfd2kgd;
 			break;
+		case IP_VERSION(10, 3, 6):
+			gfx_target_version = 100306;
+			if (!vf)
+				f2g = &gfx_v10_3_kfd2kgd;
+			break;
+		case IP_VERSION(10, 3, 7):
+			gfx_target_version = 100307;
+			if (!vf)
+				f2g = &gfx_v10_3_kfd2kgd;
+			break;
 		case IP_VERSION(11, 0, 0):
 			gfx_target_version = 110000;
 			f2g = &gfx_v11_kfd2kgd;

