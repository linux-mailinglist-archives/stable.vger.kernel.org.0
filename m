Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7FB1149AD9E
	for <lists+stable@lfdr.de>; Tue, 25 Jan 2022 08:32:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1359688AbiAYH2p (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 25 Jan 2022 02:28:45 -0500
Received: from mail-dm6nam12on2082.outbound.protection.outlook.com ([40.107.243.82]:45665
        "EHLO NAM12-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1445104AbiAYH0i (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 25 Jan 2022 02:26:38 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=B1t5KXqJYappknWmKmWVsrUPVHUvnpITXcrbJWehZSdueeKu0DtqM+l7Vy7dCAnlGcv+XTV+Wmat66YpyqEQ91/ciYKxAma/XZUd9pdU/QxXAWOxUNDo+EbbZFhlDUoLfjxXigC0mLEg5LAi+8XmkPRQKxYmWSyRY4mrTUJP+xFrp+Dt5GclhYvsrNUFBDNTa7gQFdWzN500thGQQ2xL+cpcHVe+WKm1D96hr8VJOAmf5jErr7kAswjTxXgTnewRNPi7yxoVTaSbOnubjWXhvzL2tgvEs0uEtUNW/wo2uH80WjO6gMHvZBejQh0iho+KJI6CwxxF0Qd1snF89E92cA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=iDYVNkPrlzT9H9e1/OuiVoKw3/d9p2F+WSl5pz1Vg+c=;
 b=frkPBkdtHvI77tQDzVGt/Unri8wMoKJogqbNDW0k6O80w3M0IJeDtQTsTIfIvQp9YAYCuHlEtNR1izUSlp9g0z21ufrclpGRnrg3EKWYzPmQTXNuzGAXChj8PfR7sHp3Wxy7qjBObhmIg0kcxkXjc3Dxa1mnRTPSH9AgtotyRXEcUFfl3nj6mISGlTEDesue9py2vd54z4NnYyakFrapmrJV9yIBGvhwYCtD3s2KDN00Z09YkvQ1+YpgWK742l6hEEwkByvSzjKWsrZz7e+6apFZjcQ5M9Mq0y6RvOevug1J3R6s5GcxNm/gFNn0hpwjgMY1Q9wxjowdTcOn7lhYGQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iDYVNkPrlzT9H9e1/OuiVoKw3/d9p2F+WSl5pz1Vg+c=;
 b=BkF9QY+947zASJ49OuolZ9dUDV52YgoNaZ9wLPSvm/q4doa4BtINlJ4IH9ANqjZWdesZL7k1tb4EXiwz+HPwi2W3AKoBesWvXsx1NmtrElnjObFxz2oDvwuCWHAk6hJIL0rm4BrQSJsI60UHJ3RNpiWY6ltgVgAyLKl3l7GLD1s=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from BN8PR12MB3587.namprd12.prod.outlook.com (2603:10b6:408:43::13)
 by BN8PR12MB2897.namprd12.prod.outlook.com (2603:10b6:408:99::25) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4909.7; Tue, 25 Jan
 2022 07:26:26 +0000
Received: from BN8PR12MB3587.namprd12.prod.outlook.com
 ([fe80::d8e7:e6b0:d63c:4a21]) by BN8PR12MB3587.namprd12.prod.outlook.com
 ([fe80::d8e7:e6b0:d63c:4a21%5]) with mapi id 15.20.4909.017; Tue, 25 Jan 2022
 07:26:26 +0000
Subject: Re: [PATCH 5.16 0702/1039] drm/amdgpu: Dont inherit GEM object VMAs
 in child process
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, Felix Kuehling <Felix.Kuehling@amd.com>,
        David Yat Sin <david.yatsin@amd.com>,
        Rajneesh Bhardwaj <rajneesh.bhardwaj@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>
References: <20220124184125.121143506@linuxfoundation.org>
 <20220124184148.931014095@linuxfoundation.org>
From:   =?UTF-8?Q?Christian_K=c3=b6nig?= <christian.koenig@amd.com>
Message-ID: <e37beeb2-1ec0-9f7f-06f6-ee4df975a956@amd.com>
Date:   Tue, 25 Jan 2022 08:26:20 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
In-Reply-To: <20220124184148.931014095@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-ClientProxiedBy: AM6P195CA0065.EURP195.PROD.OUTLOOK.COM
 (2603:10a6:209:87::42) To BN8PR12MB3587.namprd12.prod.outlook.com
 (2603:10b6:408:43::13)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 49fce4f3-e7d1-4480-58cc-08d9dfd3fede
X-MS-TrafficTypeDiagnostic: BN8PR12MB2897:EE_
X-Microsoft-Antispam-PRVS: <BN8PR12MB28974044EAC6C089CC111E92835F9@BN8PR12MB2897.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2657;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: rpMe6izbguWC2OnLFhAzI5HHNSc6lPdkaJ2wDxThH5mveOjWXSUdBcpKUMnFJs0tKTCz4bbtl9y69STQFNiqIaNwGCtjfveGrh7UPMK7pKad473aDX0jK5V42EyLmW85Uyfcqq2j/BrhI2RZSwjZW5hz1hdaok9AL0CAkFxjbKKwf1W4/PX4MO3ac3dfUtQIYZAy10WDSeRP3b2iJtbCaLbWZ3y+6ViscjBh/qiKrgOtc+qCtqM4I7WxUC+8PkDj1ObKpBDZBsr/HredJbVAY/568kgChSsfNUMm9WcZVF6q5YlXtrHMtnuef/R3H3y/PBKRftpICzjm0wt9oNy9ImoneRAH5Eb4m1ICqsZ9VWNSXypGNim8KSxpQ76HRn9dG5TrZVvxfLh1tpEUplGMmGDUSiXxXY7PQ+HUzxMe9bueB31Bofhgmj3ce4S3M0APoKNFjRJeVMfOGbjU7bJ9w/CM9mfaA143xAXmmOjuybltl7/KSUoJi5c6DKOtuGPzAKPWn3n+D7nQvlTOegrDk/RXCaxi04Y/hGZNVuNGYTkV9/ea28GL7oKjjg6r8UXD5aO0xFKpkqZ3Zv27PpqEekxYKbGN5uajuZ8QJWK0jffupH4S561OT682L6AG39EufQAUyi7E+ayQtT8jR1mWODrEWdQPpslQiZE58ScrC7OS/0w3T4fo8ypV56sekifMyYD9HAQDeQ03XLZmxX338xX238ZAx7QIyNb4w3tcqYslHR9KKbvP/Xa7G+jHBerz15RVOqYa5G4Be+Nk1IUMPQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN8PR12MB3587.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(31696002)(8936002)(38100700002)(66946007)(66476007)(66556008)(6666004)(186003)(5660300002)(8676002)(6506007)(86362001)(54906003)(4326008)(2906002)(316002)(508600001)(6512007)(6486002)(66574015)(36756003)(83380400001)(31686004)(2616005)(192303002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?U1dXaStZenZNbTIvYWVOLy95KzRQbVdOTlEzWURMRXNES1g5Rkp5TDhlamZR?=
 =?utf-8?B?MlZjSTMrSnN2MkdMWk9ORkZTdVZnWU5QZG4yYUFkeU1MSHRaUHNxSzVmUDA1?=
 =?utf-8?B?WGY2Z0w0bXQrNEZTNmU1ZEx5ZGpxdTJaZlRDMktRQ1BFVU85bjZPOUgwVVIv?=
 =?utf-8?B?QVNsZVVLL3h3RS9JMCtsUFZWeElkdVhYeFdkYmIvMmMzTlJPNmVlRkZxdGxy?=
 =?utf-8?B?SGhoeGFUQVQzU1RsSXFXRWZYSlc1RTdWUW55cVVBa3VZTWozeDZ4QXFUVUxN?=
 =?utf-8?B?MFlKRXp6UWQ1VGU1Z0xVOVVsY0RRQUFsYWpwV2NVKys4a1VmSDFqVlg5YzdV?=
 =?utf-8?B?NE1YZ3U0dVhPbnJPRml1SU5qaUdWOW9kWGsvYUIralFyV2pxL2hLK2FzckVp?=
 =?utf-8?B?Y3F6c29pYSs0VjlQVzhsVnkwTXBGdEVyNHZEZmkvcGZKK2haUEFuRm9nM2Vh?=
 =?utf-8?B?TTdrZmVLY3p5ZUxRSEIxMWZqalVNcmIzZ2c0em5hVmxyNCtxZ3NJVWREa3or?=
 =?utf-8?B?RVlacTBCdkYwWTZuZU1BaUl4OXhMZ3BCcDJuelkzbjZnUmVpdFpPNGxqVklQ?=
 =?utf-8?B?VDNPMHI2ekJidWFRWDFQME9ITFRTOFdJbGE3SEVhSDZGa3Q2VG1SN1hXU0ds?=
 =?utf-8?B?MlpCOFVnMFJoTnRRMG9nTUxZQzU2REI1M2J0ZkNSczJnNGQrRklxWGxKbjMv?=
 =?utf-8?B?cDNza3BScUVCSHA1b0wvUUh0emFMVjg4eVlwdzA2Wlp4NDg2N3NaU2hIaklh?=
 =?utf-8?B?cmdqd0xmSDFHa2VuNVdYQmxSazZuMXpJd3J0YlNFQXY4dXk4SEpVUWZhTlRn?=
 =?utf-8?B?Ujl4UmZnS0Vkb3E4TjkzRDVpQXh0UzltaGkrRWNBQUZqUnNNTy9pLzRPVGQw?=
 =?utf-8?B?VFZ1NEVaQTRrTDI2OWdMZVlvUTllaU92TXZTZUVXQk5yenJ2c0dnOTdvTUhP?=
 =?utf-8?B?bHk1cXVlK29wV09mZVdiSExUR09ESGNjYXJBK0N5azd4RE5SRU1ZRGNRWWpy?=
 =?utf-8?B?QUxReFdRaXBWbjZISzFEbEVUbU1nczBCWHMvMXBEUERRZHh1OXo1SGxGMmtH?=
 =?utf-8?B?SnhGQWE5UUdBcjYyK3ZMRDdrTC8vZ2pCV1cvM2IrUUVRZTVSb1NIcWFBWmNK?=
 =?utf-8?B?UHpKaTBpeFV3Q1NnSytMd0JJOUhCamxlMnpZcExWc25sRzZFaGRNU2dEQ2dp?=
 =?utf-8?B?M3ZsQVgySkc3bjdxNmVqY2o5RWMzZmUvY1lvb3BhYkxEUjBoNEg1azBXRDNQ?=
 =?utf-8?B?SVhCYzBOQmhOc1VTWUJVQTFtUkJsOTY2MWpLeTdaYWo2L1Q1YUpUVmNlYzFG?=
 =?utf-8?B?VEUwcCtrcHdteVVkSmZuQndETk9xVGk1OWM5aHQ3Rm9oalE3SnFrSHBDK2JQ?=
 =?utf-8?B?MzN3QlZCSGppd1FCVDNianJvc1duT01GK0Zrd1VBWlVQbG8vcWl0a00xMEd3?=
 =?utf-8?B?TG1rcTU1UHU5UGd6WHEvbllXbjFWdXUydkJVWUFKR2prZWMvTzJ0dThSZmUx?=
 =?utf-8?B?QlRqOE9HaVVUUXl1UUJYcll2d2NCM0w3eWdMM0JOYU51OUNKVlRabEErTHl0?=
 =?utf-8?B?ZGVKQzAzV3pVaHEvWHpyVERkdUxkQkhCYU0wVitLekExQUI5dVp2ZnJlYVM4?=
 =?utf-8?B?SHB5NmR1YW5uS1MzR3phWVo3b2NUUWNVQmUvZ3NRUVZCR2d4enA4OE5zUm1u?=
 =?utf-8?B?a2l0cEI2QkoxOFYwbys3V1BkL1pRdGN6NFdDd0ZtU0l4V2xhSE9CajgwOUVL?=
 =?utf-8?B?dVZNcnpHYjU1NlFUaHlNWFNwY09rWXh4UG9KUUw3Tmk3RGo2eEJVNkgyZlRW?=
 =?utf-8?B?NUIzY0hENlM5NjdWalVjS2hXd1JNVDRuOVY2Q3pmYWRYVXUydS8yajRBenNm?=
 =?utf-8?B?VDMxNVUxM2UwdGluS293bjg4cmFBaE15ejhpYjJUYWRaajZVNkcxMGFjd3Vu?=
 =?utf-8?B?bEJwNmFOWFRCTGt6MTc4b1QrTnkxeTkvWlBjMTFGS3dQbm1pbThhMEg1Q2wz?=
 =?utf-8?B?dHBLdUp5dG5ybmFwTG9WNmxTWDIxSXBlUm41eE0vaXFKbTVVNXFHWDUzRnM3?=
 =?utf-8?B?WlNTUXdRcTRjWmdwN1FjWjg4RmhJMi9JUDhXd2R3eDkzVEhobnhCN1NzQ3Bk?=
 =?utf-8?B?TUlTbEpDK0grTUdvcDFURmZDbVl3YkxVTWxaWU44dGtYU3BORGgwK0lCekFN?=
 =?utf-8?Q?8ij7aGtHKHPHCUsBCMhz1vk=3D?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 49fce4f3-e7d1-4480-58cc-08d9dfd3fede
X-MS-Exchange-CrossTenant-AuthSource: BN8PR12MB3587.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Jan 2022 07:26:25.8745
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: whTcLrfbBHAxWcSvtOGdo5l9hWYXe8Rf0P5F2mhiUf40qY3m/5WDXfRiHEM5j+mM
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN8PR12MB2897
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Greg,

Am 24.01.22 um 19:41 schrieb Greg Kroah-Hartman:
> From: Rajneesh Bhardwaj <rajneesh.bhardwaj@amd.com>
>
> [ Upstream commit fbcdbfde87509d523132b59f661a355c731139d0 ]
>
> When an application having open file access to a node forks, its shared
> mappings also get reflected in the address space of child process even
> though it cannot access them with the object permissions applied. With the
> existing permission checks on the gem objects, it might be reasonable to
> also create the VMAs with VM_DONTCOPY flag so a user space application
> doesn't need to explicitly call the madvise(addr, len, MADV_DONTFORK)
> system call to prevent the pages in the mapped range to appear in the
> address space of the child process. It also prevents the memory leaks
> due to additional reference counts on the mapped BOs in the child
> process that prevented freeing the memory in the parent for which we had
> worked around earlier in the user space inside the thunk library.
>
> Additionally, we faced this issue when using CRIU to checkpoint restore
> an application that had such inherited mappings in the child which
> confuse CRIU when it mmaps on restore. Having this flag set for the
> render node VMAs helps. VMAs mapped via KFD already take care of this so
> this is needed only for the render nodes.
>
> To limit the impact of the change to user space consumers such as OpenGL
> etc, limit it to KFD BOs only.
>
> Acked-by: Felix Kuehling <Felix.Kuehling@amd.com>
> Reviewed-by: Christian König <christian.koenig@amd.com>
> Signed-off-by: David Yat Sin <david.yatsin@amd.com>
> Signed-off-by: Rajneesh Bhardwaj <rajneesh.bhardwaj@amd.com>
> Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
> Signed-off-by: Sasha Levin <sashal@kernel.org>

Please drop this patch from all stable versions since it was reverted 
from upstream later on.

Regards,
Christian.

> ---
>   drivers/gpu/drm/amd/amdgpu/amdgpu_gem.c | 3 +++
>   1 file changed, 3 insertions(+)
>
> diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_gem.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_gem.c
> index a1e63ba4c54a5..630dc99e49086 100644
> --- a/drivers/gpu/drm/amd/amdgpu/amdgpu_gem.c
> +++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_gem.c
> @@ -264,6 +264,9 @@ static int amdgpu_gem_object_mmap(struct drm_gem_object *obj, struct vm_area_str
>   	    !(vma->vm_flags & (VM_READ | VM_WRITE | VM_EXEC)))
>   		vma->vm_flags &= ~VM_MAYWRITE;
>   
> +	if (bo->kfd_bo)
> +		vma->vm_flags |= VM_DONTCOPY;
> +
>   	return drm_gem_ttm_mmap(obj, vma);
>   }
>   

