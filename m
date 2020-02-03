Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 28C96150D39
	for <lists+stable@lfdr.de>; Mon,  3 Feb 2020 17:43:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730582AbgBCQdZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Feb 2020 11:33:25 -0500
Received: from mail.kernel.org ([198.145.29.99]:47362 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730577AbgBCQdY (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 3 Feb 2020 11:33:24 -0500
Received: from localhost (unknown [104.132.45.99])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 661DA2082E;
        Mon,  3 Feb 2020 16:33:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1580747603;
        bh=3wGRL90czmoweh8O1WUlHwtiqXhbAD81rd8yS1gnIek=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oa8ikF2Shn15ExKA6KFq/yAeFlL1G3Du0fXokuN+oniSiObJzFTBy+6MOJIZjLzYB
         2RoiJDh0rjK2KADCf5W2FBxN9yODVE7gJ5dF9Yia/k2hWWFoihGTg7mRxn01PgveFc
         eKM1ttnqg8vj7+c9S92QtgJYxoVEWrzTJR2lD1XY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Shahed Shaikh <shshaikh@marvell.com>,
        Yonggen Xu <Yonggen.Xu@dell.com>,
        Manish Chopra <manishc@marvell.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 64/70] qlcnic: Fix CPU soft lockup while collecting firmware dump
Date:   Mon,  3 Feb 2020 16:20:16 +0000
Message-Id: <20200203161921.384801113@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200203161912.158976871@linuxfoundation.org>
References: <20200203161912.158976871@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Manish Chopra <manishc@marvell.com>

[ Upstream commit 22e984493a41bf8081f13d9ed84def3ca8cfd427 ]

Driver while collecting firmware dump takes longer time to
collect/process some of the firmware dump entries/memories.
Bigger capture masks makes it worse as it results in larger
amount of data being collected and results in CPU soft lockup.
Place cond_resched() in some of the driver flows that are
expectedly time consuming to relinquish the CPU to avoid CPU
soft lockup panic.

Signed-off-by: Shahed Shaikh <shshaikh@marvell.com>
Tested-by: Yonggen Xu <Yonggen.Xu@dell.com>
Signed-off-by: Manish Chopra <manishc@marvell.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/qlogic/qlcnic/qlcnic_83xx_init.c | 1 +
 drivers/net/ethernet/qlogic/qlcnic/qlcnic_minidump.c  | 2 ++
 2 files changed, 3 insertions(+)

diff --git a/drivers/net/ethernet/qlogic/qlcnic/qlcnic_83xx_init.c b/drivers/net/ethernet/qlogic/qlcnic/qlcnic_83xx_init.c
index a496390b8632f..07f9067affc65 100644
--- a/drivers/net/ethernet/qlogic/qlcnic/qlcnic_83xx_init.c
+++ b/drivers/net/ethernet/qlogic/qlcnic/qlcnic_83xx_init.c
@@ -2043,6 +2043,7 @@ static void qlcnic_83xx_exec_template_cmd(struct qlcnic_adapter *p_dev,
 			break;
 		}
 		entry += p_hdr->size;
+		cond_resched();
 	}
 	p_dev->ahw->reset.seq_index = index;
 }
diff --git a/drivers/net/ethernet/qlogic/qlcnic/qlcnic_minidump.c b/drivers/net/ethernet/qlogic/qlcnic/qlcnic_minidump.c
index afa10a163da1f..f34ae8c75bc5e 100644
--- a/drivers/net/ethernet/qlogic/qlcnic/qlcnic_minidump.c
+++ b/drivers/net/ethernet/qlogic/qlcnic/qlcnic_minidump.c
@@ -703,6 +703,7 @@ static u32 qlcnic_read_memory_test_agent(struct qlcnic_adapter *adapter,
 		addr += 16;
 		reg_read -= 16;
 		ret += 16;
+		cond_resched();
 	}
 out:
 	mutex_unlock(&adapter->ahw->mem_lock);
@@ -1383,6 +1384,7 @@ int qlcnic_dump_fw(struct qlcnic_adapter *adapter)
 		buf_offset += entry->hdr.cap_size;
 		entry_offset += entry->hdr.offset;
 		buffer = fw_dump->data + buf_offset;
+		cond_resched();
 	}
 
 	fw_dump->clr = 1;
-- 
2.20.1



