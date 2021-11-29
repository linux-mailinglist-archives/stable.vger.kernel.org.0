Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D3D53461FEE
	for <lists+stable@lfdr.de>; Mon, 29 Nov 2021 20:10:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348464AbhK2TNp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Nov 2021 14:13:45 -0500
Received: from mail-dm6nam12on2083.outbound.protection.outlook.com ([40.107.243.83]:8360
        "EHLO NAM12-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S233999AbhK2TLo (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Nov 2021 14:11:44 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Q5PryMhWCn3YVbu6U57xsiDi2V3sv/Ymo0U0elwrjU4e10z9yqN1fWhHlmVKTN1bAUuTcKoqJQzIthpPDbIFsT3Ju9FPgDhF0NpOBBg2TQPuCN6TqvvntPyjr941hUsmQwVw7S75HXFrk7ihh1qaWE+iqmASCFwzTWm5dDyEutuONw1w6QRg6gAUENdxiPbOO6flXKLeakGbKGkzVO2BXGnUaIdGZwg5zoAJ0T5GpLEsZmuvgUAtV80pjMAzEZ7qC73Vskxse3LimKfaBQDT1edkuN7/0sVxag2aQwUdk4rgDNV/nCf2NcHqWC0+X/lkFyj1LyIPkhSfJlBuZPNN5Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=buoPcLNv7ygYept2gHLWD8Xof/w+BbT/cMoaBJQROjI=;
 b=HMlPSuK9b3ckXj7JVBGPl79wpDVGz5ryF96o64thnK9wK6PmgK0yLOzIQhvXGni9uGDzVHfRvTdZikSfd0mIm+cKzqmIP0oun8UZv8/HJvq3+dBrYCHjvpYKh99LwO9z/Gc1hWm6JkLcrgtp5D+hvjrrhFCZqvg2qgiyfheYev7xN0JZr0qk1WN0AJUvVYk2oD1szQJELZ+2cT2vLwAWQIyyPIfqzpA5dq2OiDO5h2JgyAn5526NG/9rx/csI1QE5XNTGNN4CU4q4mQyzioumn8tdxrHjyg9fbz1osUKhiQKTl7w2hkwYkfb8bIejy5euZmfCbRrDStFTwqZSzVVtQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=buoPcLNv7ygYept2gHLWD8Xof/w+BbT/cMoaBJQROjI=;
 b=ICwRBwORZ6czX3pfunUktfaIxIbNqH34eZTINEkyYw2n0Z3THEISX3DMRZU1jSStZfy4sbaLD25wQ4/Thpk3bQeo2yOqoQaXuuyu5kcUwcbHhR6T07upixsZ+hhB7zIoWWNc5AzbZjDF0+gmFpbfJElbkEo7CmXxD534jEAEka0=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM4PR12MB5229.namprd12.prod.outlook.com (2603:10b6:5:398::12)
 by DM4PR12MB5086.namprd12.prod.outlook.com (2603:10b6:5:389::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4734.23; Mon, 29 Nov
 2021 19:08:25 +0000
Received: from DM4PR12MB5229.namprd12.prod.outlook.com
 ([fe80::1ddd:71e4:5803:e44a]) by DM4PR12MB5229.namprd12.prod.outlook.com
 ([fe80::1ddd:71e4:5803:e44a%3]) with mapi id 15.20.4734.020; Mon, 29 Nov 2021
 19:08:25 +0000
Subject: Re: [PATCH] KVM: MMU: shadow nested paging does not have PKU
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Lai Jiangshan <laijs@linux.alibaba.com>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     stable@vger.kernel.org
References: <20211126132131.26077-1-pbonzini@redhat.com>
 <2091ec8e-299a-8b3d-596e-75cf4b68fde1@linux.alibaba.com>
 <b5e2c332-59a8-7fa8-5e59-4cb2e5be3b8d@redhat.com>
From:   Tom Lendacky <thomas.lendacky@amd.com>
Message-ID: <9f56fc4c-9842-a125-0f95-c32e248b677c@amd.com>
Date:   Mon, 29 Nov 2021 13:08:22 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
In-Reply-To: <b5e2c332-59a8-7fa8-5e59-4cb2e5be3b8d@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: MN2PR08CA0008.namprd08.prod.outlook.com
 (2603:10b6:208:239::13) To DM4PR12MB5229.namprd12.prod.outlook.com
 (2603:10b6:5:398::12)
MIME-Version: 1.0
Received: from [10.236.30.241] (165.204.77.1) by MN2PR08CA0008.namprd08.prod.outlook.com (2603:10b6:208:239::13) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4734.20 via Frontend Transport; Mon, 29 Nov 2021 19:08:24 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f1c8c740-5ac3-4c83-82f3-08d9b36b9e46
X-MS-TrafficTypeDiagnostic: DM4PR12MB5086:
X-Microsoft-Antispam-PRVS: <DM4PR12MB50868EA2C9C439624C2EDC79EC669@DM4PR12MB5086.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7219;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: WTiq/uHUaFBrfNX1/2qE9F9CAH34OKtxgGc/IekPvfCEqGknGWU0bQ5O1u4S3mG3GKfyFSvSMz0w+fXdxQXmjGwpCoK2av+QJzwkzaxQ3s+om7LcasOUOzXbKUdcuFy2VN6U9O/SBWpA7ZlKx5PsQu8hpcN7EZ7EIo+rhY2J8RVaRl5jHkMOxH+lOaLPY9fS0c17EkMP6i4OO58RrLWXDMadRsQrFWNuTyZH0NHmS4MN11jnTDo38EtYjBu0sVi3k8OZo4psjj0yvg0EJEzFPM91C+oUwDgv4PLiIfTnwPJpfVKhWdiPWpoXfkbRbfpzuF+WgH4L72ibn05KlEoCIj3Fe4NhjrLSmr69vVFw4UPRq31kwbTYTnR0qhnHPxIpvlRSAsWOuxCTdWWOjhii9feKuBaL8NBzevfgmkatmvTXd8Eii3UKbwjZ6601w8SecTr8hpHeaA0xrAwFzemXOWC0//fidpTSD2q+HWoC6HdZqZv3tWlcQGLoAdwKWZXHxHEifE8evfAvD9EiueP4WphmXnCUSgpW0uH7H7jP3IAcW3QjVJX+trSiW8DJKhvJ18Ic2nMpgOXz3LdkpOL6rsAaU8q8aQvaMFNaWuo487MyOOR5D2YGtOdoPC35f2pOcdqYxbCYnD7zvQe5g6ua7GrQxm6rX8lMaJA7n6Ed6YKCRIhhZ76eIKpE5E2crqVvuGSYlZzdx8wfjd/2hd+OGx1aQlQr0oYfbuibN2I2HHctKEGuAXb9Z9sf/pBzJntN
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5229.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(66946007)(186003)(66556008)(2616005)(8936002)(66476007)(6486002)(956004)(16576012)(26005)(31696002)(53546011)(4326008)(83380400001)(316002)(508600001)(8676002)(38100700002)(36756003)(5660300002)(86362001)(31686004)(2906002)(4744005)(110136005)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?NzRydnZhajMwVXZMOC9hR2w3WXE1SkZXNzk3YjFnTnJtcGNWSXR2Wm93NFRo?=
 =?utf-8?B?eVhkckljZm5NZFVRWC8rRStSUDRPRGxZVDNoSEo0bU40S2pLNDhNV1hjTDBY?=
 =?utf-8?B?Wk1PUTRicWw1K1hXaFZnV0wzRTUzd0tnalFRak5YNy9td0JlZjg3dVAxbGE5?=
 =?utf-8?B?SEtqUDNVbEhHaUhlcVhmVGpMTUVTSmUvYjM4TWpuZ2VJSlV0RDJkckhSa2lz?=
 =?utf-8?B?djFHTEx2T0JJZUg3NUxxZklyTmQ5SGsyaG1tRnA2eGRqWW9NbU0zSXN4UU5K?=
 =?utf-8?B?SFJTbkU0VEsvWWlsL3FTNGlsS2pmKzllbGVSTW42S3dmK1JMQlRQQlFvSFpW?=
 =?utf-8?B?bWppWXI5NXc3REphZWUwQld1ZS95SmxMNS9aRHZ4a1Z5Um50S2xRUVYzRnZy?=
 =?utf-8?B?aGFLRVJ5YTEzdlFNWnVHVFlHWk5lSHVXQnk3RGJpVWFESDJyVXk1Vy8xd2dL?=
 =?utf-8?B?MlIrUXNwU1l4ZEdTdERWTEtQZFZQSEQ1QnJFTVoza2VXOWVsWDQ1RldiOSsw?=
 =?utf-8?B?MmhiTVpaWUowTElHTjFBM0ZHS29qQW41Wm5GUklqTVYwNjBNaHhTbmVZMXV5?=
 =?utf-8?B?U3BYWUtMUTZOd2FqWk1XMTFreWE5VWZwbTVjSGdhNGg0a0Zlc2c4cjZETXpl?=
 =?utf-8?B?QTYwVDQrSlhlbW1pc3N6bmJ6S05MRFdGMmdkOEtoZEFQbjZDeUJmWE1pNHp1?=
 =?utf-8?B?N3dJTTdiSmEzMDNwbnhJZnpEZytJeWdaQ0ovTHVZdEVpUDIwVEpoUXZ1OVVF?=
 =?utf-8?B?bHpVVU15WXE0Q1RuRkg1QzB2ZEhSQUtuV0NOd2x5MVFaZ2RrRnpobUswa2V2?=
 =?utf-8?B?T1hTdlp5c1VaMDltaG1XS01nNnNPMTR4SmpXcEQ4V0Z3MDNJWVdzQ3FRaG0x?=
 =?utf-8?B?aUo2aFpuZW5qNXdwMVB2Ri9NazRLMnZUajhwUVpNelMxZlpFTDVMQ0Z4ekor?=
 =?utf-8?B?OG9nSnJIb2JTYlJET3NFT2hGNXBvQzE2R1NPcVc3ajhrOW9RM3pOYkorbSth?=
 =?utf-8?B?ejlaRVR4OWVVb2c2K29GNGx1ZktyOUREZzNQRllyNlE5L2ZtU0xsYW81TDNV?=
 =?utf-8?B?WURhRWRsaHhtMFZweGY3NWVMckpBMmMzaHVUYlRJTTFtR0NKaDQ2NTFucVlt?=
 =?utf-8?B?T3gyVGxRdm5NSi8wUW1FMDlrU2NaeUR3cmxncVpXc0FQNjBVS2NDL09JRjFK?=
 =?utf-8?B?N1dkbU5DVlVDdVRDclNDMkE2NXByaVVLcFVxbE1Ca2JkblhjckJ6RWhveW0y?=
 =?utf-8?B?ZjlpRG91OC81L3dTUXJSeTQ2UkRjN2Q3aDBvNEZWRUJ2Q2hZTDY1NXppRUdN?=
 =?utf-8?B?WXFhNnNBbDJvWmxzb3R6N0FJUmdYUGh5OVJEZmhza2hUTGdUNk03WnpveHdv?=
 =?utf-8?B?ZmJ4RFQ3QVBQcnZzZk52OVNoekRTemF0TU9nYm9UV1RCb0VWWUZIQlNvb2hL?=
 =?utf-8?B?eDZHZ3ZRalVSRHhWRHJJS25QeHU0SERXTFYyNlVmOTBqRFBrUjRoVTFIN24z?=
 =?utf-8?B?V1lHRFpnUDF4RTBwdjRndlhjQVdDeTQrVzlWcG93SlUzMGFqY0FBREh2WjR4?=
 =?utf-8?B?TXJ2OGV1YVAwL0E4N0hDS014MDUwenJUVzNNcElYL2o5MGtvL1gxWnA0bnYv?=
 =?utf-8?B?SDFGOGZOWmJmNGN6TW9GTnl5NGJ5b1RSV04zemptTUdldU4xWkdFclBlQ0dI?=
 =?utf-8?B?cnJVcCtWYmlkZ0lIZFIxd3d2NHJKREZ3VFJhNUNraFVVYlFEWWRrZUJMVEVL?=
 =?utf-8?B?cWdoVm1uc1lMWFlNaHJmY3pPbTczeDNMRzAvTzZ4M2VERlVDYmlQbFdVQW9V?=
 =?utf-8?B?UDF4ZW1kdThhcnlDOFNHcU9NdkdkVU8zVzFmY0VsdURDd1ovYm1UV21XN2Q0?=
 =?utf-8?B?TGswZkJoZVpubWM3dWNPRlM1RFVKdHhQRVZaOFRNQ1B6TjJvblVyTzJhaWdi?=
 =?utf-8?B?Nk1wREJyMjVvTW5YNmVLQVZvaEp0VW40ZkJiUXRHbkh1L0NtZEh0b2FNVzQz?=
 =?utf-8?B?TnBYWGxpaUtqLzIrQnFmempzbG5CMHBHWmwvemovYUdzU3Y3SkxpNnNuUjJO?=
 =?utf-8?B?MWI0dVZ5cW9OZXdiYW4zajBrdTdBRWJNNWNDcnIzcnpORC9ReXpPQ2dVcE1X?=
 =?utf-8?B?MXkzZWwrSGtEd1BEVnF2YjhzL3hJWmZwVUZpaWRFZ0RrSkJzaGJGT1FobGhl?=
 =?utf-8?Q?9hplSf6nuPl8+8iz1y7vmnY=3D?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f1c8c740-5ac3-4c83-82f3-08d9b36b9e46
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5229.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Nov 2021 19:08:24.8905
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: mKHSozQ7DYkMENWoHClg3vrQSObnbvLBwlVIjQ8bg8xjbhcC8C+xy37M07E2ldDWKeLzRkNwShO6kJT1M2qRkg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB5086
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 11/27/21 4:25 AM, Paolo Bonzini wrote:
> On 11/27/21 02:21, Lai Jiangshan wrote:
>>
>>
>> On 2021/11/26 21:21, Paolo Bonzini wrote:
>>> Initialize the mask for PKU permissions as if CR4.PKE=0, avoiding
>>> incorrect interpretations of the nested hypervisor's page tables.
>>
>> I think the AMD64 volume2 Architecture Programmer’s Manual does not
>> specify it, but it seems that for a sane NPT walk, PKU should not work
>> in NPT.
> 
> The PK bit is not defined in the nested page fault EXITINFO1, too. Thomas, 
> can you have it fixed in the APM that the host's SMEP, SMAP and PKE bits 
> do not affect nested page table walks?
> 

I talked to our documentation folks and they will look to update the APM 
with the appropriate information.

Thanks,
Tom
