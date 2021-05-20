Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EA7FB38A1F8
	for <lists+stable@lfdr.de>; Thu, 20 May 2021 11:35:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232965AbhETJgn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 May 2021 05:36:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:34686 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231556AbhETJev (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 May 2021 05:34:51 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id BD11461402;
        Thu, 20 May 2021 09:29:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621502960;
        bh=cBDFQ6T9nKMjY6cs3VgPOYNoVcPxNaiHvrAWiXC657Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gXOWZ+hKZfEyh1Gs9pP/BJ/fFKhKCWdS+9Yw1qCQ5XT0nRNFoRcdcgy9flcpIfx/E
         oe8/LV6GkrReWfpxW18AkPQg2o8JEPVj8qCnNVJPY+EUkRcLOV/Yl+kCWn+EEJ79IT
         /DW/xZoFJK6ag0bEXR64JyDQcRoOOi4aTpHtSXbo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Bodo Stroesser <bostroesser@gmail.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 23/37] scsi: target: tcmu: Return from tcmu_handle_completions() if cmd_id not found
Date:   Thu, 20 May 2021 11:22:44 +0200
Message-Id: <20210520092053.036261745@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210520092052.265851579@linuxfoundation.org>
References: <20210520092052.265851579@linuxfoundation.org>
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
index d6634baebb47..71144e33272a 100644
--- a/drivers/target/target_core_user.c
+++ b/drivers/target/target_core_user.c
@@ -1205,7 +1205,7 @@ static void tcmu_set_next_deadline(struct list_head *queue,
 		del_timer(timer);
 }
 
-static unsigned int tcmu_handle_completions(struct tcmu_dev *udev)
+static bool tcmu_handle_completions(struct tcmu_dev *udev)
 {
 	struct tcmu_mailbox *mb;
 	struct tcmu_cmd *cmd;
@@ -1245,7 +1245,7 @@ static unsigned int tcmu_handle_completions(struct tcmu_dev *udev)
 			pr_err("cmd_id %u not found, ring is broken\n",
 			       entry->hdr.cmd_id);
 			set_bit(TCMU_DEV_BIT_BROKEN, &udev->flags);
-			break;
+			return false;
 		}
 
 		tcmu_handle_completion(cmd, entry);
-- 
2.30.2



