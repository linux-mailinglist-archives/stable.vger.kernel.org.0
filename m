Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 36F845AA47F
	for <lists+stable@lfdr.de>; Fri,  2 Sep 2022 02:36:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233734AbiIBAgb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 1 Sep 2022 20:36:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48000 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233723AbiIBAga (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 1 Sep 2022 20:36:30 -0400
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2068.outbound.protection.outlook.com [40.107.223.68])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BBBF4580AA;
        Thu,  1 Sep 2022 17:36:27 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BwGIx7uOkT4bj9sFaQJRp8+TJF50AHCi5/3kMKOiUFiRY+H2jpRwQyOdM361qYCHZAyoeHaorIEA8h/8gtGNVpMh1ed88IHzx4OYkEppJfZm7MbMVYGag7qy9p+HztCDdnTyCQy7eX3iQDu1AkXH4l/TzhjlStCpPmYh31EJ6vU2JS0YNSWF1FSoLzBwpQ/kHP4pVG2OGQ09WMeMd3gp6LuN0c/sQ3pM1VTM+3KOjBBvEmgyHAcjMtRsavKlzAsRJGCioJm/FRG2OUSO7eNVrBFI9Q7kU3HNZwCYYU2E9kJJX3BacWL0xfVUVAofWr+T57lML7SkQWLuoE6DbGwnfA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=eiZcJOw/Rdqbcxw/aFtmjNXtEWbSyoeadqVjC97LY1g=;
 b=QtnrpoEQj7E6rRzZnGoJ8l2rLmLa2kzGcWLqIwPJn9fvx9cvMzjZ/KF0L8/dyR5ce/RRlSjb+KqpblVhkgQtO/wQjqbNdFhwNRzvVvneYyhIA4mELxO+FWO9h95/X+XgBpvggBEt8eeMIXagmtvXl1jDtJlapf7hS03WJmoydDViYJN6BwmvetjC4CkMQM4qFMfzBTB5a/RSjVBaN4iiWMfL6d9X9BkCh/JtapJmPWvxk7F8VfzCM1Av5nseg+SWXsJ68BpPXZZ78LbbAMJtPVwjK+//Qb0V+YwDbGVFS3avVtK9t8PFl727EXncfN6cqAwILeZujM3He6lGbNKKxQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=eiZcJOw/Rdqbcxw/aFtmjNXtEWbSyoeadqVjC97LY1g=;
 b=sgHnj4CYpJYMwiN15g41RE6v2YRVDjN1KRDQmqulsUFYkn1gHH1wwei9EjevxeJxQRNKg8lGVuexn7OZuBnZKoIqbjg9Vhk/N5NSK85IUZ5friPMgzIxf5PSK4l1QCfscOhsvP3+T3EILKNET/TnQ7L/ltLZf4EDGuSq3knatm040o2mo5hHKA9MVS1UZRh7XG3BTZqFXuCXSTsymsgHDh3UKtOwn5iHK8mAT5DP9XLkJEQL7YGCCjFWW8WKG1tY0RoRRyjW2nnVbDQjBoWsSCI/2lLEVIGNeR9YDF7yy6xoOFqodgWVb46MBo8N1Z2Nfb1iJnU1YMqsOLpfif9SpQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from BYAPR12MB3176.namprd12.prod.outlook.com (2603:10b6:a03:134::26)
 by DM4PR12MB5086.namprd12.prod.outlook.com (2603:10b6:5:389::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5588.10; Fri, 2 Sep
 2022 00:36:25 +0000
Received: from BYAPR12MB3176.namprd12.prod.outlook.com
 ([fe80::7432:2749:aa27:722c]) by BYAPR12MB3176.namprd12.prod.outlook.com
 ([fe80::7432:2749:aa27:722c%7]) with mapi id 15.20.5566.021; Fri, 2 Sep 2022
 00:36:25 +0000
From:   Alistair Popple <apopple@nvidia.com>
To:     linux-mm@kvack.org, akpm@linux-foundation.org
Cc:     Peter Xu <peterx@redhat.com>, Nadav Amit <nadav.amit@gmail.com>,
        Alistair Popple <apopple@nvidia.com>,
        huang ying <huang.ying.caritas@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>,
        "Sierra Guiza, Alejandro (Alex)" <alex.sierra@amd.com>,
        Felix Kuehling <Felix.Kuehling@amd.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        John Hubbard <jhubbard@nvidia.com>,
        David Hildenbrand <david@redhat.com>,
        Ralph Campbell <rcampbell@nvidia.com>,
        Matthew Wilcox <willy@infradead.org>,
        Karol Herbst <kherbst@redhat.com>,
        Lyude Paul <lyude@redhat.com>, Ben Skeggs <bskeggs@redhat.com>,
        Logan Gunthorpe <logang@deltatee.com>, paulus@ozlabs.org,
        linuxppc-dev@lists.ozlabs.org,
        "Huang, Ying" <ying.huang@intel.com>, stable@vger.kernel.org
Subject: [PATCH v4 1/4] mm/migrate_device.c: Flush TLB while holding PTL
Date:   Fri,  2 Sep 2022 10:35:51 +1000
Message-Id: <9f801e9d8d830408f2ca27821f606e09aa856899.1662078528.git-series.apopple@nvidia.com>
X-Mailer: git-send-email 2.35.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BYAPR07CA0085.namprd07.prod.outlook.com
 (2603:10b6:a03:12b::26) To BYAPR12MB3176.namprd12.prod.outlook.com
 (2603:10b6:a03:134::26)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ac77a4c3-da93-448c-d75e-08da8c7b2aa6
X-MS-TrafficTypeDiagnostic: DM4PR12MB5086:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 5By7JDjBV4FpvC0E2wNtdupNsf7r0E3W3wZqcO0NzjDSM98U210fvCJOK0aOZK/IRLsojvLDPE3s+Dd+fneNQbigsasxpJKUW+wlafT4P3yvbPOM+zTdBvw15cezTRvt9d0It4ijrCR8DR68oGjlcRsSlss1Tjy9Y0exWk7H/ECrJxrRqzHBUSjzRRgNkOiMJ20M5qf8O1AIABgfTrJxAZlPqvbeSGXU/96wyyh450esWAqo+pVzm3kQEB6skkRU5yM40oB0SOZPDaMXwhF2oHpLvou5SeZ1xbJ7liugzniVIMcRzZmLn4YKOZRL7EPedY6YLAfojneRJ+zVvlnco3BrL/hJ9TiZpkjrno+Wwdl9fU6KAKuAC13TkE+yrFoXQ/OUW18MTpVrvTOQb8C0gjVUjJ9ifYnRmCchvdfGupmwsY2l0JGnuUonGntMZhY/CVWpV/mYoG4UEkX21Q6EoD713Jiftchh1ftkq6/BiPhVm1+wNWd9CIQzSF51ERzZ5I7KIh9SaNrH04SU9keQibiCiXujNdxd7DntU2hdzNf3PAKj8vpFo+IYgukwne4VYZHNhZlWg0sbkxKy8OeV11vWr3wmCSyMGeXeEz6/nozJ36JrC0/+Or6Ou6z9aFcZx0RXWISV6ETYTbojWRJsGcBxXAJaaVho5PNPYmrq2PJk6jSyfFcFinkuWH9VMd8vdEemkhSrB7b39iC6ckLWHA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR12MB3176.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(366004)(376002)(346002)(39860400002)(396003)(136003)(83380400001)(38100700002)(66556008)(66946007)(66476007)(8676002)(4326008)(54906003)(316002)(2906002)(7416002)(8936002)(5660300002)(6506007)(6512007)(26005)(186003)(2616005)(478600001)(41300700001)(6666004)(6486002)(86362001)(36756003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?3G2x+tFQF0Bd6VTDJFUQT1LTnTEEbkHbuy6CcZEs1eJts9JPjNQqzJuWE9tJ?=
 =?us-ascii?Q?NqandOfZGDks/GjTuplL3s2hW4EG2UUizk3a4WlEAdSD6XAu29kMuq0LpA6U?=
 =?us-ascii?Q?Ikm+IEJkhGzCS/rDv1gSPzO3Wj/N9lHVLLs+MRKnkl7vgGgNIRtpcM7giSrG?=
 =?us-ascii?Q?BS8ZpnwAsWMitAZGM8YugyLq6LkgDKzVxbMxV/HwMeOPDjOS4ayw61Ia1g/i?=
 =?us-ascii?Q?hfTgU4aTcWRcnvzKp2eRkxqTbnJ9/EVFm64DTfpG8bOYofqhX5z3YgjiNnz2?=
 =?us-ascii?Q?XnBwjFzFqtaEMcAz6WqPoTXaqV9pAvIzas7hQVbve3EYbcTdiRRsZ/LqNurg?=
 =?us-ascii?Q?iBSmL4Iz50KvTEvGw+ex7yvOi756drYiGCY2rM06pbxZERL9gN8CrqU1WhzP?=
 =?us-ascii?Q?BYODex4jQt3CkODbeM+GcLJxSUtIMJo/pimK3806kM53dXfGZMekTknIHi73?=
 =?us-ascii?Q?YurtmvhsmR9gWli11ne+RkiGFDqIIlVto13vjmYOHW7SawNmJUVhXvsdvEFI?=
 =?us-ascii?Q?rnIbpulaKmIhqphB4HTY/tTdLYVz4NuxCdEvArMh6E+JXl2k9+ysh+FxA+Sk?=
 =?us-ascii?Q?KfXmWj3eOs4oH9eXjL+53sA63OuGrvzPjnn2Cx60fit7DhjvM2j/lQPdm4a4?=
 =?us-ascii?Q?TW+tV04BleB8PwkTvK6b4F2eY5eDn1mcaJcvi5re+aS++vraCtjnmXcIDVLc?=
 =?us-ascii?Q?yC9LcjSabN7tjr4tiMIaMITdmoayoYJKFM4sOJY9/eayuVku+ZRZivfGGLMK?=
 =?us-ascii?Q?3TQl7ZILxemCWNOpVv2Y1KR5Y19JKgKftAONIq8Yz5mm84aIAxg06UxmMK50?=
 =?us-ascii?Q?42EoacEpAiDkj0/9roTGK9oPQTgLevGRrnfRgyNMrpuai8tGdM/740JsiuIa?=
 =?us-ascii?Q?pNi5ydxSJnUNB8dnAiWnZZQeqhc5bNSILdfFX3sYY/BCl9Adaw+m9mymhXhC?=
 =?us-ascii?Q?wGcxA3ECuUbqcEO5vPhs9JWqe8U97YNa9fc9gog1Q1lz7Ldy2Ty3WDUOrHzx?=
 =?us-ascii?Q?HNL+A/oE3dXuHvQE3/oI+pl9ShiMcvypr7E7A5puPAAhPSUN5cyCdStLtbgC?=
 =?us-ascii?Q?/zroSH6e0wh/Kot5ZsXyw2xYCfCh00TklNLo6IFokxZZrEdtnWTaReFL0dga?=
 =?us-ascii?Q?N9SiMhxVb7TmAGi/3zv7T3Xeyjf6AZezHEvrJsRPAAwShbY3YFv4CzPfiWgB?=
 =?us-ascii?Q?83K7LxUCuB4wZyrE0qKbnV+AxTjOzJntmccKSKPDVcAE6MKIJ2ysXC3uAQuM?=
 =?us-ascii?Q?2cuRc67RnMxfdzOZi2CLzdDRDcqJnC7zFfg6YxrzPa5rg7KUnK+/D0FaezbN?=
 =?us-ascii?Q?r6lZDd/iTo+ZZLGs/AOEAxEltIUrqL9Aw/qLilCnHtuOLE6vjsdtF1H1/sPx?=
 =?us-ascii?Q?8ZABXJvfI/sJX1Ca0O8zY09+EIfh/3EHvR7uIoKtfuMkiGSlVC4DvBhDtx/Y?=
 =?us-ascii?Q?da2joV8UgQJjKdE8PqzvOb4YrZ3X7jGKMCyRr8vje3VpebsakdHNSGEDzPpI?=
 =?us-ascii?Q?vxmg/ATy89bpV7kgM1UNdL8y8EAkcaawDg2bN5not0GyQHBbqFkHUZ4MsF+d?=
 =?us-ascii?Q?6hHr3kO6erSoqZOvnsFbyx2vHnIvrK1eWmplbZ1W?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ac77a4c3-da93-448c-d75e-08da8c7b2aa6
X-MS-Exchange-CrossTenant-AuthSource: BYAPR12MB3176.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Sep 2022 00:36:25.2820
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 01V0ss6H0tvrrxartWe58iu8sKaOouzy1+HsWOLX3ATOVpRHxzv1QacREU11LQuJrg/2fFsEOSRavEoexZJtCg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB5086
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

When clearing a PTE the TLB should be flushed whilst still holding the
PTL to avoid a potential race with madvise/munmap/etc. For example
consider the following sequence:

  CPU0                          CPU1
  ----                          ----

  migrate_vma_collect_pmd()
  pte_unmap_unlock()
                                madvise(MADV_DONTNEED)
                                -> zap_pte_range()
                                pte_offset_map_lock()
                                [ PTE not present, TLB not flushed ]
                                pte_unmap_unlock()
                                [ page is still accessible via stale TLB ]
  flush_tlb_range()

In this case the page may still be accessed via the stale TLB entry
after madvise returns. Fix this by flushing the TLB while holding the
PTL.

Signed-off-by: Alistair Popple <apopple@nvidia.com>
Reported-by: Nadav Amit <nadav.amit@gmail.com>
Reviewed-by: "Huang, Ying" <ying.huang@intel.com>
Fixes: 8c3328f1f36a ("mm/migrate: migrate_vma() unmap page from vma while collecting pages")
Cc: stable@vger.kernel.org

---

Changes for v4:

 - Added Review-by

Changes for v3:

 - New for v3
---
 mm/migrate_device.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/mm/migrate_device.c b/mm/migrate_device.c
index 27fb37d..6a5ef9f 100644
--- a/mm/migrate_device.c
+++ b/mm/migrate_device.c
@@ -254,13 +254,14 @@ static int migrate_vma_collect_pmd(pmd_t *pmdp,
 		migrate->dst[migrate->npages] = 0;
 		migrate->src[migrate->npages++] = mpfn;
 	}
-	arch_leave_lazy_mmu_mode();
-	pte_unmap_unlock(ptep - 1, ptl);
 
 	/* Only flush the TLB if we actually modified any entries */
 	if (unmapped)
 		flush_tlb_range(walk->vma, start, end);
 
+	arch_leave_lazy_mmu_mode();
+	pte_unmap_unlock(ptep - 1, ptl);
+
 	return 0;
 }
 

base-commit: ffcf9c5700e49c0aee42dcba9a12ba21338e8136
-- 
git-series 0.9.1
