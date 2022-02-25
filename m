Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5180D4C3C2F
	for <lists+stable@lfdr.de>; Fri, 25 Feb 2022 04:11:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235777AbiBYDMB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 24 Feb 2022 22:12:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35206 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230117AbiBYDMA (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 24 Feb 2022 22:12:00 -0500
Received: from APC01-PSA-obe.outbound.protection.outlook.com (mail-psaapc01on2086.outbound.protection.outlook.com [40.107.255.86])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 558C01BE81
        for <stable@vger.kernel.org>; Thu, 24 Feb 2022 19:11:29 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jM1pRrF4FXDpAlv4AACrs93JQp6u3bd0U34Zy1YTH1uCpHO1jPe9K8RJ82+/Lg0N25e5VCrOsRBlv6ZaVqtjhEQ3bHxnrN3GiKOZrI2BPia2e7ls69VGbllIRa13j18PPooAs3TRCCeeHCPCT79Al2NPujw8PsUXUoEq2U0fgbVPkeChLC0fcG+S6S8JLK20vpZe6qnRXM33S3EBiYWxTz37nSrtwXZcscjZzgqbHqjUzCR5LrWCuWkD8fpj771m4HjHVhyHnd9zNYSCCcqlBL6dJgQsS5K+Le3E+xh/t14Mgpw82HQwW0+aPhrBTvNfd2gUhw0oa++sHFipsdgQlQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Lr3Gle7A55jENViCYigy6sCx14PdZhJgfC6nlQdXkN8=;
 b=Ihj5a62ehZDSNYe3OB1yJhzCt3/2PcpM80P6EhV7dUKVoXg4mi4963wkKML/yDq54bv55PH+AIqEtIGtjjs1/cuRPbv2G4rRfJ5aEpxrvKRxE3pFP/jEVRnrNJepyq6+zreK83tnV2I0xB+QgSrFCj05AjqUUMe2RgViPHRptrUVnD4eHl/EydTqgrCuaFvXkFWnCoj8stdoTqbFiCqM6vD0Y5v7JAj4/QL/C9jGrZien73SKI75/2pecA59lj1OpT9u3vlJQmbtvDdR6dx2golfg+oy7sItw9jCugN3XTn3itmDVTgmAFp9kHY/BZHvGJu6fsXcNf2+u7JeMXf26A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oppo.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Lr3Gle7A55jENViCYigy6sCx14PdZhJgfC6nlQdXkN8=;
 b=q4sOlF43DCZefz3El3EielpSvWAG+5WL5pgl8P0Jruux+bATBCdNkq0Ur04LMxM9Wr3zcMsIGnH9Ld/ZQtQxIdsl8N91NN7SSjBpSg0pCgKW3bpMsJ5tuIdg73KV78EngSFBMcAbHl7wQRXLj6WqRD3u9MQu/QvpNhnveimMZ9A=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=oppo.com;
Received: from TY2PR02MB3165.apcprd02.prod.outlook.com (2603:1096:404:4f::13)
 by HK0PR02MB2897.apcprd02.prod.outlook.com (2603:1096:203:37::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4951.19; Fri, 25 Feb
 2022 03:11:24 +0000
Received: from TY2PR02MB3165.apcprd02.prod.outlook.com
 ([fe80::cc04:c674:b67b:baac]) by TY2PR02MB3165.apcprd02.prod.outlook.com
 ([fe80::cc04:c674:b67b:baac%6]) with mapi id 15.20.5017.024; Fri, 25 Feb 2022
 03:11:24 +0000
Message-ID: <51d259d5-468d-4a5e-b654-50d0f02d6c30@oppo.com>
Date:   Fri, 25 Feb 2022 11:11:20 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.6.0
Subject: Re: [f2fs-dev] [PATCH] f2fs: quota: fix loop condition at
 f2fs_quota_sync()
Content-Language: en-US
To:     Juhyung Park <qkrwngud825@gmail.com>,
        linux-f2fs-devel@lists.sourceforge.net
Cc:     stable@vger.kernel.org
References: <20220215082721.844244-1-qkrwngud825@gmail.com>
From:   Chao Yu <chao.yu@oppo.com>
In-Reply-To: <20220215082721.844244-1-qkrwngud825@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: HKAPR04CA0009.apcprd04.prod.outlook.com
 (2603:1096:203:d0::19) To TY2PR02MB3165.apcprd02.prod.outlook.com
 (2603:1096:404:4f::13)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 6c1828b7-64e8-4b57-8794-08d9f80c811a
X-MS-TrafficTypeDiagnostic: HK0PR02MB2897:EE_
X-Microsoft-Antispam-PRVS: <HK0PR02MB289726DA9FDCFA82C4BAB4CE923E9@HK0PR02MB2897.apcprd02.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Nae8qNvv/PuV9COdKe9wkKpefmqMV01jratL3eqnPzh2h3nTQ0odE3pS5hWsghmgO7r/PZcMeYOeaf+3CYsn1ho0cw0Zr/sPRvq1Ph5qIMZFquhPDvEg7blryHfHPuWSmDU8QsQfEGFZFn0X+nVnxkNalC+ioVy85EhVrWoeCWedtkchWx7eVVLIKu5zkoodLH2M8TCjqVAia/lZRlZpPyfw10avj7V6FbIACPXacHfHvr6NcXdlBufNWCjrsq6KihOLl5Nyk/ZhXZ3ux+/1Liw6JqFJiRX1FlVd4frOWVGeKgqmmvi+oeondbAi/rvpHKa5rc/ZZLPyJDM1H7Z9Pt24e7fn4WOhlQdk4KuZ93fsA4Pw1v+lv8pfFeU9WSdbRXEJ4DdR0uwshBHGYKhcW0wlNYrg+80x45JuOm5W3Ry6aqgF2pRhAgkncPTcDgfKO+tOu0mf7s1IsIov5MAQeq3mmLAUgPzpsQgOyExMvbRALkB7/cWgMrYFUr+XP5d7VWW4tyaZUlUUTJzcB9Mhj4rsOwPh0ruOXBc7hzfNDcTwKVqmYWtmhy6wlO1zKo0qAS0ysDw7IlIqHgcxGyKLunujtI1sUNOKSBB164IhrhQwc6BikKkh4ok+eScKQnLn1gBU/L0j3FbtrFlKRbvMzLLD/tQHAZrof4DpvmtJzSgbdxfGRNpiNFgIPXRen3KqgGcNvFCFQg4KgNl7dqlMTgtqjYBt/9RqHw4ovZB0OV/5QJPCUe7GOduC/WPcGQYarcmwx9xbdu/h698bKQz4yw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:TY2PR02MB3165.apcprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(31686004)(8936002)(316002)(186003)(66476007)(6486002)(53546011)(83380400001)(6666004)(52116002)(5660300002)(26005)(2616005)(31696002)(36756003)(508600001)(66556008)(15650500001)(66946007)(6506007)(38350700002)(44832011)(8676002)(2906002)(86362001)(6512007)(38100700002)(4326008)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?ekJvRENhaTU5d3RrNHhrN043ZUV0ZDE5eVJqbTNQZGl1dkpUODJBN2RGOEJU?=
 =?utf-8?B?TjQrWFpidU93eGR1Ry9QeUpMRUFEWkxUd1FKZ2xwajRMTkxjSDhwQlZuYjJT?=
 =?utf-8?B?VEs2Wk5NQjk0aldqMzJtek9tZ05sUEdRKzhqNEprTlNTazFFRGtkNUVXV1Vk?=
 =?utf-8?B?SEQ2TjNCSlpKc05WRGxoRE5WTjF1anFxOUJBKzV2NnhDMzNXUFQzaGR0L3Nj?=
 =?utf-8?B?bnhMaGZGVW5lVzJ6blU4QkJXbU1uSStpRzJ1VWZmSVBlb0gyR21FdWx6WVd2?=
 =?utf-8?B?RDRUbVB4RHE4bnhhRWUvMmN0YmhHUm5OQmRPeGlBUWxjZk1yTy9CTHZKa3FD?=
 =?utf-8?B?YkZqVDY2ZVl5N2JWMlJES3k4a0JiQ0RZRXE0U1o1YkJqRnY2Z04vUDBDZllO?=
 =?utf-8?B?RDlSbFdaTFNxMGRCZlZTOTJoTkhHZjM4cTF1TjZyZXN1ZGwwSWEvbmk3YTNG?=
 =?utf-8?B?VnZFQVA0VUlwOStxWndlbU9haTBFcGxtYTZSc3JxZHh5dWpBM0FnRWlVNDFZ?=
 =?utf-8?B?Mm1LaVZobSs1S2V5cW1ZQjFDWTFBVTJ5VVh5MEE5RUdHZVJEaktUVFRGaWo3?=
 =?utf-8?B?dWZRM3RkenpJV3hmbnY5Q0k3NTgrY1g4SnIyalNNZzZiQit2N0JVZkl5Z3A4?=
 =?utf-8?B?SWtOZnpleXFGa0lVbWJKUlN4dDZqWlhNU3QrS2J0TnB3Y04wdW8yNDRDTjB5?=
 =?utf-8?B?bGwzQ2dtVHh3TFFod25kU093emVEU0tGVHZLbUJFQm9FRVZEWnlFYzN1RmRV?=
 =?utf-8?B?NitmU2wxQVlmMWRyVGhWQS93STdiSGVYRk9kaG13MWMyNmd2YTRpRHVCYXhT?=
 =?utf-8?B?YXFuOFNwSW1yd3dudmIzR0dreWd5N3BVejNBaGsrRzRlZ01EYlFoL3A5b0JH?=
 =?utf-8?B?U0s4eVJDUmFXQW1wK0hVcnJRQnp0NUY3Nkc2ajh4cng5Y1l3K3VjR2I0RWNI?=
 =?utf-8?B?MWZ1Y2F6S3c4MjNwYUZqZlBvamtiZlcyWlRrOXI2V1pUVTRoTlIwZG9Sa0JV?=
 =?utf-8?B?Wmg0TmFtVm15NTd0UUl4WnFndEtZb3dvbjQxQTBxUFdnVUh3REVqY3kxalVF?=
 =?utf-8?B?bDBsN0E5MjN3NHY0cUZDSC84SXlZcCttck94TC8xb0wyZHNST0Y4Z1NxaFdU?=
 =?utf-8?B?UWR3WTZPRGZ2T3VuVVFaL082N3lSQm50cmlCTkxGTWsxZnpiUkdLVCtWcXlY?=
 =?utf-8?B?OHhaMkpXK0NKdmgxOXhjRUNkeC82ZENlRllBZVFteUVRK1NtUVBtU01HdWg2?=
 =?utf-8?B?dHVTYkY0K05OTGM0QWdCT2xkQzFRZys1TUJRMmY2aW9ra0dLTDBHNjVnQnV4?=
 =?utf-8?B?VWgzcXozQmUwaCtzZkpsUVBkRkV1KzJrVGFnanpkdGxPa3d2aTBRUTJuT2hv?=
 =?utf-8?B?TFFFMXdIY0lteUN5bXd3NFc4YzYwazlYRHFEZHQ1MlhNVUR1bEM3MkovQ29D?=
 =?utf-8?B?NlczTnRqVzZ1Z3FhTndqOWMvdmtWdUNBS1Q2N0wvdG9NM1lXU29EQkkrTC9O?=
 =?utf-8?B?Y21YLy9oK1RHOGR5MjY5aTlUL0krb1JWeHZ5QXBQVHo4MS9kRVA0Y3VQa1BH?=
 =?utf-8?B?djNUeDEwb2g4NXpGbGd2U0RiaGMrZmFobXJ0cDNkcTdUMm1tZU9VVWZCd1Z6?=
 =?utf-8?B?bUpQc3NHdVNrVjROMjZwb3VjMFU2ZGpWSzNFb0VhMmlRWU4ySXNESHlJeW15?=
 =?utf-8?B?TCtaVWpFWEJsRFB5YUlNdmE0UHRaZHJsbURkaVU3WE5FeVZtNnA2Qlp4N2R5?=
 =?utf-8?B?S2lBVllCdGtLR0hQeWR4TUVXT1ZrYWtMdnAxK1JqR3ZzbFM1aXlESUYvTGhS?=
 =?utf-8?B?b0gzSStLTlo5eUdORHBHbjJIWHBsZlcyZXZpb21oYjNmbEFXelV1eXlvU0RR?=
 =?utf-8?B?elVJQm5XUUVtU3UyeFBjQnI2ZjZMYnVKb3lUY2QraHpaVXgvbVZrLzlZbWtI?=
 =?utf-8?B?UThTNzdDQkhqbnBINTI5Z3dqWFJhS2dYbnlHbjlTUGI2cUNKRlpyRUc5aGkw?=
 =?utf-8?B?T2pZaWl3eTdia2lkUGRrVWkvTlI2YkNRZWtoRk96WXBNLzJZSHI3M3FCcWtz?=
 =?utf-8?B?cUxaWE9WS3piWlh2MnhEd1k2NFlLbWp2UnhrZ0pieEFRVWNGZVpSU0h4YW1V?=
 =?utf-8?B?MU1lVk1Xd1FzYml0bHhYQmk0WU83UFVlWlZ4MTBPVTNOem9zSVFwQVpCMjhi?=
 =?utf-8?Q?JjY/rXSsr41n/uYZVdPB4bA=3D?=
X-OriginatorOrg: oppo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6c1828b7-64e8-4b57-8794-08d9f80c811a
X-MS-Exchange-CrossTenant-AuthSource: TY2PR02MB3165.apcprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Feb 2022 03:11:24.2837
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f1905eb1-c353-41c5-9516-62b4a54b5ee6
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: E93WD/XD+/c7Sr0sJmHNmywCKfU5EGAtAMOgSmTwT+Sb8boQjj31Tjbx3cb72PSE/8lIEMESnBEJebUZ4M4IoA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: HK0PR02MB2897
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 2022/2/15 16:27, Juhyung Park wrote:
> cnt should be passed to sb_has_quota_active() instead of type to check
> active quota properly.
> 
> Moreover, when the type is -1, the compiler with enough inline knowledge
> can discard sb_has_quota_active() check altogether, causing a NULL pointer
> dereference at the following inode_lock(dqopt->files[cnt]):
> 
> [    2.796010] Unable to handle kernel NULL pointer dereference at virtual address 00000000000000a0
> [    2.796024] Mem abort info:
> [    2.796025]   ESR = 0x96000005
> [    2.796028]   EC = 0x25: DABT (current EL), IL = 32 bits
> [    2.796029]   SET = 0, FnV = 0
> [    2.796031]   EA = 0, S1PTW = 0
> [    2.796032] Data abort info:
> [    2.796034]   ISV = 0, ISS = 0x00000005
> [    2.796035]   CM = 0, WnR = 0
> [    2.796046] user pgtable: 4k pages, 39-bit VAs, pgdp=00000003370d1000
> [    2.796048] [00000000000000a0] pgd=0000000000000000, pud=0000000000000000
> [    2.796051] Internal error: Oops: 96000005 [#1] PREEMPT SMP
> [    2.796056] CPU: 7 PID: 640 Comm: f2fs_ckpt-259:7 Tainted: G S                5.4.179-arter97-r8-64666-g2f16e087f9d8 #1
> [    2.796057] Hardware name: Qualcomm Technologies, Inc. Lahaina MTP lemonadep (DT)
> [    2.796059] pstate: 80c00005 (Nzcv daif +PAN +UAO)
> [    2.796065] pc : down_write+0x28/0x70
> [    2.796070] lr : f2fs_quota_sync+0x100/0x294
> [    2.796071] sp : ffffffa3f48ffc30
> [    2.796073] x29: ffffffa3f48ffc30 x28: 0000000000000000
> [    2.796075] x27: ffffffa3f6d718b8 x26: ffffffa415fe9d80
> [    2.796077] x25: ffffffa3f7290048 x24: 0000000000000001
> [    2.796078] x23: 0000000000000000 x22: ffffffa3f7290000
> [    2.796080] x21: ffffffa3f72904a0 x20: ffffffa3f7290110
> [    2.796081] x19: ffffffa3f77a9800 x18: ffffffc020aae038
> [    2.796083] x17: ffffffa40e38e040 x16: ffffffa40e38e6d0
> [    2.796085] x15: ffffffa40e38e6cc x14: ffffffa40e38e6d0
> [    2.796086] x13: 00000000000004f6 x12: 00162c44ff493000
> [    2.796088] x11: 0000000000000400 x10: ffffffa40e38c948
> [    2.796090] x9 : 0000000000000000 x8 : 00000000000000a0
> [    2.796091] x7 : 0000000000000000 x6 : 0000d1060f00002a
> [    2.796093] x5 : ffffffa3f48ff718 x4 : 000000000000000d
> [    2.796094] x3 : 00000000060c0000 x2 : 0000000000000001
> [    2.796096] x1 : 0000000000000000 x0 : 00000000000000a0
> [    2.796098] Call trace:
> [    2.796100]  down_write+0x28/0x70
> [    2.796102]  f2fs_quota_sync+0x100/0x294
> [    2.796104]  block_operations+0x120/0x204
> [    2.796106]  f2fs_write_checkpoint+0x11c/0x520
> [    2.796107]  __checkpoint_and_complete_reqs+0x7c/0xd34
> [    2.796109]  issue_checkpoint_thread+0x6c/0xb8
> [    2.796112]  kthread+0x138/0x414
> [    2.796114]  ret_from_fork+0x10/0x18
> [    2.796117] Code: aa0803e0 aa1f03e1 52800022 aa0103e9 (c8e97d02)
> [    2.796120] ---[ end trace 96e942e8eb6a0b53 ]---
> [    2.800116] Kernel panic - not syncing: Fatal exception
> [    2.800120] SMP: stopping secondary CPUs
> 
> Fixes: 9de71ede81e6 ("f2fs: quota: fix potential deadlock")
> Cc: <stable@vger.kernel.org> # v5.15+
> Signed-off-by: Juhyung Park <qkrwngud825@gmail.com>

Reviewed-by: Chao Yu <chao@kernel.org>

Thanks,
