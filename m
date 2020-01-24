Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 50FB1147C37
	for <lists+stable@lfdr.de>; Fri, 24 Jan 2020 10:50:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387747AbgAXJuJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Jan 2020 04:50:09 -0500
Received: from mail.kernel.org ([198.145.29.99]:50704 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730321AbgAXJuG (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 24 Jan 2020 04:50:06 -0500
Received: from localhost (unknown [145.15.244.15])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1F8DC20718;
        Fri, 24 Jan 2020 09:50:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579859405;
        bh=JHQF3YTiUEq07UgmOGJhPmx5WWuS0Ke7mUJr69tW1cc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=W7KnTQoJz1G/YDaR6snpP5Xhma4glx/UiMY+uoHESL4yQ/6rvWLauYHHgITCX8W3A
         U9Yf9izKK34S3lU9z/hPXWJn85g3RL1VTx1VTjw07/sjrIQTDzUCErBVK6V6SNIEN2
         uRXUgpljnawY/4w8XF9vYAiLRsk3Du6fOo6AqKzQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Alexey Kardashevskiy <aik@ozlabs.ru>,
        Paul Mackerras <paulus@ozlabs.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 110/343] KVM: PPC: Release all hardware TCE tables attached to a group
Date:   Fri, 24 Jan 2020 10:28:48 +0100
Message-Id: <20200124092934.519656053@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200124092919.490687572@linuxfoundation.org>
References: <20200124092919.490687572@linuxfoundation.org>
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
index 5e44462960213..ef6a58838e7ce 100644
--- a/arch/powerpc/kvm/book3s_64_vio.c
+++ b/arch/powerpc/kvm/book3s_64_vio.c
@@ -134,7 +134,6 @@ extern void kvm_spapr_tce_release_iommu_group(struct kvm *kvm,
 					continue;
 
 				kref_put(&stit->kref, kvm_spapr_tce_liobn_put);
-				return;
 			}
 		}
 	}
-- 
2.20.1



