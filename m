Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9763511BE79
	for <lists+stable@lfdr.de>; Wed, 11 Dec 2019 21:50:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727183AbfLKUsf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 11 Dec 2019 15:48:35 -0500
Received: from mail-eopbgr690058.outbound.protection.outlook.com ([40.107.69.58]:8748
        "EHLO NAM04-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727166AbfLKUse (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 11 Dec 2019 15:48:34 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kZBSKxPSgyDIRJs0goAj2cy/UL1uhqrR/1RVjK4RFz1/O1WORjAzN5ojw8kiU8D+vou0yGx/ksly4rqzsNebtGT2gr16UkpfzJyG1sWTZQ2ErC75lcW0cWnyiHKQmNZf0eccpb/YFUoZX8E4Xnlk/lBGRY+1JRrVx4KeH2zrztywsEO5BCZFYCuCc/C88vKaWCDOpuCfJzb3UbC/TE8Ag8kI9NJ+WZxc9ppkHYPVDPL0OYP4mxY7BcgiB14mXpcAP/HCRQSqBjh3gGPtjwXFz8F4XLL5EM5s7nC6jFhbHOL4GPT+qOlmwKdSVO9Bkwd7f2hhyCsT9P0dIE9Ys/YZXQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aZyz/c2mAUARG6Zmav6IUnMOQzV6cmQl/4exC1qXr2Q=;
 b=hMC3z5JJJLmEPH4PFBjhsPPxrkzVqilsVHLBBX5HVsYY2ezmUonBgJ69XkveE4m1ePH/ULw43ByiehGbMa8daGcnjUuZ1MsYMxhaWfh4bGynj48+uM/VlfbCM92SUBFfgwI8yfcT/bhVFs7bFwd++B4o6e7lFjh3da2+BApQ8GZa3kNdw8WaEbG+izEg+K6oAGlAhmx9ikLfdQsNhgben3J+pUQP5eI+ClE2Vpom0Le8mE0egbHQcEhFO43EfKDBJFATtrM0nmA/IKV0Ys+Gp1gqkQnn+kuPZ7oN3cV86kSh2GZ3ciCYJ2p7lvbz6vphuIQXFFhRjvV2GLE3hc+D6g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aZyz/c2mAUARG6Zmav6IUnMOQzV6cmQl/4exC1qXr2Q=;
 b=rpt14WTzZVWFhuY+2qrERN5bJVzmvBoju4amairjDIHzSXyCVcJYomQrS7aQgdcGfYjXl/99jIr7zP7n6Nr6ZPdD3YZUo1y876aZoL9Z5HwyPoAdXGvBCg68RSv+6tJzDHsFC7u3kfgRdmft3NsESC+MbgX9tm7mIxAqu7cwsZU=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=Thomas.Lendacky@amd.com; 
Received: from DM6PR12MB3163.namprd12.prod.outlook.com (20.179.71.154) by
 DM6PR12MB3354.namprd12.prod.outlook.com (20.178.31.225) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2516.18; Wed, 11 Dec 2019 20:48:32 +0000
Received: from DM6PR12MB3163.namprd12.prod.outlook.com
 ([fe80::c16f:b437:4266:dbc1]) by DM6PR12MB3163.namprd12.prod.outlook.com
 ([fe80::c16f:b437:4266:dbc1%4]) with mapi id 15.20.2516.018; Wed, 11 Dec 2019
 20:48:32 +0000
Subject: Re: [PATCH v2] KVM: x86: use CPUID to locate host page table reserved
 bits
To:     Paolo Bonzini <pbonzini@redhat.com>,
        "Huang, Kai" <kai.huang@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Cc:     "Christopherson, Sean J" <sean.j.christopherson@intel.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
References: <1575474037-7903-1-git-send-email-pbonzini@redhat.com>
 <8f7e3e87-15dc-2269-f5ee-c3155f91983c@amd.com>
 <7b885f53-e0d3-2036-6a06-9cdcbb738ae2@redhat.com>
 <3efabf0da4954239662e90ea08d99212a654977a.camel@intel.com>
 <62438ac9-e186-32a7-d12f-5806054d56b2@redhat.com>
From:   Tom Lendacky <thomas.lendacky@amd.com>
Message-ID: <4faef0e9-72aa-9328-9110-fc67b2580f91@amd.com>
Date:   Wed, 11 Dec 2019 14:48:29 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.1
In-Reply-To: <62438ac9-e186-32a7-d12f-5806054d56b2@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SN2PR01CA0028.prod.exchangelabs.com (2603:10b6:804:2::38)
 To DM6PR12MB3163.namprd12.prod.outlook.com (2603:10b6:5:15e::26)
MIME-Version: 1.0
X-Originating-IP: [165.204.77.1]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 9407d02b-f4fe-4eef-ba69-08d77e7b7b91
X-MS-TrafficTypeDiagnostic: DM6PR12MB3354:
X-Microsoft-Antispam-PRVS: <DM6PR12MB3354B2DCE67DD12E6FEF1F44EC5A0@DM6PR12MB3354.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7219;
X-Forefront-PRVS: 024847EE92
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(4636009)(396003)(39860400002)(366004)(136003)(346002)(376002)(199004)(189003)(8676002)(110136005)(81156014)(54906003)(26005)(52116002)(81166006)(6666004)(8936002)(6486002)(186003)(478600001)(53546011)(6506007)(2616005)(6512007)(2906002)(66476007)(4326008)(31686004)(31696002)(5660300002)(66946007)(66556008)(316002)(36756003)(86362001)(4744005)(60764002);DIR:OUT;SFP:1101;SCL:1;SRVR:DM6PR12MB3354;H:DM6PR12MB3163.namprd12.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
Received-SPF: None (protection.outlook.com: amd.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 8hxfS+IIvSQo9JTptKeK3ofV+dHQSqAIadEwedCjnsMEl1xFjK0aAETYfa8uaZ3EaC7kgs1vNBC8mHCllY0UZrsRi7IbXoR+oU030UaGCpyBV5yPmrNaiYJKx31npdFe4+8ZxlWikdUcWjwyVJVFKC4joqkIc884eF9I8D4fMHObdNgMFkHC2PSHXnXOzhMnvThprX9yMTUjDB8QvRuEZv+YJ5YfciPltW/BGcykCzMwfLvZzQxyqrb3M3fv8WU7VegXi+tPZBtG3lQQdV+NIHZbv8nnKPHbR7rMiEPuRE9yVFOqNEjCJ8bO4lMRVFdq9rGkJaiYFVeYgX3PsAgR7RL6kNVsitVBhzc+brIpKWc8E3h40ayKFKXx7VGXu7zfwaTZWrjnNN49jrg72mDKThlSAHcHKNRr7SiyyPB2xBC1rvsh4d2m5n5KmWyOBBb1ky+Oh5f6z9vwXl76fAk4MDnWLKygdnmW7k+Y9X6/2Ik=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9407d02b-f4fe-4eef-ba69-08d77e7b7b91
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Dec 2019 20:48:31.8388
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: lghKsLoCWwY9c8uLWGn0E7GZJ6zaKnx27eE37AowJ0OMwbrUKnqfm/XJgmFeQZlfY0P69kZ/FZEXPShDAR+VJA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB3354
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 12/11/19 3:07 AM, Paolo Bonzini wrote:
> On 11/12/19 01:11, Huang, Kai wrote:
>>> kvm_get_shadow_phys_bits() must be conservative in that:
>>>
>>> 1) if a bit is reserved it _can_ return a value higher than its index
>>>
>>> 2) if a bit is used by the processor (for physical address or anything
>>> else) it _must_ return a value higher than its index.
>>>
>>> In the SEV case we're not obeying (2), because the function returns 43
>>> when the C bit is bit 47.  The patch fixes that.
>> Could we guarantee that C-bit is always below bits reported by CPUID?
> 
> That's a question for AMD. :)  The C bit can move (and probably will,
> otherwise they wouldn't have bothered adding it to CPUID) in future
> generations of the processor.

Right, there's no way to guarantee that it is always below bits reported
by CPUID. As Paolo stated, the position is reported by CPUID so that it
can easily move and be accounted for programmatically.

Thanks,
Tom

> 
> Paolo
> 
