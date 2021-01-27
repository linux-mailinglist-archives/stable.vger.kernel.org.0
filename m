Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4B9613052F6
	for <lists+stable@lfdr.de>; Wed, 27 Jan 2021 07:14:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232231AbhA0GO2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Jan 2021 01:14:28 -0500
Received: from mail-dm6nam12on2069.outbound.protection.outlook.com ([40.107.243.69]:52864
        "EHLO NAM12-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232116AbhA0Fpl (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 27 Jan 2021 00:45:41 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ayJQ/Pb6pO3KkHSNIIdzZtEE8AwOD6nj1yKPljNxYfk86VHbXd9pt/EdRIE16CQfd1YPHxsTBUVuCgn8Un5pNH+tpK+Lj0/PPwe/n4pKkMJTedriiDpsPYqJdGTq7uTo6uaSlgSn0AKFWG/gL3QOtMJP5a2/7YC3MTGCN9qfpwoQoLb9ba459tVFmXxDa8EYfdLhiJt7g+xSquS4M0bQtqvmmrS8WluK6Poy1T/c+B45n76mrmV8HM9fnMoZ2b6ydMPPzl67hc6iX5c/2acp9efhFyMXBZZHW7qKIEaFJhxPawUWbmKMP2YonSCsSSHXE8PHigg/V/Ywpyt4Zd4J3w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ylblwJHe2kgDYRMWCwDQQkWkA6scZly+wIQgidu4Icw=;
 b=CBjk3ui2lYOMw8ZZa6oUJGK7i/JA+blQudJsTUn3yGNQ+8u7WaGKx++TDwK4kVi43ygAvc+jj8w+lI/jRk0Q0xi14X3NVlml1iylabNeHRiuX17mAnOJN3dm8vxFJdKwSwKHYBKztEySqf/zit2K5JkP978SGizObY5Y2pOq/d1ejYLAA9VYw6m0Cabz6o0z7F3Do3gfgwIhTiSh5tIyBTetHOBcTOkZAIRGZ75fPqXSSpy8XHut0yDxEDTVS1hPY07d2TnMgmeXc4/R87j8iaNz+PMLcTI+a5yWlspLuaDdDttSx3xC1GXFWQMWCBV/uOk8QxUHeA4J9firMdDwxg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=vmware.com; dmarc=pass action=none header.from=vmware.com;
 dkim=pass header.d=vmware.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vmware.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ylblwJHe2kgDYRMWCwDQQkWkA6scZly+wIQgidu4Icw=;
 b=XJXcvOGnvYYqgRzq3gW98CyOzdZ9VZ0wKpkTp37LFpR7WT5koxNOmeQLZwEKfLItJId/1ZJei/fW31RuhAtTIZSlT2uvieMbrxaI5d82hDNSu7JTSqzYxbStWKa/UyG2P2Jofsz6AxXXWUCJcaLkvDJZh3m8b7iHGv+rGc4luqU=
Received: from (2603:10b6:a03:4a::18) by
 BY5PR05MB7192.namprd05.prod.outlook.com (2603:10b6:a03:1dd::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3805.5; Wed, 27 Jan
 2021 05:44:44 +0000
Received: from BYAPR05MB4776.namprd05.prod.outlook.com
 ([fe80::ddba:e1e9:fde7:3b31]) by BYAPR05MB4776.namprd05.prod.outlook.com
 ([fe80::ddba:e1e9:fde7:3b31%3]) with mapi id 15.20.3805.014; Wed, 27 Jan 2021
 05:44:44 +0000
From:   Nadav Amit <namit@vmware.com>
To:     Lu Baolu <baolu.lu@linux.intel.com>
CC:     "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        lkml <linux-kernel@vger.kernel.org>,
        David Woodhouse <dwmw2@infradead.org>,
        Joerg Roedel <joro@8bytes.org>, Will Deacon <will@kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: Re: [PATCH] iommu/vt-d: do not use flush-queue when caching-mode is
 on
Thread-Topic: [PATCH] iommu/vt-d: do not use flush-queue when caching-mode is
 on
Thread-Index: AQHW9EQyuCeJ3tKErUCDqGktZranxqo69n4A
Date:   Wed, 27 Jan 2021 05:44:44 +0000
Message-ID: <6A23AA4D-243E-4857-AB37-28135F161928@vmware.com>
References: <20210126203856.1544088-1-namit@vmware.com>
 <cf693fca-4f5a-a6a6-cc58-3f4e3cd882b6@linux.intel.com>
In-Reply-To: <cf693fca-4f5a-a6a6-cc58-3f4e3cd882b6@linux.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: linux.intel.com; dkim=none (message not signed)
 header.d=none;linux.intel.com; dmarc=none action=none header.from=vmware.com;
x-originating-ip: [24.6.216.183]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: a6694850-2562-46a4-1f97-08d8c286a677
x-ms-traffictypediagnostic: BY5PR05MB7192:
x-microsoft-antispam-prvs: <BY5PR05MB71927592BC16318B58CABE26D0BB9@BY5PR05MB7192.namprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: GeVio7USKg4s/BOGIdRk5bACjbiJjNvDkHi3HcfS4RFBqFm1dy8Ok4dOprLs0+ZLEFt8c76imbsYC/zwCmMSQD4BYBPj2wy0Upv5mCb4rgXRm3r0Zczo+R5lYmdj5O1tY3yOgQmNRbWHxb3zEK51uDKZRxd6neZV5iOLr+EYUffYTqIMTbwZL7diNgJn/gUV88Yd3MjpcGB4CWekEYnQg4nNN15NaZPeSgjzS6vuSMwIuUg2/fGzg/KpLy+BOc8leZSHWgtMkTGDx7nI36XyTeW3DDWvd9WK+7kfvF6NJyIldsouSbfM6i2PkCzEv7Qtc9Vb6FF2EpNEo1R86CHonEAIheC0Noz+hjOGEG9pLSKFO/nU+9sNo5uh+u6g/fWOFGn94MlKUEXExsBx5v2JpvF+DHyf4PZJqK4IfIG2qK5/OjupdDxTRKkAos3xkFyp9Y0Lg1k4XUmW9Yz/m4AFPmEHAoFVfPvrAz/655Uc+wlJVw4zcIO43HlACfeDKROZuoBExNFJT+HetyUqVNnHZPDNrFQStaokFjxIx/KwZj2swDz7BMSGrNAcLJRzoX76NjJZ9YT+0FAsJp1tnke9dQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR05MB4776.namprd05.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(366004)(396003)(39860400002)(346002)(136003)(2616005)(86362001)(316002)(6512007)(33656002)(5660300002)(53546011)(6506007)(36756003)(186003)(8676002)(66476007)(64756008)(66946007)(66556008)(76116006)(66446008)(71200400001)(6486002)(2906002)(54906003)(4326008)(478600001)(26005)(8936002)(83380400001)(6916009)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?/X0VKznPLoDCMecUuzJyYlrjvcoM0ZdkaMiRFajzrM3OFuZjOp8yGqLHakAO?=
 =?us-ascii?Q?TwDsRkHTF/JCJ4i1OgdqT30ieRAzGpxs2tZ7q0upts/Wk+Olqdd9RtAkMHtt?=
 =?us-ascii?Q?EVMDIGCeuL2b6vAQYD9q+P8Z8IkI2JjIyhyD95asoZDodo7ESRc7cIHTlR1C?=
 =?us-ascii?Q?+uxsdY2SbfsEEg5aeBn3pYJQzbPoKRjqVfUhiTitd7wVfNrLR/06pD7TeOqb?=
 =?us-ascii?Q?hZyel+y3+J7H+7DdfH9ErLf9gRXoWaFQ7Uc3w7xWlVnrHJSrjioJP+QOLRAU?=
 =?us-ascii?Q?Jj/wpehlT+HeJjtTkLKuHEKhyyvptEXSrRenefZUJUZwRns6HQ23MeZdUpDz?=
 =?us-ascii?Q?yOV2uxMaNcpkRrcBDAn8VX0YJyjgHA8rORMQC6HHhP0ZX7MEWPDCgWqOJ3cT?=
 =?us-ascii?Q?POjUHSyQGhwAvKlFOHztnJnLPuk4Dnc3N7x7Ch7w8y2QQryMaqDZLpawmql6?=
 =?us-ascii?Q?bsvDXoY1yqrCRCx4t8NJ5Ng+jYKoBh/kSa3it6wVqMdPIsPFjYBuOmIAxz0Z?=
 =?us-ascii?Q?3f6mNinzC8AIiRHoOIqzOqfzftoItdZZFf81VTNl4VHEIKGGvktXMlJkuhyV?=
 =?us-ascii?Q?86f8MFHtKht4S2OjfnSrjo5x6tQ1uKWAfF5YZ8YVT78LjGEWLU6goZsn0mrp?=
 =?us-ascii?Q?MNwhFPHCx731OlfuCYF0MBYpnhRpMKBgBbAWvxi7H2mNE5X8hOZnhopN2EkI?=
 =?us-ascii?Q?XjyEi2kMb92SxhsESvFzn1RsY2v+KwUQ+z0yxlLDm55OyCe2ctxecJ9DyRIp?=
 =?us-ascii?Q?kdVIVipGJZCozceV8+hvGnlb+I27uORNb50NTkez0yrdO8d7WDanke+ZcNPX?=
 =?us-ascii?Q?IcLdO++C2ROd5XWnGAZ8DDZF89MgBPgsDoZosts8Lf1lkPkch93or9Tgm/qX?=
 =?us-ascii?Q?K5bmEsYi9ikEfU8r0uTjbhwQNBR1WCZRWbtrXnHor5FgKfiF7f/89b1ruT8h?=
 =?us-ascii?Q?uohZvwW1eKyIwVQQEdVt5YKqnTqO3S/gmg61jd2pEQLrcW9Cw0yVBsAgh8/h?=
 =?us-ascii?Q?tccBNnMmyRuaCNqIp+YxuTyO16kYXTxf78dxBnWzitT7gco85UYC33MPe7oT?=
 =?us-ascii?Q?4sl2bIon?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-ID: <AF507E7F0CFD0D46A1E6ADD1B6F70229@namprd05.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: vmware.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR05MB4776.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a6694850-2562-46a4-1f97-08d8c286a677
X-MS-Exchange-CrossTenant-originalarrivaltime: 27 Jan 2021 05:44:44.5646
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b39138ca-3cee-4b4a-a4d6-cd83d9dd62f0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: HojlFiajytKtGwrDaM1Bb1ZRp3cufwMCdGsyfn9nUxHjaeNzHYCcsNDgll1JoYsLSN/FjJACY/bWRljNvkcdfg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR05MB7192
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

> On Jan 26, 2021, at 4:26 PM, Lu Baolu <baolu.lu@linux.intel.com> wrote:
>=20
> Hi Nadav,
>=20
> On 1/27/21 4:38 AM, Nadav Amit wrote:
>> From: Nadav Amit <namit@vmware.com>
>> When an Intel IOMMU is virtualized, and a physical device is
>> passed-through to the VM, changes of the virtual IOMMU need to be
>> propagated to the physical IOMMU. The hypervisor therefore needs to
>> monitor PTE mappings in the IOMMU page-tables. Intel specifications
>> provide "caching-mode" capability that a virtual IOMMU uses to report
>> that the IOMMU is virtualized and a TLB flush is needed after mapping to
>> allow the hypervisor to propagate virtual IOMMU mappings to the physical
>> IOMMU. To the best of my knowledge no real physical IOMMU reports
>> "caching-mode" as turned on.
>> Synchronizing the virtual and the physical TLBs is expensive if the
>> hypervisor is unaware which PTEs have changed, as the hypervisor is
>> required to walk all the virtualized tables and look for changes.
>> Consequently, domain flushes are much more expensive than page-specific
>> flushes on virtualized IOMMUs with passthrough devices. The kernel
>> therefore exploited the "caching-mode" indication to avoid domain
>> flushing and use page-specific flushing in virtualized environments. See
>> commit 78d5f0f500e6 ("intel-iommu: Avoid global flushes with caching
>> mode.")
>> This behavior changed after commit 13cf01744608 ("iommu/vt-d: Make use
>> of iova deferred flushing"). Now, when batched TLB flushing is used (the
>> default), full TLB domain flushes are performed frequently, requiring
>> the hypervisor to perform expensive synchronization between the virtual
>> TLB and the physical one.
>=20
> Good catch. Thank you!
>=20
>> Getting batched TLB flushes to use in such circumstances page-specific
>> invalidations again is not easy, since the TLB invalidation scheme
>> assumes that "full" domain TLB flushes are performed for scalability.
>> Disable batched TLB flushes when caching-mode is on, as the performance
>> benefit from using batched TLB invalidations is likely to be much
>> smaller than the overhead of the virtual-to-physical IOMMU page-tables
>> synchronization.
>> Fixes: 78d5f0f500e6 ("intel-iommu: Avoid global flushes with caching mod=
e.")
>> Signed-off-by: Nadav Amit <namit@vmware.com>
>> Cc: David Woodhouse <dwmw2@infradead.org>
>> Cc: Lu Baolu <baolu.lu@linux.intel.com>
>> Cc: Joerg Roedel <joro@8bytes.org>
>> Cc: Will Deacon <will@kernel.org>
>> Cc: stable@vger.kernel.org
>> ---
>>  drivers/iommu/intel/iommu.c | 26 +++++++++++++++++++++++++-
>>  1 file changed, 25 insertions(+), 1 deletion(-)
>> diff --git a/drivers/iommu/intel/iommu.c b/drivers/iommu/intel/iommu.c
>> index 788119c5b021..4e08f5e17175 100644
>> --- a/drivers/iommu/intel/iommu.c
>> +++ b/drivers/iommu/intel/iommu.c
>> @@ -5373,6 +5373,30 @@ intel_iommu_domain_set_attr(struct iommu_domain *=
domain,
>>  	return ret;
>>  }
>>  +static int
>> +intel_iommu_domain_get_attr_use_flush_queue(struct iommu_domain *domain=
)
>=20
> Just nit:
>=20
> Can we just use this
>=20
> static bool domain_use_flush_queue(struct iommu_domain *domain)
>=20
> ?

Sure.

>=20
>> +{
>> +	struct dmar_domain *dmar_domain =3D to_dmar_domain(domain);
>> +	struct intel_iommu *iommu =3D domain_get_iommu(dmar_domain);
>> +
>> +	if (intel_iommu_strict)
>> +		return 0;
>> +
>> +	/*
>> +	 * The flush queue implementation does not perform page-selective
>> +	 * invalidations that are required for efficient TLB flushes in virtua=
l
>> +	 * environments. The benefit of batching is likely to be much lower th=
an
>> +	 * the overhead of synchronizing the virtual and physical IOMMU
>> +	 * page-tables.
>> +	 */
>> +	if (iommu && cap_caching_mode(iommu->cap)) {
>> +		pr_warn_once("IOMMU batching is partially disabled due to virtualizat=
ion");
>> +		return 0;
>> +	}
>=20
> domain_get_iommu() only returns the first iommu, and could return NULL
> when this is called before domain attaching to any device. A better
> choice could be check caching mode globally and return false if caching
> mode is supported on any iommu.
>=20
>       struct dmar_drhd_unit *drhd;
>       struct intel_iommu *iommu;
>=20
>       rcu_read_lock();
>       for_each_active_iommu(iommu, drhd) {
>                if (cap_caching_mode(iommu->cap))
>                        return false;
>        }
>        rcu_read_unlock();

Err.. You are correct (thanks!).

To be frank, I do not like it. I once (10 years ago) implemented a VT-d DMA=
R
virtualization prototype (not for VMware), and it seemed to me that the bes=
t
practice to maximize performance would be to virtualize one IOMMU with
caching-mode turned off for emulated devices, and one IOMMU with
caching-mode turned on for passthrough devices.

If some hypervisor used such a scheme, it would be better to allow the VM t=
o
use batched invalidations for domains that only hold emulated devices.

However, as you said, it is not simple, since we do not know which devices
will be attached to each domain. So I will use your scheme (with the
correction that you sent).

It is a shame the code got broken so long ago and I (and others) did not
notice.

Thanks again,
Nadav=
