Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4003B46D018
	for <lists+stable@lfdr.de>; Wed,  8 Dec 2021 10:28:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230071AbhLHJc3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 8 Dec 2021 04:32:29 -0500
Received: from mail-dm6nam10on2056.outbound.protection.outlook.com ([40.107.93.56]:55136
        "EHLO NAM10-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229481AbhLHJc3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 8 Dec 2021 04:32:29 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YtBobmgSisuNuCN9BhhcLeBk8petJ23BI23oiXO/yahI7l85HwO028FaD8tGtOPAcfYdXqCE+0oTDY0ECuaKIwcTU34qgOkrgqhESoECKnuMPYK/gPp1tjCsaypEyrLuic0MxLYdJr8mPIlmiHjz3ev4z9/fSR6fMRZasVhmzpSNDVKfHdGrs+SWcaCrSpjYxHCRGx4YKI6WqJkCcazMH7k1fM2afQROUeQoniAtMeU2Q2qkTt2BIAHx1+waHBMB9vvdSLAbysLVikekcb8TeMG/6eW3fD4WKgraH/vuwilTdnzPrwFknefORrFJn2RehrpqozP1t7C3AfgkYQaIgg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=CdvURolc7Oo+ppsBk2ti1HQji5dEMAU0G9N2llHLZYg=;
 b=GcpMHSUKF8ecTChRmClk99X6AOxrUQDW79aKy0P9K3Do24PtrUD8I+t2vAFCW1+Wu1QuOVB4fe/L/Sn8AV0vcmICV5Ssuh9SQVSAZaOK+k/mWrzufcPCJL+F9fVPoe4LKCpp6Gjx+4KhC94U3Ue9yDA9jd9qhK3NI2zzidrs7Qb0INy+5oVf9jLB9tLyYJKYeXyTWRrldvwBYnvn5dFD2Z/mr2tA1MG9zez01sVY1LUaXdGrKCFLzY0hf7eJ/n3TkHEHvwDKLtjU2zl+fDqEpqrbky4QGjdee+crboG9xz98qxIz9TL36PhPIOqq7taFB/hlGFdae/oskG/UeaIK6Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CdvURolc7Oo+ppsBk2ti1HQji5dEMAU0G9N2llHLZYg=;
 b=4IC5PYGbjyfT80ahnd1NPWBgt1tENWgpX/xd+fufsSqTF+dPKUM9hHkZOAYH/uO4eFgU5NBfph+S50W0LsNW4aGkF6MhdKgLP9GnysCDR2oz7tKWFHCV40UsjdxelUTJW6n6POJ3ekHYInr6459UR6GWG1U8IHOTa+5+3397/8w=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from MWHPR1201MB0192.namprd12.prod.outlook.com
 (2603:10b6:301:5a::14) by MW2PR12MB2425.namprd12.prod.outlook.com
 (2603:10b6:907:f::26) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4755.20; Wed, 8 Dec
 2021 09:28:55 +0000
Received: from MWHPR1201MB0192.namprd12.prod.outlook.com
 ([fe80::d16c:a6d5:5d2e:f9d4]) by MWHPR1201MB0192.namprd12.prod.outlook.com
 ([fe80::d16c:a6d5:5d2e:f9d4%12]) with mapi id 15.20.4755.024; Wed, 8 Dec 2021
 09:28:54 +0000
Subject: Re: [PATCH v2] drm/syncobj: Deal with signalled fences in
 drm_syncobj_find_fence.
To:     Bas Nieuwenhuizen <bas@basnieuwenhuizen.nl>,
        dri-devel@lists.freedesktop.org
Cc:     lionel.g.landwerlin@intel.com, stable@vger.kernel.org
References: <20211208023935.17018-1-bas@basnieuwenhuizen.nl>
From:   =?UTF-8?Q?Christian_K=c3=b6nig?= <christian.koenig@amd.com>
Message-ID: <2e0269eb-d007-4577-d760-343ccfb05c9a@amd.com>
Date:   Wed, 8 Dec 2021 10:28:48 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
In-Reply-To: <20211208023935.17018-1-bas@basnieuwenhuizen.nl>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-ClientProxiedBy: AM5PR0601CA0060.eurprd06.prod.outlook.com
 (2603:10a6:206::25) To MWHPR1201MB0192.namprd12.prod.outlook.com
 (2603:10b6:301:5a::14)
MIME-Version: 1.0
Received: from [IPv6:2a02:908:1252:fb60:23fe:5a01:cda7:6599] (2a02:908:1252:fb60:23fe:5a01:cda7:6599) by AM5PR0601CA0060.eurprd06.prod.outlook.com (2603:10a6:206::25) with Microsoft SMTP Server (version=TLS1_2, cipher=) via Frontend Transport; Wed, 8 Dec 2021 09:28:52 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 8575f235-e2cb-4dd9-6d71-08d9ba2d26ad
X-MS-TrafficTypeDiagnostic: MW2PR12MB2425:EE_
X-Microsoft-Antispam-PRVS: <MW2PR12MB2425C5B7CCA067467C3D7BA5836F9@MW2PR12MB2425.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7219;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: RGQ6x/Umq3TspvVJR7ztHrHuJxJO4PKNLgPluzurOdsEOKEx9IXQ/T2ZXccV06ag2TsY2OkG6/17IvMt1K/kQ0Nhxh67S+s8qU5kbItHJb+fYHR6KzJdgPX3uqQsdsSArQcr3fH1nFVnW7aK4a77lRY3d8Hj0VW6k7SaqXd6TZ+CGXSnKo7xiDCLTjzOdDQr9Zv9kqaI8Y7klwSnVvtXoeEAh6fsEGqG+CGYUoXsxDe2/0IJVG7QtT2or86jWcmCa33y+jslBdryfAADwaEHNiTlMoqyBA/lh8SsRpEjhEx/Ew26Rtr9OJQbpl1AKCH9Li1gyx4s4ktpfFPh2Sy9kSDMkLFqTeeeuuUmnkUQLlNPP/2NejWCHsQAFlkqB/6SeYSy7vWoYhOhBSmF3kuHmj/ORHBogWTXOPKlwvJmQ07gD8J5zVecgF0H2LNwEsj3JhEU/gWnhmC/wJBACSbT+zubbSr220XAxMB1vXk0vVmlRseG8s328l3j9Ja9uv5mQsbQZ+OxYPPBS8LD9kfTcaCXGbow7qCLLWVCwRPVWcKPslaHyCNPyLAbf2PwoMdYqTTon3O8/8wUcR2kEY4BpxbYtASLczLJOM39m6/bDUalFu0GVaMjNqUXYGlKBpxAl43fpldCBy4dXhpw3fnceu2k6YpM+fxL5c6yoKNw0e1/S2A5Wx6nPw7PEyHBkMW7LR3m9nnppVz8zd4J+OhfvRBhfibRP4RT6pon2xeekZ/BFIfdd+J8cat9ySjlLE2I
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1201MB0192.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(38100700002)(36756003)(2906002)(66574015)(83380400001)(6666004)(508600001)(4326008)(31686004)(66946007)(86362001)(8936002)(186003)(6486002)(2616005)(8676002)(31696002)(316002)(66556008)(66476007)(5660300002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?UllySWVzUGtkOUlGcU90M0xvVy9PWUs2Wlp2R1ZjQXVrQzVMUnlyWTFQKzc4?=
 =?utf-8?B?N1VUcFl5QmtpNDZPNzU4a1NBTmpsSFlFY0F4QXcwb2pNVGExWmpxMWdiZitW?=
 =?utf-8?B?cExxS1krdWp0b0dzM2V5YStwMUc3RXBCT2RBRVF6VVdvN1lFNC94VWJZbGl0?=
 =?utf-8?B?VFJCVFREZWpoSGx5TTl0QXhtaHBqcndwVDlVeitGSHRJUjZCMk9IYUhGL1JZ?=
 =?utf-8?B?QjF3QzBtTnJMZjZYaTIrNVB2Vlo0RTZIYk53RkFQYUF4WHJUdUtzdnVoeFRZ?=
 =?utf-8?B?SEQyY1lHVEU4SGU1OHZ0SUNaUGRRdEFGUXFINmgzbWU1MFRjaDBtTnRwL2sr?=
 =?utf-8?B?T0huU21NdDlEUDZVY3NEWWI5d3JLVUo4K2Q2MkxOSnBmSlVEMG10RHNJaXIx?=
 =?utf-8?B?Q3k5Q3N2VU1DZGFzQWROWU9hZWVYYytpRFZXS29iaFZOTGRMbFFCMVRWUU9V?=
 =?utf-8?B?K0lpTUJnM1pwNHBrTDdQRGNOcnN0WFpzZWFsUWt6YTkzcE85Ty9kQk14RDA1?=
 =?utf-8?B?NU5vd04rUWIvQ1FxbCtRWWN3TXMzY0NvR3NYYnRiMVpRSmxydThOWjZhdmxl?=
 =?utf-8?B?a25xVVlEdm9oaEt4bzFzdEJLMG8xNFAvL3ovQkZ6UVFWL25RamxjaE1RdWd5?=
 =?utf-8?B?ZXFONUNSSTBpVUxFTkN0aUtmR3dFQWNjTjBzRC9udDJ4LzlEYkYyYTh0K2lw?=
 =?utf-8?B?ZkNGaGc2akk3MDhvUGZuWWFYR2R1dVJSWTZIWmxjcFlIMVlERlFsM0kzSWNt?=
 =?utf-8?B?N2g5dkJRbk5VVTdtZG81QVFBSENWd1lUbHVhSjRSY0s1NitNVFMwSWtuSVZx?=
 =?utf-8?B?U0JVNkkwTTFFWmlBYUkzVWozQk05d0hmNzJ0bms3Z0w0Y21Fb1kySTA3UGNM?=
 =?utf-8?B?Z0lieVF0cHJTZ2dmUlBxU1NlUXltNkhGYXFmSVpiK214ejFOUkorZ0FlY3ZY?=
 =?utf-8?B?NE9jbXBESE5oWjlCdThhWURXQ2NUVnVEMnpOMzJtaVVUTTBkV3Q0Nm12dUgz?=
 =?utf-8?B?bmNSdlRFNjV6UkFPUUh2Y3RBazJ0NC9hTFpRVzNWbHhOaDlzTkNjVmMzRFJU?=
 =?utf-8?B?dDZ2NU1iZ0JtUEIzbUpRWktBMlRuZ0ExYUUvdXRGZEdlOTY0YlNobFl5MENo?=
 =?utf-8?B?MG94ejVQejB6WU1nNmM4UnlNKzJpM1BZaGthZTl1MnlHS2tJOExCc2d6dUZy?=
 =?utf-8?B?ZTFaNUlmUWdhS2MzaUVlb29CRUFEdml6TW9OeGk1UW8vNHNIZ3JUcTN0WkhB?=
 =?utf-8?B?U3VTYzVOOHJBcTBSM2h0bStGejhhRFZGOUg0Nkh3WStycnBURnFTQUpQSkFF?=
 =?utf-8?B?QkpjYkRvdEdLMWMyWmcxakx1enY2OExEd2JvNEZQVVJ0Mi9GeHV2U3ArSzZ6?=
 =?utf-8?B?L0V6eFlCM2M2SkwrNWJzMWxiQWNyZ3Q3QzI4VFNQK09SQmFGeko3QjBYaFU2?=
 =?utf-8?B?dUluaVl4N01FZjJRMitWQXAweEV0em5nbTRVRVZyd3JEUnlCUFlRdFpBaW5s?=
 =?utf-8?B?M2FiWm5zNUUwdVR5R0pJbWI4TUJjajlVa0JoOGRkYW5sazJPWG5CZDVaY3ow?=
 =?utf-8?B?czcyZWpSWGNMbDdYTFY3bFpKN3lhZUN6cFd2a3RDSWRRV3BYN1FORkVMMi9S?=
 =?utf-8?B?VnhZeDFkRTdjSE83SUhVN2NCRm9ha0ZkWmZuT3BpaWhvR2MyWlVYOEhFZEJ2?=
 =?utf-8?B?SDROM1BLalNMWDA2SlNBU25uTmVGTlhYeEdtZ1JOYy9IRDZGeGZQTE12c212?=
 =?utf-8?B?VXNCRzJqMDh4NVBGUHdOSFRMS3FvRnM4LytNSk1NUlZkZkI2eWdVUFE1alBB?=
 =?utf-8?B?TnlzTHdHbmM1bXU0NnF2MlcrMEwrVzNqaWFoRHkvRk9RbVRoK0ZhSnptUTg4?=
 =?utf-8?B?a2ZZZ29JODkzVG1HQXY3SjgzYXhKbXlkclVrV1JLbnhEbElEOW10ZFZtR0dh?=
 =?utf-8?B?ck9VZ2RUN1o4bWE5ZHUxKzl4L1R4TDMrRFRKM0VmWC9ubWNVYnkxWFA5L1FM?=
 =?utf-8?B?bDVvYmhZZTF0T1AxWU1jM2d5MnREaGcweWg1V1pNZXYrTkE4dTVjcGxZQndH?=
 =?utf-8?B?aW82Vml5RzhDQ3lacm9neGVtYVFLMlM2dkI1V29zL2RzVFBXWHBJNUJ5d3M5?=
 =?utf-8?B?emcyWWg5Q0FRblVSVjRKR0RUY2UyNFp6YkhiQTRSanRONjRwck1VZ1FRMTY2?=
 =?utf-8?Q?ZIQJMN+pgMV7akTBwURJi0w=3D?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8575f235-e2cb-4dd9-6d71-08d9ba2d26ad
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1201MB0192.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Dec 2021 09:28:53.7989
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: MztZ4iFbiFQCz9DLNhx8L5rj7tnQhLuHNtiJrVTFShU8vL+hH6v3ebVq7Kf0QX9o
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW2PR12MB2425
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Am 08.12.21 um 03:39 schrieb Bas Nieuwenhuizen:
> dma_fence_chain_find_seqno only ever returns the top fence in the
> chain or an unsignalled fence. Hence if we request a seqno that
> is already signalled it returns a NULL fence. Some callers are
> not prepared to handle this, like the syncobj transfer functions
> for example.
>
> This behavior is "new" with timeline syncobj and it looks like
> not all callers were updated. To fix this behavior make sure
> that a successful drm_sync_find_fence always returns a non-NULL
> fence.
>
> v2: Move the fix to drm_syncobj_find_fence from the transfer
>      functions.
>
> Fixes: ea569910cbab ("drm/syncobj: add transition iotcls between binary and timeline v2")
> Cc: stable@vger.kernel.org
> Signed-off-by: Bas Nieuwenhuizen <bas@basnieuwenhuizen.nl>

Reviewed-by: Christian König <christian.koenig@amd.com>

> ---
>   drivers/gpu/drm/drm_syncobj.c | 11 ++++++++++-
>   1 file changed, 10 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/gpu/drm/drm_syncobj.c b/drivers/gpu/drm/drm_syncobj.c
> index fdd2ec87cdd1..11be91b5709b 100644
> --- a/drivers/gpu/drm/drm_syncobj.c
> +++ b/drivers/gpu/drm/drm_syncobj.c
> @@ -404,8 +404,17 @@ int drm_syncobj_find_fence(struct drm_file *file_private,
>   
>   	if (*fence) {
>   		ret = dma_fence_chain_find_seqno(fence, point);
> -		if (!ret)
> +		if (!ret) {
> +			/* If the requested seqno is already signaled
> +			 * drm_syncobj_find_fence may return a NULL
> +			 * fence. To make sure the recipient gets
> +			 * signalled, use a new fence instead.
> +			 */
> +			if (!*fence)
> +				*fence = dma_fence_get_stub();
> +
>   			goto out;
> +		}
>   		dma_fence_put(*fence);
>   	} else {
>   		ret = -EINVAL;

