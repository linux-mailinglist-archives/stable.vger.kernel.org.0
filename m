Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9DC4F1043A9
	for <lists+stable@lfdr.de>; Wed, 20 Nov 2019 19:50:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726757AbfKTSua (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 20 Nov 2019 13:50:30 -0500
Received: from mga06.intel.com ([134.134.136.31]:38554 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726001AbfKTSua (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 20 Nov 2019 13:50:30 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga104.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 20 Nov 2019 10:50:28 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.69,222,1571727600"; 
   d="scan'208";a="259121645"
Received: from tthayer-hp-z620.an.intel.com (HELO [10.122.105.146]) ([10.122.105.146])
  by FMSMGA003.fm.intel.com with ESMTP; 20 Nov 2019 10:50:26 -0800
Reply-To: thor.thayer@linux.intel.com
Subject: Re: [PATCH] EDAC/altera: Use fast register IO for S10 IRQs
To:     Borislav Petkov <bp@alien8.de>
Cc:     stable@vger.kernel.org, mchehab@kernel.org, tony.luck@intel.com,
        james.morse@arm.com, rrichter@marvell.com,
        linux-edac@vger.kernel.org, linux-kernel@vger.kernel.org,
        Meng Li <Meng.Li@windriver.com>
References: <1574271481-9310-1-git-send-email-thor.thayer@linux.intel.com>
 <20191120180733.GJ2634@zn.tnic>
From:   Thor Thayer <thor.thayer@linux.intel.com>
Message-ID: <5bfe9cc4-6cd4-7edb-9ed2-abe5fadff06d@linux.intel.com>
Date:   Wed, 20 Nov 2019 12:52:18 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20191120180733.GJ2634@zn.tnic>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Boris,

On 11/20/19 12:07 PM, Borislav Petkov wrote:
> On Wed, Nov 20, 2019 at 11:38:01AM -0600, thor.thayer@linux.intel.com wrote:
>> From: Thor Thayer <thor.thayer@linux.intel.com>
>>
>> When an irq occurs in altera edac driver, regmap_xxx() is invoked
>> in atomic context. Regmap must indicate register IO is fast so
>> that a spinlock is used instead of a mutex to avoid sleeping
>> in atomic context.
>>
>> Fixes mutex-lock error
>>     lock_acquire+0xfc/0x288
>>     __mutex_lock+0x8c/0x808
>>     mutex_lock_nested+0x3c/0x50
>>     regmap_lock_mutex+0x24/0x30
>>     regmap_write+0x40/0x78
>>     a10_eccmgr_irq_unmask+0x34/0x40
>>     unmask_irq.part.0+0x30/0x50
>>     irq_enable+0x74/0x80
>>     __irq_startup+0x80/0xa8
>>     irq_startup+0x70/0x150
>>     __setup_irq+0x650/0x6d0
>>     request_threaded_irq+0xe4/0x180
>>     devm_request_threaded_irq+0x7c/0xf0
>>     altr_sdram_probe+0x2c4/0x600
>> <snip>
>>
>> Upstream fix pending [1] (common code uses fast mode)
>> [1] https://lkml.org/lkml/2019/11/7/1014
> 
> I don't understand - I picked those up and are already queued for 5.5:
> 
> https://git.kernel.org/pub/scm/linux/kernel/git/ras/ras.git/log/?h=edac-for-next
> 
> What is that patch for?
> 
> Are you saying, I should stick it before the two patches above so that
> it gets backported to stable so that you have older kernels addressed?
> 
> But then the above ones won't apply anymore because
> 
> EDAC/altera: Use the Altera System Manager driver
> 
> removes s10_sdram_regmap_cfg.
> 
> What I can offer you is to remove the two patches and apply this one so
> that it goes in next week. Then, you can send me the two rediffed after
> 5.5-rc1 is out. Ok?
> 
>> Fixes: 3dab6bd52687 ("EDAC, altera: Add support for Stratix10 SDRAM EDAC")
>> Cc: stable@vger.kernel.org
>> Reported-by: Meng Li <Meng.Li@windriver.com>
>> Signed-off-by: Meng Li <Meng.Li@windriver.com>
> 
> What does Meng's SOB mean?
> 
>> Signed-off-by: Thor Thayer <thor.thayer@linux.intel.com>
> 
> Thx.
> 

Sorry, I didn't explain this well enough. The patches you have queued 
will fix this for the next 5.5 branch.

This patch should to be applied to the stable branches to fix the issue 
in older branches. Although I knew the To: had to be to 
stable@vger.kernel.org, I wasn't sure how that worked with the EDAC 
reviewers. This was a weird situation where I couldn't fix the upstream 
because it had already been fixed a different way.

Meng sent me the notification and the patch with a SOB so I put Meng 
first in the order.

Sorry for the confusion,

Thor

