Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CBFFB26FB38
	for <lists+stable@lfdr.de>; Fri, 18 Sep 2020 13:16:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726115AbgIRLQ0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 18 Sep 2020 07:16:26 -0400
Received: from mail-dm6nam12on2075.outbound.protection.outlook.com ([40.107.243.75]:56352
        "EHLO NAM12-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725941AbgIRLQZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 18 Sep 2020 07:16:25 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DpmUgzbsKNr2bLIM1sB0XjmglxCSpD5dBu6wotMb64yGCC2IsPsHYvjTK62FOE5EkVZ1ySv/D+ARoWtqGgkU9cng9SSrf02tB/zw38Qjecu29I4X9dsrZWCpg4xb38yKDc4k1zeeHTHKcV6blO31yuyL4coI+nEyW9BjVYFL+44c0Go2jbraNI1PFSkgrKKSd6JzW8xqM2+zruPwftfU9QneazoxhaT9U8Yz7bSAcvZV0keAaV99RZFNBdU5GoteufJaVeWqw4N8ixakUO7mMuq93VWnFXjlEbnFvhBQvT83qpqmHHov+irxxL++Uq2cWZ3ks56j435seTtEiDn1QQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Iiv3/44FtgnlymSQClCT8RVI8qwKcRv+ssElx6pYhuo=;
 b=R300IIsZTdM0M2FvRoIvqNMCJLrMnSPmf6/Z/E3d6E1sc/PkthZqT408ybBSEUV1DYtUsB0Wzulh4ipsbi71ftjIkxcHU5ehs/dDMlH05K/ZJ2RpqbNj2FVPUHazV2Guc8Fdhy7MNEvamtLaDYOsk3GWZXFyhI1u3zh78TeWPYUWvbonyG8z7HQOIio1maqSkiUv6IGolqbCNMeDmyY5mNvZ+mxHs2K/OiztHJGb3/zbfje+SaZYXNvZvqSjuOKpFkM4bgLo8sN0Vpvhhvb26164iPyLHsEjpE7ns3h3AhEpGnHFtlzBAYFflEVRMO+sZy14jkbBzGy7FZPspRdLAQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Iiv3/44FtgnlymSQClCT8RVI8qwKcRv+ssElx6pYhuo=;
 b=UByYjychr0hPLAApfzC0VesRvB/0jxFHfS/M7uWwb5K9n3SKemhu/AOmbo3TpSFZzy7PvclKOKBV7Yxhi9Ca/l6JOa6v6meRsUImcCYibA60mDPDy09BCaEJWb1BfwsiEGpRqgUhCNNU9v4l86kmDn3fuoogtcw/kS2KBADqZeA=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=amd.com;
Received: from MN2PR12MB3775.namprd12.prod.outlook.com (2603:10b6:208:159::19)
 by MN2PR12MB3677.namprd12.prod.outlook.com (2603:10b6:208:15a::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3391.15; Fri, 18 Sep
 2020 11:16:22 +0000
Received: from MN2PR12MB3775.namprd12.prod.outlook.com
 ([fe80::f8f7:7403:1c92:3a60]) by MN2PR12MB3775.namprd12.prod.outlook.com
 ([fe80::f8f7:7403:1c92:3a60%6]) with mapi id 15.20.3391.014; Fri, 18 Sep 2020
 11:16:22 +0000
Subject: Re: [PATCH] dmabuf: fix NULL pointer dereference in dma_buf_release()
To:     Charan Teja Reddy <charante@codeaurora.org>,
        sumit.semwal@linaro.org, arnd@arndb.de
Cc:     linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org,
        linaro-mm-sig@lists.linaro.org, linux-kernel@vger.kernel.org,
        vinmenon@codeaurora.org, stable@vger.kernel.org
References: <1600425151-27670-1-git-send-email-charante@codeaurora.org>
From:   =?UTF-8?Q?Christian_K=c3=b6nig?= <christian.koenig@amd.com>
Message-ID: <7a4a51fb-008b-cd64-35e7-2a2765b2c3a6@amd.com>
Date:   Fri, 18 Sep 2020 13:16:16 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
In-Reply-To: <1600425151-27670-1-git-send-email-charante@codeaurora.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-ClientProxiedBy: AM0PR10CA0073.EURPRD10.PROD.OUTLOOK.COM
 (2603:10a6:208:15::26) To MN2PR12MB3775.namprd12.prod.outlook.com
 (2603:10b6:208:159::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [IPv6:2a02:908:1252:fb60:be8a:bd56:1f94:86e7] (2a02:908:1252:fb60:be8a:bd56:1f94:86e7) by AM0PR10CA0073.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:208:15::26) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3391.11 via Frontend Transport; Fri, 18 Sep 2020 11:16:20 +0000
X-Originating-IP: [2a02:908:1252:fb60:be8a:bd56:1f94:86e7]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 693b83d4-143e-4fd1-827b-08d85bc445fb
X-MS-TrafficTypeDiagnostic: MN2PR12MB3677:
X-Microsoft-Antispam-PRVS: <MN2PR12MB3677429DEB345A0F2266AF96833F0@MN2PR12MB3677.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7219;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: bsRO7dNULjTkpwp4SMFbIK/VLH5SnEm6LxiM4Hjiv81/eHL7YjJOnYPpRHDQ9tw1fUXFFNyCAaxjD2/LQIs//CyoMyva4BZaF96AG+pl3buPQXqTb4s9qv/kUCxdyCt56QSFxyQz61cREfY7ktzw8oYg0Xjm/eO09nxp8IzXEvvlgs6CBgUjOk8k3g7BIYXGECkoMzw/+kMoxwiYHnV5bfCDk98DnUQznFZvqqGnK5Zii1Etj1EFTBe91ytQV/7wK5K27uxobE1AIcuz5xvEHjwkC8z+2PqQgk1DkQXv67nQYcv8VtZpUswqG1yFmZ+NE+mVUsoM8cgW8PoaNxglTM4ZS/WTDYvyeEkpcgtOz2aTN4eaLz97Fe5ycIe2yHBq
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB3775.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(39860400002)(366004)(346002)(136003)(376002)(83380400001)(52116002)(31686004)(4326008)(31696002)(6666004)(186003)(5660300002)(16526019)(6486002)(316002)(86362001)(66556008)(66476007)(66946007)(36756003)(478600001)(2906002)(8936002)(8676002)(2616005)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: flkrJMG51H99fX9atJL9h5v6kNohjt9FMa1mv8R/gnHg0NusOCiJF5NuN2/gVnY3aIo5v+TYrcpPCv5iZ+L9T8qElMonq/IKsmtEbhpcjssFBOtm3wWwoSP9y5aHol60ZWaIPevrvDHPqZWwF58vmPY7xJxi4GVo058a2JhuWO9ZhzrQC5EJc0t2vLxVm+yyG4qhWpZfsgm1kPwUWz1qY6RI28PyozuoVfjY+3qOPQ+g+BN0/7cW+FUpd08pFXw0tt+fnaaXSj7Yx7APFBTBDM+9M0YvJ+7BAtp+aMURR1NKPoCHiY3KrNnj6sj9urbo9QEdAcqQQKwkvBf6UYFgjbkJ05O1P/2MduiQi02lSr+k/bRaEtNcJxUEDrpKEQo03XbyE4cO6B7bDgRsMPFBFn2McIBlpKjXMCnQGcijY3BW5x6C0L6MLHh/VZx1kbF3AVdtXmo9tyDoBSq1aHR+hyVzYhLYQgPFRiBHjeQFxIT/CE8kLmzr3SnMaTfW/23/ZDm7xIPrjxj7B1g/Y89U/es6PhsEGqACmEl1esiY21WqaZL9psvnaUd0xCfQFHiJMZDrsRqCfjibkWmapbQzsYosCVSk9p6vnhLRmUPEwFwE70eVWvSvbO49fe38BiJ/3k17gBr2XVzPGaIhxGl1rapKfqIb/5oL3kCIJmz8IlGNCFqijPal7cDBe9FZdfM/AwRjxM0K8cGu2ELYvp8PHw==
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 693b83d4-143e-4fd1-827b-08d85bc445fb
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB3775.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Sep 2020 11:16:22.3191
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: vweHaVDvbAc724l/x8T48pepFdJfqPjPuQbnAtGy2/paOW9SUTv5d4jm3dyUcgaD
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB3677
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Am 18.09.20 um 12:32 schrieb Charan Teja Reddy:
> NULL pointer dereference is observed while exporting the dmabuf but
> failed to allocate the 'struct file' which results into the dropping of
> the allocated dentry corresponding to this file in the dmabuf fs, which
> is ending up in dma_buf_release() and accessing the uninitialzed
> dentry->d_fsdata.
>
> Call stack on 5.4 is below:
>   dma_buf_release+0x2c/0x254 drivers/dma-buf/dma-buf.c:88
>   __dentry_kill+0x294/0x31c fs/dcache.c:584
>   dentry_kill fs/dcache.c:673 [inline]
>   dput+0x250/0x380 fs/dcache.c:859
>   path_put+0x24/0x40 fs/namei.c:485
>   alloc_file_pseudo+0x1a4/0x200 fs/file_table.c:235
>   dma_buf_getfile drivers/dma-buf/dma-buf.c:473 [inline]
>   dma_buf_export+0x25c/0x3ec drivers/dma-buf/dma-buf.c:585
>
> Fix this by checking for the valid pointer in the dentry->d_fsdata.
>
> Fixes: 4ab59c3c638c ("dma-buf: Move dma_buf_release() from fops to dentry_ops")
> Cc: <stable@vger.kernel.org> [5.7+]
> Signed-off-by: Charan Teja Reddy <charante@codeaurora.org>

Reviewed-by: Christian König <christian.koenig@amd.com>

Going to pick this up for inclusion into drm-misc-next as well.

> ---
>   drivers/dma-buf/dma-buf.c | 2 ++
>   1 file changed, 2 insertions(+)
>
> diff --git a/drivers/dma-buf/dma-buf.c b/drivers/dma-buf/dma-buf.c
> index 58564d82..844967f 100644
> --- a/drivers/dma-buf/dma-buf.c
> +++ b/drivers/dma-buf/dma-buf.c
> @@ -59,6 +59,8 @@ static void dma_buf_release(struct dentry *dentry)
>   	struct dma_buf *dmabuf;
>   
>   	dmabuf = dentry->d_fsdata;
> +	if (unlikely(!dmabuf))
> +		return;
>   
>   	BUG_ON(dmabuf->vmapping_counter);
>   

