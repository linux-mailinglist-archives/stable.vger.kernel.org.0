Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 29A5311313D
	for <lists+stable@lfdr.de>; Wed,  4 Dec 2019 18:57:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728321AbfLDR5h (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Dec 2019 12:57:37 -0500
Received: from mail.kernel.org ([198.145.29.99]:58612 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728311AbfLDR5g (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 4 Dec 2019 12:57:36 -0500
Received: from localhost (unknown [217.68.49.72])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B370D2081B;
        Wed,  4 Dec 2019 17:57:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1575482256;
        bh=+4ZYxgp6JPeEo+Ag+AOKVeFQr15T9Pdm9jbIOQcVegU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=joItWs5kKSpB99nZCpMWH63l1R3FRvun2eUrFQyP6WTIJFGGEbbXmqarfmGsyjjXh
         8dDxu+lu9n6bNCBrQNnOtfFWc2sn3JRY0JpEVaAlkkBJIsb4aPsECVoxrQiG5ctYva
         XWWcr99ZHc55KnzIWoWt8bT4+T+ErWN6iaeKReqE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Steve Capper <steve.capper@arm.com>,
        Will Deacon <will.deacon@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 14/92] arm64: smp: Handle errors reported by the firmware
Date:   Wed,  4 Dec 2019 18:49:14 +0100
Message-Id: <20191204174330.241834671@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191204174327.215426506@linuxfoundation.org>
References: <20191204174327.215426506@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index 03c0946b79d20..7e90f429f7e5c 100644
--- a/arch/arm64/kernel/smp.c
+++ b/arch/arm64/kernel/smp.c
@@ -115,6 +115,7 @@ int __cpu_up(unsigned int cpu, struct task_struct *idle)
 		}
 	} else {
 		pr_err("CPU%u: failed to boot: %d\n", cpu, ret);
+		return ret;
 	}
 
 	secondary_data.stack = NULL;
-- 
2.20.1



