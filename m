Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 15B72148483
	for <lists+stable@lfdr.de>; Fri, 24 Jan 2020 12:44:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730103AbgAXLLN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Jan 2020 06:11:13 -0500
Received: from mail.kernel.org ([198.145.29.99]:47084 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732546AbgAXLLM (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 24 Jan 2020 06:11:12 -0500
Received: from localhost (ip-213-127-102-57.ip.prioritytelecom.net [213.127.102.57])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 53F342071A;
        Fri, 24 Jan 2020 11:11:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579864272;
        bh=Y7udHayko4hLYah8HCrSvn8wMOr2wfGioJtl9hTUbYk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DPROd/Ypjp1Q7wZnzEkzPOm9KKw6e3SKtx6Pzr7v3uxcdjJBjj6d205wvw72U/Sls
         /JkOwaInbyydOM1U063kSfD/ipXW3SUngkai8a/YKHnImiPzLSP4lruQ3oQ9rYfiSH
         7gzyOq4Vi8P+K8B/5ejE5NcptdGYXW2+pBU1tiJQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Alexey Kardashevskiy <aik@ozlabs.ru>,
        Paul Mackerras <paulus@ozlabs.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 208/639] KVM: PPC: Release all hardware TCE tables attached to a group
Date:   Fri, 24 Jan 2020 10:26:18 +0100
Message-Id: <20200124093113.071861818@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200124093047.008739095@linuxfoundation.org>
References: <20200124093047.008739095@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alexey Kardashevskiy <aik@ozlabs.ru>

[ Upstream commit a67614cc05a5052b265ea48196dab2fce11f5f2e ]

The SPAPR TCE KVM device references all hardware IOMMU tables assigned to
some IOMMU group to ensure that in-kernel KVM acceleration of H_PUT_TCE
can work. The tables are references when an IOMMU group gets registered
with the VFIO KVM device by the KVM_DEV_VFIO_GROUP_ADD ioctl;
KVM_DEV_VFIO_GROUP_DEL calls into the dereferencing code
in kvm_spapr_tce_release_iommu_group() which walks through the list of
LIOBNs, finds a matching IOMMU table and calls kref_put() when found.

However that code stops after the very first successful derefencing
leaving other tables referenced till the SPAPR TCE KVM device is destroyed
which normally happens on guest reboot or termination so if we do hotplug
and unplug in a loop, we are leaking IOMMU tables here.

This removes a premature return to let kvm_spapr_tce_release_iommu_group()
find and dereference all attached tables.

Fixes: 121f80ba68f ("KVM: PPC: VFIO: Add in-kernel acceleration for VFIO")
Signed-off-by: Alexey Kardashevskiy <aik@ozlabs.ru>
Signed-off-by: Paul Mackerras <paulus@ozlabs.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/kvm/book3s_64_vio.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/arch/powerpc/kvm/book3s_64_vio.c b/arch/powerpc/kvm/book3s_64_vio.c
index 65486c3d029b5..26b03af71abd2 100644
--- a/arch/powerpc/kvm/book3s_64_vio.c
+++ b/arch/powerpc/kvm/book3s_64_vio.c
@@ -133,7 +133,6 @@ extern void kvm_spapr_tce_release_iommu_group(struct kvm *kvm,
 					continue;
 
 				kref_put(&stit->kref, kvm_spapr_tce_liobn_put);
-				return;
 			}
 		}
 	}
-- 
2.20.1



