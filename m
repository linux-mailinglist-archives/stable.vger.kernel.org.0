Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8C959D3D65
	for <lists+stable@lfdr.de>; Fri, 11 Oct 2019 12:31:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726829AbfJKKbd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 11 Oct 2019 06:31:33 -0400
Received: from foss.arm.com ([217.140.110.172]:55814 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726290AbfJKKbd (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 11 Oct 2019 06:31:33 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 8837F28;
        Fri, 11 Oct 2019 03:31:32 -0700 (PDT)
Received: from dawn-kernel.cambridge.arm.com (unknown [10.1.197.116])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id B7F1E3F703;
        Fri, 11 Oct 2019 03:31:31 -0700 (PDT)
Subject: Re: [PATCH] arm64: cpufeature: Fix truncating a feature value
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        will@kernel.org, mark.rutland@arm.com, catalin.marinas@arm.com
References: <20191010122922.GA720144@kroah.com>
 <20191010131943.26822-1-suzuki.poulose@arm.com>
 <20191011045538.GA977916@kroah.com>
From:   Suzuki K Poulose <suzuki.poulose@arm.com>
Message-ID: <433563f1-1aad-f43b-a294-08cb39ba4818@arm.com>
Date:   Fri, 11 Oct 2019 11:31:30 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.0
MIME-Version: 1.0
In-Reply-To: <20191011045538.GA977916@kroah.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Greg,

On 11/10/2019 05:55, Greg KH wrote:
> On Thu, Oct 10, 2019 at 02:19:43PM +0100, Suzuki K Poulose wrote:
>> A signed feature value is truncated to turn to an unsigned value
>> causing bad state in the system wide infrastructure. This affects
>> the discovery of FP/ASIMD support on arm64. Fix this by making sure
>> we cast it properly.
>>
>> This was inadvertently fixed upstream in v4.6 onwards with the following :
>> commit 28c5dcb22f90113dea ("arm64: Rename cpuid_feature field extract routines")
> 
> What prevents us from just taking that commit instead?  You did not
> document that here at all, which I thought I asked for.

Sorry, I missed that part. So, that change introduces helpers to
extract feature fields based on the sign. And it also depends on

commit ff96f7bc7bf6 ("arm64: capabilities: Handle sign of the feature bit")

which introduces "sign" bit for the "capability" list and modifies
the generic capability->matches() helpers to use the hint to switch to the
appropriate helpers.

I could backport parts of the commit 28c5dcb22f90 dropping the bits
that affect the changes mentioned above.

> 
> Also, you only need 12 digits for a sha1, 28c5dcb22f90 ("arm64: Rename
> cpuid_feature field extract routines") would be just fine :)

Yea, I understand. Its simply a pain to count the numbers, so I make sure
to pickup something that looks larger than the 12 ;-). I will try to stick
to that :-)

Cheers
Suzuki

