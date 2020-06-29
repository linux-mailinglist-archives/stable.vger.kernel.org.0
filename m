Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 331DE20DE1C
	for <lists+stable@lfdr.de>; Mon, 29 Jun 2020 23:52:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729217AbgF2UWk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Jun 2020 16:22:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:37038 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732582AbgF2TZd (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Jun 2020 15:25:33 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3752025456;
        Mon, 29 Jun 2020 15:43:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1593445410;
        bh=KIqz86iLPbGE0xfrJUfeaiRP4YEt5cJQXJcpZvxjiMo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ItTgehNiLDU9LDBTnS9bY2bRzLmOLL3tyyh0MSE0IClURo/kpXwgINeZ1+XNP7sN8
         5yTxbK5BRNdjhoe/7/4BDs/gretc2XQwyr2ByZTeXc9M+/GtPysKxFhoJW4anRA0nX
         o/ZdPruR0S2P8pG0AFYmZbKfqbApjoy0CL33LbZw=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Qiushi Wu <wu000273@umn.edu>, Ard Biesheuvel <ardb@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 161/191] efi/esrt: Fix reference count leak in esre_create_sysfs_entry.
Date:   Mon, 29 Jun 2020 11:39:37 -0400
Message-Id: <20200629154007.2495120-162-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200629154007.2495120-1-sashal@kernel.org>
References: <20200629154007.2495120-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.9.229-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.9.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.9.229-rc1
X-KernelTest-Deadline: 2020-07-01T15:39+00:00
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Qiushi Wu <wu000273@umn.edu>

[ Upstream commit 4ddf4739be6e375116c375f0a68bf3893ffcee21 ]

kobject_init_and_add() takes reference even when it fails.
If this function returns an error, kobject_put() must be called to
properly clean up the memory associated with the object. Previous
commit "b8eb718348b8" fixed a similar problem.

Fixes: 0bb549052d33 ("efi: Add esrt support")
Signed-off-by: Qiushi Wu <wu000273@umn.edu>
Link: https://lore.kernel.org/r/20200528183804.4497-1-wu000273@umn.edu
Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/firmware/efi/esrt.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/firmware/efi/esrt.c b/drivers/firmware/efi/esrt.c
index 241dd7c63d2c8..481b2f0a190b0 100644
--- a/drivers/firmware/efi/esrt.c
+++ b/drivers/firmware/efi/esrt.c
@@ -180,7 +180,7 @@ static int esre_create_sysfs_entry(void *esre, int entry_num)
 		rc = kobject_init_and_add(&entry->kobj, &esre1_ktype, NULL,
 					  "entry%d", entry_num);
 		if (rc) {
-			kfree(entry);
+			kobject_put(&entry->kobj);
 			return rc;
 		}
 	}
-- 
2.25.1

