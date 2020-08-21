Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8185024DB85
	for <lists+stable@lfdr.de>; Fri, 21 Aug 2020 18:42:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728401AbgHUQkW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 21 Aug 2020 12:40:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:49728 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728405AbgHUQUq (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 21 Aug 2020 12:20:46 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 04EFE22D07;
        Fri, 21 Aug 2020 16:19:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598026800;
        bh=lhPzxAMtGiGwqFgokTYuR2htwCTnKmFaZukK5H3J0RU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sjZQYaZ1KFYB3uWJn2dgBO80YCTexlN/9BSx8spR6mF4p5wD9mCOv15OavckjKX4Q
         EkW35XHRqJrbR9ARRTeRZPsK1RZ/f0WeF8fxCEKBySUhgBLWQPKnVPakztMgGur8Hb
         EtQe5KN59BJhtUvnVTYhGj3ZBnIltYpTY9chjIXA=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Qiushi Wu <wu000273@umn.edu>, Bjorn Helgaas <bhelgaas@google.com>,
        Sasha Levin <sashal@kernel.org>, linux-pci@vger.kernel.org
Subject: [PATCH AUTOSEL 4.9 16/26] PCI: Fix pci_create_slot() reference count leak
Date:   Fri, 21 Aug 2020 12:19:27 -0400
Message-Id: <20200821161938.349246-16-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200821161938.349246-1-sashal@kernel.org>
References: <20200821161938.349246-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Qiushi Wu <wu000273@umn.edu>

[ Upstream commit 8a94644b440eef5a7b9c104ac8aa7a7f413e35e5 ]

kobject_init_and_add() takes a reference even when it fails.  If it returns
an error, kobject_put() must be called to clean up the memory associated
with the object.

When kobject_init_and_add() fails, call kobject_put() instead of kfree().

b8eb718348b8 ("net-sysfs: Fix reference count leak in
rx|netdev_queue_add_kobject") fixed a similar problem.

Link: https://lore.kernel.org/r/20200528021322.1984-1-wu000273@umn.edu
Signed-off-by: Qiushi Wu <wu000273@umn.edu>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/slot.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/pci/slot.c b/drivers/pci/slot.c
index 429d34c348b9f..01a343ad7155c 100644
--- a/drivers/pci/slot.c
+++ b/drivers/pci/slot.c
@@ -303,13 +303,16 @@ struct pci_slot *pci_create_slot(struct pci_bus *parent, int slot_nr,
 	slot_name = make_slot_name(name);
 	if (!slot_name) {
 		err = -ENOMEM;
+		kfree(slot);
 		goto err;
 	}
 
 	err = kobject_init_and_add(&slot->kobj, &pci_slot_ktype, NULL,
 				   "%s", slot_name);
-	if (err)
+	if (err) {
+		kobject_put(&slot->kobj);
 		goto err;
+	}
 
 	INIT_LIST_HEAD(&slot->list);
 	list_add(&slot->list, &parent->slots);
@@ -328,7 +331,6 @@ struct pci_slot *pci_create_slot(struct pci_bus *parent, int slot_nr,
 	mutex_unlock(&pci_slot_mutex);
 	return slot;
 err:
-	kfree(slot);
 	slot = ERR_PTR(err);
 	goto out;
 }
-- 
2.25.1

