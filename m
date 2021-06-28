Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1C5513B627D
	for <lists+stable@lfdr.de>; Mon, 28 Jun 2021 16:46:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236366AbhF1OsG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Jun 2021 10:48:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:51372 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233794AbhF1On0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Jun 2021 10:43:26 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9C69861CE9;
        Mon, 28 Jun 2021 14:33:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1624890825;
        bh=NZlrqUBmSGQiqrxIlDF/JlOQIdLb2D9x0WuQTQFUCsE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LFIfPlr7GdMZQjMItXpnekOPCleoinrBgJy+1SLKFcmLP2IK9s53/gtf1amhQ0CHv
         9J5KM1CR2nAERt+e1cVl/N4O0tDTWdaa3bDAGeLgXKTD6KPp4Hqz2hgxTMVJXs+CbF
         ZwHMqXpPqW9Yv9znVeY2bNuPJRMirw8W3YcFgvOSOS6Ahj0xTjZxqgOol455JqhEtp
         5s60iKdpj4h3WffzhodFpA6KNkhqstsQHBrQ1pcIIxaTbcY2lQsvS7qcxDVQAcDSqu
         ySwraCn3QkQebU+YWYn23bRZnFRVkwfnt89SV/KczAg86nsi3oJH9EA57q3lJrV83d
         R+NduH/S3qkIA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Shalom Toledo <shalomt@mellanox.com>,
        Petr Machata <petrm@mellanox.com>,
        Ido Schimmel <idosch@mellanox.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 042/109] ptp: ptp_clock: Publish scaled_ppm_to_ppb
Date:   Mon, 28 Jun 2021 10:31:58 -0400
Message-Id: <20210628143305.32978-43-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210628143305.32978-1-sashal@kernel.org>
References: <20210628143305.32978-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.196-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.19.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.19.196-rc1
X-KernelTest-Deadline: 2021-06-30T14:32+00:00
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Shalom Toledo <shalomt@mellanox.com>

[ Upstream commit 4368dada5b37e74a13b892ca5cef8a7d558e9a5f ]

Publish scaled_ppm_to_ppb to allow drivers to use it.

Signed-off-by: Shalom Toledo <shalomt@mellanox.com>
Reviewed-by: Petr Machata <petrm@mellanox.com>
Signed-off-by: Ido Schimmel <idosch@mellanox.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/ptp/ptp_clock.c          | 3 ++-
 include/linux/ptp_clock_kernel.h | 8 ++++++++
 2 files changed, 10 insertions(+), 1 deletion(-)

diff --git a/drivers/ptp/ptp_clock.c b/drivers/ptp/ptp_clock.c
index e232233beb8f..863958f3bb57 100644
--- a/drivers/ptp/ptp_clock.c
+++ b/drivers/ptp/ptp_clock.c
@@ -76,7 +76,7 @@ static void enqueue_external_timestamp(struct timestamp_event_queue *queue,
 	spin_unlock_irqrestore(&queue->lock, flags);
 }
 
-static s32 scaled_ppm_to_ppb(long ppm)
+s32 scaled_ppm_to_ppb(long ppm)
 {
 	/*
 	 * The 'freq' field in the 'struct timex' is in parts per
@@ -95,6 +95,7 @@ static s32 scaled_ppm_to_ppb(long ppm)
 	ppb >>= 13;
 	return (s32) ppb;
 }
+EXPORT_SYMBOL(scaled_ppm_to_ppb);
 
 /* posix clock implementation */
 
diff --git a/include/linux/ptp_clock_kernel.h b/include/linux/ptp_clock_kernel.h
index 51349d124ee5..40ea83fcfdd5 100644
--- a/include/linux/ptp_clock_kernel.h
+++ b/include/linux/ptp_clock_kernel.h
@@ -204,6 +204,14 @@ extern void ptp_clock_event(struct ptp_clock *ptp,
 
 extern int ptp_clock_index(struct ptp_clock *ptp);
 
+/**
+ * scaled_ppm_to_ppb() - convert scaled ppm to ppb
+ *
+ * @ppm:    Parts per million, but with a 16 bit binary fractional field
+ */
+
+extern s32 scaled_ppm_to_ppb(long ppm);
+
 /**
  * ptp_find_pin() - obtain the pin index of a given auxiliary function
  *
-- 
2.30.2

