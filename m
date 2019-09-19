Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AFEB2B8576
	for <lists+stable@lfdr.de>; Fri, 20 Sep 2019 00:21:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404775AbfISWV0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 Sep 2019 18:21:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:35876 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2406728AbfISWVY (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 19 Sep 2019 18:21:24 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 642B221920;
        Thu, 19 Sep 2019 22:21:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1568931683;
        bh=BhAkphDj+0fgyrcKIHmH9JEYx3kwCeJH+ofYqdmz4b4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vCTc5CVva0r6v89QOtXmbC0NJ8lSDxl8p5V15PeHoC42e11HFuf4ZrXjeh/Vht1EF
         9Ws584Uji/r3iEm+wKqlfvd2ZExLeMC8QX7JxWUe1BellUfF5zsLfdImdA1BtOI3iL
         NWu1vZTGab6MXqRnEBlgKUKiclvboNEA9RN24JT8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Matt Delco <delco@chromium.org>,
        Jim Mattson <jmattson@google.com>,
        syzbot+983c866c3dd6efa3662a@syzkaller.appspotmail.com,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 4.9 40/74] KVM: coalesced_mmio: add bounds checking
Date:   Fri, 20 Sep 2019 00:03:53 +0200
Message-Id: <20190919214808.781026606@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190919214800.519074117@linuxfoundation.org>
References: <20190919214800.519074117@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Matt Delco <delco@chromium.org>

commit b60fe990c6b07ef6d4df67bc0530c7c90a62623a upstream.

The first/last indexes are typically shared with a user app.
The app can change the 'last' index that the kernel uses
to store the next result.  This change sanity checks the index
before using it for writing to a potentially arbitrary address.

This fixes CVE-2019-14821.

Cc: stable@vger.kernel.org
Fixes: 5f94c1741bdc ("KVM: Add coalesced MMIO support (common part)")
Signed-off-by: Matt Delco <delco@chromium.org>
Signed-off-by: Jim Mattson <jmattson@google.com>
Reported-by: syzbot+983c866c3dd6efa3662a@syzkaller.appspotmail.com
[Use READ_ONCE. - Paolo]
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 virt/kvm/coalesced_mmio.c |   17 ++++++++++-------
 1 file changed, 10 insertions(+), 7 deletions(-)

--- a/virt/kvm/coalesced_mmio.c
+++ b/virt/kvm/coalesced_mmio.c
@@ -39,7 +39,7 @@ static int coalesced_mmio_in_range(struc
 	return 1;
 }
 
-static int coalesced_mmio_has_room(struct kvm_coalesced_mmio_dev *dev)
+static int coalesced_mmio_has_room(struct kvm_coalesced_mmio_dev *dev, u32 last)
 {
 	struct kvm_coalesced_mmio_ring *ring;
 	unsigned avail;
@@ -51,7 +51,7 @@ static int coalesced_mmio_has_room(struc
 	 * there is always one unused entry in the buffer
 	 */
 	ring = dev->kvm->coalesced_mmio_ring;
-	avail = (ring->first - ring->last - 1) % KVM_COALESCED_MMIO_MAX;
+	avail = (ring->first - last - 1) % KVM_COALESCED_MMIO_MAX;
 	if (avail == 0) {
 		/* full */
 		return 0;
@@ -66,24 +66,27 @@ static int coalesced_mmio_write(struct k
 {
 	struct kvm_coalesced_mmio_dev *dev = to_mmio(this);
 	struct kvm_coalesced_mmio_ring *ring = dev->kvm->coalesced_mmio_ring;
+	__u32 insert;
 
 	if (!coalesced_mmio_in_range(dev, addr, len))
 		return -EOPNOTSUPP;
 
 	spin_lock(&dev->kvm->ring_lock);
 
-	if (!coalesced_mmio_has_room(dev)) {
+	insert = READ_ONCE(ring->last);
+	if (!coalesced_mmio_has_room(dev, insert) ||
+	    insert >= KVM_COALESCED_MMIO_MAX) {
 		spin_unlock(&dev->kvm->ring_lock);
 		return -EOPNOTSUPP;
 	}
 
 	/* copy data in first free entry of the ring */
 
-	ring->coalesced_mmio[ring->last].phys_addr = addr;
-	ring->coalesced_mmio[ring->last].len = len;
-	memcpy(ring->coalesced_mmio[ring->last].data, val, len);
+	ring->coalesced_mmio[insert].phys_addr = addr;
+	ring->coalesced_mmio[insert].len = len;
+	memcpy(ring->coalesced_mmio[insert].data, val, len);
 	smp_wmb();
-	ring->last = (ring->last + 1) % KVM_COALESCED_MMIO_MAX;
+	ring->last = (insert + 1) % KVM_COALESCED_MMIO_MAX;
 	spin_unlock(&dev->kvm->ring_lock);
 	return 0;
 }


