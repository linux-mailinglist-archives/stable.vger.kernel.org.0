Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9117346B368
	for <lists+stable@lfdr.de>; Tue,  7 Dec 2021 08:09:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229446AbhLGHNO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Dec 2021 02:13:14 -0500
Received: from mail-bn8nam12on2076.outbound.protection.outlook.com ([40.107.237.76]:47672
        "EHLO NAM12-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229445AbhLGHNM (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 7 Dec 2021 02:13:12 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=G0tv4okyATBYo6IYExXKQlxP2FdtVrCgUwPUmbsR+L9LPfbqlvz10vEgvhZ8IDMeYGcGpMBTULLqcmRuY6V+ppUgcdCwaTGHbkZfJQkXJ0BUq7kwmFRfKg5Dor4V97ntsfDoUsKuixOov38YvK/5O4Gg3EPfWuQahyaXvYqZYnUwc+LxZg4N1qIX6N++6dsbGI0juVCwLnhnysxGY8mE2cafUpJU+u7fTHJ0yC5oQohAlCjRv9ldbW/WUyCowX9++NV1iLI4jOwYO+7ZQZXmYHKIguhDhrJ8hktP6dpusNDKeKXklD76evJ9HeqDayD1t5jf0GVX7A+cvOpWPoE5+A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=odz5QcBpUr3bpfLuLBKOJQFqKYsFgOVGzQBTNr+3btk=;
 b=i3IWzcppm4sH07FSd7U+FnNAfQHUdquPRq1dbdIg18iax5JyGj3GYdPmOQuGRm0EBvOizfikkvo5MCuq+pncPAXQoojPhAeSvkhIVwLQ69fVViS/XJi3QunDF5YaFdFHrv5heFasDod94aP1Cn+ibUCTQrg7JEuIzdAgwbns3hhIHur3vi6yQGrZMlwAAbsU59u/tjU6iPg879G2BtvEKoqKVAc1bSY4F0IDU2Z59J4FqRItqe+iUF42YfQJckVUWAvlbIGG8RDhXQdX6C3o4hqKIT66bf87rNxk1lzeFm/Jt7EOUGhJGyce0g+IdInK1yr669UlWdVOuhd7n1B5kg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=odz5QcBpUr3bpfLuLBKOJQFqKYsFgOVGzQBTNr+3btk=;
 b=GMzxyfXMIMx1pZfT6VWz7H11AP6NdbRB9qk+RoJQAnhvw5K3Fkb7hd7LL/qN+SeK0bmKoa5vvEHOhNPOz4yCmg81rK3NTQlUwKurxI2j//RRV7kM4zpsjuk/4ulWNQu3e+iAr/Q7klsoKnz/zbs1hAm+eHOw4x/V///90HjKY7I=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from MWHPR1201MB0192.namprd12.prod.outlook.com
 (2603:10b6:301:5a::14) by MWHPR12MB1616.namprd12.prod.outlook.com
 (2603:10b6:301:b::20) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4755.21; Tue, 7 Dec
 2021 07:09:39 +0000
Received: from MWHPR1201MB0192.namprd12.prod.outlook.com
 ([fe80::d16c:a6d5:5d2e:f9d4]) by MWHPR1201MB0192.namprd12.prod.outlook.com
 ([fe80::d16c:a6d5:5d2e:f9d4%12]) with mapi id 15.20.4755.022; Tue, 7 Dec 2021
 07:09:39 +0000
Subject: Re: [PATCH] drm/syncobj: Deal with signalled fences in transfer.
To:     Bas Nieuwenhuizen <bas@basnieuwenhuizen.nl>,
        dri-devel@lists.freedesktop.org
Cc:     david1.zhou@amd.com, lionel.g.landwerlin@intel.com,
        stable@vger.kernel.org
References: <20211207013235.5985-1-bas@basnieuwenhuizen.nl>
From:   =?UTF-8?Q?Christian_K=c3=b6nig?= <christian.koenig@amd.com>
Message-ID: <6b4beed9-6d2a-96c2-956e-5a5fb6f6fbd9@amd.com>
Date:   Tue, 7 Dec 2021 08:09:31 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
In-Reply-To: <20211207013235.5985-1-bas@basnieuwenhuizen.nl>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-ClientProxiedBy: AS8PR04CA0133.eurprd04.prod.outlook.com
 (2603:10a6:20b:127::18) To MWHPR1201MB0192.namprd12.prod.outlook.com
 (2603:10b6:301:5a::14)
MIME-Version: 1.0
Received: from [192.168.178.21] (87.176.191.248) by AS8PR04CA0133.eurprd04.prod.outlook.com (2603:10a6:20b:127::18) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4755.14 via Frontend Transport; Tue, 7 Dec 2021 07:09:37 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 4989b807-5952-4596-35b2-08d9b95088a9
X-MS-TrafficTypeDiagnostic: MWHPR12MB1616:EE_
X-Microsoft-Antispam-PRVS: <MWHPR12MB16162F9C6FD212B59AA8103C836E9@MWHPR12MB1616.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: xPO2mGnwgEk9THacZVg4WAAJbR2+WJ7aLr6Qug9kVdgy6sX3EdzgG5vQz/ECbyyc9kx8yC3matJBJ/qugf0tXVTdiXVWabPjlhFfB2Zm6HBhuJi+ugDp5phxvkX5J6DnnOzVZMENtUYLyNZTETP+itjH8ceQs3vkUvkeFoCNwcJWaJcKim+Yfu/QLUoSS8nk00HX3Of1pl6vgYAOAD+jXd6/z6504tEe0nqvb3PK7apXmtHR6V8ZcbrdsLr2eoS9iEen1Y5MyhKIPZoFd42bOPLyBA+6Lf0LFKI1Pjd1N03e9vkLfnFGdiViSm0R+Uc3TeLYNzn2JgBzraZwiCdXdKpxcVBCF22jjVu0xVQrvSt79wPeUWDI/Br01PQGA4EAsg1fX3w57bdfb4VA4dBSUoNY/7CJhSTH9ollGVOAEl/c/F+G9gHta7vqiOpQxrk5Kk89QMhhHoTSgrt/FUDg0CjUR2cnOuQ3g52oKHTB1pSGgNcPhSGTcEU6nOGoYOSkC4vW3GkMtvUwW4EOZ17hvSzhuOOfgl+8T7QST3JrkDtb/M1HXf3LXZU6RrSxjSCBsgiSnoKA/T2Md+L83ENjdJ4IzLOc7fFAlo5g85ny69iR0P2jdVoVQFgazNnJD/9eDhYZTgnrqQU61MY4ZDTVWahuzky8kwmmRLuXTQ9F+mbfZlGboOb/AsJa8KAVNBwkzUrmTjjQk8ZTZvorqqQEO/7pdSWSsDbALY5Ot/zKpPU=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1201MB0192.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(86362001)(36756003)(31696002)(6486002)(186003)(8936002)(26005)(316002)(508600001)(5660300002)(8676002)(2616005)(2906002)(31686004)(4326008)(6666004)(83380400001)(16576012)(956004)(66556008)(66946007)(66476007)(38100700002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?b29saXlkNWdTTTV4YzBvQi82WTN1MXdRT3ZwaXNGWU1DbWhxaEFPYXE0TkZL?=
 =?utf-8?B?b1Fab0ZwM2RvenFDNzY3VXNXNWJCeXZ0ZjJ1Tk9nR3JTTnZNQ0hnalNxcjhp?=
 =?utf-8?B?OGVRRjdteFJBMVNDdTZ1S1B2NjRmWjU1eEhuRUMyZGoxdVJlcEpvbm5QZCtn?=
 =?utf-8?B?MUk0SFc2SWRPTWZwbGJ4TjlLNGdyQXhRVE5GejRFYmpZU1cvZk91bDR5UU45?=
 =?utf-8?B?Vnp5L0c0SGRleVQvbmt6TW5LUVpCb1hzM1c1MW9XcmtueFBsNUhEMnJOampq?=
 =?utf-8?B?dGNpVGFCeWd3eFo4dHZtajY4YjNnNzJaV3BuTDJ0Z3VaeUd2OFRzMVJTS2Vu?=
 =?utf-8?B?Vmwwc0w3SlFLL2E4WkJoR1ZYK3RYUmV4ZzZueWVuczhKYnEwMHZzU0ZXenFk?=
 =?utf-8?B?clpDbHA2TndlVTVJc3pET3lXYnVXM2gyZkhwR1lzRnM3NHlHei9lU2w4NUpy?=
 =?utf-8?B?aWhaMG9aTjMxSGxjMVIvYjA1THh2Mk9EamxhUm1YaVZ4emtyWldtWDZycURv?=
 =?utf-8?B?OUxhYTRWRlVrTEx3UnNqdytyRmNvVUYzTUlGQjNsRTREV3N5aEhqMWdRTlZB?=
 =?utf-8?B?VmZCTXZEeTdTV2VWdnBPTWFWWUl1WC9RZXVnbnh5ZmtHOVhuR00vVjh2WGJU?=
 =?utf-8?B?VU1HNER1SEJ0M2QzZ0c5ejFMY24yQm5iY0ZHcVN2eHoxejRTU3l2MlRaRGN0?=
 =?utf-8?B?TDFsckc0Znd4TytWamlpVFVxT2dRUjUwYjFINXNIam9hWksvdXhKTEYwOXAz?=
 =?utf-8?B?dThyYkxEdGV5endyN1dKQ0M0eG5LNmRFbjBzWERTUklMbUtxSHQvampweThm?=
 =?utf-8?B?empndHlWcjE5Z3QxTzVEc1Q0VCtxTW52QzQzWnIySjh5RXExTGlKV3c4SzIz?=
 =?utf-8?B?clJCZm91QmlNSlhUbnBRb3hENHdpbG83cFJHdkxxU1ZKSWpFKytCMTNGZkNI?=
 =?utf-8?B?dC9GeFcvN2JLWCtoWnNoM1NLczlMVGxCQldXT1RTYkRtdE9RcTdzZUZlY0tx?=
 =?utf-8?B?RFNtVDdhZFNoWjIxZUtEeSt6UFNSMFFsRitCaUR6WjVMa2M0U1ZYR0w1ZHVT?=
 =?utf-8?B?bGloRHBzSGF6VXB1a3hpeS9wdDVsZ1IzeWM1dWlvTUphck1PY1RhYmdkVVJt?=
 =?utf-8?B?Z3dUc0RseGxSV2puY2g2VzRad3dzL2c2Y3U5dEV0ZlRDUm5LZ3VMcERMVUs0?=
 =?utf-8?B?RUoyekE1emlCN3B0QmE3N09yZDV4RHBrSGo4V2FadDJWVkFiSUJsaVMxL3N6?=
 =?utf-8?B?dTlYSFZHN3V5dGxUWStjYlBlSTdVUDduTm1BbjQyVDFFYXNreXk4Q1BrbTRF?=
 =?utf-8?B?VHBKcEZmMU1aQmd2dDlMdXBCRi93LzdYZGRobWJKU3dkZHBYeS9sY0ROYzYx?=
 =?utf-8?B?REpJTUNyc3ZuSzNqTU9XNjdTYm1MNmZBUytJeEFKRHNIdFBvYjVCT0tsaGc2?=
 =?utf-8?B?V3dIckxNcW8wTGhjcDJOOC9oK0lwTm9wUTVJWnFFcjcxa2ZidU04anZERHB5?=
 =?utf-8?B?YS9YRU84Mm9paUtabmRRaVIzMnRpM2tDREpZWC8rdE5xTE94VzZXSXlreFBJ?=
 =?utf-8?B?QWxvTFIwcUY3UmFnMUVKOFllcUg5NHR6R0ZsS05veExVbHNMcjUwbkJSQ0dm?=
 =?utf-8?B?OGc5bW5tbVd3dFY1RjQ5NzNzT1hyeHJ3TWVFY0JsV3IwNzZrdzVLcTAxaGRj?=
 =?utf-8?B?c3lkRUxMTFZOdnZaRGlvM3Vja2RPNCtmcTM2U3ZqdEVwU0llUlRRSS9wVWJP?=
 =?utf-8?B?eEFMcUtteVRZVjRyNDVIWGpzUytwaEM1Q0NKaEYrQkdFNHlKQUw1dVh2Q0U2?=
 =?utf-8?B?RFlFajl0RFhVV3ZCdmQwZko1WVdyK3B5WU9IQkpqV1Zub29jeXVsWmRybVU2?=
 =?utf-8?B?dVNHUGVkYXZxRmxkdVBHc1FiQ2hraGNvd1ZIdFpISzJiSVlndTAwY0hJSlh4?=
 =?utf-8?B?TEluOE1saUxqQ09reFRUUTNKRVBuZXdLUU9kQitBc2VoUjNPUEQvK25yeDVH?=
 =?utf-8?B?a2VPb1VTbE56SUF5ZUhkSnhvalUyam15RFAzOWZ5djZidldjeVc1WWJKbkpJ?=
 =?utf-8?B?TFJzS3p0Y0xvcW1GNjBCNkxWRjVHdCtWc1RvYjJWeXdkcmM4MnlLVjNMTTZH?=
 =?utf-8?Q?eOzs=3D?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4989b807-5952-4596-35b2-08d9b95088a9
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1201MB0192.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Dec 2021 07:09:39.3737
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: LGMqyGJkoazp4oWPd+PosacS/heMSlSLTpi4ZMc65wuLZAYGoAjy+bX+e2dfvsUW
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR12MB1616
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Am 07.12.21 um 02:32 schrieb Bas Nieuwenhuizen:
> See the comments in the code. Basically if the seqno is already
> signalled then we get a NULL fence. If we then put the NULL fence
> in a binary syncobj it counts as unsignalled, making that syncobj
> pretty much useless for all expected uses.
>
> Not 100% sure about the transfer to a timeline syncobj but I
> believe it is needed there too, as AFAICT the add_point function
> assumes the fence isn't NULL.
>
> Fixes: ea569910cbab ("drm/syncobj: add transition iotcls between binary and timeline v2")
> Cc: stable@vger.kernel.org
> Signed-off-by: Bas Nieuwenhuizen <bas@basnieuwenhuizen.nl>

Reviewed-by: Christian König <christian.koenig@amd.com>

Going to push that to drm-misc-fixes later today if nobody objects in 
the meantime.

> ---
>   drivers/gpu/drm/drm_syncobj.c | 26 ++++++++++++++++++++++++++
>   1 file changed, 26 insertions(+)
>
> diff --git a/drivers/gpu/drm/drm_syncobj.c b/drivers/gpu/drm/drm_syncobj.c
> index fdd2ec87cdd1..eb28a40400d2 100644
> --- a/drivers/gpu/drm/drm_syncobj.c
> +++ b/drivers/gpu/drm/drm_syncobj.c
> @@ -861,6 +861,19 @@ static int drm_syncobj_transfer_to_timeline(struct drm_file *file_private,
>   				     &fence);
>   	if (ret)
>   		goto err;
> +
> +	/* If the requested seqno is already signaled drm_syncobj_find_fence may
> +	 * return a NULL fence. To make sure the recipient gets signalled, use
> +	 * a new fence instead.
> +	 */
> +	if (!fence) {
> +		fence = dma_fence_allocate_private_stub();
> +		if (!fence) {
> +			ret = -ENOMEM;
> +			goto err;
> +		}
> +	}
> +
>   	chain = kzalloc(sizeof(struct dma_fence_chain), GFP_KERNEL);
>   	if (!chain) {
>   		ret = -ENOMEM;
> @@ -890,6 +903,19 @@ drm_syncobj_transfer_to_binary(struct drm_file *file_private,
>   				     args->src_point, args->flags, &fence);
>   	if (ret)
>   		goto err;
> +
> +	/* If the requested seqno is already signaled drm_syncobj_find_fence may
> +	 * return a NULL fence. To make sure the recipient gets signalled, use
> +	 * a new fence instead.
> +	 */
> +	if (!fence) {
> +		fence = dma_fence_allocate_private_stub();
> +		if (!fence) {
> +			ret = -ENOMEM;
> +			goto err;
> +		}
> +	}
> +
>   	drm_syncobj_replace_fence(binary_syncobj, fence);
>   	dma_fence_put(fence);
>   err:

