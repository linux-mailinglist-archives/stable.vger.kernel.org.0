Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D2EFD33D343
	for <lists+stable@lfdr.de>; Tue, 16 Mar 2021 12:41:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237419AbhCPLlS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Mar 2021 07:41:18 -0400
Received: from foss.arm.com ([217.140.110.172]:34608 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237416AbhCPLlN (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 16 Mar 2021 07:41:13 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 506F7D6E;
        Tue, 16 Mar 2021 04:41:13 -0700 (PDT)
Received: from [10.57.17.216] (unknown [10.57.17.216])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id A97E83F70D;
        Tue, 16 Mar 2021 04:41:11 -0700 (PDT)
Subject: Re: [PATCH][for-stable-v5.11]] arm64: Unconditionally set virtual cpu
 id registers
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     linux-arm-kernel@lists.infradead.org, stable@vger.kernel.org,
        catalin.marinas@arm.com, will@kernel.org, maz@kernel.org,
        dbrazdil@google.com
References: <20210316112500.85268-1-vladimir.murzin@arm.com>
 <YFCXCbKefWH8smpB@kroah.com>
From:   Vladimir Murzin <vladimir.murzin@arm.com>
Message-ID: <c89f1434-e4e5-325d-e68d-ece76e8d3315@arm.com>
Date:   Tue, 16 Mar 2021 11:41:26 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <YFCXCbKefWH8smpB@kroah.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 3/16/21 11:31 AM, Greg KH wrote:
> On Tue, Mar 16, 2021 at 11:25:00AM +0000, Vladimir Murzin wrote:
>> Commit 78869f0f0552 ("arm64: Extract parts of el2_setup into a macro")
>> reorganized el2 setup in such way that virtual cpu id registers set
>> only in nVHE, yet they used (and need) to be set irrespective VHE
>> support. Lack of setup causes 32-bit guest stop booting due to MIDR
>> stay undefined.
>>
>> Fixes: 78869f0f0552 ("arm64: Extract parts of el2_setup into a macro")
>> Signed-off-by: Vladimir Murzin <vladimir.murzin@arm.com>
>> ---
>>
>> There is no upstream fix since issue went away due to code there has
>> been reworked in 5.12: nVHE comes first, so virtual cpu id register
>> are always set.
>>
>> Maintainers, please, Ack.
> 
> Why not just use the "rework" patch instead that fixes this issue?> 
> 
> that's always preferred instead of one-off patches.

That's moderate size patch series [1] which brings new functionality, but
more importantly move boot flow upside down, where we first boot nVHE and
then switch to VHE if supported. I think that a lot of change to carry in
stable compare to proposed fix.

[1] https://lore.kernel.org/kvmarm/20210208095732.3267263-2-maz@kernel.org/

Cheers
Vladimir

> 
> thanks,
> 
> greg k-h
> 

