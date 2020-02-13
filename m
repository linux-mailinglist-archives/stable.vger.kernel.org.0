Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 23D2315C3D1
	for <lists+stable@lfdr.de>; Thu, 13 Feb 2020 16:45:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728754AbgBMPoh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 Feb 2020 10:44:37 -0500
Received: from mail.kernel.org ([198.145.29.99]:52056 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728894AbgBMP1l (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 13 Feb 2020 10:27:41 -0500
Received: from localhost (unknown [104.132.1.104])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2A63F20661;
        Thu, 13 Feb 2020 15:27:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581607661;
        bh=VE7PXwSmSw9JapI9rq7+PLy8h/PzC/94PCA7N3oN+B4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2V4EXcalSzMq2uMDnMnv1iq075VRrztzTn0CBRFtneaPER66Rx0hNxtr/GPfFw75k
         Z/EzfwY4pTBL3NVa+7WYrZvAv1j+rgeTWPmDwLbBuUOIh1UY7IYJ6Q/3IwDPBLjHyT
         IOCNlbe1rflwpsnhbtC8OzL2YcLXmaPy3168UkaY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Eric Auger <eric.auger@redhat.com>,
        Marc Zyngier <maz@kernel.org>,
        Zenghui Yu <yuzenghui@huawei.com>
Subject: [PATCH 5.4 62/96] KVM: arm/arm64: vgic-its: Fix restoration of unmapped collections
Date:   Thu, 13 Feb 2020 07:21:09 -0800
Message-Id: <20200213151903.026499129@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200213151839.156309910@linuxfoundation.org>
References: <20200213151839.156309910@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eric Auger <eric.auger@redhat.com>

commit 8c58be34494b7f1b2adb446e2d8beeb90e5de65b upstream.

Saving/restoring an unmapped collection is a valid scenario. For
example this happens if a MAPTI command was sent, featuring an
unmapped collection. At the moment the CTE fails to be restored.
Only compare against the number of online vcpus if the rdist
base is set.

Fixes: ea1ad53e1e31a ("KVM: arm64: vgic-its: Collection table save/restore")
Signed-off-by: Eric Auger <eric.auger@redhat.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
Reviewed-by: Zenghui Yu <yuzenghui@huawei.com>
Link: https://lore.kernel.org/r/20191213094237.19627-1-eric.auger@redhat.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 virt/kvm/arm/vgic/vgic-its.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/virt/kvm/arm/vgic/vgic-its.c
+++ b/virt/kvm/arm/vgic/vgic-its.c
@@ -2472,7 +2472,8 @@ static int vgic_its_restore_cte(struct v
 	target_addr = (u32)(val >> KVM_ITS_CTE_RDBASE_SHIFT);
 	coll_id = val & KVM_ITS_CTE_ICID_MASK;
 
-	if (target_addr >= atomic_read(&kvm->online_vcpus))
+	if (target_addr != COLLECTION_NOT_MAPPED &&
+	    target_addr >= atomic_read(&kvm->online_vcpus))
 		return -EINVAL;
 
 	collection = find_collection(its, coll_id);


