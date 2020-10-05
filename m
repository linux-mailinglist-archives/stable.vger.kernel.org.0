Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DBAC6283DA1
	for <lists+stable@lfdr.de>; Mon,  5 Oct 2020 19:39:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729159AbgJERjN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Oct 2020 13:39:13 -0400
Received: from nat-hk.nvidia.com ([203.18.50.4]:21375 "EHLO nat-hk.nvidia.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727033AbgJERjN (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 5 Oct 2020 13:39:13 -0400
Received: from HKMAIL102.nvidia.com (Not Verified[10.18.92.9]) by nat-hk.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B5f7b5a3e0000>; Tue, 06 Oct 2020 01:39:10 +0800
Received: from HKMAIL103.nvidia.com (10.18.16.12) by HKMAIL102.nvidia.com
 (10.18.16.11) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Mon, 5 Oct
 2020 17:38:58 +0000
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.104)
 by HKMAIL103.nvidia.com (10.18.16.12) with Microsoft SMTP Server (TLS) id
 15.0.1473.3 via Frontend Transport; Mon, 5 Oct 2020 17:38:58 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jW8m/vx134I9COQ6t6Kr7JRTQESbBCkEuzc1wgrwxR0gB0y7/1zeWxRrW9L+vrtMdYcqke/tKQaa3RzjvoqUprvU+FP5mzd2r10+48m0xZitmuVNHNAfPLGfVf22aeL9byyGjeM321TodvP29OGOhQWVgQCMtTLOEMfD/ZB1af3P0oZEREKxB+9eDCkmzp3rHDk0GDYstiyLkXuznTVTBxQZu9Et+BsKQm0YPprBPLm1hyO31Nc8MZIobIxFRC9IccGQoqs7E/IYMqUfcxaQHjAHpsrECCPKbPGU8r6Cb44u0m7oohtzn4QN9J/W09NhyXKSYOmWeRQgMB1Xb+hpAA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fSYl5KD7934AouZDNUKobCCSeGROG8RmBta0PxNC5ew=;
 b=AyfWItsk0TOyFTxKRfB6+wbl7GR3LkEC4l2QTjkMZ7XFKyWLXpCVFGIvuFggiGmEBW3VDEwiyG4cIsVAWpZ9t5Tt7/fMLIyGiurEYy5XBwe3OlFB3FUlKcpBps+YXJT57Dcysz2hpv5ck1BsErmSExXMCx+JwpfguCRXYkYGNq5ovnBmUo9EAXbb8UU6CcpK2GAi5J/ouGyvDy8kjHjKWprq6Imq2TmhPwLHIoFHACQb65r3pfsmu9jNEgbJHUkQ2LQW/O8m76NQjH3FKtJwhN/HJuk7jueo4zBLFdb46JDVhpbEVnsBZ9iQWW36MsxCLeycZ9+23uhCuzz4d2zv5w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
Received: from DM6PR12MB3834.namprd12.prod.outlook.com (2603:10b6:5:14a::12)
 by DM6PR12MB3833.namprd12.prod.outlook.com (2603:10b6:5:1cf::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3433.32; Mon, 5 Oct
 2020 17:38:56 +0000
Received: from DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::cdbe:f274:ad65:9a78]) by DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::cdbe:f274:ad65:9a78%7]) with mapi id 15.20.3433.044; Mon, 5 Oct 2020
 17:38:56 +0000
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     andrew Morton <akpm@linux-foundation.org>,
        Daniel Vetter <daniel.vetter@ffwll.ch>, <linux-mm@kvack.org>
CC:     Hans Verkuil <hans.verkuil@cisco.com>, Jan Kara <jack@suse.cz>,
        "Mauro Carvalho Chehab" <mchehab@osg.samsung.com>,
        Mel Gorman <mgorman@suse.de>, <stable@vger.kernel.org>,
        Vlastimil Babka <vbabka@suse.cz>,
        John Hubbard <jhubbard@nvidia.com>,
        DRI Development <dri-devel@lists.freedesktop.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Dan Williams <dan.j.williams@intel.com>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        linux-samsung-soc <linux-samsung-soc@vger.kernel.org>,
        <linux-media@vger.kernel.org>
Subject: Re: [PATCH 2/2] mm/frame-vec: use FOLL_LONGTERM
Date:   Mon, 5 Oct 2020 14:38:54 -0300
Message-ID: <0-v1-447bb60c11dd+174-frame_vec_fix_jgg@nvidia.com>
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain
X-ClientProxiedBy: MN2PR15CA0058.namprd15.prod.outlook.com
 (2603:10b6:208:237::27) To DM6PR12MB3834.namprd12.prod.outlook.com
 (2603:10b6:5:14a::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (156.34.48.30) by MN2PR15CA0058.namprd15.prod.outlook.com (2603:10b6:208:237::27) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3433.34 via Frontend Transport; Mon, 5 Oct 2020 17:38:55 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1kPURq-0003yS-3O; Mon, 05 Oct 2020 14:38:54 -0300
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1601919550; bh=EBBzMnzHdglFg4fc6Q+vYu+a20ACUXFYGuuOSwtJCqE=;
        h=ARC-Seal:ARC-Message-Signature:ARC-Authentication-Results:From:To:
         CC:Subject:Date:Message-ID:Content-Transfer-Encoding:Content-Type:
         X-ClientProxiedBy:MIME-Version:
         X-MS-Exchange-MessageSentRepresentingType;
        b=C65HOUx2sQwA0Z9I/HyXi7Zoe3KWz2BvP970C8OBm0crjJnTlAQ9SwKEK9gCZ2JuJ
         xsMHNVefxVm4z0kcNHciCuL3fCUmbzQfF0nmTHZMz3tur14QYYvpOLexv6QGM/VZYv
         KoSBZo72nEDtXB7fLlMqU2qXAr98pxbePnvJ9c/QsofRl1hs/Kc0hj4At+mY/00pGF
         5iJ15jO/Yg+195FUsBtZ9nyQbHi745UfgTQ3xdsFePRU9fE511l5uxZTQRVFMAIATu
         K2smzSXW5xmuHxphoHyhxOye2XS0aTl6UiSK+ucwxNoILLw7aNa/Q4IdswsUHnMgL1
         9gj6ae060YOrQ==
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

When get_vaddr_frames() does its hacky follow_pfn() loop it should never
be allowed to extract a struct page from a normal VMA. This could allow a
serious use-after-free problem on any kernel memory.

Restrict this to only work on VMA's with one of VM_IO | VM_PFNMAP
set. This limits the use-after-free problem to only IO memory, which while
still serious, is an improvement.

Cc: stable@vger.kernel.org
Fixes: 8025e5ddf9c1 ("[media] mm: Provide new get_vaddr_frames() helper")
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 mm/frame_vector.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/mm/frame_vector.c b/mm/frame_vector.c
index 10f82d5643b6de..26cb20544b6c37 100644
--- a/mm/frame_vector.c
+++ b/mm/frame_vector.c
@@ -99,6 +99,10 @@ int get_vaddr_frames(unsigned long start, unsigned int n=
r_frames,
 		if (ret >=3D nr_frames || start < vma->vm_end)
 			break;
 		vma =3D find_vma_intersection(mm, start, start + 1);
+		if (!(vma->vm_flags & (VM_IO | VM_PFNMAP))) {
+			ret =3D -EINVAL;
+			goto out;
+		}
 	} while (vma && vma->vm_flags & (VM_IO | VM_PFNMAP));
 out:
 	if (locked)
--=20
2.28.0

