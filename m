Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 189E020BAE8
	for <lists+stable@lfdr.de>; Fri, 26 Jun 2020 23:04:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726132AbgFZVEC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 26 Jun 2020 17:04:02 -0400
Received: from hqnvemgate24.nvidia.com ([216.228.121.143]:8995 "EHLO
        hqnvemgate24.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725781AbgFZVEB (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 26 Jun 2020 17:04:01 -0400
Received: from hqpgpgate102.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate24.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5ef662610004>; Fri, 26 Jun 2020 14:02:25 -0700
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate102.nvidia.com (PGP Universal service);
  Fri, 26 Jun 2020 14:04:00 -0700
X-PGP-Universal: processed;
        by hqpgpgate102.nvidia.com on Fri, 26 Jun 2020 14:04:00 -0700
Received: from HQMAIL107.nvidia.com (172.20.187.13) by HQMAIL101.nvidia.com
 (172.20.187.10) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Fri, 26 Jun
 2020 21:03:50 +0000
Received: from rnnvemgw01.nvidia.com (10.128.109.123) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3 via Frontend
 Transport; Fri, 26 Jun 2020 21:03:50 +0000
Received: from rcampbell-dev.nvidia.com (Not Verified[10.110.48.66]) by rnnvemgw01.nvidia.com with Trustwave SEG (v7,5,8,10121)
        id <B5ef662b50003>; Fri, 26 Jun 2020 14:03:50 -0700
From:   Ralph Campbell <rcampbell@nvidia.com>
To:     <nouveau@lists.freedesktop.org>, <linux-kernel@vger.kernel.org>
CC:     Jerome Glisse <jglisse@redhat.com>,
        John Hubbard <jhubbard@nvidia.com>,
        Christoph Hellwig <hch@lst.de>,
        Jason Gunthorpe <jgg@mellanox.com>,
        "Ben Skeggs" <bskeggs@redhat.com>,
        Ralph Campbell <rcampbell@nvidia.com>, <stable@vger.kernel.org>
Subject: [PATCH v2] nouveau: fix page fault on device private memory
Date:   Fri, 26 Jun 2020 14:03:37 -0700
Message-ID: <20200626210337.20089-1-rcampbell@nvidia.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
X-NVConfidentiality: public
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1593205345; bh=mwwOsKu36dXm+0p8ULHDS3ICUwuV7kITaXbla/zbTUs=;
        h=X-PGP-Universal:From:To:CC:Subject:Date:Message-ID:X-Mailer:
         MIME-Version:X-NVConfidentiality:Content-Transfer-Encoding:
         Content-Type;
        b=qC41cWrlv5PLn22RgQchoeWC/KvVD5wmV1a7t8JeJOo6zUvnssFr7pXleVBMzGzm6
         FmE7WXJdhKnagu2W3vJaEbwnaYKvp+evh3PvFFUSEuXaRrXW58v49YhOzW1S2in/Q6
         pcw6AA8JaGpFUey4GJIfrQqElaCvMqoVTrb4teax6DZII/+Y//8gSCSnZvxPgWNv2M
         sOBKATauOQGiSYnaUcngMLMGiKH4Df1aFOvKhLzJf9DxgNXnTjhAgCsbf+15jptEnX
         rfsXBPuSNzmPuRuK+Wxpe7HFDGIDwOoQ/HEfCfzOHkD6BBuqBdTpP6xOVpmO1OPdDk
         X4ZvL2s4Rj0rA==
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

If system memory is migrated to device private memory and no GPU MMU
page table entry exists, the GPU will fault and call hmm_range_fault()
to get the PFN for the page. Since the .dev_private_owner pointer in
struct hmm_range is not set, hmm_range_fault returns an error which
results in the GPU program stopping with a fatal fault.
Fix this by setting .dev_private_owner appropriately.

Fixes: 08ddddda667b ("mm/hmm: check the device private page owner in hmm_ra=
nge_fault()")
Cc: stable@vger.kernel.org
Signed-off-by: Ralph Campbell <rcampbell@nvidia.com>
Reviewed-by: Jason Gunthorpe <jgg@mellanox.com>
---

This is based on Linux-5.8.0-rc2 and is for Ben Skeggs nouveau tree.
It doesn't depend on any of the other nouveau/HMM changes I have
recently posted.

Resending to include stable@vger.org and adding Jason's reviewed-by.

 drivers/gpu/drm/nouveau/nouveau_svm.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/gpu/drm/nouveau/nouveau_svm.c b/drivers/gpu/drm/nouvea=
u/nouveau_svm.c
index ba9f9359c30e..6586d9d39874 100644
--- a/drivers/gpu/drm/nouveau/nouveau_svm.c
+++ b/drivers/gpu/drm/nouveau/nouveau_svm.c
@@ -562,6 +562,7 @@ static int nouveau_range_fault(struct nouveau_svmm *svm=
m,
 		.end =3D notifier->notifier.interval_tree.last + 1,
 		.pfn_flags_mask =3D HMM_PFN_REQ_FAULT | HMM_PFN_REQ_WRITE,
 		.hmm_pfns =3D hmm_pfns,
+		.dev_private_owner =3D drm->dev,
 	};
 	struct mm_struct *mm =3D notifier->notifier.mm;
 	int ret;
--=20
2.20.1

