Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AE022579C51
	for <lists+stable@lfdr.de>; Tue, 19 Jul 2022 14:38:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240987AbiGSMij (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Jul 2022 08:38:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40578 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241021AbiGSMiK (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 19 Jul 2022 08:38:10 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D18A48E93;
        Tue, 19 Jul 2022 05:14:41 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id CC9DEB81B2E;
        Tue, 19 Jul 2022 12:14:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 36AA5C341C6;
        Tue, 19 Jul 2022 12:14:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1658232879;
        bh=O9al60/sdL+jit1M+gf1vVMmjpTVz41snS5/sD9cFeg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sTVqRMrGbc87JV2s2PHydEd8YbDqAI7lZrnVy/L4vi5zd6vX6CStLuIejP9/Am1hk
         MWMdYY3lrIHPG16nM/4bcXBvWpEm7jPmifjNTNF7zIEPNExVnUeKt75Cs1B4uYQFse
         IKvI746Kam+efDTLYfd0NGVEX9uebXc9BxZRI13M=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Evan Quan <evan.quan@amd.com>,
        =?UTF-8?q?Andr=C3=A9=20Almeida?= <andrealmeid@igalia.com>,
        Yefim Barashkin <mr.b34r@kolabnow.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 098/167] drm/amd/pm: Prevent divide by zero
Date:   Tue, 19 Jul 2022 13:53:50 +0200
Message-Id: <20220719114705.929728889@linuxfoundation.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220719114656.750574879@linuxfoundation.org>
References: <20220719114656.750574879@linuxfoundation.org>
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

From: Yefim Barashkin <mr.b34r@kolabnow.com>

[ Upstream commit 0638c98c17aa12fe914459c82cd178247e21fb2b ]

divide error: 0000 [#1] SMP PTI
CPU: 3 PID: 78925 Comm: tee Not tainted 5.15.50-1-lts #1
Hardware name: MSI MS-7A59/Z270 SLI PLUS (MS-7A59), BIOS 1.90 01/30/2018
RIP: 0010:smu_v11_0_set_fan_speed_rpm+0x11/0x110 [amdgpu]

Speed is user-configurable through a file.
I accidentally set it to zero, and the driver crashed.

Reviewed-by: Evan Quan <evan.quan@amd.com>
Reviewed-by: André Almeida <andrealmeid@igalia.com>
Signed-off-by: Yefim Barashkin <mr.b34r@kolabnow.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/pm/swsmu/smu11/smu_v11_0.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/gpu/drm/amd/pm/swsmu/smu11/smu_v11_0.c b/drivers/gpu/drm/amd/pm/swsmu/smu11/smu_v11_0.c
index e6c93396434f..614c3d049514 100644
--- a/drivers/gpu/drm/amd/pm/swsmu/smu11/smu_v11_0.c
+++ b/drivers/gpu/drm/amd/pm/swsmu/smu11/smu_v11_0.c
@@ -1235,6 +1235,8 @@ int smu_v11_0_set_fan_speed_rpm(struct smu_context *smu,
 	uint32_t crystal_clock_freq = 2500;
 	uint32_t tach_period;
 
+	if (speed == 0)
+		return -EINVAL;
 	/*
 	 * To prevent from possible overheat, some ASICs may have requirement
 	 * for minimum fan speed:
-- 
2.35.1



