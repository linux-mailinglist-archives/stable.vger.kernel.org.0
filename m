Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 377162604E9
	for <lists+stable@lfdr.de>; Mon,  7 Sep 2020 20:56:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729885AbgIGS4F (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Sep 2020 14:56:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56128 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729472AbgIGSzJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Sep 2020 14:55:09 -0400
Received: from mail-pf1-x441.google.com (mail-pf1-x441.google.com [IPv6:2607:f8b0:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 106D6C061573;
        Mon,  7 Sep 2020 11:55:09 -0700 (PDT)
Received: by mail-pf1-x441.google.com with SMTP id b124so8994122pfg.13;
        Mon, 07 Sep 2020 11:55:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=dawj1SMvdQbml5uHKFi5qJIO1Xksj7iCEcoBAXgXEuI=;
        b=LzYUAim1sww5RSYzIbFyJZ7GkaZRwpjcPpZ2OaI+rE7BDVh1A0Ni+qbUi1gDaqtK+2
         eGsCrnL1B32m+PDpBd+969FoZj+Tu9KXd9QCQb35FDrmfZbM88KAAHX/Z4YzDEy3iRdw
         +31fkC97nJDFvW5V5XIMDPfr+INVFkFbcmZkzV4TCT2L3uL403QE/hwW5BTUDeNlVtg7
         rWLXQlvXhbhsAjuJEEP/oYZ8Ocsy2nx/6MI5finWZTcs01lk270uL8ElQyKKRaxKrX5E
         SSVvM4G4hScGD5BYtQreQ0uBdHyV4nH5Ad5jM61SexmSmZK26CYCBOlBVhPE+gEykIIK
         5tcQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=dawj1SMvdQbml5uHKFi5qJIO1Xksj7iCEcoBAXgXEuI=;
        b=YFk4cwGmtM63kaWQJN7oESua55pyL7m7oNNMKunNv9m5v45YW6RuUYCHYrMxYXQrkB
         X2p1mXKjyh6azWk0AJu9ETi3F+vcU1/GuuG6AKxIWzo20nv8ElYTk82qYdsU7SNu6VPy
         vcQkmt/0fri/S7ovXaJgPB6stRry5rV6DNbYO1Ia/gYYf1fEeU1zz7IUXNSaPPRrjcFZ
         6BIqXcwWSAvv/uha0sPAl/yKsSGDANDLTftxf/6fEzyjomlzPda9F3+JgIbGYEY/WUgJ
         2dp7eNkEX6ZK1fbeDjrMKSeGMWy1Kvpqq4OL4TYIsAOHGcxs1mtNZpwAwKnPIWDK3yIO
         3TzQ==
X-Gm-Message-State: AOAM531kg5n0/fKsvh0CvRZCiMXFvUDEI4u47SGYt+ramNbJNQR9VW98
        imNbzc2HJSeKELLPAbw2JSU=
X-Google-Smtp-Source: ABdhPJxay8d9Q5I7t6iNt4rnkHhZw2gW/vAIWCtXS76rfVzqgleboOPliRkM/UDIXkwoe5DpbcNg9g==
X-Received: by 2002:aa7:9991:0:b029:13c:1611:6530 with SMTP id k17-20020aa799910000b029013c16116530mr19254157pfh.16.1599504908391;
        Mon, 07 Sep 2020 11:55:08 -0700 (PDT)
Received: from localhost.localdomain (104.36.148.139.aurocloud.com. [104.36.148.139])
        by smtp.gmail.com with ESMTPSA id p190sm16178304pfp.9.2020.09.07.11.55.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Sep 2020 11:55:07 -0700 (PDT)
From:   Rustam Kovhaev <rkovhaev@gmail.com>
To:     pbonzini@redhat.com, vkuznets@redhat.com, gustavoars@kernel.org,
        kvm@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, gregkh@linuxfoundation.org,
        stable@vger.kernel.org, Rustam Kovhaev <rkovhaev@gmail.com>
Subject: [RESEND PATCH v2] KVM: fix memory leak in kvm_io_bus_unregister_dev()
Date:   Mon,  7 Sep 2020 11:55:35 -0700
Message-Id: <20200907185535.233114-1-rkovhaev@gmail.com>
X-Mailer: git-send-email 2.28.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

when kmalloc() fails in kvm_io_bus_unregister_dev(), before removing
the bus, we should iterate over all other devices linked to it and call
kvm_iodevice_destructor() for them

Fixes: 90db10434b16 ("KVM: kvm_io_bus_unregister_dev() should never fail")
Cc: stable@vger.kernel.org
Reported-and-tested-by: syzbot+f196caa45793d6374707@syzkaller.appspotmail.com
Link: https://syzkaller.appspot.com/bug?extid=f196caa45793d6374707
Signed-off-by: Rustam Kovhaev <rkovhaev@gmail.com>
Reviewed-by: Vitaly Kuznetsov <vkuznets@redhat.com>
---
v2:
- remove redundant whitespace
- remove goto statement and use if/else
- add Fixes tag
---
 virt/kvm/kvm_main.c | 21 ++++++++++++---------
 1 file changed, 12 insertions(+), 9 deletions(-)

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 67cd0b88a6b6..cf88233b819a 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -4332,7 +4332,7 @@ int kvm_io_bus_register_dev(struct kvm *kvm, enum kvm_bus bus_idx, gpa_t addr,
 void kvm_io_bus_unregister_dev(struct kvm *kvm, enum kvm_bus bus_idx,
 			       struct kvm_io_device *dev)
 {
-	int i;
+	int i, j;
 	struct kvm_io_bus *new_bus, *bus;
 
 	bus = kvm_get_bus(kvm, bus_idx);
@@ -4349,17 +4349,20 @@ void kvm_io_bus_unregister_dev(struct kvm *kvm, enum kvm_bus bus_idx,
 
 	new_bus = kmalloc(struct_size(bus, range, bus->dev_count - 1),
 			  GFP_KERNEL_ACCOUNT);
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
2.28.0

