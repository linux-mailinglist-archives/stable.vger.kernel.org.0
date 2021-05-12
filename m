Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1059137C7BC
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 18:37:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233666AbhELQCT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 12:02:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:38450 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238124AbhELP5Y (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 11:57:24 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 00AE661CCA;
        Wed, 12 May 2021 15:30:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620833424;
        bh=4v0ba2zeHGtqbuC+LuTU0fkcgKcAJxB8HHhecyZd7kQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SEu7WjJeA9vnxnMhgcBPphg0hlnfXs21kO5xjU96RNN052aKDelSdzOXBrNqgCykz
         MmJJfl3vWwwDoI4fPcerQBM3bYD1B5TWk5kXo2tJc9lB3j7hsNELYbIAb474bToQyS
         b4Dg+NgGgKC5XSnwWvBYYQSA5FyQ79ufIXhcu15M=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 5.11 109/601] KVM: Destroy I/O bus devices on unregister failure _after_ syncing SRCU
Date:   Wed, 12 May 2021 16:43:06 +0200
Message-Id: <20210512144831.428979450@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210512144827.811958675@linuxfoundation.org>
References: <20210512144827.811958675@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sean Christopherson <seanjc@google.com>

commit 2ee3757424be7c1cd1d0bbfa6db29a7edd82a250 upstream.

If allocating a new instance of an I/O bus fails when unregistering a
device, wait to destroy the device until after all readers are guaranteed
to see the new null bus.  Destroying devices before the bus is nullified
could lead to use-after-free since readers expect the devices on their
reference of the bus to remain valid.

Fixes: f65886606c2d ("KVM: fix memory leak in kvm_io_bus_unregister_dev()")
Cc: stable@vger.kernel.org
Signed-off-by: Sean Christopherson <seanjc@google.com>
Message-Id: <20210412222050.876100-2-seanjc@google.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 virt/kvm/kvm_main.c |   10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -4487,7 +4487,13 @@ void kvm_io_bus_unregister_dev(struct kv
 		new_bus->dev_count--;
 		memcpy(new_bus->range + i, bus->range + i + 1,
 				flex_array_size(new_bus, range, new_bus->dev_count - i));
-	} else {
+	}
+
+	rcu_assign_pointer(kvm->buses[bus_idx], new_bus);
+	synchronize_srcu_expedited(&kvm->srcu);
+
+	/* Destroy the old bus _after_ installing the (null) bus. */
+	if (!new_bus) {
 		pr_err("kvm: failed to shrink bus, removing it completely\n");
 		for (j = 0; j < bus->dev_count; j++) {
 			if (j == i)
@@ -4496,8 +4502,6 @@ void kvm_io_bus_unregister_dev(struct kv
 		}
 	}
 
-	rcu_assign_pointer(kvm->buses[bus_idx], new_bus);
-	synchronize_srcu_expedited(&kvm->srcu);
 	kfree(bus);
 	return;
 }


