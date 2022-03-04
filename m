Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3052C4CCF21
	for <lists+stable@lfdr.de>; Fri,  4 Mar 2022 08:35:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238810AbiCDHgn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 4 Mar 2022 02:36:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45476 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238549AbiCDHgm (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 4 Mar 2022 02:36:42 -0500
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (mail-bn1nam07on2081.outbound.protection.outlook.com [40.107.212.81])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 151AFA2F29;
        Thu,  3 Mar 2022 23:35:55 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=b9GZQRVTqmom0onir62HtYSJhlUO9SxoejKeV1aN5trNacowkjw78hCdD9dnErWFiYp+qwbmKNtnHmdYBki5dC8FGJc6jrHQn1PjqEK2QONZtmQ8JOgnGO+/HbLlTGzTnk+8kJYN6lwMkMp5OzLjxJhnaplW3YFSoEfUgAlqBVRNuT41yvUfDNSCgbVrai2D7ZG8lcSdDGacS7uw0LKVoD16572+ygaJW7ZR5x7qY/L0fdFKLm1qS029tCPzrLUDFUA0NhAwtOQar/sdcKwohnRJv43uPytNFnQZ6o1z9xmP7o1fzGJwpmxdbkl3+h0En+xGLls9Je1UhAXMQXaLzg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Jo9em+kGrQaLMjVMuZOCmPtHQaSySg5uC8Ody1xj6CE=;
 b=awDad9N3YcorzCyqFINP/JzC9QFybs2HrbIsmbTo/Pn3j7jnZ1lP7lAVu4u9W7o1j1Ht52qCIjKzkMSJ94oUGZDRHwj2xA8L/cf9B0539FNcpms8+ulpnfYvBP54QejFpQIBSu6qd1fnigTXJBrk2Pr0u537o0pZW3xaVJp0QUBB/6L8+0wuw48kSpNx2XjkQ3GFZFtumK15hImVLRlPU9se04P5biRhycUSNeHoirMdufn34bYYxKmBGSX43imFnbH/lXg+3vCTIdilv/tW3fTqeE0d2s5BomNGzvuRpfdY1Hw7RcQan3hP3VJaXiw/MjeQYE8MIxS/iXwibQDECQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Jo9em+kGrQaLMjVMuZOCmPtHQaSySg5uC8Ody1xj6CE=;
 b=fgPatY5YShnpp1dfmogdeg2p6wnGbZ7+NoY4O/PgYhPxwx2v3O+zmCRheZqXlezhZ7JMMUdATgwkhYjMbE9oT8iLPFMBBoRVx1o49bho5kJ3fx0lA5D1drhqWu2xlzBfWq29gQ0r9DEuM+r2yIr6kZKz1TvFK99SA+q+L5kWrTg=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from BN8PR12MB3587.namprd12.prod.outlook.com (2603:10b6:408:43::13)
 by BYAPR12MB3045.namprd12.prod.outlook.com (2603:10b6:a03:ac::25) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5017.26; Fri, 4 Mar
 2022 07:35:52 +0000
Received: from BN8PR12MB3587.namprd12.prod.outlook.com
 ([fe80::e03f:901a:be6c:b581]) by BN8PR12MB3587.namprd12.prod.outlook.com
 ([fe80::e03f:901a:be6c:b581%6]) with mapi id 15.20.5038.014; Fri, 4 Mar 2022
 07:35:51 +0000
Message-ID: <fff424e7-247c-38d8-4151-8b0503a16a7d@amd.com>
Date:   Fri, 4 Mar 2022 08:35:44 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH] i2c: at91: use dma safe buffers
Content-Language: en-US
To:     Michael Walle <michael@walle.cc>,
        Codrin Ciubotariu <codrin.ciubotariu@microchip.com>,
        Nicolas Ferre <nicolas.ferre@microchip.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Claudiu Beznea <claudiu.beznea@microchip.com>,
        Sumit Semwal <sumit.semwal@linaro.org>
Cc:     linux-i2c@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
        dri-devel@lists.freedesktop.org, linaro-mm-sig@lists.linaro.org,
        stable@vger.kernel.org
References: <20220303161724.3324948-1-michael@walle.cc>
From:   =?UTF-8?Q?Christian_K=c3=b6nig?= <christian.koenig@amd.com>
In-Reply-To: <20220303161724.3324948-1-michael@walle.cc>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: AM6P193CA0130.EURP193.PROD.OUTLOOK.COM
 (2603:10a6:209:85::35) To BN8PR12MB3587.namprd12.prod.outlook.com
 (2603:10b6:408:43::13)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 6da3efe1-05ab-4d7f-5c1f-08d9fdb19b98
X-MS-TrafficTypeDiagnostic: BYAPR12MB3045:EE_
X-Microsoft-Antispam-PRVS: <BYAPR12MB3045F991C189E9DF85FE402D83059@BYAPR12MB3045.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: O+KpSNg+VQuj8fXqfoiknauVU8TsPoL+JUBxFPfRoBX/1GwjyvmYboa6fd7Rx5NVWo/l4R6VfGJ+AtANgFpfxhnh9yHvpBcoLkQGcE9NK+SvTBJEJkvn1CBhlJVwcretT0Elk59HktdRDpsLh9uq2QC1RqDssYYvmiip13IpoRhrb7mmMWCh/lWQLQMiLL52PjueEtCEMdFRp4y/d5UTwejhGvysUg6G1jB3ETitUb1++WuHRdm2IQkGwGgsDdGwPW2Knmi98xsLptZFcgIrdHHgoTPWYU0vXjIY7lDw9lWpk64s3VsE51tgtzr8q4tx4Rin44rrfvRQHs7xv752AdJXoftldDuhnm2ze4MjCNJPVgE4/vidM6oNW+pJMZHEDW+WdfIbhmrNzn08VRuvWTcCv+rEDnv9C4Tn9HztouvDaUoFO9XY/2+Cm2tf2z4bZsIrhBv9rqOkX0jyESbecTTzTdXBpJYzOhcrtF3pzWMfVSZOywkTOS1T2U7dZeazovUUxgQMbjMs+yeFTpzaKTM+GmxRqhe2W5xTELMkIeMEs4NriXikgmHW9MBz5GaT4whHa7MCasXF9Cobb5tv2yclm6BGfByASJ2Se/q6VCDShAIArrQcwyeTVR6SgkTqEf1V17bUI4o1UZfQjj+ci+C3bhC9N0SwyB68EaHol9JLN1eRxWFGLjOZ7XaaBjLuZmmAno9/9QtnTcYiuBva9Riat4NEKxB/e1ld68y8/5M=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN8PR12MB3587.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(6486002)(38100700002)(6666004)(36756003)(6506007)(31686004)(83380400001)(508600001)(110136005)(2906002)(4326008)(86362001)(316002)(6512007)(7416002)(31696002)(5660300002)(26005)(186003)(66476007)(66556008)(8676002)(2616005)(66946007)(8936002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?dGljZGFIa2pxWkVaWnZMcTNIajAxbkNvaEppNmkzZzVKdFBxalBnNHN6czFa?=
 =?utf-8?B?VEVYNUxDakZHL253VWJEdXBOSmxsNmoxNTVzUHdwQzJLSkpyNUV0SkowaU1O?=
 =?utf-8?B?eGFCVjQvMVVrT1ljclA3Z0laOWgzb2hTZnRtZC82bk8zNFZtUjJQanRPNnVt?=
 =?utf-8?B?Kzk5dDBxY20yZks4eHhuU0VSTmJnbTdnRmI3Ti9FeW1naWc4dVdsMHZMTkxi?=
 =?utf-8?B?OGg1U2tQMk1rKzR1Yzh0VWFUNGN2Nk9FNXhwWTZxNFJCcHgzYTN0dzhjMzhk?=
 =?utf-8?B?NVhIWHdJUmYvM1dyRTVITzZqMVJFS2Y3WDRVNG5QYVRvVStlTk5CaEJsdUNU?=
 =?utf-8?B?SFVKMWl3RERYZzFYczN3MFNvNm0zYkV5eHFERnByNEZuQURGNmIwRFRpcmFy?=
 =?utf-8?B?bWd5aFk3VDRqL3pwNzBnVVNvMjBhUUNlbGI4TDl2ekFXdWRoZUF0L2x3VDJy?=
 =?utf-8?B?L2g0N0FUMndsYXJxd3g4YzNGT3I5MXVQbXJab0JldlA1SW1nc005UzVWaDN2?=
 =?utf-8?B?YVozVmdKeGxYRVROVzVUOHIxWmgvWXdqMFFLUGMxY3hvUi9sZXNLbTNxYkE5?=
 =?utf-8?B?L1JuZ0JiTnpXMld0RHdHYUIrR1RUbWNqUEFPU2M5SFd5VTZrbndLNHZsci9K?=
 =?utf-8?B?OVk1VVdEd25UQlltZ0VsQ1FRTFN2QmpGTG10OWlRVlJveGxacnRjbndVVSty?=
 =?utf-8?B?R2l4R3dObE1XZVJNSmpBdExlSmVRR1RNU1JUMUFzSnpmVGZ2T0cvRHZJWFdv?=
 =?utf-8?B?Uk1ZZXZua1NCMHl0Y0MwNEJVWFBoQzNwakhKdkc0T281b3dTNlBESEhDL2RJ?=
 =?utf-8?B?NEt4ZjBEY0p0T3kyOWR3M0Y3Y29OQllsWmtVK3BudWpJaDNWbTAyRjhOZkRP?=
 =?utf-8?B?YVBodlp0TDZnMTg2bjMvdElwOHM2VUZNTEVBRysyenJzREQ5emttcFJMWG1x?=
 =?utf-8?B?aHV0dFdMVHNzUU1XNEhGK3lxekc5Y21vMm9TMXRvMkxOYjVGWDYyNGFyZXFY?=
 =?utf-8?B?SEtQOHVDSW9IcGdOdHN0aHRhL2FuaEdaTHMveExORFhMTGJlbk5JZjJCRjkx?=
 =?utf-8?B?Vjd5Y0w4RERCM0dVRlVtNDJqZ3lxekF4YzdsVjg1Q0x4R1FPeStmRXJNK2ZU?=
 =?utf-8?B?cmRPaDV1Tlh4dXcxNXBWSEtrOHFmVlcwTm1xUlZoS0tYdHpmZUlNMGZoczhv?=
 =?utf-8?B?OHA1bTF1eTF0MU9zNkpMNTgwdk9zcmpZbGFUdEhDazg5Q2pXZkpCOFFLakpi?=
 =?utf-8?B?dndZcTVRVnBpdGJuSjNQcnpLVG5SdTNQY0FzSzVNbitJMUxDak9DeVZhdkFv?=
 =?utf-8?B?SWpoRDU4U1JQNStKdDYzOUZjUnpJc3hibXozUlg1ZENMUWRseERXUzZLMmZt?=
 =?utf-8?B?QS9yL2F1dmVhUDN6NkJIU2VzdFlVMnJhTUdjalVkWVdYdEhLcmhQN1VqSWVm?=
 =?utf-8?B?MHhFZzNLVHRKZWdyem42eDN0Mk93R3FNdm0vaHJKZUtLM3BNN2VOTEVlZ0FN?=
 =?utf-8?B?VHNRbDRBN2F4VDNNZ2lCcFVmME1HbGd4aHNXT3B1eUlIamkwaklqN09oNDQw?=
 =?utf-8?B?bmdkekphRVgwN1JkN0MrUmJ2akpucjZpaCtFbERqOFJqVG1TOGR1aGcvWnFP?=
 =?utf-8?B?NWM2WmJ4bUFrOE5xam5HM3ZLOFpDa1lXaWs3VlF3aHNpQWR0YkxMK1ZrYi9G?=
 =?utf-8?B?UzQrRlovUnVsL2drTW8yc2xQQjl6R1czQ3dUQ1dCQlp1QWtIUlBiVFlqam5Q?=
 =?utf-8?B?ZnFzb01Bb1FHYnlYWjAvNVlQMFVhdFhQNUxRL3JTMFBoR043MldVNnN2WWpQ?=
 =?utf-8?B?MUY2ZG5Md0ZCVXZtOWJaaW90STRoOVRmc1l3Zms2cGdySlFCcHM3dDZGY3pV?=
 =?utf-8?B?S1lpbGpiV2xRcWtXU1dURkhoWWtYVHZadzFFaGlnNHlGUVhvZUVGU0VSRFVW?=
 =?utf-8?B?OS9vTWE2ZUFZb1JqaThZd0NIcXhyeG9hVVZra1VIYmdqVEd3VDFsTzRWWTFv?=
 =?utf-8?B?azk1bTlQU0t0N2lTSWNBVXBlQ1JNTVU4bUdpT29SZC8wRU1wQkxKREp5bVdF?=
 =?utf-8?B?dnZva3Jpd1ZwNUN1ZUpiS1AxZEt1dW9wYlUvTmsxdFVybURJakd0eVg4YzUw?=
 =?utf-8?Q?Pdb8=3D?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6da3efe1-05ab-4d7f-5c1f-08d9fdb19b98
X-MS-Exchange-CrossTenant-AuthSource: BN8PR12MB3587.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Mar 2022 07:35:51.4096
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Pu69Q1u5fSSgNOD/ALrmfaJwvtCXxCGyKdW+yRafzg0rkd0y5+mX2mvEo0y+lyw9
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR12MB3045
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Am 03.03.22 um 17:17 schrieb Michael Walle:
> The supplied buffer might be on the stack and we get the following error
> message:
> [    3.312058] at91_i2c e0070600.i2c: rejecting DMA map of vmalloc memory
>
> Use i2c_{get,put}_dma_safe_msg_buf() to get a DMA-able memory region if
> necessary.
>
> Cc: stable@vger.kernel.org
> Signed-off-by: Michael Walle <michael@walle.cc>
> ---
>
> I'm not sure if or which Fixes: tag I should add to this patch. The issue
> seems to be since a very long time, but nobody seem to have triggered it.
> FWIW, I'm using the sff,sfp driver, which triggers this.
>
>   drivers/i2c/busses/i2c-at91-master.c | 12 ++++++++++++
>   1 file changed, 12 insertions(+)
>
> diff --git a/drivers/i2c/busses/i2c-at91-master.c b/drivers/i2c/busses/i2c-at91-master.c
> index b0eae94909f4..a7a22fedbaba 100644
> --- a/drivers/i2c/busses/i2c-at91-master.c
> +++ b/drivers/i2c/busses/i2c-at91-master.c
> @@ -656,6 +656,7 @@ static int at91_twi_xfer(struct i2c_adapter *adap, struct i2c_msg *msg, int num)
>   	unsigned int_addr_flag = 0;
>   	struct i2c_msg *m_start = msg;
>   	bool is_read;
> +	u8 *dma_buf;

Maybe call your variable differently. DMA-buf is an inter driver buffer 
sharing frame we use for GPU acceleration and V4L.

It doesn't cause any technical issues, but the maintainer regex now 
triggers on that. So you are CCing people not related to this code in 
any way.

Regards,
Christian.

>   
>   	dev_dbg(&adap->dev, "at91_xfer: processing %d messages:\n", num);
>   
> @@ -703,7 +704,18 @@ static int at91_twi_xfer(struct i2c_adapter *adap, struct i2c_msg *msg, int num)
>   	dev->msg = m_start;
>   	dev->recv_len_abort = false;
>   
> +	if (dev->use_dma) {
> +		dma_buf = i2c_get_dma_safe_msg_buf(m_start, 1);
> +		if (!dma_buf) {
> +			ret = -ENOMEM;
> +			goto out;
> +		}
> +		dev->buf = dma_buf;
> +	}
> +
> +
>   	ret = at91_do_twi_transfer(dev);
> +	i2c_put_dma_safe_msg_buf(dma_buf, m_start, !ret);
>   
>   	ret = (ret < 0) ? ret : num;
>   out:

