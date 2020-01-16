Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0EC0513F200
	for <lists+stable@lfdr.de>; Thu, 16 Jan 2020 19:33:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392022AbgAPScK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Jan 2020 13:32:10 -0500
Received: from mail.kernel.org ([198.145.29.99]:60500 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729022AbgAPRZD (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Jan 2020 12:25:03 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3CB3F246A5;
        Thu, 16 Jan 2020 17:25:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579195503;
        bh=NIdGwcMkgiL1s4jVL8Cgn7XAt7PcbTinlJgZIyRtmig=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hdTO72V6E3lohjEL0A6OLWB+wk+tno1FuQwVJqAWDJf707XqQ7P3amdabXKh3nxY0
         omiNpwc8i0A55/ZVBRLqdFZQBcWMpj5sbllH6WpMkvovCwbBrFLO44w8NtFa84H37A
         gT88y9GD2LmoWaxm4vT8EsUwJSlO/GlXoRC+u6lI=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Alexey Kardashevskiy <aik@ozlabs.ru>,
        Paul Mackerras <paulus@ozlabs.org>,
        Sasha Levin <sashal@kernel.org>, kvm-ppc@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org
Subject: [PATCH AUTOSEL 4.14 103/371] KVM: PPC: Release all hardware TCE tables attached to a group
Date:   Thu, 16 Jan 2020 12:19:35 -0500
Message-Id: <20200116172403.18149-46-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200116172403.18149-1-sashal@kernel.org>
References: <20200116172403.18149-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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
index 5e4446296021..ef6a58838e7c 100644
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

