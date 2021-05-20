Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 291A338A0F5
	for <lists+stable@lfdr.de>; Thu, 20 May 2021 11:26:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231775AbhETJ1U (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 May 2021 05:27:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:52886 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231773AbhETJ0r (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 May 2021 05:26:47 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4750E61261;
        Thu, 20 May 2021 09:25:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621502726;
        bh=H43xm+WMtNrfk1LdR8lVNuVsxTgEYIhPWq3vTxV73Jk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bsgMsktS5Ah5zL8XmE3AAbqs5RlcxKn3PT+niFaWcFlCp5FfckZIXGeZ09rjnGGc8
         Hjx3NCoTI2YVk5SVMlYNP3d59sLxCCaZTXpTeyH7omRGP1Cas/2QmGTPUMNaJmpUvm
         QUTugVmVzElvfM/PXgVIUxSMlCF6RmxRsYCcPbnI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Bodo Stroesser <bostroesser@gmail.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 30/45] scsi: target: tcmu: Return from tcmu_handle_completions() if cmd_id not found
Date:   Thu, 20 May 2021 11:22:18 +0200
Message-Id: <20210520092054.502247755@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210520092053.516042993@linuxfoundation.org>
References: <20210520092053.516042993@linuxfoundation.org>
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
index bf73cd5f4b04..6809c970be03 100644
--- a/drivers/target/target_core_user.c
+++ b/drivers/target/target_core_user.c
@@ -1377,7 +1377,7 @@ static int tcmu_run_tmr_queue(struct tcmu_dev *udev)
 	return 1;
 }
 
-static unsigned int tcmu_handle_completions(struct tcmu_dev *udev)
+static bool tcmu_handle_completions(struct tcmu_dev *udev)
 {
 	struct tcmu_mailbox *mb;
 	struct tcmu_cmd *cmd;
@@ -1420,7 +1420,7 @@ static unsigned int tcmu_handle_completions(struct tcmu_dev *udev)
 			pr_err("cmd_id %u not found, ring is broken\n",
 			       entry->hdr.cmd_id);
 			set_bit(TCMU_DEV_BIT_BROKEN, &udev->flags);
-			break;
+			return false;
 		}
 
 		tcmu_handle_completion(cmd, entry);
-- 
2.30.2



