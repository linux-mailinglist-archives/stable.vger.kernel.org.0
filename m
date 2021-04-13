Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0D07135E94B
	for <lists+stable@lfdr.de>; Wed, 14 Apr 2021 00:55:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231793AbhDMWzl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 13 Apr 2021 18:55:41 -0400
Received: from mail-dm6nam12on2054.outbound.protection.outlook.com ([40.107.243.54]:28923
        "EHLO NAM12-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231318AbhDMWzl (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 13 Apr 2021 18:55:41 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NmnZjMYoLEktBb94g/tv6oRapgr5YNwRESvZVFcceonVAdIdSw/Dr+lu+panhmSfMF25kcWgLChI3+WdtVcLyPWdOgjmMXHsA79N3zwSDWyAuNk2hMd6TLhN90xf5Cz17VgbW/2NGsK0qTqkzc5oahlhfSxigKYjgJMWaRV/U5nbQXiJB9F4iDcTsOCOI9128DTFJRmxof7zcqdrPxtPhRwIMXGTA1lOQ3BuLsZzLaViAMZGiycsFTzAOkDmI0SsixWICJkrnOzCYZrdOxcyADv72Dw5Kw6Z+raVamKCUcijff1SDLDwFq71XXc9/tFp1Ya8G/VMSeKuIrA7s8qLCw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jZyr4Azag8kVMXN4iDUte1+nEB9Lnv3g9iOeGpKycuc=;
 b=OV+dh0pcOCP7SGTFlnI7DVtCD3aCVlOmXerTP02G6olnwIE6FOo9bWiJzRpr/4QYdwZb67p57ZJuyu++rh2Kt7kHy0jwMJuy/yy/P8jH3JZI7qT5L9+hLEYwNVD8CeXofDoQIw+Glqe8jalTnOjBTb4pw1rWs/us5p8rX3U7F9kgrgo2gDpfgTmH02TS4E7M8rFquWqdgjvOsKgIcX9bunhBtvNA1YpMofJhikxvKqftX3ZcFub3836LykV+NtY3YEZ0RfCacDSdQg9mQdSSSPB89CTwXey5Xot6eFWMYw96zMdArXtOzW5RR0CGS3HHXezSu2SSU8eZYW2YfE0uXg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jZyr4Azag8kVMXN4iDUte1+nEB9Lnv3g9iOeGpKycuc=;
 b=O7ct2RFl2ZRgskLeTaL/mzwcJgAqa8/joMWUnXFGTc9wNI4bqzxsrar0SFYfwA3dY+xqVDRQ/R1Dc2vUqSRSIitcCQz3xxiVOhLMzerSXBJaKJWu46vKLTmnySHF0QCO/7Qm1PJxabTikRkHumHDPQakvPgBW5RnYcr6kSVJthQsGSZCqJd1DedBe7OFDg/1XIdROi2FRS8iCXwUhHc6k8kFKXLq/3T/BoZrALd356mq/8XQJDrobpiBE7VkDw+NP5pskRCeiW44TAnWF4q63iyXLRH1CvbmpT7hpiaowdZwycJ8xQjtCHqyLOCDowpRV74uS4ma+O11U+7uQ+TnZQ==
Authentication-Results: cornelisnetworks.com; dkim=none (message not signed)
 header.d=none;cornelisnetworks.com; dmarc=none action=none
 header.from=nvidia.com;
Received: from DM6PR12MB3834.namprd12.prod.outlook.com (2603:10b6:5:14a::12)
 by DM5PR12MB1146.namprd12.prod.outlook.com (2603:10b6:3:73::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4020.17; Tue, 13 Apr
 2021 22:55:11 +0000
Received: from DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::1c62:7fa3:617b:ab87]) by DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::1c62:7fa3:617b:ab87%6]) with mapi id 15.20.4020.022; Tue, 13 Apr 2021
 22:55:11 +0000
Date:   Tue, 13 Apr 2021 19:55:09 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     dennis.dalessandro@cornelisnetworks.com
Cc:     dledford@redhat.com, linux-rdma@vger.kernel.org,
        Mike Marciniszyn <mike.marciniszyn@cornelisnetworks.com>,
        stable@vger.kernel.org
Subject: Re: [PATCH for-rc 4/4] IB/hfi1: Fix regressions in security fix
Message-ID: <20210413225509.GA1376467@nvidia.com>
References: <1617025700-31865-1-git-send-email-dennis.dalessandro@cornelisnetworks.com>
 <1617025700-31865-5-git-send-email-dennis.dalessandro@cornelisnetworks.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1617025700-31865-5-git-send-email-dennis.dalessandro@cornelisnetworks.com>
X-Originating-IP: [142.162.115.133]
X-ClientProxiedBy: BL1PR13CA0307.namprd13.prod.outlook.com
 (2603:10b6:208:2c1::12) To DM6PR12MB3834.namprd12.prod.outlook.com
 (2603:10b6:5:14a::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (142.162.115.133) by BL1PR13CA0307.namprd13.prod.outlook.com (2603:10b6:208:2c1::12) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4042.6 via Frontend Transport; Tue, 13 Apr 2021 22:55:10 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1lWRw5-005m7L-CV; Tue, 13 Apr 2021 19:55:09 -0300
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 74f55347-1b85-4185-ff9d-08d8fecf310a
X-MS-TrafficTypeDiagnostic: DM5PR12MB1146:
X-Microsoft-Antispam-PRVS: <DM5PR12MB1146BE6F7D604E16636B1E08C24F9@DM5PR12MB1146.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: aYSUKg7J3gYC2ym8VK2t+7yuVKOO+zcLhur59K8CnZkW+F4mQSkYyuLp1/h8xXALMIh+bepnoiGIf+jW6aAi9ggZh0MqcP626AXzz1UqzJDkX4iPrvN/yTqVVV0pEfhxN26ZzbFEJo0aXP/M7UoboJHJDwHIq/wSBqC48eCOPPgVBOrTXq/ztSxK7KKQ6jDmsQEThaOL+NydxH4a0zCIL49fIbs0LLDNkZ+XNvwOlfUUaKz7kkUl9UEgnAGb1qUHn/Di+xa8qWBMJ/4t2ciqnYaZW+ag8SAOx0JEIXrJkjFXYhvMHWDUXgFHxHJIzJZK4phDUo/pwYPp4llPCj1vBq3ApglDY/G30IEbHa1mlkB/03G2FEf90vzvOwv9hkkuiBoBVvs1D81L0kqr4qrC2KX67MiiDkL74lymvp7vxv8hPOWb9dm+UWXtS04ehDdF+7jZvMTIT9ymoNkvjmSncsh1EC+Sd0j4f35mtcoy4ZDkFftGQxwmjiK3L3pt277gdzIraNq3ZqAD1xltz7oTlnICetbyxK14zkgk64Dw2zpvWc4fehofpU5etJNUvc3CH1SpyHBvtONkMk/VNb6up3z9gXG2C6Ouy9hi4pheJps=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB3834.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(39860400002)(346002)(396003)(136003)(376002)(15650500001)(316002)(86362001)(2616005)(478600001)(9746002)(66476007)(8936002)(4326008)(66946007)(66556008)(2906002)(83380400001)(5660300002)(36756003)(1076003)(8676002)(9786002)(26005)(186003)(426003)(6916009)(38100700002)(33656002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?3vVf9OQACtxEHmPfjwabqDrAReEs6F3nUPJa3YhBVUuwD5oXfLY2l83WXdg3?=
 =?us-ascii?Q?FsxPM1wJwmmaZsS9+nDXnmy1Tt/gdW0r7negGEmvkJenycGwujLqP9mq3G3j?=
 =?us-ascii?Q?HDmWylIWniNcx6Jmdr6jM7CjO/s6UXw1qSLWHCNwQLVlCwGVm3y/6unR0y+E?=
 =?us-ascii?Q?J/gbEz+ub7dIq7VHwi8SuRSv+xnVaxXVD8EVS1t8Z6tNehvS/BdCrw3Hsqxh?=
 =?us-ascii?Q?A+19cU/EXBJbO547c+M4GUXUkx0Xr4YRtBekdSED2G80jAXafhp9VGxhO9jQ?=
 =?us-ascii?Q?6gFMCmvMU+Wl60Ikjg19fB35e9YNUxO1xcY3+I8xhK1Hz/rT7aHB5OpQfGei?=
 =?us-ascii?Q?/34WsELOf7aCoq+/2eFPAZF0Nt3WH6ZB/U8qQEu+S3jLfE3AfSx8cZOyF18v?=
 =?us-ascii?Q?vcD7Pq6UlohwC8kgAytptjI80s3WDPvfz4uuu4J2SJhDkEfS19DrTy524eda?=
 =?us-ascii?Q?5WytQtNpmeZh6UaZA19Yim6QKWR1DH0XH/LCYUr7F1VKgaDj7x/pNuZ2ikIH?=
 =?us-ascii?Q?xy/+z53BsTwta1zSnwpBPixpSgpNy0TE+EZL7gMa6pE2Gu5QYCwmD2rG9Xw0?=
 =?us-ascii?Q?+bdsQWrhx6atZCLeFRL4KingqwZd/21rWaeIizbkCcNlLQqS4rSUqfdGb1SQ?=
 =?us-ascii?Q?zcjm1q1Wt8Oi6JlgvdnMPvgCeAuQUHlbaHowQtTUpN9tLiM6dScpmN+uPUfS?=
 =?us-ascii?Q?U5bALrF3X/Jj4VKfCib/WjzBM7gKYQLl7edHK6XyJejZpf2TvYmeRpSt6KAa?=
 =?us-ascii?Q?dVPsh8A2EVdm01YY5PgcxtnvHUkrnMlF3O9xQnAKD2kvQs6LXt2IZvW3/t8o?=
 =?us-ascii?Q?Zr/tHyFTzsGlPAcjYPjmV1YUZt8EO1qBM8IwB9BAx8vE0kR167QGwlyUU3Af?=
 =?us-ascii?Q?SAJl5rFAYR/pGzwzDjWfAdvUwyNgYr3CktgRaDhpdh3yac4R5Gulm1kofu7h?=
 =?us-ascii?Q?DAl4ieeNdzh2ALq5h6A3cvfUvO/ZPwbU8Plh7wg8RgY3Yg10IuGmVf129AyA?=
 =?us-ascii?Q?nElYHR1czIBcYxuVu6EKbH3sfCUYmpd+tMU1mieLcwo/6ByUkR6hClJEud3x?=
 =?us-ascii?Q?+jXsiBydawREWQlGkTJs6iIASnVy3cUEqIgIFQsH56N1VqGpOM+4kJdSyqwF?=
 =?us-ascii?Q?GLd8M2mgf/39GI2nwBcS8xlrNYSTBUOqicH/q6kVa2vTBFNPyIBHnmLpxpIm?=
 =?us-ascii?Q?u0WQudlfrGPcs1Pszj4vzcekXilD4svZW12v1JQmGQagG1FVkzmv0WhQe0rb?=
 =?us-ascii?Q?M6XESkgRpI4eTo9HRn7NGo5jCvipzm3RVgveE9yfs4kU+7pwQthtdW4ziKRw?=
 =?us-ascii?Q?jqzz83bTIv5+V+JC2RIhbu6TtjeoT0+5hoPzjYOel6/nRQ=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 74f55347-1b85-4185-ff9d-08d8fecf310a
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB3834.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Apr 2021 22:55:10.9673
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: jpFIL9xGwrRw3jMBlGMsvUnZ0W0jtOU0UYpdOb0epzUTqP54xDm9CdM6aDDMwXcD
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR12MB1146
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Mar 29, 2021 at 09:48:20AM -0400, dennis.dalessandro@cornelisnetworks.com wrote:
> From: Mike Marciniszyn <mike.marciniszyn@cornelisnetworks.com>
> 
> The security code guards for non-current mm in all cases for
> updating the rb tree.
> 
> That is ok for insert, but NOT ok for remove, since the insert
> has already guarded the node from being inserted and the remove
> can be called with a different mm because of a segfault other similar
> "close" issues where current-mm is NULL.
> 
> Best case, is we leak pages. worst case we delete items for an lru_list
> more than once:
> [20945.911107] list_del corruption, ffffa0cd536bcac8->next is LIST_POISON1 (dead000000000100)
> 
> Fix by removing the guard from any functions that remove nodes
> from the tree assuming the node was entered into the tree as valid since
> the insert is guarded.
> 
> Fixes: 3d2a9d642512 ("IB/hfi1: Ensure correct mm is used at all times")
> Cc: <stable@vger.kernel.org>
> Signed-off-by: Mike Marciniszyn <mike.marciniszyn@cornelisnetworks.com>
> Signed-off-by: Dennis Dalessandro <dennis.dalessandro@cornelisnetworks.com>
>  drivers/infiniband/hw/hfi1/mmu_rb.c | 9 ---------
>  1 file changed, 9 deletions(-)

I'm going to drop this - resend it when the more thinking is done

But generally the security concern is establishing new access to a mm,
not so much destroying access created by another user of a FD.

Jason
