Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6A4CC579E5F
	for <lists+stable@lfdr.de>; Tue, 19 Jul 2022 15:01:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243305AbiGSNA4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Jul 2022 09:00:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40370 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242662AbiGSM7X (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 19 Jul 2022 08:59:23 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A3DD349B66;
        Tue, 19 Jul 2022 05:24:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 32A5261921;
        Tue, 19 Jul 2022 12:24:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD314C341D5;
        Tue, 19 Jul 2022 12:24:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1658233456;
        bh=rO+12WaTA7CEK346tI4sccEoEMeXEJJq6yWPr6caLSA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=B5v/E3FpdbmQOMcKgUTmbBm2jzgS9rxQzN328ijse26cQMyMWv9KHFcQLf/rIQDdN
         IZ6eKBxjErScUz2ktug/b5u6vXtw/YcwOC+C9BH+JsY9EWPRwKffMNyTMvQHhV7RgX
         DcvmX1acreUNKvC0P1BtRTJtl1l05LCaeUQ0OuEs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Prike Liang <Prike.Liang@amd.com>,
        Aaron Liu <aaron.liu@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 129/231] drm/amdkfd: correct the MEC atomic support firmware checking for GC 10.3.7
Date:   Tue, 19 Jul 2022 13:53:34 +0200
Message-Id: <20220719114725.304038043@linuxfoundation.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220719114714.247441733@linuxfoundation.org>
References: <20220719114714.247441733@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Prike Liang <Prike.Liang@amd.com>

[ Upstream commit c0044865480a162146b9dfe7783e73a08e97b2b9 ]

On the GC 10.3.7 platform the initial MEC release version #3 can support
atomic operation,so need correct and set its MEC atomic support version to #3.

Signed-off-by: Prike Liang <Prike.Liang@amd.com>
Reviewed-by: Aaron Liu <aaron.liu@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org # 5.18.x
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdkfd/kfd_device.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/gpu/drm/amd/amdkfd/kfd_device.c b/drivers/gpu/drm/amd/amdkfd/kfd_device.c
index 651498bfecc8..2059c3138410 100644
--- a/drivers/gpu/drm/amd/amdkfd/kfd_device.c
+++ b/drivers/gpu/drm/amd/amdkfd/kfd_device.c
@@ -158,6 +158,8 @@ static void kfd_device_info_init(struct kfd_dev *kfd,
 			/* Navi2x+, Navi1x+ */
 			if (gc_version == IP_VERSION(10, 3, 6))
 				kfd->device_info.no_atomic_fw_version = 14;
+			else if (gc_version == IP_VERSION(10, 3, 7))
+				kfd->device_info.no_atomic_fw_version = 3;
 			else if (gc_version >= IP_VERSION(10, 3, 0))
 				kfd->device_info.no_atomic_fw_version = 92;
 			else if (gc_version >= IP_VERSION(10, 1, 1))
-- 
2.35.1



