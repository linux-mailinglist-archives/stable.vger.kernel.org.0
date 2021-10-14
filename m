Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A4D1B42E279
	for <lists+stable@lfdr.de>; Thu, 14 Oct 2021 22:13:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230411AbhJNUPT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 14 Oct 2021 16:15:19 -0400
Received: from mail-bn8nam11on2055.outbound.protection.outlook.com ([40.107.236.55]:58721
        "EHLO NAM11-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230026AbhJNUPT (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 14 Oct 2021 16:15:19 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=obvxHfjs3nefFXiicz4KGvzdXDNH5I2AFLFwZ/c3Cskz2n0wctT6ti91UHi7AwA92GnZg+1mm2DazlK1YQZMdIpcgOzfbH8Z9lkGC+Wz4ROnd4nbBAaD7fICit8UIxijIJrGDW+e/03vNOmjlHQ0+cL4sIoENt6SffokaXWyafi3/17BGm3fkjQbHIRG/anCRVYWnvZDQUrfGpQ2d29joagq048rfq5SOITPQAgGxJahlTLLtXzGvhw3uxeVqXnWcw6KFY0+2z0kbaDNxpzHDrumtwrml7359A+EnzHlby0kWATybPItdsQCZUcg351thNAglYsyqVW/KaJhPlD7Zw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7UHDBlMhPRpMtQVLMiCSw8OBu0ZqbiuXJ+ElSp3Ax7g=;
 b=dEj+/zAXzKOGVCH/AzUaRyuUtmwGMvYBwjKOsnNl8XroCt319Axqjexko6KPbY1ipoVcfi8FqisAk9y8WEZ0CQoKB6cB13d2YkMcCW2+DT7EfMVKgYKtEid3YwjVeo+YIEVUc1owu4/X9CRwiJq2l6FPxEv3+GsVMdi5thNO0+vHNCd0PQDR3j9HIBrzc8Dl1q9sPT5vIhYmEPvb3Jd39vYwrVA54P/fZUlqGJ86OpS7xx7+d/HY/piatbzYoebkigEbPbKAA18R3Gd/iPk+QiNmcRG0jVO9bF8Q6Cj/Jlfgl9jIz7RrpUmCGTqRyToabUE/11LwAQV94JcWBT6QLQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7UHDBlMhPRpMtQVLMiCSw8OBu0ZqbiuXJ+ElSp3Ax7g=;
 b=L0vTAWjKnx7paVw+rIUUWPu8BGb3iz76uwuOOoSGnDhf2R+imUGG/380dK0c9TJeGdFXeIV0r4QR3onjrQHSvbIhcvC+zsOQueQ3moqfknA4JjtHWN1f8OXCk6YbJjqT0ZXz4oUHSPsBGoGWo+27DvISoqpz/7NcEcN65ZuPLBY=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=amd.com;
Received: from DM4PR12MB5229.namprd12.prod.outlook.com (2603:10b6:5:398::12)
 by DM8PR12MB5397.namprd12.prod.outlook.com (2603:10b6:8:38::6) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4608.15; Thu, 14 Oct 2021 20:13:11 +0000
Received: from DM4PR12MB5229.namprd12.prod.outlook.com
 ([fe80::a87d:568d:994f:c5f9]) by DM4PR12MB5229.namprd12.prod.outlook.com
 ([fe80::a87d:568d:994f:c5f9%7]) with mapi id 15.20.4608.016; Thu, 14 Oct 2021
 20:13:11 +0000
Subject: Re: [PATCH 1/8] KVM: SEV-ES: fix length of string I/O
To:     Paolo Bonzini <pbonzini@redhat.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     fwilhelm@google.com, seanjc@google.com, oupton@google.com,
        stable@vger.kernel.org
References: <20211013165616.19846-1-pbonzini@redhat.com>
 <20211013165616.19846-2-pbonzini@redhat.com>
From:   Tom Lendacky <thomas.lendacky@amd.com>
Message-ID: <b3fdb853-5bc4-39d8-bbf1-4d49dcb27a84@amd.com>
Date:   Thu, 14 Oct 2021 15:13:09 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
In-Reply-To: <20211013165616.19846-2-pbonzini@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SN4PR0701CA0008.namprd07.prod.outlook.com
 (2603:10b6:803:28::18) To DM4PR12MB5229.namprd12.prod.outlook.com
 (2603:10b6:5:398::12)
MIME-Version: 1.0
Received: from [10.236.30.241] (165.204.77.1) by SN4PR0701CA0008.namprd07.prod.outlook.com (2603:10b6:803:28::18) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4608.15 via Frontend Transport; Thu, 14 Oct 2021 20:13:10 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e8ad2137-e43b-49bc-248a-08d98f4f0bd4
X-MS-TrafficTypeDiagnostic: DM8PR12MB5397:
X-Microsoft-Antispam-PRVS: <DM8PR12MB5397E800D30FF78B9261C775ECB89@DM8PR12MB5397.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2512;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: IO8VIqXYhruZI2EWF93KilFvevnCL69fkBHB7CR2ajTz9zcmwod/M5hB1P+/iMxIkPYRBtpgKtWdUudI3FlnfMTJcOer6JnJSwVnvPkeXZ77kgEUxItwCyIBVdn9x36e/GI0sUJnBYPF6rfyJK3x55NwMxljpzVZc93F1jN65l+3iyWjLQM2UdNFf4Lxitz87eoBMHwJ/UQ358IFOwZXU7PdwG2kzqzCxUjWzCVb6pEJY3UtsjmYLaAdSR7iySwYLTXKiAoN5thmkt+LEetTyRjErzroQTcbz11KCWpWvGRbjWiAkGZyC1aHHxv/2C4CqNhvourdeKxu+dYbR7vWHR+50yTrutD7uWZNNJtwb2tdlS6edXJSVoWqavjaMVzRTDMYX+yZGuaPSCPWBx20SAwo0FUBnnetamSIeMKiY+9ZxMS5gsl8zy977gFYb4oE4JBCFiGRn7RtUzCyOcs2AraOZXbrap6I7lEUtZ/vaGuugXzYJFEq0teipmbpGQglKADzDdBtZ7UCpDr2YLrVmPK7+9RypY4O7g7bzWDVRk8KrPyKMpx1ZN4r5EkDzBvRHE3cho9CpEWIhARzwqrb9Ra3MBQPLfTQ6jZWR0yljkCioLb+NfE370j/BF3jyAjYNdbAJcvVNhJ5zyYHce6VsvUv7XbdF5b0hfx4sNQJZpdpMlB1uVhrgMF/6+O4/wGQ3GG0vH70nZ0rCAhaQhhBXD+9eYwoVMw/DImXyh8iPqU=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5229.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(16576012)(4326008)(5660300002)(38100700002)(316002)(31686004)(2906002)(508600001)(86362001)(53546011)(186003)(36756003)(8676002)(66946007)(26005)(83380400001)(8936002)(66476007)(66556008)(2616005)(956004)(31696002)(6486002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?VGt0eVF0TnVqYy84NTFTQXVpOG1Zd1pjeWJEZmVieFp3Smo0U1ZnSW84UFV3?=
 =?utf-8?B?YnJoUHpzOHNTZ0pRcUcvYTdlQWpxTGp1T1p1SHBMOHN0K0xFVkQ1bEhFWWdJ?=
 =?utf-8?B?djhENXpjYUFST0xJRnlSZGlZeEZSb2pRU0E1dzlnNU1RV1BjL082RFJ4cTlL?=
 =?utf-8?B?US96QWRLbGxsYmg1WXVNRG4vSDdON3VIOEhKYzh3dTF3NWZGcVhxa3JvS09N?=
 =?utf-8?B?Z1dlTXIrUTdjM2ptSmIxUndhRnZuSFBEcVpaNlhqRk04K0xWUWovUUhvaHE4?=
 =?utf-8?B?bnh4OE4zUkp1V0UxZmNNV2wzQldMcmk0MXF2bmNJazBkNlorNjNmb3pNZ2tu?=
 =?utf-8?B?dTdJc0VRN0NjaWNJelhuTEU4M0RrcDBCNTB1SWJiVC9tWVdKUld2SDN3ME4x?=
 =?utf-8?B?SUJEYzVGY2ovalIwRTRwOXZMRWxrcHdyTmRJNDZCemd2c0FRckRTS2VvVWpZ?=
 =?utf-8?B?MUd0MEg1ei9UU3JEbnd4dUpGODFnamdqVGdyOENxazlNWEdEU0JnYVhwcVR0?=
 =?utf-8?B?UkZEd0x0bVpaWUN1NEo4eVd3d0ZSVzU2dHg0cUlKQzlOT2NqQUI2VVNXa3Ez?=
 =?utf-8?B?M21kUlNSeVRKaXN4U05iMGluc25vU0NaRzFGMDZVK3pqbnhwNElZK2ZLdUNx?=
 =?utf-8?B?MnRFN281aWFTTTA1M3o0RFk3WnRhMGdVcHE1aEVVdVJjSHVCazd5OGhLZG9L?=
 =?utf-8?B?SysyUHZGcmxvbGszc3hUbG45RlN2K3N2MXdGcENmbno1cHc1MHJsNVBBZFpB?=
 =?utf-8?B?bUpOTUJQUnhiandRbU1waXBoUUozQ2pUSmdUdndhdlYySWRmWlgzRTZxKzZm?=
 =?utf-8?B?NGNQeTg1ZWxNSFNaNVJRd0pLeXgwTTBXVkdOUC83Z0puRTE4SlNZRDNRRDFi?=
 =?utf-8?B?SjZhaWJuaFE0VU9aL2E1eDJmQ3pBb3NwdFNFaGlOakdPaUN6ZEFyTDl6WmJL?=
 =?utf-8?B?TUxreUFWcGY4RkRyK1FaWXV0a2tDSEpqNklqSTFlWk9SUitpRlFVaklQS0o3?=
 =?utf-8?B?V3U4SmZNblZBU2pBTW9rYitSZWFEempuQ3JJUFlkQWY3R2VrTlhQbGJYdGYz?=
 =?utf-8?B?WldQM0pNYmpSZHNlb2NDZTFEMURUWDRtM3hXazVtTmRSYkNqLzRWZ3NNWXpi?=
 =?utf-8?B?MjNOWlV5SDNvOGdJdGo3enFPTStlTmowNWR2QlJlRlBPUlVSSVY4MWlDYzV0?=
 =?utf-8?B?dWNONmY5cWJaYmdLSFc0cGVOR01QeStFT01rQUpKUHIvcGtZVXBxYm9INzND?=
 =?utf-8?B?MFpReTZqZGxsTXFEMjVxQ0RwbGQzbjBxWW9YOHJhMURHV3lwV0FHc1A1blZL?=
 =?utf-8?B?SWFEbFdhQVE3aTdWK2pKN25HQU5Nbkcwb295cTFGS3pUTEU0Y3pPa3BIcU05?=
 =?utf-8?B?ajJzRFQ4M2svb3pyMmhrN0l6WUxscCtFNkh6bERFY1BiR05XMVVhUjQ0b3Zq?=
 =?utf-8?B?RTgvQlBwOG1JenFjdEN1MFVWMnVlVmNjRzNaMng4SzMxNW9PdDJsNE12MU9L?=
 =?utf-8?B?YU1pMm1kaWhnbWtIMEF0TlJ3Vms5ZlIvWnoxYmgyRmtzRlRGaTZFK0lsRmRq?=
 =?utf-8?B?U2xvejUxbnQyVmZxeklsQ1hIYlB5ZWxNZUl6TFY4RTFzbjhrK3Q2aGtGVnVa?=
 =?utf-8?B?YlhMdm9LbDhmOXlCUFZrMGxHTkY5TmtqUzhIZUZ0V25pRkY4dFBuRGovcFcw?=
 =?utf-8?B?NnlTd3JrZVNSUmpFTHJDL1F3L2pETmVWNUtBMDBSTHlUc3dvV0xMaEY2SDly?=
 =?utf-8?Q?CdVGrdnxztDSqV5zD9JjR/vMIDfJ1bR++ek6+ij?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e8ad2137-e43b-49bc-248a-08d98f4f0bd4
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5229.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Oct 2021 20:13:11.4570
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: THvSP1TEZlEBYdw0bjY1suaSL72NmKQ0D3ycCWiH641QCrHa7YVFPhDJuvRzIw4eC39GSZef1eo/18P6u4IgGA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM8PR12MB5397
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 10/13/21 11:56 AM, Paolo Bonzini wrote:
> The size of the data in the scratch buffer is not divided by the size of
> each port I/O operation, so vcpu->arch.pio.count ends up being larger
> than it should be by a factor of size.
> 
> Cc: stable@vger.kernel.org
> Fixes: 7ed9abfe8e9f ("KVM: SVM: Support string IO operations for an SEV-ES guest")
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>

Ugh, can't believe I did that...

Acked-by: Tom Lendacky <thomas.lendacky@amd.com>

> ---
>   arch/x86/kvm/svm/sev.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
> index c36b5fe4c27c..e672493b5d8d 100644
> --- a/arch/x86/kvm/svm/sev.c
> +++ b/arch/x86/kvm/svm/sev.c
> @@ -2583,7 +2583,7 @@ int sev_es_string_io(struct vcpu_svm *svm, int size, unsigned int port, int in)
>   		return -EINVAL;
>   
>   	return kvm_sev_es_string_io(&svm->vcpu, size, port,
> -				    svm->ghcb_sa, svm->ghcb_sa_len, in);
> +				    svm->ghcb_sa, svm->ghcb_sa_len / size, in);
>   }
>   
>   void sev_es_init_vmcb(struct vcpu_svm *svm)
> 
