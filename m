Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C6C173062AE
	for <lists+stable@lfdr.de>; Wed, 27 Jan 2021 18:53:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344253AbhA0Rww (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Jan 2021 12:52:52 -0500
Received: from mail-bn7nam10on2059.outbound.protection.outlook.com ([40.107.92.59]:51936
        "EHLO NAM10-BN7-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1344249AbhA0Rwq (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 27 Jan 2021 12:52:46 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=e3Y//DMEtQMJiI5N25BQmoajn0GzGFvAeb8kR0kowU7PVkq/edLOGE/KR1JkAqqC528TEwxFl8VW1VuELaXl/RDIGPY27taowX0BMwd8AaBDrU4pLXGIydZFDVgjJCUS4T7R/QpR3lc+rCPQYtmiN2L2eCbKqPaZVNF7LWzb46bXoxxWgeI/yxE4gv+vo10uBCGyMaGqHz0iC7Fw19zheqOsbXHm/OGyGshcyt8Flpxbw8MLuimyOyI+cbatDNVvTtuQ2oGFA3bmGr3aNIU8oGyKMjyY6pec372g46FcyVqxiHij8gwxNtTbnCOgDU0ivauAX4Llin3Qlijy6k+6Xg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UG1HLDilZkuzO+uvTwoie/g0gqPAe2+gyezoMtKL7YI=;
 b=ad83fyjS01mTxjWPs9h5jKHUX8p2l14giKXKP+aFCGp1jMNTIsQoyi+A+BiEQS4BS2cWCsKgcdaJttK/Vr4LC03hZXAoCugWi0z0I0CBoqnfRRSPkwJPzQOjLjgvXO9Rg/XUXOxNgVlNeh8cfNEKCPPMOawYlVa+6R+B+x1P1g3AWKNkIH+qOU0QppK3FJcXC9nP1eQt25Jcr92oZwUePxCqpI5XCw2QOA0LuptZH2hV8W7pxmIUOnir2Ds7d3nvOb79Zx93dpkJgDddhdbQXq4oA1fHzLECroiCFPJlk5XO/T0e8y/ZeHHOegWZaggkG0oWAR+ZmqIgf1pxqKOMqw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=vmware.com; dmarc=pass action=none header.from=vmware.com;
 dkim=pass header.d=vmware.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vmware.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UG1HLDilZkuzO+uvTwoie/g0gqPAe2+gyezoMtKL7YI=;
 b=LhsxxJU3lsxgH2LFDArcnunOC/U3SO9J8c7oK8PC7RU9MgMHlOIpc1bOLOOuv6h6QKxek4aBQ4Pjtf6l/YR4S41Bz+r20LJXHCjWX2FgnsPiSDhES+1z37WtZJE+xrX4Tk2CDRdXav4nS+//eWgKLtFmb82cRS4E5xSghlbQLqk=
Received: from (2603:10b6:a03:4a::18) by
 BYAPR05MB4406.namprd05.prod.outlook.com (2603:10b6:a02:ef::22) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3805.6; Wed, 27 Jan 2021 17:51:50 +0000
Received: from BYAPR05MB4776.namprd05.prod.outlook.com
 ([fe80::ddba:e1e9:fde7:3b31]) by BYAPR05MB4776.namprd05.prod.outlook.com
 ([fe80::ddba:e1e9:fde7:3b31%3]) with mapi id 15.20.3805.014; Wed, 27 Jan 2021
 17:51:50 +0000
From:   Nadav Amit <namit@vmware.com>
To:     Lu Baolu <baolu.lu@linux.intel.com>
CC:     "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        lkml <linux-kernel@vger.kernel.org>,
        David Woodhouse <dwmw2@infradead.org>,
        Joerg Roedel <joro@8bytes.org>, Will Deacon <will@kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: Re: [PATCH v2] iommu/vt-d: do not use flush-queue when caching-mode
 is on
Thread-Topic: [PATCH v2] iommu/vt-d: do not use flush-queue when caching-mode
 is on
Thread-Index: AQHW9J8qsK81TA6sQUu5BavghsL9SKo7wO2A
Date:   Wed, 27 Jan 2021 17:51:50 +0000
Message-ID: <DFC5801C-CD2A-4D2C-8AAE-CBCF76832858@vmware.com>
References: <20210127061729.1596640-1-namit@vmware.com>
 <15c974b1-b50d-9061-9d97-fef6f3804b22@linux.intel.com>
In-Reply-To: <15c974b1-b50d-9061-9d97-fef6f3804b22@linux.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: linux.intel.com; dkim=none (message not signed)
 header.d=none;linux.intel.com; dmarc=none action=none header.from=vmware.com;
x-originating-ip: [24.6.216.183]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: eb43a804-1e8a-4d2d-d9d4-08d8c2ec3999
x-ms-traffictypediagnostic: BYAPR05MB4406:
x-microsoft-antispam-prvs: <BYAPR05MB44068D12187570EA6728AB12D0BB9@BYAPR05MB4406.namprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:1824;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 7XoeTWCkMI0XX1Eu3YJBpg3Poj+maxGxF8kuWyNnCmvE3DyGs5oFgF52p3IRhk9+4ZDzOYLq4ALO1lbzcT7r3md7WT159qVoJ2Q8/sZtYeDa80teKv/7ZQmG4/f6BpRUqqU/3axDHaAdEFR9wEhs6g4pX6Ajy6/ijHjMF/S1HcRERhWn925zXbypks79FJMmdZU+WrSQIMbhEvcMhenWMTmp64W5Ul0eBld68oIgk2Nr/u82gUbiu2kdXNygvjD3AX6se9NDSSf99pjTyJmwdE30llVUwTuogYQRa8rBkBos8Ja8geqYMo1cFJ5V5rO2CJ/MKCkFqx7tOQOh4oWFeu1loSnryNCINjdH2AKtlkfwzHHPWS6jSIUmViQKj+lK8AaxbxUrAY7E2mR98Kf0oTb7tfOMnsdb3qZZztkU8SrTL2I2lYKMwDy8CZ7D5BmTlJtUu9GfWkJ61TvMTUtId26lErb3gSkgso89rKS/org0OTbUBBqTYe7IZ1C34ziFE3H8ocINJH22OGtHQM+EMpK/n7vUvsSA5CEdFMru7rLdIW64isQNAeyU8RDtN5ex3MfRcLG7zY1FG8bIPbKaqg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR05MB4776.namprd05.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(366004)(39860400002)(396003)(136003)(346002)(71200400001)(186003)(8676002)(64756008)(6486002)(83380400001)(2906002)(4326008)(36756003)(478600001)(5660300002)(54906003)(66476007)(66446008)(66556008)(76116006)(2616005)(86362001)(8936002)(26005)(6506007)(66946007)(91956017)(316002)(6512007)(33656002)(53546011)(6916009)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?4sqZnnzj24TuL0UO0LC0fij6RPKwL93KrJlrsat9YMlHHl93r98KNeyKhSNE?=
 =?us-ascii?Q?zpyTyK/LRTk2dzy8Je5PLrRNmWTPdbG/0EbtFP2MXfdKLnk5gpQiAUC5oQ6o?=
 =?us-ascii?Q?GubFumNh3Oz3FHdfO76BrMIkWGv2pw54WO3Lng8X6vTvIo3Af1YsoyxM7yRG?=
 =?us-ascii?Q?mP9BjkEs97/z0Bu6A5Wpvv+54LTDMrFddthG2wpVxDcMagi0uKnAAvjy/7fQ?=
 =?us-ascii?Q?EgkOg6VViDa8/r0PbgQyKgBQDf6RhvkkXNxg1gyzWs8XYOfblFv3hWnqn9De?=
 =?us-ascii?Q?mgjACfB9wgbJ0cKshxBXdXJ3aDsNbpKN/Qx9ISWbp41TjlI06VsNod+LxfN+?=
 =?us-ascii?Q?TXydxOt6/WPnbFN3WpJ+oe21+v03bF6e13P5lP5aZ1oJ6XPqd0E7zcxdrikY?=
 =?us-ascii?Q?ZCHty6DYKzrwXw2JMe6cfNmYhURjlmknyDjNQh78Gk+OuR45tUJ9A5M0YfEJ?=
 =?us-ascii?Q?hvP7doMdgnFEWgenLMkS0qNjlh6Y5TRHiDoPvYTaHMPMURupW+He0790q3GS?=
 =?us-ascii?Q?g5x9SdF36ZezaXlMfmZk4OoIhkIIftuUZHnTMIEbMy4NyBMbXAYMKK1Wp3nN?=
 =?us-ascii?Q?OBRBqxQ3Vt91XMMkcVcPOQsJSZxj3x3Uecsmw4iCaHl5eOQyktRkCAZI9lKy?=
 =?us-ascii?Q?0DN5EgNSrb5L9ahjMDHC7fw05SwTKcButVCgneDcZRWv5+YUSGMWtjoSbX0W?=
 =?us-ascii?Q?uoi/7oA60J5v16ceEe6nk7UBtIufEQ6X3nAXORzrpj7gUSOAhj0URyUOxmru?=
 =?us-ascii?Q?bXNyVb5KgWwMUn7dUmqFt/wButqtECffNnDMNv3K7iwVttvgr9EySOYzMcxn?=
 =?us-ascii?Q?mJPx1UauzcKnn5S8knRXiGYLZD64uNwU6D5MSX94SchYFZ2VAnHqvBuhzotH?=
 =?us-ascii?Q?Qi4GU3DOpZ/Ni5UlROeua2V7MEx8a/XfakMwKgZnG9t6bDBUommtmSAOzavh?=
 =?us-ascii?Q?a2JVobnPanlZlfkbO/eCumyXk1FK/TtX2DKMlOoi/ZzVCoO0eavG1GCQC4pY?=
 =?us-ascii?Q?ZdFiGQb3vQF/GYmHFcbDH5rFgVm9OuolVNx6RDjSNe5ihQAxE2L2ZGgQQR70?=
 =?us-ascii?Q?jgWptAsz?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-ID: <B2D1CB1105001B46A1E81B855DA3DBAE@namprd05.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: vmware.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR05MB4776.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: eb43a804-1e8a-4d2d-d9d4-08d8c2ec3999
X-MS-Exchange-CrossTenant-originalarrivaltime: 27 Jan 2021 17:51:50.6310
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b39138ca-3cee-4b4a-a4d6-cd83d9dd62f0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 1kuaGzD3NoafsHGAbpUEGB+5PFCwgL3QuIXVwRkqh7EjRU6WiRUtajqI+a2KWGVGhsBiR3zyaYhqnU+oPjYHAQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR05MB4406
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

> On Jan 27, 2021, at 3:25 AM, Lu Baolu <baolu.lu@linux.intel.com> wrote:
>=20
> On 2021/1/27 14:17, Nadav Amit wrote:
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
>> Synchronizing the virtual and the physical IOMMU tables is expensive if
>> the hypervisor is unaware which PTEs have changed, as the hypervisor is
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
>> Getting batched TLB flushes to use in such circumstances page-specific
>> invalidations again is not easy, since the TLB invalidation scheme
>> assumes that "full" domain TLB flushes are performed for scalability.
>> Disable batched TLB flushes when caching-mode is on, as the performance
>> benefit from using batched TLB invalidations is likely to be much
>> smaller than the overhead of the virtual-to-physical IOMMU page-tables
>> synchronization.
>> Fixes: 78d5f0f500e6 ("intel-iommu: Avoid global flushes with caching mod=
e.")
>=20
> Isn't it
>=20
> Fixes: 13cf01744608 ("iommu/vt-d: Make use of iova deferred flushing")
>=20
> ?

Of course it is - bad copy-paste. I will send v3.

Thanks again,
Nadav=
