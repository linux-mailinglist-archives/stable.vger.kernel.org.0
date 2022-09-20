Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 456CB5BED54
	for <lists+stable@lfdr.de>; Tue, 20 Sep 2022 21:08:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230258AbiITTIf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 20 Sep 2022 15:08:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50116 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229896AbiITTIe (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 20 Sep 2022 15:08:34 -0400
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2041.outbound.protection.outlook.com [40.107.236.41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2452261D90;
        Tue, 20 Sep 2022 12:08:33 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Fw11Kr8BQ1c22a8BEPCCcTT6S8sQj548xQ4QmHnC5ubs//6dp8tYGkN65+KYWxufEQg13FYQMYYXN3QiLHGxZtcrRDgXtIJvw7HwqqJDP0WLyWnR9AB907x895qBe+S4bXhTTYTLi3ChJQk4Akm5ymIT5qfA/vOSSivbG85MvImSXzJFqVKWf8VzbDOBrq9blvtzyF1xy2Vu/1GNhpIM402iyLF5gu5uGMql6rJ1LyvoY02fBHVMqRuq0paLB+I3Fs+kGSBuJnLjAUWVtY/oDCCLz3f78fECzYjUJF8bWsRmSZLhqc0cqZIuJxbZ9hwQSR6zpT325jC49HT2y6eVbQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=K4xGWndBJ2dDM73hSw0mxXDL40ANxSMj7J5e9TPhxTg=;
 b=FegZ1HqLh7J133NL1qmTcANHDQkg8CFpTXv7wqKax8719tOv9PN2h7hlkxPHfAxNlm509CQx6WTsMaTmU4PJIateLub7uLLNqEBLoSDKlIYcHpi9lkSbPSld8+3TnhmbHiTzkhCsqZ80lYRmforAPuw+8p7kY7ck3IF3XBGNwn5AYyBiTAjwAauoC8mGsF0wIAbru45uBN0K97IO4TcrBPqRtmYJHqMsu/mD41Z6s+OgS2WoFYeE6/rhGTxL/MZePxMUhTlYcINDzKemtTDbJYhVER5eYznOcE6OgXXTU6+im9MYs1ZKKq+OBx8zi76DRjTCFa7f1C+gCDyLGfyfOA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=talpey.com; dmarc=pass action=none header.from=talpey.com;
 dkim=pass header.d=talpey.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=talpey.com;
Received: from BYAPR01MB4438.prod.exchangelabs.com (2603:10b6:a03:98::12) by
 BL0PR01MB4836.prod.exchangelabs.com (2603:10b6:208:30::29) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5632.18; Tue, 20 Sep 2022 19:08:30 +0000
Received: from BYAPR01MB4438.prod.exchangelabs.com ([fe80::9219:212:e722:6c8])
 by BYAPR01MB4438.prod.exchangelabs.com ([fe80::9219:212:e722:6c8%5]) with
 mapi id 15.20.5632.021; Tue, 20 Sep 2022 19:08:30 +0000
Message-ID: <9a6e70b1-8aa4-ceb3-6cc5-fa768900eb72@talpey.com>
Date:   Tue, 20 Sep 2022 15:08:28 -0400
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.2
Subject: Re: [PATCH] cifs: destage dirty pages before re-reading them for
 cache=none
Content-Language: en-US
To:     Ronnie Sahlberg <lsahlber@redhat.com>,
        linux-cifs <linux-cifs@vger.kernel.org>
Cc:     Steve French <smfrench@gmail.com>, stable@vger.kernel.org,
        Paulo Alcantara <pc@cjr.nz>,
        Enzo Matsumiya <ematsumiya@suse.de>
References: <20220920043202.503191-1-lsahlber@redhat.com>
From:   Tom Talpey <tom@talpey.com>
In-Reply-To: <20220920043202.503191-1-lsahlber@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MN2PR22CA0024.namprd22.prod.outlook.com
 (2603:10b6:208:238::29) To BYAPR01MB4438.prod.exchangelabs.com
 (2603:10b6:a03:98::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BYAPR01MB4438:EE_|BL0PR01MB4836:EE_
X-MS-Office365-Filtering-Correlation-Id: 42754bae-fccf-42f3-7081-08da9b3b8123
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: q1Y3pGuDbxluJCzHjfisSlCEle/lRYtAgvHg+dYzKAf8IV/sPBkAYJAmyyLJZ6YQsbe7PXbEh9Q3F2ZnQH1Sj24FxFrgjQ9tp4siQYMhg+4Otr1GrteUGQpjZ+pCfhAvVtKYuWaWJzSrpBc/bZaGxM8jjvwJYOiOWc2fjVvYPiUvfa0yBePhgzKJpzkQ46li2wPc+XiDa2wSELnRYrp85MQq1TNwFaxHAdRyy2uI5fTuxlPyyJpquDyXZO2p8KoDxQedC9U6Qm6P3O+dYX7oJLyzfD/UPfshWu44TAeHZUEJBDC0XKAZNUV9mwgWBlU8mqYcSmqwweiyvmBs5VdISah4SXSwoXv7ZNY37QN1Hn6ojsrJCKp0Ym+QYCgTBY8fyflx+JElWq07Sd2EfWuFqa1hrs9mvYKpeyUOAKGQtUEuyZrWv+Rxh6/Q9kav0y8ECZzjXgwXCP1YaJnlbLiy0LHFDgSico5My9GFnqZi+bj8YKIAv9XmhvZFdQwQWv48jAVnxf6DyTEnplbrgcJP30RSAbymuSK40TvEzlUFrIzM1a2N7TjRBnEEOA6PBPk/X8NDH5xjE3wdJGB3LsMjx+1gK2x5zeCFccbCrpKFS9VYBNQF24ASaPrtm7BeH69nAUoB7U+TUB1y4eV9sl9xLnDGMvzIhvE+PYSZSLMANsSvIzeufD8RSaWUTf55Z49tZY37mFp5+IqraKbdq21iV5ot5H3ZFD4QZrLsOovuzHdcaz3bYS+jNTxHUdf0J3R+8TSrwwZRhBa72jspIjH0WTrQIkRMbs9dwwII8ZRTQjQkv173CUy6bWKIR7nTEsFm
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR01MB4438.prod.exchangelabs.com;PTR:;CAT:NONE;SFS:(13230022)(346002)(366004)(376002)(39830400003)(396003)(136003)(451199015)(6486002)(478600001)(110136005)(54906003)(316002)(6512007)(5660300002)(41300700001)(8936002)(83380400001)(8676002)(66946007)(66556008)(66476007)(26005)(4326008)(52116002)(86362001)(53546011)(6506007)(36756003)(31686004)(186003)(31696002)(38100700002)(38350700002)(2906002)(2616005)(14143004)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?RUkzQzVoWlFJVW1aeHB6NjhiMkRYek85Y3FPQ0xOWld3STN2ekJsVkw3eERQ?=
 =?utf-8?B?VG0wamV6U1B3Ykx3YXRjajhueVJTOGk5OUtaWExkQ2l2U05tNGpWUFN1VWUw?=
 =?utf-8?B?NGtuUXNnd1FQeUJiM2JYRyt1SjVwRXNlVVJUblBkWFJPa1VBc3hkaTBiSEJm?=
 =?utf-8?B?RWpVQnpMWm10SXMzRk1hU2c3QktncnNaRmg3QzlFQm9TMVpPUG1WR0lTb0hp?=
 =?utf-8?B?N0FVYkhhYlFEbGdtYjY0bDhtdHV6V0Mralg4clZNcnphR2NIY2R6enAwU2Za?=
 =?utf-8?B?TjZha0dkNFB2MnIxeWRuOGJhQjFTY0YrcVU2ZGVnZnZMY0J2T2VKOVRRd3Bm?=
 =?utf-8?B?cFAvczZOUTBvWHlzK0xEUTBZUVRFNVpPNDVoZ2cybmxGQUFsajA1YlZoZlhR?=
 =?utf-8?B?aHdzVXpURmVQb2psdWgra290bVBtalpkZ0xQR1dTN1JhVzBFc3h2bEJMSnJT?=
 =?utf-8?B?R2U3cUlYS1M4Nkl0V0VlVUVHajBXYVgzcm1lNXp6c0tUVWhJZHNQZzhWZG9K?=
 =?utf-8?B?SUFRcTFRcCsvam5iNHprc2QvSDdRbTJqK2prV0FqUWRaM3kzRUprWHRQbDRw?=
 =?utf-8?B?NG9LeDdyL1lHOHFwYUFoc2lUeXVITGRaMTI5bDNwcEJybUhoUTVHakxYS0pW?=
 =?utf-8?B?MStIRUJCNkRKTjIzc3VIM1R0b3pCdFdNY2ZZczZYQ2ZPK3FRblo2M1NhU2x0?=
 =?utf-8?B?Vlp3VlVSbzZyVnE2R2x3QklvSExvdnBzcStvYWNWT0N4SFpES05DR21BRFZU?=
 =?utf-8?B?VWdZdjBDemhOWWEvaDNZMjlIRENtU3Z5cTFwOXg0NndNcUhOV3dmUFNvM3Q5?=
 =?utf-8?B?aUlxU1dkLy8zK3FGOUs3eDBZdHVPWklOZlN1MXVNRWV3M3FpbWN6VytjODlD?=
 =?utf-8?B?b3BqMVdVTG5GOEsvS3BtalVvTkhGZERMNy9PdmhnWG1FTVVIZ1dTRjRVb1hE?=
 =?utf-8?B?NU5objBCNkxzUnByQkFwd3NhY2w4bnhkOEJSeVNwRSs5NmJiYWk4SkkxNC95?=
 =?utf-8?B?emt6M3lhZ01DL1FkQVdrWVRObG1ydWVCNjd3ZDcyNStvZFRNUGMrS0Z1Rzht?=
 =?utf-8?B?cFFYSCthRmRTbExmRWErYTBKN29TMEpVK0thazUvTTk1LytlY3F1d0JhZ3o3?=
 =?utf-8?B?KytFeTUvcHNndDg3VmdkcEJ4M0U5d2NxRVpiZm1RNXhrdHhPN1BKZ1FleXBn?=
 =?utf-8?B?Q2R0TlAwYnVoUEZQeWRSL2t4QTVLOFhqeDQ5WVpOaWdGcHVwckdRMVJZQlA0?=
 =?utf-8?B?NkpGT0tMUHhIcGMvdWFBMlppS0hiRkJZVDdYK1hRbE9ES254RnJ6aUl1ZTg5?=
 =?utf-8?B?cnlsbHAvaUVMZmJuU0diWVVLME13T1V2ejBJeDl5aVpqL0tuM0FlRzVCcUdN?=
 =?utf-8?B?ZS9qQ1NaUjhnNG9WcEZYTnExYnlyMW5Tc3BwQ1dOL0h0V1dNR1V0Z0lqQTdK?=
 =?utf-8?B?NzBRT3FaMHhZVld2ZjFwN3VWdTc2VWQ4WjA1QWVwR0g5ZkIyZUVWVnE0dW1U?=
 =?utf-8?B?QUVIMlhTbGtZOG5McE1QM3d2QjhSYVdOV09SalpMVmZ3cVNtdm9vRlNUSDJ4?=
 =?utf-8?B?U1h2QTNsVE44eWlaQ0Nwak14VFp3c1hsaGVFWnFwRTluc0J3ZGRsU204RDNT?=
 =?utf-8?B?RWJnZnl6VEVlOGVVdFZVUlVuSUlLeUlvNVhEeUxEdDNHek5wSnpEVHRIOWdx?=
 =?utf-8?B?VWtMQUhZU0x1cE5OUVlCRGhyblE5WHhqUExacWQ4bEl1L1ZnYlUwOFpTbG5U?=
 =?utf-8?B?bS94TWdpdnhvSk4wU2l6bGxrcjg1dmVNL2FITXNKQm9aRnZNamxWMzNRZmM5?=
 =?utf-8?B?R0J5amphM282R05vaEFvTFBtbVlrS1JkL3p0WVpXbTBvMGtEeGVVYXBHamZE?=
 =?utf-8?B?c3V5ZTk4RzJ3VkZ4ajRLMTZ3WnJFL0ZuY3ExTmhkcWtlNmZseHl0WVpTZloy?=
 =?utf-8?B?aWxnT0QwSGRCQjBGR0hIRVM2V0xJYyttcFpDOFhEMjFQSnFIQ3BKdlllbzRp?=
 =?utf-8?B?WDJXTUN5MEJ1K0Uzamwvb094dm80QWpsdkNUVFJQQmtPUzFUd2ZzZWNBOHlU?=
 =?utf-8?B?ZG5TTHoxSWRtS2x4aFlUWlhSM1MydUR2ZDVWd2ZrOHhCODRZUW1YMm15Zm9B?=
 =?utf-8?Q?9a8GlsIuEutCoX2BP05eQRrd6?=
X-OriginatorOrg: talpey.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 42754bae-fccf-42f3-7081-08da9b3b8123
X-MS-Exchange-CrossTenant-AuthSource: BYAPR01MB4438.prod.exchangelabs.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Sep 2022 19:08:30.0180
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 2b2dcae7-2555-4add-bc80-48756da031d5
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: aMwfcv5iTlu9feBYJuIIsXrFlh0BubWHWqvczNMlkPL70nnUC1Sk/CGaMzLLNF0l
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR01MB4836
X-Spam-Status: No, score=-4.1 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 9/20/2022 12:32 AM, Ronnie Sahlberg wrote:
> This is the opposite case of kernel bugzilla 216301.
> If we mmap a file using cache=none and then proceed to update the mmapped
> area these updates are not reflected in a later pread() of that part of the
> file.
> To fix this we must first destage any dirty pages in the range before
> we allow the pread() to proceed.
> 
> Cc: stable@vger.kernel.org
> Reviewed-by: Paulo Alcantara (SUSE) <pc@cjr.nz>
> Reviewed-by: Enzo Matsumiya <ematsumiya@suse.de>
> Signed-off-by: Ronnie Sahlberg <lsahlber@redhat.com>
> ---
>   fs/cifs/file.c | 9 +++++++++
>   1 file changed, 9 insertions(+)
> 
> diff --git a/fs/cifs/file.c b/fs/cifs/file.c
> index 6f38b134a346..7d756721e1a6 100644
> --- a/fs/cifs/file.c
> +++ b/fs/cifs/file.c
> @@ -4271,6 +4271,15 @@ static ssize_t __cifs_readv(
>   		len = ctx->len;
>   	}
>   
> +	if (direct) {
> +		rc = filemap_write_and_wait_range(file->f_inode->i_mapping,
> +						  offset, offset + len - 1);

It's only a nit, but with the new EAGAIN return code below, it's no
longer necessary to capture "rc" here.

> +		if (rc) {
> +			kref_put(&ctx->refcount, cifs_aio_ctx_release);
> +			return -EAGAIN;
> +		}
> +	}
> +
>   	/* grab a lock here due to read response handlers can access ctx */
>   	mutex_lock(&ctx->aio_mutex);
>   
