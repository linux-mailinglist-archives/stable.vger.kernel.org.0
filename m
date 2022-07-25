Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7D2E35803AF
	for <lists+stable@lfdr.de>; Mon, 25 Jul 2022 19:55:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235791AbiGYRzH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 25 Jul 2022 13:55:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52972 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229806AbiGYRzG (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 25 Jul 2022 13:55:06 -0400
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2077.outbound.protection.outlook.com [40.107.92.77])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 38FD21EC72
        for <stable@vger.kernel.org>; Mon, 25 Jul 2022 10:55:05 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YhbcqVh4p8i/wPK42H1ZUX45v6SIb0VouJuBqkQf60wTM6Ah7geIo0R93HcznhwmYdikSIpHNq4c6m9nQyHyJ3jiudsEoRiJEVtVDeB27qTx6uGNbI7QYt9brU59ztyfBX5w9m9h171vMG5bup9hMJWPqZuKimmZNNRMDTnNtxoiMNvbXD+NjGL3VizXppK5DXGoIaGFeLtMmeOGyVeSVw57BJALcXvS+A6kfSe/UNnNamMalJc+BpO4uRwvCCF7sDLByDSK6O4ALc7lC7yDd56zMj6qghXt5BazPjqXUOpJ/8a+m5L1XZMW0DUcTJKiX2A9J2w8YMyc8lIFGHsABQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6yRr01USZafpUn2b0N8qi+DUW2HdbUQRltlE2E6XW5w=;
 b=mj61/h30xcNaQfXnuZv/NZSz8vgXPnA1KHUt3/WWWEVFzjT7fZ+6wlhIF2QUxxt5SGfJpEWlRrMPlbiMLx9jW/bw5rd0t9ydzVNdmTpqcucCieligZNHfSjZVDY907P4zxHtpE8ZixMVk0PvBVt5V2l2pPbAeQ4KmNfeeh0pvbGz5vg6Bt7TWWeArRgBmJOLxi2HALzOvw9HQG7Xu5rn294FcwxxYq05+UsJwKd7xqF9ic8IZSIYDK2Pz3Bu1kipMVF6WcZ8x//08XzG2tHgxKaPcezHCPbNlbfnhiVjr9rPx5uBdMzBjiyJpf9Fz3TUT4ZPHJQmYgcYbr1Vbvstww==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6yRr01USZafpUn2b0N8qi+DUW2HdbUQRltlE2E6XW5w=;
 b=Rhu8YRDyn155Vcl2wsOqTZZw9SM3Uun/tZcdWHyVfhz5mRjcA/VKmPoGUcOUrfVA3YH8frz/dGWrMIzuYr0dD7mYHuUBe5kEyNdXwF9ey+n6Vu319nSzMq9lOIEsaaXxU40r1WLUyzg6dtqOT/FHlnWL7pRGJ3yeeoxKA50GgKmx8zd3pg35UpPVrQHWAHI70QmJpwdM9MtsPcn0ILznIkT0Js0X2QTSJ8M87/Ad0P34hWQbZwUb5azQmUZAkYQhVw0LIZzvhtr/zxJb6vNUyL1kxf6bz8fo8T7v7PD9XCO4AYPBxtbvUwld4KGjERY8TDgZLQhSEEZBbJE9h1orQg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN0PR12MB6150.namprd12.prod.outlook.com (2603:10b6:208:3c6::11)
 by BY5PR12MB4084.namprd12.prod.outlook.com (2603:10b6:a03:205::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5458.18; Mon, 25 Jul
 2022 17:55:02 +0000
Received: from MN0PR12MB6150.namprd12.prod.outlook.com
 ([fe80::30b4:54b4:c046:2e14]) by MN0PR12MB6150.namprd12.prod.outlook.com
 ([fe80::30b4:54b4:c046:2e14%3]) with mapi id 15.20.5458.024; Mon, 25 Jul 2022
 17:55:02 +0000
Message-ID: <bbb7b3e1-cf67-111b-078c-c388379b20cd@nvidia.com>
Date:   Mon, 25 Jul 2022 10:54:59 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH] mm/hmm: fault non-owner device private entries
Content-Language: en-US
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     linux-mm@kvack.org, Felix Kuehling <felix.kuehling@amd.com>,
        Philip Yang <Philip.Yang@amd.com>,
        Alistair Popple <apopple@nvidia.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        stable@vger.kernel.org
References: <20220722225632.4101276-1-rcampbell@nvidia.com>
 <20220723133214.GA78800@nvidia.com>
From:   Ralph Campbell <rcampbell@nvidia.com>
In-Reply-To: <20220723133214.GA78800@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BY3PR03CA0011.namprd03.prod.outlook.com
 (2603:10b6:a03:39a::16) To MN0PR12MB6150.namprd12.prod.outlook.com
 (2603:10b6:208:3c6::11)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 14dc6503-cd31-4ad1-d478-08da6e66cca5
X-MS-TrafficTypeDiagnostic: BY5PR12MB4084:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: oeyNcPz/US34RZTA7MpFkDVx9QOP9SO68SvSUMnbQmppFtpKlADEHjyfLvreM8DPIcPQuiP1InKEYU/gOR3y94L1jpdnZHOzDdv/x29tK4G3zQO/pGAip5UZegXLauYho6BCyehbvlWHCzxSs0kN4qxpsMyJjHq9OJPZ/Xc9x+amjIk2oLKnPtPPbJaoBV6BzCoiD39CT2nKvAF71MS8vg3rbS7RkaoOPSnsaBWA3bO0uZrxyCufSCFT1qTLlo1Kj/bGaKRIjmbmQw3OBWsygVbCnXN10zvPdeYtnjSmdPqLTFRSn1EHQ04gNqEGm1Ag7UApv5y8zV5xR9xxuuR3GQwFLXebltV7EDieHBjAPcwWhr+oA06AsrKHbFpjZDJIohHWo0IgL+n0YjA/OED5yJCK/PcHgSdjEKLcnQ6RnXhfXJNQLnZyPvPBBdk4HRYpy2i+qH9VWVyKDzJE4YG6viTsnjqVQnsv4syxghZmhA2pm2qCX5/hOActlNda74uNRHyr8VBDOy97Uv4mG4ExEMF6SRfasQGiEO5X5IbRWoxkfZ+ANRpNyA/qFGx0LQ4+rioMH20ToW2Xy8qftg8eJe/vmlnLT6I7koB1tx8ucpT+7zlWHm/AGmLipHMoYK9l1KYp+VwLSz9VndT0BtJWroo5Msw7HinsdEcvsav298fy5UnP2qbQ9y1J36lnMRYR+XNoZjvlFWtyTM+6AVGZOFVyAmEwKVesP9xlsKcJaxNdvwzXfNFLQwDVG2EcpvvWe5JzR17zz4r0yVBekp0sZtXBkwMvlypKzqeLWiIF/ueabt2G7tyVPXh/w/OerBbA
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR12MB6150.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(39860400002)(376002)(136003)(396003)(346002)(366004)(6636002)(31696002)(38100700002)(86362001)(478600001)(4744005)(6486002)(6862004)(8936002)(5660300002)(316002)(41300700001)(53546011)(66476007)(66556008)(66946007)(186003)(8676002)(4326008)(6666004)(2616005)(6512007)(6506007)(2906002)(54906003)(31686004)(37006003)(36756003)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?ZnEvMG90Y3pJMWFQUVUrUTc5eHo2U1Y5ZlJMUVZXZzFYTXRqRWxReW5MYWNL?=
 =?utf-8?B?U3JzTFFJTTdVa05GditJVTQ5RlUxMGFKUFIyUHhBK29FVlpNbm0xS3EvbzZY?=
 =?utf-8?B?MTdMZDliem9rUElXbG1aY2VhSFlzNmt2QjFxSXBEdk5veWZBMEZNK0prbkFB?=
 =?utf-8?B?SXh5SXEvMzl4T0xWZVl4djlzK0VMcnZteWNLdGIxaElyamJnVzBPWDVUaGp4?=
 =?utf-8?B?K3VyVDVPcVV0Z1dNcjFzamJ1ZW5zNFVzWXhRZ2hObGRKdFg4Y21HdzFnNzNr?=
 =?utf-8?B?MWJtUVV0QXdmU203TDM1NUNKMUgvSFp0U3d0bDBmQ2JKc3lvT2dCQm9rdFU5?=
 =?utf-8?B?MWZhWnY5SG40a0IwMWljYmtGT0l0bVgvOW9xWUEvTGhxaFQ5RGorS2M4WFVm?=
 =?utf-8?B?c2F5MDZhYVI1NXpIaC9FYUhjcjUrKzVXazJmNGsra2ZNNTg4cWoyTkRvaW9D?=
 =?utf-8?B?RUtpWkR2SzdUSW9IWllvNzNJSjlvaGMvWTMwb1JteEgxRFUrTzluVk43R3I0?=
 =?utf-8?B?dDN0aWdKV1Zwc0hBei82dGpBU29ReWlCNHMxeEU2QWlzNGc5d1JNem9IRzFi?=
 =?utf-8?B?ZHFGbi9JTHBXbVdSSE1ENS9pdEg5R1RYZHlUMVJVOXdOd1AyejJaVFpkejZj?=
 =?utf-8?B?OWZIbmhMMmhwTjZ3b2FGTGNLU0JUSE1HcUtINkpsL1oxYk5uUDJKL0lDc2VN?=
 =?utf-8?B?NHZKWmVjdXN6ZnptWGJaMXZEQTRTZ3U3ellGWGQvdFRzQ1ExUU9IQ0xSci9t?=
 =?utf-8?B?NGtLSVcyaGV3SzFKSzhFdUVQRUkrRkh5TTRVaVB6dDdNOUJyRk9uRXNNalc1?=
 =?utf-8?B?d1EvS2Y5QWFGQWNVSzhHcUFOcDNTTllpWnlmczBVK010ZVpDUlBGV3RYa1FD?=
 =?utf-8?B?YWJEZU9ERTRGaU9sZUdJTzdBTm9GK0V0cTZtUEhiQ1dNeTAwQUJYelNYalpK?=
 =?utf-8?B?WHE0L1FnUk1aWlhOcDBMOW1DRWNpV1o3SCsrVDdTK1hvR29PbFJ1a1pjWksz?=
 =?utf-8?B?VDhLVndGUGpPTDNuUldlVVEvRDA4WUV4clBaNWloQlZjekU5QUN4U1N6MURB?=
 =?utf-8?B?S0xVWU5LeFNLWFFPNEM1MEY3aGlYWmRtbEU2bFdNSFMrNlgzMWt3T0FUZmNn?=
 =?utf-8?B?MjNlR241aVRrYjVyamF1b0lLMmdETUo4cVFwSmhWTWcrRlhtb1VjQjZkWURo?=
 =?utf-8?B?dVBKa3RmWmlWV2JwRGRNVldoa3lXd04wWVdNNVNUVUszQ2hyMGUxWW5Lalg4?=
 =?utf-8?B?dUM1VXpZWmxPalpXZlp2NS9UajFtdHpNV28rMGdxdUtiL0Y3enBZVmVMQU1j?=
 =?utf-8?B?SFVVaW1oelhydnJRVzNrcmJ5N0VxS0x3NXcvdzI0M3d5L24rZkg1eUQ0Vk83?=
 =?utf-8?B?SjNzL0JUakRTWnQ2c2hOK2JzWGhSNjZpL1lRQURIcVBodnFicVlqUXc5TlNm?=
 =?utf-8?B?ZTg2bG9LT0ptNDZnbUxzWGdIR3ZmeTR4R1ZCU1lJbDFIOXVNclFWeVlPaFFN?=
 =?utf-8?B?MjEydi8wNExadkpSWFdiNk1wOVFCa2JVaHhQZU5FMDViUVFQbHlFNDRwTk80?=
 =?utf-8?B?d3VhcEFPcndiVVJCVUVvMkg5SnRBanozd2hJQTNGdmVzMjRoRTFUeEdvaG8z?=
 =?utf-8?B?ZjlKcjluNExFMEs5VEZ6Z1RyZENGcW96UGZYdldNM2VNNXN4bzNDUGxLTHhN?=
 =?utf-8?B?cjlJMEU3L0VRT0tPb3lNV0R1QjFiQXFZeVZnTG5zb0g2VW9GdVJtTTRuM3RS?=
 =?utf-8?B?Sm15QytWSWJZZ0JwcytESDEzb042Wk0rakpCS3FvZDFudXk1aEtvSTZYRVVZ?=
 =?utf-8?B?cTdZZHliYmVGQ0FuOVMxZHRrOStVeHF4SkUwU2VjUkQ4ZWs4ekFYNDF6UExy?=
 =?utf-8?B?cUhuald0c3RRdUdqOEdnMTZ1ZGJRanovbWgrcWJoMDZmcVkwQXhJUmNJOTIv?=
 =?utf-8?B?Y20vTytNL3EzcEU4RW9vSjJBOTZXc3JVeXVJZE80NHV3cnJTQzUydU83SVpC?=
 =?utf-8?B?cnpqcVE3ejRxUjgwMm03SzRzQnNGbTRiL2ZJbm1iVHp1R2ZOamZod0ZiMnFK?=
 =?utf-8?B?eEJtY1haWEFVRmpTRnN2cmt2R3luWExDNVQvcm0zV3kvOEJBWDJzUjhPaG9n?=
 =?utf-8?B?T3dJWjBCcW5Vck9ERFd4OWkxa0M1RS9EUUdzM1VZaUswRlJXQkd5MVZSTzJW?=
 =?utf-8?Q?eNji6bPJXu8OQFDh/7cyFkw=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 14dc6503-cd31-4ad1-d478-08da6e66cca5
X-MS-Exchange-CrossTenant-AuthSource: MN0PR12MB6150.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Jul 2022 17:55:02.7985
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ygcfDGT5Nm6GThmLGFR4j29o0WefiowV8S06aOq1OZB0T5B5hJz08HguRrJswscsDmEZ2jFfpYN130wR4qi9xg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB4084
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
        SPF_NONE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


On 7/23/22 06:32, Jason Gunthorpe wrote:
> On Fri, Jul 22, 2022 at 03:56:32PM -0700, Ralph Campbell wrote:
>> If hmm_range_fault() is called with the HMM_PFN_REQ_FAULT flag and a
>> device private PTE is found, the hmm_range::dev_private_owner page is
>> used to determine if the device private page should not be faulted in.
>> However, if the device private page is not owned by the caller,
>> hmm_range_fault() returns an error instead of calling migrate_to_ram()
>> to fault in the page.
>>
>> Cc: stable@vger.kernel.org
>> Fixes: 76612d6ce4cc ("mm/hmm: reorganize how !pte_present is handled in hmm_vma_handle_pte()")
>> Signed-off-by: Ralph Campbell <rcampbell@nvidia.com>
>> Reported-by: Felix Kuehling <felix.kuehling@amd.com>
>> ---
>>   mm/hmm.c | 3 +++
>>   1 file changed, 3 insertions(+)
> Should we have a test for this ?
>
> Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
>
> Jason

Sure, I'll add something to tools/testing/selftests/vm/hmm-tests.c

