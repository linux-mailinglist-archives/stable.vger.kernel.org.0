Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A65EF1064BA
	for <lists+stable@lfdr.de>; Fri, 22 Nov 2019 07:20:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728966AbfKVFzz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 22 Nov 2019 00:55:55 -0500
Received: from mail.kernel.org ([198.145.29.99]:33588 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728961AbfKVFzy (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 22 Nov 2019 00:55:54 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 66D2E20659;
        Fri, 22 Nov 2019 05:55:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574402154;
        bh=cmKGOHgM7wHlc5kYMfA4o8dgcIF1tniR9eks2UIjlII=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pbatcNWzLU/4HG8rWYmemMxGPcpuRfuun4VHVx/eipQ1/sanKnc5zYQBiLzUQch4V
         gNimGmnHf3ga/G9+jSwGwgwn7S1dNHzmYTM5W7F16KLp/K7zf18ruwK6yONcSTEyOz
         AkOUhy62xV76HaYtrmfu8fEDj2IjAmkamQmZqZ8s=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Suzuki K Poulose <Suzuki.Poulose@arm.com>,
        Steve Capper <steve.capper@arm.com>,
        Will Deacon <will.deacon@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Sasha Levin <sashal@kernel.org>,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 4.14 009/127] arm64: smp: Handle errors reported by the firmware
Date:   Fri, 22 Nov 2019 00:53:47 -0500
Message-Id: <20191122055544.3299-8-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191122055544.3299-1-sashal@kernel.org>
References: <20191122055544.3299-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Suzuki K Poulose <Suzuki.Poulose@arm.com>

[ Upstream commit f357b3a7e17af7736d67d8267edc1ed3d1dd9391 ]

The __cpu_up() routine ignores the errors reported by the firmware
for a CPU bringup operation and looks for the error status set by the
booting CPU. If the CPU never entered the kernel, we could end up
in assuming stale error status, which otherwise would have been
set/cleared appropriately by the booting CPU.

Reported-by: Steve Capper <steve.capper@arm.com>
Cc: Will Deacon <will.deacon@arm.com>
Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
Signed-off-by: Will Deacon <will.deacon@arm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/kernel/smp.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm64/kernel/smp.c b/arch/arm64/kernel/smp.c
index 0881dfab10f8f..909bf3926fd23 100644
--- a/arch/arm64/kernel/smp.c
+++ b/arch/arm64/kernel/smp.c
@@ -144,6 +144,7 @@ int __cpu_up(unsigned int cpu, struct task_struct *idle)
 		}
 	} else {
 		pr_err("CPU%u: failed to boot: %d\n", cpu, ret);
+		return ret;
 	}
 
 	secondary_data.task = NULL;
-- 
2.20.1

