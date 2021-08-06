Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 90CF43E25AF
	for <lists+stable@lfdr.de>; Fri,  6 Aug 2021 10:22:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243784AbhHFIVy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 6 Aug 2021 04:21:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:48692 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S244150AbhHFIUm (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 6 Aug 2021 04:20:42 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id CC000611C9;
        Fri,  6 Aug 2021 08:20:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1628238021;
        bh=8uPZydX9gBsF0it8nG3NA0wwVehYKRnuuB9H8lWB2Lg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nkFpZkXLprObUBklpafetxXTBnFuBYzFiMaW8Wqjgv0e1/Y8H8/Zsd4reN90jW6M3
         Ly91/w/CiwBA1rKLr8XLENvawNz82jXBYgjAk4KFObpm/9QKUhoUThEIQ53og4xJ7r
         3qQUFyWwG0UzExsXCNFCOU4tXWJytJLnC3O0xrq8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lijian Zhang <Lijian.Zhang@arm.com>,
        Jia He <justin.he@arm.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 21/35] qed: fix possible unpaired spin_{un}lock_bh in _qed_mcp_cmd_and_union()
Date:   Fri,  6 Aug 2021 10:17:04 +0200
Message-Id: <20210806081114.428051803@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210806081113.718626745@linuxfoundation.org>
References: <20210806081113.718626745@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jia He <justin.he@arm.com>

[ Upstream commit 6206b7981a36476f4695d661ae139f7db36a802d ]

Liajian reported a bug_on hit on a ThunderX2 arm64 server with FastLinQ
QL41000 ethernet controller:
 BUG: scheduling while atomic: kworker/0:4/531/0x00000200
  [qed_probe:488()]hw prepare failed
  kernel BUG at mm/vmalloc.c:2355!
  Internal error: Oops - BUG: 0 [#1] SMP
  CPU: 0 PID: 531 Comm: kworker/0:4 Tainted: G W 5.4.0-77-generic #86-Ubuntu
  pstate: 00400009 (nzcv daif +PAN -UAO)
 Call trace:
  vunmap+0x4c/0x50
  iounmap+0x48/0x58
  qed_free_pci+0x60/0x80 [qed]
  qed_probe+0x35c/0x688 [qed]
  __qede_probe+0x88/0x5c8 [qede]
  qede_probe+0x60/0xe0 [qede]
  local_pci_probe+0x48/0xa0
  work_for_cpu_fn+0x24/0x38
  process_one_work+0x1d0/0x468
  worker_thread+0x238/0x4e0
  kthread+0xf0/0x118
  ret_from_fork+0x10/0x18

In this case, qed_hw_prepare() returns error due to hw/fw error, but in
theory work queue should be in process context instead of interrupt.

The root cause might be the unpaired spin_{un}lock_bh() in
_qed_mcp_cmd_and_union(), which causes botton half is disabled incorrectly.

Reported-by: Lijian Zhang <Lijian.Zhang@arm.com>
Signed-off-by: Jia He <justin.he@arm.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/qlogic/qed/qed_mcp.c | 23 +++++++++++++++++------
 1 file changed, 17 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/qlogic/qed/qed_mcp.c b/drivers/net/ethernet/qlogic/qed/qed_mcp.c
index cd882c453394..caeef25c89bb 100644
--- a/drivers/net/ethernet/qlogic/qed/qed_mcp.c
+++ b/drivers/net/ethernet/qlogic/qed/qed_mcp.c
@@ -474,14 +474,18 @@ _qed_mcp_cmd_and_union(struct qed_hwfn *p_hwfn,
 
 		spin_lock_bh(&p_hwfn->mcp_info->cmd_lock);
 
-		if (!qed_mcp_has_pending_cmd(p_hwfn))
+		if (!qed_mcp_has_pending_cmd(p_hwfn)) {
+			spin_unlock_bh(&p_hwfn->mcp_info->cmd_lock);
 			break;
+		}
 
 		rc = qed_mcp_update_pending_cmd(p_hwfn, p_ptt);
-		if (!rc)
+		if (!rc) {
+			spin_unlock_bh(&p_hwfn->mcp_info->cmd_lock);
 			break;
-		else if (rc != -EAGAIN)
+		} else if (rc != -EAGAIN) {
 			goto err;
+		}
 
 		spin_unlock_bh(&p_hwfn->mcp_info->cmd_lock);
 
@@ -498,6 +502,8 @@ _qed_mcp_cmd_and_union(struct qed_hwfn *p_hwfn,
 		return -EAGAIN;
 	}
 
+	spin_lock_bh(&p_hwfn->mcp_info->cmd_lock);
+
 	/* Send the mailbox command */
 	qed_mcp_reread_offsets(p_hwfn, p_ptt);
 	seq_num = ++p_hwfn->mcp_info->drv_mb_seq;
@@ -524,14 +530,18 @@ _qed_mcp_cmd_and_union(struct qed_hwfn *p_hwfn,
 
 		spin_lock_bh(&p_hwfn->mcp_info->cmd_lock);
 
-		if (p_cmd_elem->b_is_completed)
+		if (p_cmd_elem->b_is_completed) {
+			spin_unlock_bh(&p_hwfn->mcp_info->cmd_lock);
 			break;
+		}
 
 		rc = qed_mcp_update_pending_cmd(p_hwfn, p_ptt);
-		if (!rc)
+		if (!rc) {
+			spin_unlock_bh(&p_hwfn->mcp_info->cmd_lock);
 			break;
-		else if (rc != -EAGAIN)
+		} else if (rc != -EAGAIN) {
 			goto err;
+		}
 
 		spin_unlock_bh(&p_hwfn->mcp_info->cmd_lock);
 	} while (++cnt < max_retries);
@@ -554,6 +564,7 @@ _qed_mcp_cmd_and_union(struct qed_hwfn *p_hwfn,
 		return -EAGAIN;
 	}
 
+	spin_lock_bh(&p_hwfn->mcp_info->cmd_lock);
 	qed_mcp_cmd_del_elem(p_hwfn, p_cmd_elem);
 	spin_unlock_bh(&p_hwfn->mcp_info->cmd_lock);
 
-- 
2.30.2



