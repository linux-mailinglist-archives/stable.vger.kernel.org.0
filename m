Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A083427C3AA
	for <lists+stable@lfdr.de>; Tue, 29 Sep 2020 13:08:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728590AbgI2LHd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 29 Sep 2020 07:07:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:45726 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728866AbgI2LHO (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 29 Sep 2020 07:07:14 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7CA6A21D46;
        Tue, 29 Sep 2020 11:07:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601377633;
        bh=tSx6nNkkj72nzkCz4hDeAGHMhtGpVKtr9FMBzPm5iaM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VWFq8HiaFYGk+I8YycZ41wyA2Cz8qIy4ABtS+IrNjrKv1asjO+tYOf9enLnPTQDUD
         edusUjVs1SkC0s+kH8AueFFYqJb8L2mCfH0+9obJ9TV7qqlYdFWxNN93aILFcnV0HO
         PI+NL5ul+KSWFqxXvo8XKvBQL5+v1w1xlxfE6p0c=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Rustam Kovhaev <rkovhaev@gmail.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sasha Levin <sashal@kernel.org>,
        syzbot+f196caa45793d6374707@syzkaller.appspotmail.com
Subject: [PATCH 4.9 002/121] KVM: fix memory leak in kvm_io_bus_unregister_dev()
Date:   Tue, 29 Sep 2020 12:59:06 +0200
Message-Id: <20200929105930.303978981@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200929105930.172747117@linuxfoundation.org>
References: <20200929105930.172747117@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Rustam Kovhaev <rkovhaev@gmail.com>

[ Upstream commit f65886606c2d3b562716de030706dfe1bea4ed5e ]

when kmalloc() fails in kvm_io_bus_unregister_dev(), before removing
the bus, we should iterate over all other devices linked to it and call
kvm_iodevice_destructor() for them

Fixes: 90db10434b16 ("KVM: kvm_io_bus_unregister_dev() should never fail")
Cc: stable@vger.kernel.org
Reported-and-tested-by: syzbot+f196caa45793d6374707@syzkaller.appspotmail.com
Link: https://syzkaller.appspot.com/bug?extid=f196caa45793d6374707
Signed-off-by: Rustam Kovhaev <rkovhaev@gmail.com>
Reviewed-by: Vitaly Kuznetsov <vkuznets@redhat.com>
Message-Id: <20200907185535.233114-1-rkovhaev@gmail.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 virt/kvm/kvm_main.c | 21 ++++++++++++---------
 1 file changed, 12 insertions(+), 9 deletions(-)

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 4e4bb5dd2dcd5..010d8aee9346b 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -3639,7 +3639,7 @@ int kvm_io_bus_register_dev(struct kvm *kvm, enum kvm_bus bus_idx, gpa_t addr,
 void kvm_io_bus_unregister_dev(struct kvm *kvm, enum kvm_bus bus_idx,
 			       struct kvm_io_device *dev)
 {
-	int i;
+	int i, j;
 	struct kvm_io_bus *new_bus, *bus;
 
 	bus = kvm->buses[bus_idx];
@@ -3656,17 +3656,20 @@ void kvm_io_bus_unregister_dev(struct kvm *kvm, enum kvm_bus bus_idx,
 
 	new_bus = kmalloc(sizeof(*bus) + ((bus->dev_count - 1) *
 			  sizeof(struct kvm_io_range)), GFP_KERNEL);
-	if (!new_bus)  {
+	if (new_bus) {
+		memcpy(new_bus, bus, sizeof(*bus) + i * sizeof(struct kvm_io_range));
+		new_bus->dev_count--;
+		memcpy(new_bus->range + i, bus->range + i + 1,
+		       (new_bus->dev_count - i) * sizeof(struct kvm_io_range));
+	} else {
 		pr_err("kvm: failed to shrink bus, removing it completely\n");
-		goto broken;
+		for (j = 0; j < bus->dev_count; j++) {
+			if (j == i)
+				continue;
+			kvm_iodevice_destructor(bus->range[j].dev);
+		}
 	}
 
-	memcpy(new_bus, bus, sizeof(*bus) + i * sizeof(struct kvm_io_range));
-	new_bus->dev_count--;
-	memcpy(new_bus->range + i, bus->range + i + 1,
-	       (new_bus->dev_count - i) * sizeof(struct kvm_io_range));
-
-broken:
 	rcu_assign_pointer(kvm->buses[bus_idx], new_bus);
 	synchronize_srcu_expedited(&kvm->srcu);
 	kfree(bus);
-- 
2.25.1



