Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 704C27FC4F
	for <lists+stable@lfdr.de>; Fri,  2 Aug 2019 16:34:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730109AbfHBOeY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 2 Aug 2019 10:34:24 -0400
Received: from foss.arm.com ([217.140.110.172]:52900 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729971AbfHBOeY (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 2 Aug 2019 10:34:24 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 0B12F1596;
        Fri,  2 Aug 2019 07:34:24 -0700 (PDT)
Received: from [10.1.197.45] (e112298-lin.cambridge.arm.com [10.1.197.45])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id C2A313F575;
        Fri,  2 Aug 2019 07:34:21 -0700 (PDT)
Subject: Re: [PATCH v4 3/9] arm: perf: save/resore pmsel
To:     Will Deacon <will@kernel.org>
Cc:     linux-arm-kernel@lists.infradead.org, mark.rutland@arm.com,
        peterz@infradead.org, jolsa@redhat.com, will.deacon@arm.com,
        Russell King <linux@armlinux.org.uk>, acme@kernel.org,
        alexander.shishkin@linux.intel.com, mingo@redhat.com,
        stable@vger.kernel.org, namhyung@kernel.org, sthotton@marvell.com,
        liwei391@huawei.com
References: <1563351432-55652-1-git-send-email-julien.thierry@arm.com>
 <1563351432-55652-4-git-send-email-julien.thierry@arm.com>
 <20190801130126.xxsot2mabvisq76e@willie-the-truck>
From:   Julien Thierry <julien.thierry@arm.com>
Message-ID: <1a349743-8fcf-9f05-00b4-b5e31340854e@arm.com>
Date:   Fri, 2 Aug 2019 15:34:20 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <20190801130126.xxsot2mabvisq76e@willie-the-truck>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 01/08/2019 14:01, Will Deacon wrote:
> [typo in subject: resore ->restore]
> 
> On Wed, Jul 17, 2019 at 09:17:06AM +0100, Julien Thierry wrote:
>> The callback pmu->read() can be called with interrupts enabled.
>> Currently, on ARM, this can cause the following callchain:
>>
>> armpmu_read() -> armpmu_event_update() -> armv7pmu_read_counter()
> 
> Why can't we just disable irqs in armv7pmu_read_counter() ?
> 

We could. But since we get rid of the lock after (otherwise it is the
only reason we have to keep the lock) we might as well find another
solution.

Thanks,

-- 
Julien Thierry
