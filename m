Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 99CCB2D276E
	for <lists+stable@lfdr.de>; Tue,  8 Dec 2020 10:24:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728793AbgLHJYA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Dec 2020 04:24:00 -0500
Received: from mail-eopbgr20134.outbound.protection.outlook.com ([40.107.2.134]:4666
        "EHLO EUR02-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728787AbgLHJX7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 8 Dec 2020 04:23:59 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fncgeF3RspOCi1j7wD/rmg949O2zu0fnslrEgcHVqjzN07P1hDdRfdKb9zSggivzt3j9YscSuAj1aWsjDv6QBT5Aa5D8zfRtLS4xWmh51puxzU3rjmzobOU4O/i2aY5CorHxrV0LDNfFXoEPt95IpVept/PU4emZdtEKdRXsxGN9bBth55WUxLsa41/ryznD6fMTsvr7fC47Exgu5Pvv5Lb5XxrYxh3JyTn/iQtAH9shN1L7gqvxF5XUTzBVYZmiPGnZA80Dm9uqzPeospnatD84o4WDEc/8evelf7XGP9dH4xzL0iV+3LSfoZQnchTKg6Nn7YhU47yNwJ0pROOEJg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=phxic6PqB35Z7CnX7S8UfKDGr22KNqXNLURPWvR5T5M=;
 b=ZyQDQ8qRDuvtYCeMNcWRSs1iOM167mvUigBGS4s96HRcq7402M+n5pDiPuYHnYMxt8KBLRGifpfKeqvwfq+ujEuzIlmPItJShnmLSPYKBmETQOgzglYVlYsx4Tya7BX/6dQ+mgvQd3D7PY9doZsPagrxbcC9X52h4iXw7J+Nt7XB/Jbn4w2ZByYA8FoZ23uZT/aQa48nL1MAE4H2IMeayS0pj1gjNNGjxWgeqydrUkZitbHgsk7subd1iFh9bHyKaSnw3cb6txW2X9aZBePHY6lyw2J9xAPOxL/mMOdiTn3Q/nKY0kvyLot8qBMcL9+r3kJT1b0QJ436hm8ViYJMuw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=virtuozzo.com; dmarc=pass action=none header.from=openvz.org;
 dkim=pass header.d=openvz.org; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=openvz.org;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=phxic6PqB35Z7CnX7S8UfKDGr22KNqXNLURPWvR5T5M=;
 b=leQvmi+IpRCF/FtsF79dZzvziMKmuBo1RNYMmDkmnqvLgjGVB4wWjR5NuWk9+U7bSD9lbZLcrx5wxoAau77lQX1We021KilXGSy9G2hQDrYm7MIltV8+xWDetqWpzF6tbZUriN/QHWNGQQrK5An4BSGnQpXNOOc79aTjQ+ipkJk=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=openvz.org;
Received: from AM6PR08MB4214.eurprd08.prod.outlook.com (2603:10a6:20b:8d::30)
 by AS8PR08MB6280.eurprd08.prod.outlook.com (2603:10a6:20b:29b::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3654.12; Tue, 8 Dec
 2020 09:23:07 +0000
Received: from AM6PR08MB4214.eurprd08.prod.outlook.com
 ([fe80::311c:c7ce:56cc:1399]) by AM6PR08MB4214.eurprd08.prod.outlook.com
 ([fe80::311c:c7ce:56cc:1399%5]) with mapi id 15.20.3632.023; Tue, 8 Dec 2020
 09:23:07 +0000
Subject: Re: [PATCH] KVM: x86: reinstate vendor-agnostic check on SPEC_CTRL
 cpuid bits
To:     Paolo Bonzini <pbonzini@redhat.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     stable@vger.kernel.org
References: <20201203151516.14441-1-pbonzini@redhat.com>
From:   "Denis V. Lunev" <den@openvz.org>
Message-ID: <1b8f94fa-a66b-e237-af47-aa1ad25cc4af@openvz.org>
Date:   Tue, 8 Dec 2020 12:23:04 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.5.0
In-Reply-To: <20201203151516.14441-1-pbonzini@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Originating-IP: [31.148.204.195]
X-ClientProxiedBy: HE1PR09CA0079.eurprd09.prod.outlook.com
 (2603:10a6:7:3d::23) To AM6PR08MB4214.eurprd08.prod.outlook.com
 (2603:10a6:20b:8d::30)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.1.22] (31.148.204.195) by HE1PR09CA0079.eurprd09.prod.outlook.com (2603:10a6:7:3d::23) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3654.12 via Frontend Transport; Tue, 8 Dec 2020 09:23:06 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 23e4ae2f-acbf-424b-19aa-08d89b5adf5d
X-MS-TrafficTypeDiagnostic: AS8PR08MB6280:
X-Microsoft-Antispam-PRVS: <AS8PR08MB62809FB38E000ADF156A614BB6CD0@AS8PR08MB6280.eurprd08.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2331;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: mpoMlM7RbSSBaunMtnR6WaK+EiEbaAEPe/bXsy0VdJjIbrAlHYzsCC4VU1JluMYipENVs0dLFrWnHl/XEmQYJVKy5YUUjLDs+XNNkoFql1yJWuDVUzzVR0RlEWaJ6r9BcLT+8qsGhIYR43coj0kG+9l322mjpnlYVlL13u4jcoUwznCK+7tETcHgR6ehHkMm2SdW2D1BAaxx8G38rG0JQhZn77G1PDSjkSvytXYjrMB7eLnPlheppf/JB6q1VtV3Q57lQE8cf3zq/WjZabymiepAbx2RvovxdnYAfJZiUFnI7Emlw54OfP8LNZkHWIqVZphpymL5REztXP8yNLDM2x40YioUQLjWhDdvmuW1BwaFp8uEHsN9o80HU7eIXjOHUK4+AXw7oCxtPhHy+wsU4+d9kYyy8SCE8cZTxaFCA22TBIrnD0Bv8Kj1KyPfQmcf
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM6PR08MB4214.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(366004)(136003)(376002)(83170400001)(66476007)(66556008)(66946007)(956004)(52116002)(53546011)(186003)(36756003)(26005)(8936002)(16526019)(31696002)(16576012)(42882007)(2616005)(83380400001)(8676002)(508600001)(5660300002)(31686004)(4326008)(2906002)(34490700003)(6486002)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?RWZWYlExS056RUlvV0hFbW9TMWFLdDVTL3QzL1ZrTlpaWmJOU3gwWjE4M3FO?=
 =?utf-8?B?cU9ZWnF1bzVINmJzcXp1WWFnMXVFRzJ0eFhGRE5Kc2ltUUpSaUZjaTd4S1o3?=
 =?utf-8?B?cU1RdW5FSVR5YnNLY2pGK1VRa0liNHgvWURTL1kwdmNkMUpwN2Z4aXNZcUdx?=
 =?utf-8?B?WDlERU5ueFZYNmMwZVR0c2l6Z3kxNEtueGRUbVgzejF1Ukx3R0NoUHdhWFBj?=
 =?utf-8?B?MXVJMkpmc2NjYUM0OThydkhQaUJoaTRlWUsrWHpQa3Z2SlhDVDlFY3RrT2Zu?=
 =?utf-8?B?bERHZ2F5SWxDK3BBb1ZNcXNNNUpkQUxKWnZCWHlNb3lLekhKczRmb2l1Rmlu?=
 =?utf-8?B?SFhiOUNKOTgzZkt5ZVF2Qkg4anZEemprano0NmVNaDhKUEsvZERMNVI2dzJv?=
 =?utf-8?B?UnB0SUsyZlhQSGE1U0J5QkZMNUtPUUwydVlBSERtNllmeDhjU284emRCSlpn?=
 =?utf-8?B?WE03cXFnSldmWkFWWkl0UWFYeTVCajlJeXBZUTJMR2xOaEZFQjlzNjRBVVpQ?=
 =?utf-8?B?dWlPT3l6Y3BENmUxc01EK3dZcFhoK1NkTmhkKzZRcWdvWU40YjJoSG5ubjVY?=
 =?utf-8?B?K2NTSDc4YmpqUStoZ1lSOCtmZlIzSDNBMEVIUmVCenB3QWoxSVpSWUhHcWNL?=
 =?utf-8?B?RlI0RXRGd3p0LzJjNThTTHc0NnlRSDRueHk5YW9lZG9HMmFpNlpjUnU0UXMy?=
 =?utf-8?B?ZzNWaXM4RWZRc3ZRSzlPQ2ZFMUM0enErN1N3am1VcmNZQVdvYndNSWdOSkN6?=
 =?utf-8?B?YUJqN0lYVWtIQmFXWHhHamE3a1NWNHlzdnZ5b1MvVk5TbnVCL0dHNkI3WFFR?=
 =?utf-8?B?QjZVUmErdHhjTURpQTlIWHJ1UjFPdjBzVkcyM0tLaGJMK0RBTmlPcFM1Qjlo?=
 =?utf-8?B?RklpNlN2VldEU2ZOWFF3c0NDUXR1TnBNbEdReFJYdnArNFNFSzRLTy9HU3ZQ?=
 =?utf-8?B?NGdWWDd6NUxsemF0eDl1bGlqN2NDKzVZaEp1RFQydmhSNjh2bWJIdW0zUVc4?=
 =?utf-8?B?aDBJdWhPYjE0Q24wcERyTzlvbXcva29YNUt1dWpYMGVpRWxwVkE2WXdPUWRU?=
 =?utf-8?B?VDFTZnhwTjNvcEhDcTEwVUEvZnlJS3paME5Sczh2TnZiTlVqeFBDcXZlRDZJ?=
 =?utf-8?B?S1k3ZkNSSFk1S3YrZndwd3g4OTQ3NkFnRFJqc3pManA3M2JhZGdFNjRteXJl?=
 =?utf-8?B?cnJrS2lndXpmV3NEQ3ZSa2VodWpKaXUrOHRsbS8rYTJVVkVPQ0ZDUFVBcTFn?=
 =?utf-8?B?d0VwbHZnY0hzUExYZ1krOC9mYUJmTk9pVXpFb1gvQlVaRWVVajlrQXJxL1NL?=
 =?utf-8?Q?swqGQKlYbSwF4UYpUkr7slpLQ/TMclIozu?=
X-OriginatorOrg: openvz.org
X-MS-Exchange-CrossTenant-Network-Message-Id: 23e4ae2f-acbf-424b-19aa-08d89b5adf5d
X-MS-Exchange-CrossTenant-AuthSource: AM6PR08MB4214.eurprd08.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Dec 2020 09:23:07.2416
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 0bc7f26d-0264-416e-a6fc-8352af79c58f
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: YO7t87esc2IaDEiE8ghaY8yC/d692dBc7J0DSgWfm9zfl8lc/+mTRKnSMFEaFkiZ4GjCG3B/r3W1mNLDqJobaA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR08MB6280
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 12/3/20 6:15 PM, Paolo Bonzini wrote:
> Until commit e7c587da1252 ("x86/speculation: Use synthetic bits for IBRS/IBPB/STIBP",
> 2018-05-17), KVM was testing both Intel and AMD CPUID bits before allowing the
> guest to write MSR_IA32_SPEC_CTRL and MSR_IA32_PRED_CMD.  Testing only Intel bits
> on VMX processors, or only AMD bits on SVM processors, fails if the guests are
> created with the "opposite" vendor as the host.
>
> While at it, also tweak the host CPU check to use the vendor-agnostic feature bit
> X86_FEATURE_IBPB, since we only care about the availability of the MSR on the host
> here and not about specific CPUID bits.
>
> Fixes: e7c587da1252 ("x86/speculation: Use synthetic bits for IBRS/IBPB/STIBP")
> Cc: stable@vger.kernel.org
> Reported-by: Denis V. Lunev <den@openvz.org>
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> ---
>  arch/x86/kvm/svm/svm.c |  3 ++-
>  arch/x86/kvm/vmx/vmx.c | 10 +++++++---
>  2 files changed, 9 insertions(+), 4 deletions(-)
>
> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> index 62390fbc9233..0b4aa60b2754 100644
> --- a/arch/x86/kvm/svm/svm.c
> +++ b/arch/x86/kvm/svm/svm.c
> @@ -2686,12 +2686,13 @@ static int svm_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr)
>  		break;
>  	case MSR_IA32_PRED_CMD:
>  		if (!msr->host_initiated &&
> +		    !guest_cpuid_has(vcpu, X86_FEATURE_SPEC_CTRL) &&
>  		    !guest_cpuid_has(vcpu, X86_FEATURE_AMD_IBPB))
>  			return 1;
>  
>  		if (data & ~PRED_CMD_IBPB)
>  			return 1;
> -		if (!boot_cpu_has(X86_FEATURE_AMD_IBPB))
> +		if (!boot_cpu_has(X86_FEATURE_IBPB))
>  			return 1;
>  		if (!data)
>  			break;
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index c3441e7e5a87..b74d2105ced7 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -2028,7 +2028,10 @@ static int vmx_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
>  		break;
>  	case MSR_IA32_SPEC_CTRL:
>  		if (!msr_info->host_initiated &&
> -		    !guest_cpuid_has(vcpu, X86_FEATURE_SPEC_CTRL))
> +                    !guest_cpuid_has(vcpu, X86_FEATURE_SPEC_CTRL) &&
> +                    !guest_cpuid_has(vcpu, X86_FEATURE_AMD_STIBP) &&
> +                    !guest_cpuid_has(vcpu, X86_FEATURE_AMD_IBRS) &&
> +                    !guest_cpuid_has(vcpu, X86_FEATURE_AMD_SSBD))
>  			return 1;
>  
>  		if (kvm_spec_ctrl_test_value(data))
> @@ -2063,12 +2066,13 @@ static int vmx_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
>  		goto find_uret_msr;
>  	case MSR_IA32_PRED_CMD:
>  		if (!msr_info->host_initiated &&
> -		    !guest_cpuid_has(vcpu, X86_FEATURE_SPEC_CTRL))
> +		    !guest_cpuid_has(vcpu, X86_FEATURE_SPEC_CTRL) &&
> +		    !guest_cpuid_has(vcpu, X86_FEATURE_AMD_IBPB))
>  			return 1;
>  
>  		if (data & ~PRED_CMD_IBPB)
>  			return 1;
> -		if (!boot_cpu_has(X86_FEATURE_SPEC_CTRL))
> +		if (!boot_cpu_has(X86_FEATURE_IBPB))
>  			return 1;
>  		if (!data)
>  			break;
Reviewed-by: Denis V. Lunev <den@openvz.org>
