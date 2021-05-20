Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D6E1838A161
	for <lists+stable@lfdr.de>; Thu, 20 May 2021 11:30:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232230AbhETJaq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 May 2021 05:30:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:52996 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232016AbhETJ2p (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 May 2021 05:28:45 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8672761261;
        Thu, 20 May 2021 09:27:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621502824;
        bh=o2jXKpuhkJIfer2K8SU3B+OWR3J5Y6ya9LXAL2VJYtQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=k5HyU1We5T6nsx7TEhqCAxx3t3kULoQE91IPT+GPtFv1YSvEZK97ZJJDMKApBRjar
         27j7of/YfnMadPMum0igHsiEBs3qUrSSVq6+xLm6PS7VvvoWkCTy4YAxyqcNUP1MZW
         MVeakIV7eQwP4XMm/crSkLR+E6EeF++XouutM+is=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Bodo Stroesser <bostroesser@gmail.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 30/47] scsi: target: tcmu: Return from tcmu_handle_completions() if cmd_id not found
Date:   Thu, 20 May 2021 11:22:28 +0200
Message-Id: <20210520092054.519080934@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210520092053.559923764@linuxfoundation.org>
References: <20210520092053.559923764@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Bodo Stroesser <bostroesser@gmail.com>

[ Upstream commit 9814b55cde0588b6d9bc496cee43f87316cbc6f1 ]

If tcmu_handle_completions() finds an invalid cmd_id while looping over cmd
responses from userspace it sets TCMU_DEV_BIT_BROKEN and breaks the
loop. This means that it does further handling for the tcmu device.

Skip that handling by replacing 'break' with 'return'.

Additionally change tcmu_handle_completions() from unsigned int to bool,
since the value used in return already is bool.

Link: https://lore.kernel.org/r/20210423150123.24468-1-bostroesser@gmail.com
Signed-off-by: Bodo Stroesser <bostroesser@gmail.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/target/target_core_user.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/target/target_core_user.c b/drivers/target/target_core_user.c
index 7d5814a95e1e..c6950f157b99 100644
--- a/drivers/target/target_core_user.c
+++ b/drivers/target/target_core_user.c
@@ -1391,7 +1391,7 @@ static int tcmu_run_tmr_queue(struct tcmu_dev *udev)
 	return 1;
 }
 
-static unsigned int tcmu_handle_completions(struct tcmu_dev *udev)
+static bool tcmu_handle_completions(struct tcmu_dev *udev)
 {
 	struct tcmu_mailbox *mb;
 	struct tcmu_cmd *cmd;
@@ -1434,7 +1434,7 @@ static unsigned int tcmu_handle_completions(struct tcmu_dev *udev)
 			pr_err("cmd_id %u not found, ring is broken\n",
 			       entry->hdr.cmd_id);
 			set_bit(TCMU_DEV_BIT_BROKEN, &udev->flags);
-			break;
+			return false;
 		}
 
 		tcmu_handle_completion(cmd, entry);
-- 
2.30.2



