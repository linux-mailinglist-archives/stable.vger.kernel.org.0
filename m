Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5BE58405328
	for <lists+stable@lfdr.de>; Thu,  9 Sep 2021 14:51:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244193AbhIIMuh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Sep 2021 08:50:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:55848 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1355097AbhIIMlC (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 9 Sep 2021 08:41:02 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8E65F61BE3;
        Thu,  9 Sep 2021 11:54:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631188495;
        bh=6GYGAVk2gYlgVH3/XQYaDlJTce6H+5zqR3EON9Hy2B4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mo3ququQByZOGTBrtT+Dq52tjAq4hYJg/mupPMBUdeT9OkfBdpl/nFKn7IPC1WcBW
         9YYjSNpvlLDZT6odrbkNCM1KFUSbV+7w/jUtGVbT5XAf0w2EeDPeMl762lwraJbM/a
         lOAz8TRnk5OjHJhgUT4gDkx/mvxQ6CQ4AO5p2KVmOLxO7f/fRBSB7jCCfY60y7xf+B
         oQoAg+7lKFZbSvz9SyQrnMU8fsRP8MYQfBkJGN+rGst4k8SOxQphzBVqB+kTaq6Zrg
         26wgo7DmIOLC2XIwzSTPS8ghI4byGwbTQZIjW+TEHIzV5LH2KsMFzFfEy1kOhQ/QZE
         71FIvMwRxaqAw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Colin Ian King <colin.king@canonical.com>,
        Sudip Mukherjee <sudipm.mukherjee@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 5.10 168/176] parport: remove non-zero check on count
Date:   Thu,  9 Sep 2021 07:51:10 -0400
Message-Id: <20210909115118.146181-168-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210909115118.146181-1-sashal@kernel.org>
References: <20210909115118.146181-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

[ Upstream commit 0be883a0d795d9146f5325de582584147dd0dcdc ]

The check for count appears to be incorrect since a non-zero count
check occurs a couple of statements earlier. Currently the check is
always false and the dev->port->irq != PARPORT_IRQ_NONE part of the
check is never tested and the if statement is dead-code. Fix this
by removing the check on count.

Note that this code is pre-git history, so I can't find a sha for
it.

Acked-by: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Signed-off-by: Colin Ian King <colin.king@canonical.com>
Addresses-Coverity: ("Logically dead code")
Link: https://lore.kernel.org/r/20210730100710.27405-1-colin.king@canonical.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/parport/ieee1284_ops.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/parport/ieee1284_ops.c b/drivers/parport/ieee1284_ops.c
index 2c11bd3fe1fd..17061f1df0f4 100644
--- a/drivers/parport/ieee1284_ops.c
+++ b/drivers/parport/ieee1284_ops.c
@@ -518,7 +518,7 @@ size_t parport_ieee1284_ecp_read_data (struct parport *port,
 				goto out;
 
 			/* Yield the port for a while. */
-			if (count && dev->port->irq != PARPORT_IRQ_NONE) {
+			if (dev->port->irq != PARPORT_IRQ_NONE) {
 				parport_release (dev);
 				schedule_timeout_interruptible(msecs_to_jiffies(40));
 				parport_claim_or_block (dev);
-- 
2.30.2

