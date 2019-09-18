Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7449DB6560
	for <lists+stable@lfdr.de>; Wed, 18 Sep 2019 16:01:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729228AbfIROBs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 18 Sep 2019 10:01:48 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:35753 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726038AbfIROBs (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 18 Sep 2019 10:01:48 -0400
Received: by mail-wm1-f67.google.com with SMTP id y21so207668wmi.0;
        Wed, 18 Sep 2019 07:01:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id;
        bh=sIYpPV0gwYoKAB5S6WKsIvLkhM2b1flwKz65XoEniwc=;
        b=XgiMB28SY8wROslEuzRRNotbmYHYT9AJlCfFHcf7rriCyJKEi10dDd4yXKJFmMGlSp
         XL0V5RK/nWqO4twAvYM1D6fURQWDSzpIL6Oh8jlRly74iueAWptAEqFVEBDujCYrmXJv
         tfg9KsUEWuepePhXPrKU7hC7BOkpuMQfOos/urLJ42FckYo+ojfqQcSCn8JmnOFobD5p
         ck6veQ5rqAN8jjRbfI5cR3iaX2ntZIqMPYTNLeluHFu+VE4FsPZk9PzK2uh9ngofTn3t
         y4Y97zzjg6aLAZpY75/c5ZfiRZg+Z4Kt6of4CaFU+DgwzfFIk+o0BnfVKRY2UahRnWg4
         Co+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id;
        bh=sIYpPV0gwYoKAB5S6WKsIvLkhM2b1flwKz65XoEniwc=;
        b=SWcH00m1wzKA4kBl8sn47iwHp1KYJ9G/Mf9WbzKAScHY+DuhiErWPvaEH3bgfxtcRM
         Pxt3Yry1hmTxpypeuxRHKw7rLXtqA4G+e3CpGoQaBc/1b/y+j2sfa13D1VORKLf3Nmq0
         /8JGL7YDWYLf7qJr1dhEE+DFRIuMgkQHFOI4c7bXHgnhAXmJ4MJEu9FW/KJCfUe3T3w6
         qoXBwiA2AvEvLHi1CJbL8Gp+1zVezbYu4MuqtxEMjcIfq3Vp8zRyAKbQA3avgIaS4Vsr
         Mxh5ydNZJ2I3TANBQ4aQulov+gJYW5yY3C3xso9VFnKC2IowuuxukjK//8GO7qAoiuLL
         n+5w==
X-Gm-Message-State: APjAAAXvF3Pl1yr2IwiHKo6+50gCkX1vyN/BzU9dlzZ19zBPo37+akM9
        tHSipuytYBD7kakEnc4EgRlxgKVt
X-Google-Smtp-Source: APXvYqwjPp6K7bF9k3yhxybpD/fzOc9ct3mAUrtnxNYLvvW/bLkgaizftrHvDWLgszNtQcvTaqzsAA==
X-Received: by 2002:a1c:a8d8:: with SMTP id r207mr2985299wme.135.1568815304882;
        Wed, 18 Sep 2019 07:01:44 -0700 (PDT)
Received: from 640k.lan ([93.56.166.5])
        by smtp.gmail.com with ESMTPSA id f143sm4030710wme.40.2019.09.18.07.01.43
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 18 Sep 2019 07:01:43 -0700 (PDT)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     will@kernel.org, kernellwp@gmail.com, gregkh@linuxfoundation.org,
        Matt Delco <delco@chromium.org>, stable@vger.kernel.org,
        Jim Mattson <jmattson@google.com>
Subject: [PATCH] KVM: coalesced_mmio: add bounds checking
Date:   Wed, 18 Sep 2019 16:01:42 +0200
Message-Id: <1568815302-21319-1-git-send-email-pbonzini@redhat.com>
X-Mailer: git-send-email 1.8.3.1
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Matt Delco <delco@chromium.org>

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
---
 virt/kvm/coalesced_mmio.c | 19 +++++++++++--------
 1 file changed, 11 insertions(+), 8 deletions(-)

diff --git a/virt/kvm/coalesced_mmio.c b/virt/kvm/coalesced_mmio.c
index 5294abb3f178..8ffd07e2a160 100644
--- a/virt/kvm/coalesced_mmio.c
+++ b/virt/kvm/coalesced_mmio.c
@@ -40,7 +40,7 @@ static int coalesced_mmio_in_range(struct kvm_coalesced_mmio_dev *dev,
 	return 1;
 }
 
-static int coalesced_mmio_has_room(struct kvm_coalesced_mmio_dev *dev)
+static int coalesced_mmio_has_room(struct kvm_coalesced_mmio_dev *dev, u32 last)
 {
 	struct kvm_coalesced_mmio_ring *ring;
 	unsigned avail;
@@ -52,7 +52,7 @@ static int coalesced_mmio_has_room(struct kvm_coalesced_mmio_dev *dev)
 	 * there is always one unused entry in the buffer
 	 */
 	ring = dev->kvm->coalesced_mmio_ring;
-	avail = (ring->first - ring->last - 1) % KVM_COALESCED_MMIO_MAX;
+	avail = (ring->first - last - 1) % KVM_COALESCED_MMIO_MAX;
 	if (avail == 0) {
 		/* full */
 		return 0;
@@ -67,25 +67,28 @@ static int coalesced_mmio_write(struct kvm_vcpu *vcpu,
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
-	ring->coalesced_mmio[ring->last].pio = dev->zone.pio;
+	ring->coalesced_mmio[insert].phys_addr = addr;
+	ring->coalesced_mmio[insert].len = len;
+	memcpy(ring->coalesced_mmio[insert].data, val, len);
+	ring->coalesced_mmio[insert].pio = dev->zone.pio;
 	smp_wmb();
-	ring->last = (ring->last + 1) % KVM_COALESCED_MMIO_MAX;
+	ring->last = (insert + 1) % KVM_COALESCED_MMIO_MAX;
 	spin_unlock(&dev->kvm->ring_lock);
 	return 0;
 }
-- 
1.8.3.1

