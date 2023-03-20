Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1EE896C1947
	for <lists+stable@lfdr.de>; Mon, 20 Mar 2023 16:32:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232987AbjCTPcY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Mar 2023 11:32:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48002 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232953AbjCTPcI (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Mar 2023 11:32:08 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD13D34C12
        for <stable@vger.kernel.org>; Mon, 20 Mar 2023 08:24:43 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0E381B80EC8
        for <stable@vger.kernel.org>; Mon, 20 Mar 2023 15:24:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7877EC433EF;
        Mon, 20 Mar 2023 15:24:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1679325879;
        bh=S2MT7GtQ5vxVYcNEXhKtOQ0OEdGKzxFto8a3NzbudZk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PquRr+uZU4NStMwUKjgEvuvphlKjDxsHckTXOiEPZHdgPVhY4BV1J7yzD9ef+1vGQ
         AuIcngaOEmDs/+2XjuIy4syf9NxxKceFh92l51ZI15Kc8DND+ukgH3xWEafzgJHYoW
         8qS8NpkRv3d2bbB4uWifvQ2SBrtjtMqfO966EBgo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Tim Huang <tim.huang@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.1 161/198] drm/amd/pm: bump SMU 13.0.4 driver_if header version
Date:   Mon, 20 Mar 2023 15:54:59 +0100
Message-Id: <20230320145514.285756184@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230320145507.420176832@linuxfoundation.org>
References: <20230320145507.420176832@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tim Huang <tim.huang@amd.com>

commit ab9bdb1213b4b40942af6a383f555d0c14874c1b upstream.

Align the SMU driver interface version with PMFW to
suppress the version mismatch message on driver loading.

Signed-off-by: Tim Huang <tim.huang@amd.com>
Reviewed-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org # 6.1.x
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/pm/swsmu/inc/pmfw_if/smu13_driver_if_v13_0_4.h |    4 ++--
 drivers/gpu/drm/amd/pm/swsmu/inc/smu_v13_0.h                       |    2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

--- a/drivers/gpu/drm/amd/pm/swsmu/inc/pmfw_if/smu13_driver_if_v13_0_4.h
+++ b/drivers/gpu/drm/amd/pm/swsmu/inc/pmfw_if/smu13_driver_if_v13_0_4.h
@@ -27,7 +27,7 @@
 // *** IMPORTANT ***
 // SMU TEAM: Always increment the interface version if
 // any structure is changed in this file
-#define PMFW_DRIVER_IF_VERSION 7
+#define PMFW_DRIVER_IF_VERSION 8
 
 typedef struct {
   int32_t value;
@@ -198,7 +198,7 @@ typedef struct {
   uint16_t SkinTemp;
   uint16_t DeviceState;
   uint16_t CurTemp;                     //[centi-Celsius]
-  uint16_t spare2;
+  uint16_t FilterAlphaValue;
 
   uint16_t AverageGfxclkFrequency;
   uint16_t AverageFclkFrequency;
--- a/drivers/gpu/drm/amd/pm/swsmu/inc/smu_v13_0.h
+++ b/drivers/gpu/drm/amd/pm/swsmu/inc/smu_v13_0.h
@@ -29,7 +29,7 @@
 #define SMU13_DRIVER_IF_VERSION_YELLOW_CARP 0x04
 #define SMU13_DRIVER_IF_VERSION_ALDE 0x08
 #define SMU13_DRIVER_IF_VERSION_SMU_V13_0_0_0 0x37
-#define SMU13_DRIVER_IF_VERSION_SMU_V13_0_4 0x07
+#define SMU13_DRIVER_IF_VERSION_SMU_V13_0_4 0x08
 #define SMU13_DRIVER_IF_VERSION_SMU_V13_0_5 0x04
 #define SMU13_DRIVER_IF_VERSION_SMU_V13_0_0_10 0x32
 #define SMU13_DRIVER_IF_VERSION_SMU_V13_0_7 0x37


