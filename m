Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5E9A81B7501
	for <lists+stable@lfdr.de>; Fri, 24 Apr 2020 14:30:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728098AbgDXMa0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Apr 2020 08:30:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:53632 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728078AbgDXMXj (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 24 Apr 2020 08:23:39 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1F08F2087E;
        Fri, 24 Apr 2020 12:23:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587731018;
        bh=S1pFrNshqtwbqsTvzoUTRMylnIQecyR9t7n1Hbdwejo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cQfxMZlbvXroH8O3UPdy0BQmrClM2x3H5t35RKVA2kx/Imv14xp9YAnVLJTq5fhwS
         Mmj/h+3DY7qIk/jiIzLZ6//vw96HPe1dRuD479vkC+72fdp5/r7yH3NL7Zl1PXufyC
         0lQgZA3VtKWHBdYcf1tQKtjjQ7yJYbne0guL4xg8=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Bodo Stroesser <bstroesser@ts.fujitsu.com>,
        Mike Christie <mchristi@redhat.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>, linux-scsi@vger.kernel.org,
        target-devel@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 13/26] scsi: target: tcmu: reset_ring should reset TCMU_DEV_BIT_BROKEN
Date:   Fri, 24 Apr 2020 08:23:10 -0400
Message-Id: <20200424122323.10194-13-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200424122323.10194-1-sashal@kernel.org>
References: <20200424122323.10194-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Bodo Stroesser <bstroesser@ts.fujitsu.com>

[ Upstream commit 066f79a5fd6d1b9a5cc57b5cd445b3e4bb68a5b2 ]

In case command ring buffer becomes inconsistent, tcmu sets device flag
TCMU_DEV_BIT_BROKEN.  If the bit is set, tcmu rejects new commands from LIO
core with TCM_LOGICAL_UNIT_COMMUNICATION_FAILURE, and no longer processes
completions from the ring.  The reset_ring attribute can be used to
completely clean up the command ring, so after reset_ring the ring no
longer is inconsistent.

Therefore reset_ring also should reset bit TCMU_DEV_BIT_BROKEN to allow
normal processing.

Link: https://lore.kernel.org/r/20200409101026.17872-1-bstroesser@ts.fujitsu.com
Acked-by: Mike Christie <mchristi@redhat.com>
Signed-off-by: Bodo Stroesser <bstroesser@ts.fujitsu.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/target/target_core_user.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/target/target_core_user.c b/drivers/target/target_core_user.c
index 35be1be87d2a1..9425354aef99c 100644
--- a/drivers/target/target_core_user.c
+++ b/drivers/target/target_core_user.c
@@ -2073,6 +2073,7 @@ static void tcmu_reset_ring(struct tcmu_dev *udev, u8 err_level)
 	mb->cmd_tail = 0;
 	mb->cmd_head = 0;
 	tcmu_flush_dcache_range(mb, sizeof(*mb));
+	clear_bit(TCMU_DEV_BIT_BROKEN, &udev->flags);
 
 	del_timer(&udev->cmd_timer);
 
-- 
2.20.1

