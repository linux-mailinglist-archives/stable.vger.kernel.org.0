Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 052AC2726C7
	for <lists+stable@lfdr.de>; Mon, 21 Sep 2020 16:16:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726929AbgIUOQS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Sep 2020 10:16:18 -0400
Received: from nat-hk.nvidia.com ([203.18.50.4]:5957 "EHLO nat-hk.nvidia.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726395AbgIUOQS (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 21 Sep 2020 10:16:18 -0400
Received: from HKMAIL104.nvidia.com (Not Verified[10.18.92.77]) by nat-hk.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B5f68b5af0000>; Mon, 21 Sep 2020 22:16:15 +0800
Received: from HKMAIL104.nvidia.com (10.18.16.13) by HKMAIL104.nvidia.com
 (10.18.16.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Mon, 21 Sep
 2020 14:16:15 +0000
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.172)
 by HKMAIL104.nvidia.com (10.18.16.13) with Microsoft SMTP Server (TLS) id
 15.0.1473.3 via Frontend Transport; Mon, 21 Sep 2020 14:16:15 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PBJ6Fpi6ZlByXH56yoBc99X0yVah2j4vdIq1YYxiTPHXztuMOo+bZjwqKHXF2UuBgSkXeyZFz6XmJq1QQ3yAtTOSX7WwKT7NybB5QXm0yZ1CEJyAXSnpkdPE1BWYcADiuLLIPN0wpfOnsACeggWIojSzIYPdBPJl6JWWmfC7C+xzggDyU5AsAD1um23iVyMmRO3/iCmVWtKUglFZxCgJg+iowTXjfHxAR56BVjgGKYOV2ffd8QLZ60vxVnzFqMqLvkSyx+a9JlBhxILPs5aVw5I3h+p1lPMAcTMBxcNJGgEldBW6yma4veh5ch0zg7Xf1SYRACxG7VBy+YaIEI4dSA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=s4K9yWsseSN2ZDaFU4vGj5DDcWc0CJP04jHxOpYtAdU=;
 b=Fslhy0fEkEjsXvkmtz9nz0v6zSERYBIKLj+1voF8eNdQa8iOCo221AgCTHSIQDupEGD5NP18cNE0JZV1pl4CI7POlsJE0dpMKwQ/uJniwaWFMU/W9rqi+yWS0jJtjkm0YDKWdxx+BetC3ITf6+zyZMTNTXDjrgaIHw2pWPkqyni9PDi0UmVmj8tqtHFcC74F1lkZ/Ej/p0sbjjBKCgfNVrwoNq9xYzK1qBlcLQyUaDu4wvCf6UeGtEQHetgSCJdTSf+P+OOUHilowPH2zeARJl9uIVjaj/Heb2/wOmNGH+87WU4ROkCJ8AuibKeM2TEFjbAjbF8F6V8beAWuExPJww==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
Authentication-Results: vmware.com; dkim=none (message not signed)
 header.d=none;vmware.com; dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB3834.namprd12.prod.outlook.com (2603:10b6:5:14a::12)
 by DM6PR12MB4340.namprd12.prod.outlook.com (2603:10b6:5:2a8::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3391.19; Mon, 21 Sep
 2020 14:16:13 +0000
Received: from DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::cdbe:f274:ad65:9a78]) by DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::cdbe:f274:ad65:9a78%7]) with mapi id 15.20.3391.011; Mon, 21 Sep 2020
 14:16:13 +0000
Date:   Mon, 21 Sep 2020 11:16:11 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Vishnu Dasa <vdasa@vmware.com>
CC:     <aditr@vmware.com>, <dledford@redhat.com>,
        <linux-rdma@vger.kernel.org>, <stable@vger.kernel.org>,
        <pv-drivers@vmware.com>
Subject: Re: [PATCH for-rc] RDMA/vmw_pvrdma: Correctly set and check device
 ib_active status
Message-ID: <20200921141611.GS3699@nvidia.com>
References: <20200918023859.22181-1-vdasa@vmware.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20200918023859.22181-1-vdasa@vmware.com>
X-ClientProxiedBy: MN2PR18CA0020.namprd18.prod.outlook.com
 (2603:10b6:208:23c::25) To DM6PR12MB3834.namprd12.prod.outlook.com
 (2603:10b6:5:14a::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (156.34.48.30) by MN2PR18CA0020.namprd18.prod.outlook.com (2603:10b6:208:23c::25) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3391.14 via Frontend Transport; Mon, 21 Sep 2020 14:16:13 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1kKMbz-002dRj-Ra; Mon, 21 Sep 2020 11:16:11 -0300
X-Originating-IP: [156.34.48.30]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f082ada8-2a2e-4c34-d8e5-08d85e38e551
X-MS-TrafficTypeDiagnostic: DM6PR12MB4340:
X-Microsoft-Antispam-PRVS: <DM6PR12MB43404B1CBDA6E0FC99C80FB7C23A0@DM6PR12MB4340.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3631;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Mgt8+0eBAOFd8H0V4VxGMkf5twvjfhM+SbbBoZCZ9FWbn/WR54KbUFFq0oEAHwr6iQzmZIq0IjUi28O1lk0LNutgbvS8ABlW28dumtF9P/SZ+oqzFTzYAFdIDj/tjegSDSNrxhQRdfAuq/cY9j2vQcTHpemj98JHu14jlWSgJScjSRxUTjDBAzLOpR558X0TmBa427FKSLPr4WZXwcVtMk11j6ea9qJXM+GrTLOdKIcaXZxCo041ONKvCBD+g3f8IA2G7yENzAdTXE6PPxAIPXc2umz2GkZ4vptUu31Be3gHWlvE1SoopQ68BoR7rHUJ7/n6/kdPZeu3g/GUKyWRdA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB3834.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(346002)(136003)(376002)(396003)(39860400002)(1076003)(66556008)(316002)(4326008)(66476007)(8936002)(9786002)(66946007)(9746002)(6916009)(186003)(5660300002)(8676002)(4744005)(36756003)(83380400001)(2616005)(426003)(26005)(478600001)(33656002)(2906002)(86362001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: xsahfWhmOx+7gm2oB9UKDIuLaB3z91f4dDSl3U8I17TCxR2Mj2icvsoZBeJpDSYs2TS0b2oexKaGczf/Q/ujL244u9XWjZynTN3C1VwHEWi00hJU3DaC1fdLOwwOTAzAmqyjA7xrpjqj4nTTQN3uBkkUMr4s36jWURka9hcL/8wJrGE1nAphRVkWAU22XGSJjtXElLF2udy2TcHXFRphWBXB+9t+3/egaCmu5012nK3OhuYkvJXvfKoEk3a+KMr2LWJ+1BERt3j/OvW9Ss34JoyrNrvaTf5rU+WvbAIFs6vihtIHJIoDHWxbLXg/hcDqbaJL+W9nSYUhkIKyPBPwPX4FbJ4CR+4KfjZWHc9uGZ51Hl4msxgP+ry8MY9rXV7zo+h9wLgH7CI9rJSDqD4LFNYCC3Sy2IekhbTo2po9TV9URa+Lk20XcSbotgqpxH4mdMfOTysBLqqmlYwjQ+xXH/FXDpH1MNdY8ZpEm4cABR7viLKFKMfUZms+YwZfxjRynagaOvj1tQXn6y5xjdQLOyzpj70w5ZLlvZ6WAjAx3uw1IJJ/duhAKrglwrsYYpxucQmtmmrvyq/81jmrLkvhPEAN5rONL+iRqbYjToNNE2gHGpyi4vXuJcpqL584Rg8kez11L2Asuwe1qcuJto8oNQ==
X-MS-Exchange-CrossTenant-Network-Message-Id: f082ada8-2a2e-4c34-d8e5-08d85e38e551
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB3834.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Sep 2020 14:16:13.3270
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: YmEQcbj142mMu1Wajcr9YblUI2knzMTAPdwc2RV8uVflCywRJTL88ntwgA03JO7E
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4340
X-OriginatorOrg: Nvidia.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1600697775; bh=s4K9yWsseSN2ZDaFU4vGj5DDcWc0CJP04jHxOpYtAdU=;
        h=ARC-Seal:ARC-Message-Signature:ARC-Authentication-Results:
         Authentication-Results:Date:From:To:CC:Subject:Message-ID:
         References:Content-Type:Content-Disposition:In-Reply-To:
         X-ClientProxiedBy:MIME-Version:
         X-MS-Exchange-MessageSentRepresentingType:X-Originating-IP:
         X-MS-PublicTrafficType:X-MS-Office365-Filtering-Correlation-Id:
         X-MS-TrafficTypeDiagnostic:X-Microsoft-Antispam-PRVS:
         X-MS-Oob-TLC-OOBClassifiers:X-MS-Exchange-SenderADCheck:
         X-Microsoft-Antispam:X-Microsoft-Antispam-Message-Info:
         X-Forefront-Antispam-Report:X-MS-Exchange-AntiSpam-MessageData:
         X-MS-Exchange-CrossTenant-Network-Message-Id:
         X-MS-Exchange-CrossTenant-AuthSource:
         X-MS-Exchange-CrossTenant-AuthAs:
         X-MS-Exchange-CrossTenant-OriginalArrivalTime:
         X-MS-Exchange-CrossTenant-FromEntityHeader:
         X-MS-Exchange-CrossTenant-Id:X-MS-Exchange-CrossTenant-MailboxType:
         X-MS-Exchange-CrossTenant-UserPrincipalName:
         X-MS-Exchange-Transport-CrossTenantHeadersStamped:X-OriginatorOrg;
        b=JSMFJ3zLtAnpjX6BvvMet+6R6HfJYhQ3gZBH0s5v5JoFQjX78iQi5DKTIvaMx5Gfw
         oe+ZmBTPZDaqSIYLf3mgvo6+2uKNOVEx3RZDjDoY8A+cMG5LZBtxLB8WEQE55JC2/+
         cOh8rPD4bdf2QW3pz64FDUIbpqD0y+muqPrQBVmsvoebuIV7rE4pwC3VxlIVN50FOq
         eTyPeHAsO89m9NUpCRk4R+t5eT1vahs+YVD2Eqq5+ju9dplTscutwX4PrTxX/LSO2o
         xD3kWfX3ZFeIxkWidxensvAm15yOBwF7danJNU6iLrSWgB0f42UvmEnLzfl4YPka4F
         Wz83KBQRmcDhQ==
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Sep 18, 2020 at 02:38:59AM +0000, Vishnu Dasa wrote:
> Avoid calling ib_dispatch_event on an inactive device in order to
> prevent writing to invalid I/O mapped addresses which could cause a
> guest crash.
> 
> Also, set the ib_active status to 'false' in pvrdma_pci_remove and
> in the failure path of pvrdma_pci_probe.
> 
> Fixes: 29c8d9eba550 ("IB: Add vmw_pvrdma driver")
> Acked-by: Adit Ranadive <aditr@vmware.com>
> Signed-off-by: Vishnu Dasa <vdasa@vmware.com>
> ---
>  drivers/infiniband/hw/vmw_pvrdma/pvrdma_main.c | 12 ++++++++++++
>  1 file changed, 12 insertions(+)

To fix this bug you need to change pvrdma_netdevice_event to use
ib_device_get_by_netdev() instead of the pvrdma_device_list global

And then use ib_device_put in the pvrdma_netdevice_event_work() once
the pointer is no longer needed.

The core code handles all the required locking

Jason
