Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0767B259C53
	for <lists+stable@lfdr.de>; Tue,  1 Sep 2020 19:15:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729045AbgIAPO6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Sep 2020 11:14:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:58994 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729070AbgIAPO4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 1 Sep 2020 11:14:56 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B5321206FA;
        Tue,  1 Sep 2020 15:14:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598973296;
        bh=vf8P7knMKxAd8czp29JUejgGx8ytmQ5ofKwx9f36CKI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AfcnwuPOulqVu2loWh0rnypGxWGovd4Jtf46prfkxMwwwvB50Lu51AOP5DZ5g8DIp
         Om/LdXVV6V+dsiThQSXt5a1FGB434cQrXOu7qw0UzZFWVYAwU4LUUuKfTgIM7RFKkA
         BwPZzDJahH5PmOkH0gB609Ot/SO0/Qa1TWeRlFlw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Qiushi Wu <wu000273@umn.edu>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 22/78] PCI: Fix pci_create_slot() reference count leak
Date:   Tue,  1 Sep 2020 17:09:58 +0200
Message-Id: <20200901150925.857660977@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200901150924.680106554@linuxfoundation.org>
References: <20200901150924.680106554@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
@@ -303,13 +303,16 @@ placeholder:
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
@@ -328,7 +331,6 @@ out:
 	mutex_unlock(&pci_slot_mutex);
 	return slot;
 err:
-	kfree(slot);
 	slot = ERR_PTR(err);
 	goto out;
 }
-- 
2.25.1



