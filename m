Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E49BD39631D
	for <lists+stable@lfdr.de>; Mon, 31 May 2021 17:05:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232600AbhEaPGp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 May 2021 11:06:45 -0400
Received: from [110.188.70.11] ([110.188.70.11]:23539 "EHLO spam1.hygon.cn"
        rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
        id S234525AbhEaPEi (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 31 May 2021 11:04:38 -0400
Received: from MK-DB.hygon.cn ([172.23.18.60])
        by spam1.hygon.cn with ESMTP id 14VEvH1I062046;
        Mon, 31 May 2021 22:57:17 +0800 (GMT-8)
        (envelope-from puwen@hygon.cn)
Received: from cncheex01.Hygon.cn ([172.23.18.10])
        by MK-DB.hygon.cn with ESMTP id 14VEv6Dv050307;
        Mon, 31 May 2021 22:57:06 +0800 (GMT-8)
        (envelope-from puwen@hygon.cn)
Received: from [192.168.1.193] (172.23.18.44) by cncheex01.Hygon.cn
 (172.23.18.10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2242.10; Mon, 31 May
 2021 22:56:51 +0800
Subject: Re: [PATCH] x86/sev: Check whether SEV or SME is supported first
To:     Joerg Roedel <jroedel@suse.de>
CC:     Sean Christopherson <seanjc@google.com>, <x86@kernel.org>,
        <joro@8bytes.org>, <thomas.lendacky@amd.com>,
        <dave.hansen@linux.intel.com>, <peterz@infradead.org>,
        <tglx@linutronix.de>, <mingo@redhat.com>, <bp@suse.de>,
        <hpa@zytor.com>, <sashal@kernel.org>, <gregkh@linuxfoundation.org>,
        <linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>,
        <stable@vger.kernel.org>
References: <20210526072424.22453-1-puwen@hygon.cn>
 <YK6E5NnmRpYYDMTA@google.com> <905ecd90-54d2-35f1-c8ab-c123d8a3d9a0@hygon.cn>
 <YLSuRBzM6piigP8t@suse.de>
From:   Pu Wen <puwen@hygon.cn>
Message-ID: <e1ad087e-a951-4128-923e-867a8b38ecec@hygon.cn>
Date:   Mon, 31 May 2021 22:56:50 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.1
MIME-Version: 1.0
In-Reply-To: <YLSuRBzM6piigP8t@suse.de>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [172.23.18.44]
X-ClientProxiedBy: cncheex01.Hygon.cn (172.23.18.10) To cncheex01.Hygon.cn
 (172.23.18.10)
X-MAIL: spam1.hygon.cn 14VEvH1I062046
X-DNSRBL: 
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 2021/5/31 17:37, Joerg Roedel wrote:
> On Thu, May 27, 2021 at 11:08:32PM +0800, Pu Wen wrote:
>> Reading MSR_AMD64_SEV which is not implemented on Hygon Dhyana CPU will cause
>> the kernel reboot, and native_read_msr_safe() has no help.
> 
> The reason for the reboot is that there is no #GP or #DF handler set up
> when this MSR is read, so its propagated to a shutdown event. But there
> is an IDT already, so you can set up early and #GP handler to fix the
> reboot.

Thanks for your suggestion, I'll try to set up early #GP handler to fix
the problem.

-- 
Regards,
Pu Wen
