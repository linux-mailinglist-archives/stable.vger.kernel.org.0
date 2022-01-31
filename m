Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1A6194A5007
	for <lists+stable@lfdr.de>; Mon, 31 Jan 2022 21:19:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1378368AbiAaUTW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 Jan 2022 15:19:22 -0500
Received: from mail-bn8nam11on2109.outbound.protection.outlook.com ([40.107.236.109]:33680
        "EHLO NAM11-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S239418AbiAaUTT (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 31 Jan 2022 15:19:19 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GevGYwynXVci07lh3YHzcq+txPHSkL2bd2LOYu/++bNcJqNiXUAEFQ5pxgRGmPjFTJ0aA87z8Q41IO+VVbLsS3v/BNQFy8ctY+nalctc2IMoqVONHyT+2MStNSRkViP7RTs3O8XtBQmp39Ayl+v4VR3GCs5Dae77vDBScwXx3KMHmDoMArhSXFmeXgWhn0w5Rwzfj+g+2UUg9futymZDGTv/Z/LnLjpe92uymHkMJud+lNRnBFd7hQVbsratEL6XiDuuBaAObs+8ODxiwz3tHiSybIc+iVZyMeo6EHHPOdA7c8BzMTFNeez5m8TIdfkrQmwfIRV7dZByA7FLXI5sUQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=b5p7TSANdnvwP1ual4dSOnDf0+yVEPXRIHAochAxTLw=;
 b=MwhOGRlhg/P6vgZfkbD4d1RjkgSpmV7wGoQBh1yCgIRVT0HGniuBY+4cUCBiAxYUXUEPwikbAPTAhxfwnGGVwjeyb7gsbk4+VL8WQhgpZ/2j6G2+kCw6wEog5K7/VbgoDDPRzCisK2/vRm4ek9Ba+1vxKvUrV5dY7WgZc3wq6euuxeBYrlF92j5OLRvk/SseycC0owJnWcmQ76VZUweTgirHqFOFq9r6Vxvh0bvSYeIfgqQ4CtwfMqQEPJ/DMaPFsR7AKl7b/3PgsKEzn12JAaAT+9VJQoI1hkqODy0u/WQ8hplOP0y1Wpid2XJATfTXjm7EKVlvVpTVmbCeOHBFUw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=inadvantage.onmicrosoft.com; s=selector2-inadvantage-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=b5p7TSANdnvwP1ual4dSOnDf0+yVEPXRIHAochAxTLw=;
 b=CjG/afB/NyeXxMUV728DBK9HdFE74SY+suKm9lxmm4czeUDr3Gmb/8SmkjKpNs3EVfV7Mmh9494qQsOGphXLM/A5eK+m5khpX+Ao2PwSOLuW4Ma95nF/g8BkHFE/ju/TXYunjuFQfQJRt95P6Yk0i25YD7Mj5hS69seJPnqYuH4=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=in-advantage.com;
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37) by BLAPR10MB5059.namprd10.prod.outlook.com
 (2603:10b6:208:327::6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4930.15; Mon, 31 Jan
 2022 20:19:16 +0000
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::2d52:2a96:7e6c:460f]) by MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::2d52:2a96:7e6c:460f%4]) with mapi id 15.20.4930.020; Mon, 31 Jan 2022
 20:19:15 +0000
Date:   Mon, 31 Jan 2022 12:19:09 -0800
From:   Colin Foster <colin.foster@in-advantage.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 5.10 089/100] net: cpsw: Properly initialise struct
 page_pool_params
Message-ID: <20220131201909.GA16820@COLIN-DESKTOP1.localdomain>
References: <20220131105220.424085452@linuxfoundation.org>
 <20220131105223.452077670@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20220131105223.452077670@linuxfoundation.org>
X-ClientProxiedBy: MWHPR19CA0006.namprd19.prod.outlook.com
 (2603:10b6:300:d4::16) To MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b123b4df-fc04-4edd-8d98-08d9e4f6f3e7
X-MS-TrafficTypeDiagnostic: BLAPR10MB5059:EE_
X-Microsoft-Antispam-PRVS: <BLAPR10MB50597F179868824D9EF8D1A7A4259@BLAPR10MB5059.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1923;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: HIzYmeVpSp2bc3ODATQMCJHayVMf7pu0hS+AfcnzV7BM19CDtuik/bzSW7H95t/T5FucxoM4r+lWpKGcZPJiN0y+tJlpMKZRT9JzHsvTNTnSLVSRbzdLAi4pRs9Q/lT9gyYfmvLCnXGN34PKzndlOOksbPyo7Cr5J7ty53J7zaNL2BxFzm42j686w2jBUQgGPEEHXZWD7xPSEwKYhuCnEqxeStrOC3ecbp6b5ym0J1oa8HO8O+PUHm/u0uPB8DoJ8ppHa6E4tN4KHflRU2M/+PZMvg58VBpX3Xhe87DEk2Vfv091lXaapdThyTo1lu74bUe5slYIT7wpPrw/aAIGzMgot0/BpLkeWeFAmcTTQA/XawCDq3/vuSBavXyoz8JpQaHXoBWB6ku465Csgtp2WvwZhHsr7hxDXUg/LDIHx0YZwVSM1qLA1PBW0hjW/f85An9kb9m90kNnWb2jUdpMyMPn3sxoyS9tItbU0pvOtfZc/hCBQfPv53XuqzitZj8+I8sE2ezEJf3nJ2Ey8qqSKgEdYDOO2Y8/Hm1Qg8JnzRDrKalF1jo/yrZ43diuBYn/4PyJljpWsjPFjnQ6fkchOln7YF4IbrffKh34GsxqxK60PtGK0pdzX7jLm159JT0tCWhkvncRBgBh9aSuZjUon0hSD3L+dLcoaZ7gcwpam36uhJohj1gm9O3//4xiU57MmWOGGJONYDTg/3hJvf2sCTJ6hkhdjl28iEdObjlC8+YjPe2b1OiZJwfZklEe5jHDOnbvdUqp3k9Nk53AiM3/YEpB0tnUzSUgilNepG+qRHw=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2351.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(136003)(39830400003)(346002)(42606007)(376002)(396003)(4326008)(8936002)(6916009)(26005)(8676002)(83380400001)(66574015)(508600001)(966005)(6486002)(54906003)(86362001)(33656002)(186003)(1076003)(66946007)(66556008)(66476007)(5660300002)(38100700002)(38350700002)(6506007)(6512007)(6666004)(9686003)(316002)(52116002)(2906002)(44832011)(20210929001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?WEFPZFNweFU1d3VqR2ZzZ1JTQ1BLTmVnZGVwQzJSdGl6dGJiZlpueTFTMmFk?=
 =?utf-8?B?eE4zeVRzbG13clRBT1kwVm1MTVVQMWNOU2IzcTRNcm1OQ055ZGMwb0VJMUJ0?=
 =?utf-8?B?U3lOYmZEcm9ITmxJUWN4NEtRaTdzc3pKQ0dseldtTDNTRWNsc2FDT2lsWW8v?=
 =?utf-8?B?d2tyaXZZUURqQTZ1dEF1SXphTjRWV09tNkFRb1hKdWV5c29DZzFIcFN4eTVv?=
 =?utf-8?B?UEd6Mlk2S3lYSTB1YXJ0UTVmR3VNU1UrQW9HdzA1VzQyY1l1YmRWTk1pU2E4?=
 =?utf-8?B?eE8zMTQvaVJHMjFXWHd4WkNsUWhkdGFZTFFZanVmZHNUUXZVM09kTmJEb2xt?=
 =?utf-8?B?dlZ6b3dHM3J6S3hIZ0V2dktkYm1aVjJMVXBYTVNwTDdiTDJHRG5wdDJDUnR6?=
 =?utf-8?B?bzRzV0VRcEZsdjBtRVVCUGQ0MUpYRE9pVmpkVzk5K2w3L1hzcG53bXJsUE9o?=
 =?utf-8?B?MmVjQi9yZnBnYjVPYjN3cFRYZmo1dldGcUdRNTYxSTFQVXZrN1ZHeERyR1V5?=
 =?utf-8?B?RTJjSlZKVFV4SFNudHhuSmxJcUR1dUdJL2MvRndjeXhjZzBIdEJZNSt0SS9v?=
 =?utf-8?B?MDh0dVozUTZFcjFqekZlKzFSVTNHdUZ0UkRtWGFsQ1dwbWFTREFMRkZFZzRR?=
 =?utf-8?B?VHJKb2xKeU82R05qSU5LdUlNSzBwdVMwQ0VpVmh1ZVpsbTFINVF1MXdSdXRV?=
 =?utf-8?B?M3AyS1I1blpNNHd6Mmc1VXpjRk5nejZsK09BeEdPZzBYNVVSY1FOenNDV29i?=
 =?utf-8?B?c1lRWUdYV1dZUWhzVlNBTy9pMmV3R1hzMFYxcmxRRjJTVDdMU1licjdKTjlJ?=
 =?utf-8?B?MXlISnpRWk5pS2ZWSCswRFY2MlFxYjN5ejl6ekNCTVcyWURJbWgyN2ZiZkFX?=
 =?utf-8?B?L0Q3eDBVLzNmRkxhNzVLK3ZUaWViemE5WFd2U09KRGtqSkF3NjRYc0VNalJE?=
 =?utf-8?B?NHZvelJMNTlhSFBMRHJqdTVWd1dCK2Q4T2JCSWhLejVOV1ZaRG1sTUJOYTNi?=
 =?utf-8?B?cE1uWXVkcDlSNmxnZEppUVhkMVgrM0tHTHZxOVhPYWIraHJydWJYWGpackVx?=
 =?utf-8?B?QllwVFY1bmJRWitBbmxLWXFqekdNbWpKVGc4UGpaL240dDBXV1FweEZpVVFh?=
 =?utf-8?B?WDRKQW1Fdjhqc01mU1JkSHhURU8vcXpjbml5ZG1vL1gyS0MzaVBTZkVsL3Br?=
 =?utf-8?B?MlN4akxqMExQd1ljOUJINXAzd3NhVXgyc0hCaittcnZGQkE4SVlhVFRkaTlN?=
 =?utf-8?B?MllRaVdkNHQwTXZEMDBTVk8yMUdoZm9uaURPdjAxZ2NXMCtrdlptOEtHVGly?=
 =?utf-8?B?NTgxQUpKRitrR2pGTWVkNDRzQ2ZwcG9ZN29kZ0xTL2hvbklIRUpyVEQzd2Vr?=
 =?utf-8?B?VHQza29LWDRwcWNsQ0xidno1bTZKYjJEYmFCbDZxMlByU29xcW9STXUzMDAv?=
 =?utf-8?B?S2VvRjdHOTZ5Qmw1VWRuQ0g4OThobWE0bzU3U2tCYVMvdmFIdXJOaDQzRDJy?=
 =?utf-8?B?U2RzMGJPT3FBeUp6VDhKcEZaZVNPRm9ZZVJYMmg0aU83RHpoZzczRzl6V0lE?=
 =?utf-8?B?Ukp2a2g3ZnZEVlRJZ3Btb0UxYmtyM0RHZzllU1BGbHE1YnZVUW1oS3F6RmxU?=
 =?utf-8?B?eitURVFqaE5KUzJoSEhjc3UwazZlZ2d5Q1V3MENuN25PUTJDT0JaelNiS3lZ?=
 =?utf-8?B?T2NEK2R0clFIb3RobExHVHVWV0xJL05TMmV3RWRoanRoVG1wSzdDdWEzZjk2?=
 =?utf-8?B?NVdBbDJuSEFUdFI1WEZxcWF3SkFMbW9nM05VZ1BaWWpMaGp4c1ZDTGxEMEZ0?=
 =?utf-8?B?SFRvTGJZWDM2V2VGL1dXM3p6UjVRNmJTcGdhNEM1cFdZZFVtN3ZZQzhtbkEx?=
 =?utf-8?B?WmFISi9XRHZJbmNhUXNRQ3oxaDBrdVZ1VHNnak05dEFGV0VRQVFpTU1yTXl2?=
 =?utf-8?B?eDVGdTdBbU52cVlyY056aXNPb1RxU3dDYTN4N2RwTzFuZnRjazRsbzRma2pX?=
 =?utf-8?B?YkdueWFrcUwybVA3TXhRbXJNQnNqMHVNNktnaTdvQ2hCVW9VQ0p6WkEwSHJu?=
 =?utf-8?B?czd0dFJZUkt1UjcwNE9Zdk80c1lzaktyQTdWZUd5MWRWYlc4MlNNM28yajlX?=
 =?utf-8?B?dUZOU25HUXdzVVJsQ0NpakFRVldPWFdwY3VUVmJmUUt1WFpENURSQXFTUUFN?=
 =?utf-8?B?OHhRcTVNSmxKSjFlV0FzcVo3cVVOMThpWE5NWUp4RFJXQmQzQW52MzRCeDhQ?=
 =?utf-8?B?ZXV6bW5MOG03WElobjBQN2wzc3JRPT0=?=
X-OriginatorOrg: in-advantage.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b123b4df-fc04-4edd-8d98-08d9e4f6f3e7
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2351.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Jan 2022 20:19:15.7886
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 48e842ca-fbd8-4633-a79d-0c955a7d3aae
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Rn45dzh2ETpIbSMBIXtNxLVrPE+VPbCnmS+qt7TGEMphxu2kMxTNBEkhCw7hjXtAFbv3py6cimBcoZTbjtVYALsunoOz4jZCUycTQmjj0x4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BLAPR10MB5059
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jan 31, 2022 at 11:56:50AM +0100, Greg Kroah-Hartman wrote:
> From: Toke Høiland-Jørgensen <toke@redhat.com>
> 
> [ Upstream commit c63003e3d99761afb280add3b30de1cf30fa522b ]
> 
> The cpsw driver didn't properly initialise the struct page_pool_params
> before calling page_pool_create(), which leads to crashes after the struct
> has been expanded with new parameters.
> 
> The second Fixes tag below is where the buggy code was introduced, but
> because the code was moved around this patch will only apply on top of the
> commit in the first Fixes tag.
> 
> Fixes: c5013ac1dd0e ("net: ethernet: ti: cpsw: move set of common functions in cpsw_priv")
> Fixes: 9ed4050c0d75 ("net: ethernet: ti: cpsw: add XDP support")

In 5.4 every parameter is individually initialized, so there really
isn't a "bug" necessarily. Only at commit e68bc75691cc does it actually
start not initializing every parameter.

https://elixir.bootlin.com/linux/v5.4.175/source/drivers/net/ethernet/ti/cpsw.c#L558

I'm not familiar with the process of backporting fixes to stable yet. Is
there any benefit in this cleanup for 5.4 or is it fine to leave it?

> Reported-by: Colin Foster <colin.foster@in-advantage.com>
> Signed-off-by: Toke Høiland-Jørgensen <toke@redhat.com>
> Tested-by: Colin Foster <colin.foster@in-advantage.com>
> Acked-by: Jesper Dangaard Brouer <brouer@redhat.com>
> Signed-off-by: David S. Miller <davem@davemloft.net>
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
>  drivers/net/ethernet/ti/cpsw_priv.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/net/ethernet/ti/cpsw_priv.c b/drivers/net/ethernet/ti/cpsw_priv.c
> index 424e644724e46..e74f2e95a46eb 100644
> --- a/drivers/net/ethernet/ti/cpsw_priv.c
> +++ b/drivers/net/ethernet/ti/cpsw_priv.c
> @@ -1144,7 +1144,7 @@ int cpsw_fill_rx_channels(struct cpsw_priv *priv)
>  static struct page_pool *cpsw_create_page_pool(struct cpsw_common *cpsw,
>  					       int size)
>  {
> -	struct page_pool_params pp_params;
> +	struct page_pool_params pp_params = {};
>  	struct page_pool *pool;
>  
>  	pp_params.order = 0;
> -- 
> 2.34.1
> 
> 
> 
