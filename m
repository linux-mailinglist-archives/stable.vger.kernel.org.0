Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B187F20D102
	for <lists+stable@lfdr.de>; Mon, 29 Jun 2020 20:41:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727777AbgF2Shn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Jun 2020 14:37:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:56792 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726790AbgF2Sfu (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Jun 2020 14:35:50 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E0B842473A;
        Mon, 29 Jun 2020 15:20:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1593444058;
        bh=0WaZU/K1ypkbm+ycWQnZZ8t/GAAaU/C20hvWc8njQg0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Erpte6ySkGZYA1ZetOxERCTpG8MBWk5lkANAJSG3u4xtZB2Bd9Ijr04kBjVediAXJ
         PBvjlJw6qbmWK6f6d4Wz2qiJcIII/DV7pzrXIfavsUH+UybrAiq3p7yPnpYGqwBZiV
         5tJSYDiK5/b5mDywhSW2Mg84/EynXf3Rzi9hX44c=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Colin Ian King <colin.king@canonical.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.7 166/265] qed: add missing error test for DBG_STATUS_NO_MATCHING_FRAMING_MODE
Date:   Mon, 29 Jun 2020 11:16:39 -0400
Message-Id: <20200629151818.2493727-167-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200629151818.2493727-1-sashal@kernel.org>
References: <20200629151818.2493727-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.7.7-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.7.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.7.7-rc1
X-KernelTest-Deadline: 2020-07-01T15:14+00:00
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

[ Upstream commit a51243860893615b457b149da1ef5df0a4f1ffc2 ]

The error DBG_STATUS_NO_MATCHING_FRAMING_MODE was added to the enum
enum dbg_status however there is a missing corresponding entry for
this in the array s_status_str. This causes an out-of-bounds read when
indexing into the last entry of s_status_str.  Fix this by adding in
the missing entry.

Addresses-Coverity: ("Out-of-bounds read").
Fixes: 2d22bc8354b1 ("qed: FW 8.42.2.0 debug features")
Signed-off-by: Colin Ian King <colin.king@canonical.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/qlogic/qed/qed_debug.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/qlogic/qed/qed_debug.c b/drivers/net/ethernet/qlogic/qed/qed_debug.c
index f4eebaabb6d0d..3e56b6056b477 100644
--- a/drivers/net/ethernet/qlogic/qed/qed_debug.c
+++ b/drivers/net/ethernet/qlogic/qed/qed_debug.c
@@ -5568,7 +5568,8 @@ static const char * const s_status_str[] = {
 
 	/* DBG_STATUS_INVALID_FILTER_TRIGGER_DWORDS */
 	"The filter/trigger constraint dword offsets are not enabled for recording",
-
+	/* DBG_STATUS_NO_MATCHING_FRAMING_MODE */
+	"No matching framing mode",
 
 	/* DBG_STATUS_VFC_READ_ERROR */
 	"Error reading from VFC",
-- 
2.25.1

