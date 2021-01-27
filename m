Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 95823306740
	for <lists+stable@lfdr.de>; Wed, 27 Jan 2021 23:53:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231610AbhA0Wxm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Jan 2021 17:53:42 -0500
Received: from mail-mw2nam12on2043.outbound.protection.outlook.com ([40.107.244.43]:16096
        "EHLO NAM12-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231560AbhA0Wwy (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 27 Jan 2021 17:52:54 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Qu4lfNVuWd9jYeln2/FsFAQU2Bigqyba9C9bPgQAMfA9XED9FgRp8kwEQ+EKB+85CcHgIkLfmnkANQtqMtAC52UZ06nKtfXqZQlObZT8tqT0bFhT0+jMGlfEDO2pJoS55DEwOviVZ7xGFHPVgwnMosO2aK064EqMeTzDVjOcFY/bOvHb8O/AhdRqWrD926K/o3cPSuLV2pcU89xBihWYoqiXbVStfxLN3XD9CZnEtdwk0v6ncKN3NcAV7AqW2SfNNQiGWw6NcQRJbnbYi7vZE9FTcF6KoyFJPc1HND2MZuniw5NeniFdiCd9UrRhIhxz+W+mhWr+Tiz9RtuQc0Lwsw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=acwX7CdS5efTg40C1zJnEHcTi29/gpC8KXe+uPrC3eE=;
 b=HsgFPpDBMPJwbEJbyM2eWgcQeYX9Z1yLZPzgDfO3CY5lL+2/9cM4mNC+QpO2gTNQ/L+Hz0GYj9pEhxyCEtzQ+7CjvbCC0L2tUldTCuFBZb/tQFBfhB+3WIod47SvgKlD5RHF1vlOOZmM4Y+i9frEbJT6zKiJcQucOuRnpOZIqCVqiXnxHdrFXVvx3ZQJETRS0Tq+nmBym7mORyagPLkNheCX4rFe46DMuh50o5sq8y//BzzmPEg01hzGZLCbHPD7gIWpwzMHWgHGBQfFGEotBbZM9IbscfB1fnCj7u7Bf8cmu1OQTOjAKA3LJG/JgwY31e5mlJ6vg1wxSPfmffX2qQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=acwX7CdS5efTg40C1zJnEHcTi29/gpC8KXe+uPrC3eE=;
 b=J6KohB+6d0WfSgcb21P9Mhp8u2GN21iRi0sXgjPv+frjFmwpl82kx+odYxHuiJ9A4FPzbwe/rE7fPlQJxPunvjlhRE6WmnOBi+C7Ciulp9Zg0T+O7H9mLh+ktkXjaKgDy1cw/0poup06anpKjilSAwwvnANIJ6A0lPBZgfpq4yo=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=amd.com;
Received: from DM5PR12MB1355.namprd12.prod.outlook.com (2603:10b6:3:6e::7) by
 DM6PR12MB3691.namprd12.prod.outlook.com (2603:10b6:5:1c5::30) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3784.13; Wed, 27 Jan 2021 22:52:00 +0000
Received: from DM5PR12MB1355.namprd12.prod.outlook.com
 ([fe80::cc15:4b1f:9f84:6914]) by DM5PR12MB1355.namprd12.prod.outlook.com
 ([fe80::cc15:4b1f:9f84:6914%4]) with mapi id 15.20.3784.019; Wed, 27 Jan 2021
 22:52:00 +0000
Subject: Re: [PATCH V2] Fix unsynchronized access to sev members through
 svm_register_enc_region
To:     Sean Christopherson <seanjc@google.com>,
        Peter Gonda <pgonda@google.com>
Cc:     kvm@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Joerg Roedel <joro@8bytes.org>,
        Brijesh Singh <brijesh.singh@amd.com>, x86@kernel.org,
        stable@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20210127161524.2832400-1-pgonda@google.com>
 <YBHhF8ktuMfivQEP@google.com>
From:   Tom Lendacky <thomas.lendacky@amd.com>
Message-ID: <fecafe83-5f45-a0ab-c208-9ea4720fcb6a@amd.com>
Date:   Wed, 27 Jan 2021 16:51:56 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
In-Reply-To: <YBHhF8ktuMfivQEP@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [67.79.209.213]
X-ClientProxiedBy: SN2PR01CA0024.prod.exchangelabs.com (2603:10b6:804:2::34)
 To DM5PR12MB1355.namprd12.prod.outlook.com (2603:10b6:3:6e::7)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from office-linux.texastahm.com (67.79.209.213) by SN2PR01CA0024.prod.exchangelabs.com (2603:10b6:804:2::34) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3805.17 via Frontend Transport; Wed, 27 Jan 2021 22:51:58 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 806751bc-f702-4755-143e-08d8c3162836
X-MS-TrafficTypeDiagnostic: DM6PR12MB3691:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM6PR12MB3691A3A880652B7C3AD98D01ECBB9@DM6PR12MB3691.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: BjOiZbTNPJvVNzOAcxVxVlcDhd/ZExjZf4cJaJa7SpQX+sGglD6t/QfnGiQCDNxn9zrp+kz/hkfIqwuaeUw9fgd86r8Ee1FJkSb6IyfJT5uY7+X+uATnZF2ks1FhQ0ebZrbQuIlDov0xUv1hc6OlcswQ2rtNW8a9TSAPC7lAd/Q/MCAEqiJBa3TADlLb2FwbMLJYPb0dmqDR4l/cOH6Zk70+JADHgXtVJ0tuRRxdMZUFEIw9NIbhfMrBPRhAJmHJIoWsCAcsm3lpDek2I4xmHcerfGurjzIerlE+o0LmCSZ8MrM3Zc4dELhj0Q0GUqi7qbi8ZWpNsHnid3px1U2W0KwZBD4TLPI4ackNugeMb3MzYirFjlG6VyW1fGK3hhYpzfjXjOschB/fD6zJtUxCJfRfcyrXganMNInpFGc8SsZIJc6v8ANZ9lvRXr2YTw3cqEtjgoqu7i2Q3Eq+6++YAB6TT7+cp26evqkiEJz/YhleltRh6zaZ9V/RW9xmAkXw3/H0oXhwSUYM0HaWlRQyNY9NgWjyvYkmANgbdebWIAw9ZUN/d/fHTgKySlu2bvGUGf/5jtmMKtEB+Nh3b2RM4g==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR12MB1355.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(366004)(376002)(136003)(346002)(39860400002)(52116002)(54906003)(86362001)(5660300002)(7416002)(186003)(2616005)(16526019)(6512007)(31686004)(66946007)(31696002)(53546011)(66556008)(66476007)(316002)(6486002)(83380400001)(4326008)(26005)(6506007)(2906002)(110136005)(8676002)(8936002)(956004)(36756003)(478600001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?RUltelVXV3QyN2FSTlVWRDBhQ25VdUI2K3dwalFJUWFkNGVmMldXamN1WVJ6?=
 =?utf-8?B?QmpudTljRk5LSkV1bEh4WTJOTER4bjFYUnE5N0UvYi9MenRiODNRRmQxV1BD?=
 =?utf-8?B?YzFpVzFnS1l2ZWdia2xQYWRDYjBRc2t5U1BpbWgvUUdBMVh3ZnVOcHhlaVVt?=
 =?utf-8?B?Y1I1K29yV2lXWG5xSyt4L1NpeTJVd2hZMlFHOUs0Mks1aldyb1I4V1YvVHAz?=
 =?utf-8?B?NWx0UVdqaFM0V2NIa2RhblcyTlRJdURObzJRTit6bzBkYklLMWZyQ1RBbDBE?=
 =?utf-8?B?ZGtlTEVVTkFTeE1MOC9MazZycVdzVTZsMm9qc1ozWklZRk9qeEFaQ0sySjFT?=
 =?utf-8?B?WnBuZEJSQkI2bHBNR2ZKRWpVTW5lNWVSK2JtWlQ3b3kxcy9ldWpNWS9LeDZU?=
 =?utf-8?B?dVpmMFRxWm13ci9mVUtpQmNOZVB4R3dZTXREa25rN2gyWWJiTHE2RU1rLzdK?=
 =?utf-8?B?WDhVc0F1MFhxSklnQThaNzJIcHBVWnJnWUsyanNIZVpZaUVDZWFKd2FpQ0h6?=
 =?utf-8?B?a0pqNGZoanpwOCtJek1lWTlISjNoOU5Ba3k2Z0FXaDZYTGp1SUk3bGNEbDFC?=
 =?utf-8?B?RnU4NXErazV5aVB4d0dSaTdTZXoxTkw4SllQdlpCMlNrZzc5eCtXU2hFUWlr?=
 =?utf-8?B?eEpQRnBNTEhJRG8yUGNWeGNuTFJJdkc0RWpsenc0Q01LK1IxUUhKZlVhdDVL?=
 =?utf-8?B?MEh1c2ovdWowMS9EUTBiNUFHZ0lqTEdZeU5IY3dqck9hekt4RkRWY2lYdm11?=
 =?utf-8?B?T2d0S1J4T0UwN3V0R3pjUEhleThtUmltM1VxTWtSazA5aHI1TitJV2drNnEv?=
 =?utf-8?B?VEhvSDI5Ym0vRkVwWHdWbGcvb20rUEZ3ZGdPUzQvVFd3TXJDQ3pHVVhqbGUr?=
 =?utf-8?B?UnQvWjZMZmJBSzdxcVc5Z2xVdXIxK09EWUM4NElBdFNMZzZENXdDUGFLR01W?=
 =?utf-8?B?SnlQTHpvVmZjTC9UTEpZUDdHazFxYk13U2I0Y2pxbGhSdXFZUDNVWVBabjFt?=
 =?utf-8?B?WnJUK2lnYWNOcGhMWHc2Y0NVc0YweEo5MFh3R1RJcVRjOXd2cURxTW9iWDBW?=
 =?utf-8?B?OHlZWUhOWkN5b2N6NzZrdjQvVWdDdEFHOFpjYThiUXpiN2lzaEU0Y2hFbmJF?=
 =?utf-8?B?UlZmb0pYck9uY0dGN2MvRzdtVmN3Z0MreVQvdVRFLzN4dTBBN1VGSnY4dnkv?=
 =?utf-8?B?WFp4bndLaEY3dnVEN3lQM2pRcHJLbDB4Q3FxZGRZeEZJQS8vZ0F3M0VSYlVV?=
 =?utf-8?B?dnpoMjg1bHp0dUt6RExZREhYUUMvTlJLUmpkMFMwakttb213Nk90MjB2bUYv?=
 =?utf-8?B?SDlUU3d5cVlSa1RyQ0tmaEpZdkQwdFRQQXhQSUJEMGJZNG1PUHIrNHBLTmtM?=
 =?utf-8?B?VmNoMlhwNkt4OEN6YzRnZ2dRMHBZbXFyOHVhRENmTE85WjIrMGh6MEJ5eXpI?=
 =?utf-8?Q?zBc6nuvJ?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 806751bc-f702-4755-143e-08d8c3162836
X-MS-Exchange-CrossTenant-AuthSource: DM5PR12MB1355.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Jan 2021 22:52:00.6323
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: GldGXxMlGVpIe+gAEpvE91ZluATAIKeVn8iUyUCwsrMCmV+XvsaowmBlJ8v5MNkeN1c099M267SXtfVBOeHhEA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB3691
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 1/27/21 3:54 PM, Sean Christopherson wrote:
> On Wed, Jan 27, 2021, Peter Gonda wrote:
>> Grab kvm->lock before pinning memory when registering an encrypted
>> region; sev_pin_memory() relies on kvm->lock being held to ensure
>> correctness when checking and updating the number of pinned pages.
>>
...
>> +
>> +	list_add_tail(&region->list, &sev->regions_list);
>> +	mutex_unlock(&kvm->lock);
>> +
>>   	/*
>>   	 * The guest may change the memory encryption attribute from C=0 -> C=1
>>   	 * or vice versa for this memory range. Lets make sure caches are
>> @@ -1133,13 +1143,6 @@ int svm_register_enc_region(struct kvm *kvm,
>>   	 */
>>   	sev_clflush_pages(region->pages, region->npages);
> 
> I don't think it actually matters, but it feels like the flush should be done
> before adding the region to the list.  That would also make this sequence
> consistent with the other flows.
> 
> Tom, any thoughts?

I don't think it matters, either. This does keep the flushing outside of 
the mutex, so if you are doing parallel operations, that should help speed 
things up a bit.

Thanks,
Tom

> 
