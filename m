Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 796B349675
	for <lists+stable@lfdr.de>; Tue, 18 Jun 2019 02:55:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725870AbfFRAzO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Jun 2019 20:55:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:38922 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725829AbfFRAzO (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 Jun 2019 20:55:14 -0400
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B089320833;
        Tue, 18 Jun 2019 00:55:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1560819314;
        bh=LngrchH4I/IBN3Zh6OPsxtvSRQcY1UhYSAdzmmrSMZI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=oYn2ijJx2tyO/bwbH/NumDeIYuwoNhxc+WEvJdQ3tRhRtrnjbJZED4nHzzNDovMfg
         he7lamj91s07bXu4cRiBZDOjDkCsVNcfnoqnniZvSwuaIT3b4wFSvVSYEb8RwvVW6W
         13yAsZGMAoZL5Co54QcVOqiHELUx4VfuqjzqGSRg=
Date:   Mon, 17 Jun 2019 20:55:12 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     Nadav Amit <namit@vmware.com>
Cc:     Bjorn Helgaas <bhelgaas@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Borislav Petkov <bp@suse.de>, Toshi Kani <toshi.kani@hpe.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Ingo Molnar <mingo@kernel.org>
Subject: Re: [PATCH 1/3] resource: Fix locking in find_next_iomem_res()
Message-ID: <20190618005512.GC2226@sasha-vm>
References: <20190613045903.4922-2-namit@vmware.com>
 <20190615221557.CD1492183F@mail.kernel.org>
 <549284C3-6A1C-4434-B716-FF9B0C87EE45@vmware.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <549284C3-6A1C-4434-B716-FF9B0C87EE45@vmware.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jun 17, 2019 at 07:14:53PM +0000, Nadav Amit wrote:
>> On Jun 15, 2019, at 3:15 PM, Sasha Levin <sashal@kernel.org> wrote:
>>
>> Hi,
>>
>> [This is an automated email]
>>
>> This commit has been processed because it contains a "Fixes:" tag,
>> fixing commit: ff3cc952d3f0 resource: Add remove_resource interface.
>>
>> The bot has tested the following trees: v5.1.9, v4.19.50, v4.14.125, v4.9.181.
>>
>> v5.1.9: Build OK!
>> v4.19.50: Failed to apply! Possible dependencies:
>>    010a93bf97c7 ("resource: Fix find_next_iomem_res() iteration issue")
>>    a98959fdbda1 ("resource: Include resource end in walk_*() interfaces")
>>
>> v4.14.125: Failed to apply! Possible dependencies:
>>    010a93bf97c7 ("resource: Fix find_next_iomem_res() iteration issue")
>>    0e4c12b45aa8 ("x86/mm, resource: Use PAGE_KERNEL protection for ioremap of memory pages")
>>    1d2e733b13b4 ("resource: Provide resource struct in resource walk callback")
>>    4ac2aed837cb ("resource: Consolidate resource walking code")
>>    a98959fdbda1 ("resource: Include resource end in walk_*() interfaces")
>>
>> v4.9.181: Failed to apply! Possible dependencies:
>>    010a93bf97c7 ("resource: Fix find_next_iomem_res() iteration issue")
>>    0e4c12b45aa8 ("x86/mm, resource: Use PAGE_KERNEL protection for ioremap of memory pages")
>>    1d2e733b13b4 ("resource: Provide resource struct in resource walk callback")
>>    4ac2aed837cb ("resource: Consolidate resource walking code")
>>    60fe3910bb02 ("kexec_file: Allow arch-specific memory walking for kexec_add_buffer")
>>    a0458284f062 ("powerpc: Add support code for kexec_file_load()")
>>    a98959fdbda1 ("resource: Include resource end in walk_*() interfaces")
>>    da6658859b9c ("powerpc: Change places using CONFIG_KEXEC to use CONFIG_KEXEC_CORE instead.")
>>    ec2b9bfaac44 ("kexec_file: Change kexec_add_buffer to take kexec_buf as argument.")
>
>Is there a reason 010a93bf97c7 ("resource: Fix find_next_iomem_res()
>iteration issue”) was not backported?

Mostly because it's not tagged for stable :)

--
Thanks,
Sasha
