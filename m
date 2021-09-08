Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 349B240388C
	for <lists+stable@lfdr.de>; Wed,  8 Sep 2021 13:08:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350210AbhIHLJY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 8 Sep 2021 07:09:24 -0400
Received: from de-smtp-delivery-102.mimecast.com ([194.104.111.102]:46710 "EHLO
        de-smtp-delivery-102.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1349131AbhIHLJP (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 8 Sep 2021 07:09:15 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=mimecast20200619;
        t=1631099286;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ibZZSZDjrGpS0aAvSHO8S3jjjnBSNdFfyqK0ghkhpSU=;
        b=NsaByE/xXWWLyN0oNmwuqurFRmQXrMND+8O0yM5VqCLzBL83pLztT3V/eqruQxnP2Rn5zE
        NgcpdDKkO0FQ7p9QnDN5mT+OzdYfb0nuuc4329DROVQoVk/tKAlBOK6dB0rVQVcXhdcI22
        6dO0SJl7sdNwrVC8CY4JYukynDDFLew=
Received: from EUR04-VI1-obe.outbound.protection.outlook.com
 (mail-vi1eur04lp2053.outbound.protection.outlook.com [104.47.14.53]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 de-mta-40-cB24rCK_O2mHUJsw7tIBxA-2; Wed, 08 Sep 2021 13:08:05 +0200
X-MC-Unique: cB24rCK_O2mHUJsw7tIBxA-2
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kojxzyUv9/2zTUos7IKE2PwBZBeC1HlpRWqMgCscqEGqwe9gqo9u9UcE3l8ihbkaLQkmIILrOtp4QUsoDQauqiEQOcXIwgkB2NOYPt9gXsxirqbLD2aXhtzNU8/m5Q0mfYTdG2O77qNaI6KyBg9N+TIroLI4gENyN8pWk/iJlyMsCxQa4q604fSpGIGsBkvEwyvKaSI0jinFMvHG1DFui9xX/BBDeAkQunSFay5EPxvrIy6erJU6jRVSq1tTkZR7YsvDteG7UmQOBRikyzyEBZPesINpud4IW+jn4vJ2KWBuWHwKK4Tnj9z1inzI48q+DMo0eYHvW8u1wNfwtw+c9A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=ibZZSZDjrGpS0aAvSHO8S3jjjnBSNdFfyqK0ghkhpSU=;
 b=n89IR/s7EENoYKOP7zqcqikiBQa/6U6Pw4yVEdVkTg8cbR9YPGOSs0HnnBtKfbcgehC1QJqFZNZV3QKsTcV33Lh+nxu2A7HS4KKOv5CDcAox8Wvx+zLTdfdSdEeTs2DCBbmfslPOzNS6uJ4PlVZQST8ZBDAcyjsoeVp05mpI74zJxz3fZMFLP/pTgrzbFhKuKu1C0gWPHlVGDtkX3DUHE9SkK1gEt5/u9nDdhiuOsX6gBTaRUvl08uEZX/sHnBjhohkHsn3Y/5gcNA09zkxX+snyF7OnLfTNsUAs5+mGKv2zFmc25Jv92/CIngsaw2urYRSLshpaHPeEOLPyU69sXg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=suse.com;
Received: from VI1PR04MB5600.eurprd04.prod.outlook.com (2603:10a6:803:e7::16)
 by VI1PR04MB7039.eurprd04.prod.outlook.com (2603:10a6:800:12b::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4500.14; Wed, 8 Sep
 2021 11:08:02 +0000
Received: from VI1PR04MB5600.eurprd04.prod.outlook.com
 ([fe80::4d37:ec64:4e90:b16b]) by VI1PR04MB5600.eurprd04.prod.outlook.com
 ([fe80::4d37:ec64:4e90:b16b%7]) with mapi id 15.20.4500.014; Wed, 8 Sep 2021
 11:08:01 +0000
Subject: Re: [PATCH] xen: fix usage of pmd/pud_poplulate in mremap for pv
 guests
To:     Juergen Gross <jgross@suse.com>
Cc:     Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Stefano Stabellini <sstabellini@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>, stable@vger.kernel.org,
        Sander Eikelenboom <linux@eikelenboom.it>,
        xen-devel@lists.xenproject.org, x86@kernel.org,
        linux-kernel@vger.kernel.org
References: <20210908073640.11299-1-jgross@suse.com>
From:   Jan Beulich <jbeulich@suse.com>
Message-ID: <5a4859db-d173-88dd-5ea9-dd5fd893d934@suse.com>
Date:   Wed, 8 Sep 2021 13:07:59 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
In-Reply-To: <20210908073640.11299-1-jgross@suse.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PR3P193CA0052.EURP193.PROD.OUTLOOK.COM
 (2603:10a6:102:51::27) To VI1PR04MB5600.eurprd04.prod.outlook.com
 (2603:10a6:803:e7::16)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [10.156.60.236] (37.24.206.209) by PR3P193CA0052.EURP193.PROD.OUTLOOK.COM (2603:10a6:102:51::27) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4478.22 via Frontend Transport; Wed, 8 Sep 2021 11:08:00 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 2f41b41d-b43a-4b7a-6790-08d972b8ec75
X-MS-TrafficTypeDiagnostic: VI1PR04MB7039:
X-LD-Processed: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba,ExtFwd
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR04MB7039F6D45AE04AF5D442EA02B3D49@VI1PR04MB7039.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7219;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: utxgzYs6dqQkvYSIi4H5UoBlLIk0CWWEwwADTjpOH1Bd4dSJ/KZAF+ADIOmDpS+OyNgPEG0fnWoR7mlPq3D4KkZiLy/VrZY73jYm9tNVlMGn6nDk5xLqaFdyaZwARtC7G/s8JzwtHKC6E3i0/BW8xHxIZRv11Dgr1YTYeGB6cwx0v48HtMkAUty8hmjNqZ9RLjTlwGwWVuI6twro9ekZIdYzr9SIeHRzMwNWP3wnXBkD10X2HMVY0htijEs6N4uTDUllyZc9uD6euEXBdf0yW9XN9OgpTlv28ZblCNp0syphMiSmh70JBlHINPsOmQ0+f1fp0bptpWKxEie/uj5SIuAfqySJ7WmpcVDv+v3e+f7bp/sjxUa/449KrxR7Pmmwg1RL0bqQQKu1SF0Jo6xhLqwp/0GaQtA3HTm8tQTIbLk5kiZoeZwBv3cYcGeXEQvijTjoOUgC7HTLSWi9FwxIEHLOPtR+TAS12FVJgHhyzprcwExcMnXuaa/T+1cB0P0OmGNc9U5SuwIDE4ewTSyL7JxEsyPPkEH5OHwJgkbFcfSbL5eJ5tQii7FVvugq1VUhEn44/0maQlZG/GU9Vfg1+2Nt4JDgPfTuFAxnjfxu0SdQ108Yse5cpn5brNp5pwYl0qLa5iDUOGRQeF0Z1s300M45ADdxWCW2vWjtrKvaJBp4qrcMQ9Ew+Ed7MUZzvpXtDLFATgywzL73GD/6Qc1x2aSJtv+cGOUrdP62Su1s7qg=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5600.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(346002)(366004)(396003)(39860400002)(136003)(376002)(8936002)(186003)(5660300002)(8676002)(478600001)(26005)(956004)(2616005)(86362001)(4744005)(6486002)(53546011)(66946007)(38100700002)(66556008)(4326008)(66476007)(16576012)(6862004)(6636002)(83380400001)(37006003)(31696002)(7416002)(2906002)(316002)(54906003)(31686004)(36756003)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?ODQwS2pkZitMMHA5dm1lM1NqNHRSYiswTGU3SzhkRkp2ZysvZFFob3BtelF1?=
 =?utf-8?B?dnB5M3Z1ZHV0ZGRrNmRiVjk3c2hab3FybTRvd044Rzhhb0h5ZnhhYlhZMjYy?=
 =?utf-8?B?YXprZEdYN2hnRG9ZbUV1SHNtbTZSa3FRVjR3T0tYRng3VjcramZVMXhQOWF1?=
 =?utf-8?B?TjZSZjZHcG13enYwbGxPRE9Xem9HUFJjYlFuaG01UGJlK042MEtiQTQ3VWFl?=
 =?utf-8?B?aGpLSGNwQVRQUExvTlcySzRYekJCRUlmampYOWJvV29taThXSmEyVGdrZWhS?=
 =?utf-8?B?bXY4dmdxYUQrUDNPL0hhc0prcmsyVTQ5dm5sdlVOV3RmTkpZYU4vVnlaZGlw?=
 =?utf-8?B?U2tOMStqcWN5c3RPdWVFa3IzL2tod1cyZXBpNk13SjRGVVNJQWhycTBSY2Q4?=
 =?utf-8?B?V1d5S0Q2QTdSUU4yMVVKaFBXZ0dEM0Y4eDBqR2VtSG1KTk9zT2lxa3VNeTVs?=
 =?utf-8?B?dXkxbFdKcWcwV2tUMG4wOG80S1BzTTdLQ3o4R1lVeDVrU1VZdkNsZEpLMGZ1?=
 =?utf-8?B?WE84YmgyU2JjalhhVTl0SXhiT3BSQm5nRm52Uk9xaUJYSG9tMDB5Q1NkMk1H?=
 =?utf-8?B?b05McUpTaUlEUWtnQWQrQnJDanBqaWhqK3p5WHdTYi9ZQjFnSUNaWEEyWUp3?=
 =?utf-8?B?eHpxMml2d1hFZkw1YjJwekttaVVHcU5Db21qengwUDZTdEswamxwT3lzTTFL?=
 =?utf-8?B?d2NkV2tEOEVHbzhPakdnMHgzK2p6SmozVnFxUkhvUFcwc0pseHNDTlBoMzJB?=
 =?utf-8?B?NVFqSzBudzJLeEZCdTd1WmJZd2RPbXRBU1hCUFNTT3djOE10U2NzdjUvaStP?=
 =?utf-8?B?YnRVRDZnUEZJUUh5bmVSMmZ6dVh5TEsyRGRqd1NsWGowendvbHA5bDlHc3A4?=
 =?utf-8?B?bjFJdjhTc0k1LzFBVjk1MStGQW5rbDdveDVqUEJTdUxRcElZdDVqV0x4STZN?=
 =?utf-8?B?RzBtODJEQ01jdzhOSS9Va3Rqa25sb0hzYU93OGI4Q0QrR3BZUWl6NHY3Nzli?=
 =?utf-8?B?N3hlaXQyZk1TVStLdlN6YjZEU0ZkRlZNQzBDUWhvdkJCekg5K3F3M0VoMEZY?=
 =?utf-8?B?ejdDSW9ySW81YnAvRURWaXU4VDNrWEJSSGpiakNKU3RlcmcxYmxoQXVPRU9Y?=
 =?utf-8?B?WjZGUmVTbzdaRWRRVGtqM0RoR3ZGQzNPMTJWTlArd1d4M29ENDNSQXJ3V1Q4?=
 =?utf-8?B?N001ZDBVa0pMUVhYSW85MFFlZkJrdmtpUkxkcEVtc0pXdElwNGVXaURrazdy?=
 =?utf-8?B?d1hlUFFqRitBSFdpNEtoMGlYNEdoQU9hYmhyd3Nmd3VoWnJCLzdmSlQ3dWpj?=
 =?utf-8?B?TzZQczdmVVREYi8zWTAyM1FHc0VPUUNaUHF6Lzk5Y3h4M3BPT0ExajdKc0lB?=
 =?utf-8?B?Y2lvNGpsdURnb1lJckNvOThoTXIvcE5HMTgwdnJjM2xwS2p4UHNxeURCdE11?=
 =?utf-8?B?S2FxRHNURjlkRmRjYVFyamFENUJGSnp1aHpaU2lralMyWnJCZDM5alo4RmFJ?=
 =?utf-8?B?c2xaeDY2bmN1WjhiWG41ZnRjVitHOVdWbmxFcS95Tnd1ODZKZjVJa2U1bXBp?=
 =?utf-8?B?NGJrYUVpYlp5WGRuS2tJYTBBVlNZczQ5NnZydUpvazR4aHo5NVZpL1VLWFZS?=
 =?utf-8?B?Z0ZlcEZKdElpUGt5UVlzMElJalcyR0lWYnJkaXJ0MWF1UHJ3SC9pKytORXdQ?=
 =?utf-8?B?WGdkTVpkZVZFYVM5MDluQ2M1WVFOMUdTcHdUNEI1SFlYcldmR2ZLVklZcklZ?=
 =?utf-8?Q?9bkFrGvPxGZxWkNbXvaqTo/b/suyhuSN2+mUZNK?=
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2f41b41d-b43a-4b7a-6790-08d972b8ec75
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5600.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Sep 2021 11:08:01.8090
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ZLHvnujt1kr3En3TS+/V2UrsYzpUsJ8YohOMkTEo7Rf3vUlrfLp7XX8XECNWVT4CLf14MmIj3x+hZt1iKFEiag==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB7039
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 08.09.2021 09:36, Juergen Gross wrote:
> Commit 0881ace292b662 ("mm/mremap: use pmd/pud_poplulate to update page
> table entries") introduced a regression when running as Xen PV guest.

The description of that change starts with "pmd/pud_populate is the
right interface to be used to set the respective page table entries."
If this is deemed true, I don't think pmd_populate() should call
paravirt_alloc_pte(): The latter function, as its name says, is
supposed to be called for newly allocated page tables only (aiui).

> Today pmd/pud_poplulate() for Xen PV assumes that the PFN inserted is
> referencing a not yet used page table. In case of move_normal_pmd/pud()
> this is not true, resulting in WARN splats like:

I agree for the PMD part, but is including PUD here really correct?
While I don't know why that is, xen_alloc_ptpage() pins L1 tables
only. Hence a PUD update shouldn't be able to find a pinned L2
table.

Jan

