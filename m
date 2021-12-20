Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8D03247AE50
	for <lists+stable@lfdr.de>; Mon, 20 Dec 2021 16:00:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239165AbhLTPAv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Dec 2021 10:00:51 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:48618 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237873AbhLTO6O (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Dec 2021 09:58:14 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D391F611D0;
        Mon, 20 Dec 2021 14:58:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B7022C36AE7;
        Mon, 20 Dec 2021 14:58:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1640012293;
        bh=RfDoVu/onk73KSJWrOfa/y3pYn+YdJkbJoPWvtjmvn0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LRjBg2CwyZP3trB7y/lLr9X2f+s43O1syePCcvGuLQTo8wIqWHE4nlkWGCFLHVYtM
         XjGMyHMX8tCHLvU5oSh/jgNAE25EH742VceXfA29vi9fvH5ChMokyoX8WIEcHuA+dP
         ZTO4lFIEJfVc26SU+amHkzWUeYAarhKK33p+DjE0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Mario Limonciello <mario.limonciello@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 5.15 150/177] drm/amd/pm: fix reading SMU FW version from amdgpu_firmware_info on YC
Date:   Mon, 20 Dec 2021 15:35:00 +0100
Message-Id: <20211220143045.122997497@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211220143040.058287525@linuxfoundation.org>
References: <20211220143040.058287525@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mario Limonciello <mario.limonciello@amd.com>

commit dcd10d879a9d1d4e929d374c2f24aba8fac3252b upstream.

This value does not get cached into adev->pm.fw_version during
startup for smu13 like it does for other SMU like smu12.

Signed-off-by: Mario Limonciello <mario.limonciello@amd.com>
Reviewed-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/pm/swsmu/smu13/smu_v13_0.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/gpu/drm/amd/pm/swsmu/smu13/smu_v13_0.c
+++ b/drivers/gpu/drm/amd/pm/swsmu/smu13/smu_v13_0.c
@@ -197,6 +197,7 @@ int smu_v13_0_check_fw_status(struct smu
 
 int smu_v13_0_check_fw_version(struct smu_context *smu)
 {
+	struct amdgpu_device *adev = smu->adev;
 	uint32_t if_version = 0xff, smu_version = 0xff;
 	uint16_t smu_major;
 	uint8_t smu_minor, smu_debug;
@@ -209,6 +210,8 @@ int smu_v13_0_check_fw_version(struct sm
 	smu_major = (smu_version >> 16) & 0xffff;
 	smu_minor = (smu_version >> 8) & 0xff;
 	smu_debug = (smu_version >> 0) & 0xff;
+	if (smu->is_apu)
+		adev->pm.fw_version = smu_version;
 
 	switch (smu->adev->asic_type) {
 	case CHIP_ALDEBARAN:


