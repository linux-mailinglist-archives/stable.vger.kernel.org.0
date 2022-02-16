Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C62BD4B8C34
	for <lists+stable@lfdr.de>; Wed, 16 Feb 2022 16:16:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235455AbiBPPQb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 16 Feb 2022 10:16:31 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:39540 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233873AbiBPPQa (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 16 Feb 2022 10:16:30 -0500
Received: from mga06.intel.com (mga06.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B70F929E953;
        Wed, 16 Feb 2022 07:16:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1645024577; x=1676560577;
  h=message-id:date:mime-version:to:cc:references:from:
   subject:in-reply-to:content-transfer-encoding;
  bh=FHy/9zNLmutb0+uSh1eGvqBbF76nw1m+hfg36Cxc6W4=;
  b=RYzMSfwXPAGHmFQANrkcAaKA97XwkRbEdRkNvM9/GNsr1l52Q/mss6gt
   SlsjVHNKTwqomEpIzvdrDfbp4hR54RHBa5LdIctZ9/VUqi2fGAined5eT
   N3ZGFj5PWfOBvIpHMHQmI6Gs1Ru9GDETrdaL2F7J7lyPV3Ke5Nb7XDyaz
   Ks1S7KWC77G11A9sOLHzxsBDv/YXf30BnwnXEvfnKY5eOEYNWqLrZjGwx
   hQZZ0RBwSRvwKcsE7yOP7HkcmHghJnIe3MkWhj0f3xAUua63vpvnDrBV/
   647YjzJC3FlYUhQ5AtkrbP/PBBO5QexduTrt4fWO2AG/NjYpxrWeRWsBp
   g==;
X-IronPort-AV: E=McAfee;i="6200,9189,10260"; a="311363145"
X-IronPort-AV: E=Sophos;i="5.88,374,1635231600"; 
   d="scan'208";a="311363145"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Feb 2022 07:16:17 -0800
X-IronPort-AV: E=Sophos;i="5.88,374,1635231600"; 
   d="scan'208";a="503061253"
Received: from mjjoshi-mobl.amr.corp.intel.com (HELO [10.209.90.109]) ([10.209.90.109])
  by orsmga002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Feb 2022 07:16:17 -0800
Message-ID: <fc86d51c-7aa2-6379-5f26-ad533c762da3@intel.com>
Date:   Wed, 16 Feb 2022 07:16:13 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Content-Language: en-US
To:     Greg KH <gregkh@linuxfoundation.org>,
        Brian Geffon <bgeffon@google.com>
Cc:     Thomas Gleixner <tglx@linutronix.de>,
        Willis Kung <williskung@google.com>,
        Guenter Roeck <groeck@google.com>,
        Borislav Petkov <bp@suse.de>,
        Andy Lutomirski <luto@kernel.org>,
        "# v4 . 10+" <stable@vger.kernel.org>,
        the arch/x86 maintainers <x86@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
References: <543efc25-9b99-53cd-e305-d8b4d917b64b@intel.com>
 <20220215192233.8717-1-bgeffon@google.com> <YgwCuGcg6adXAXIz@kroah.com>
 <CADyq12wByWhsHNOnokrSwCDeEhPdyO6WNJNjpHE1ORgKwwwXgg@mail.gmail.com>
 <YgzMTrVMCVt+n7cE@kroah.com>
From:   Dave Hansen <dave.hansen@intel.com>
Subject: Re: [PATCH stable 5.4,5.10] x86/fpu: Correct pkru/xstate
 inconsistency
In-Reply-To: <YgzMTrVMCVt+n7cE@kroah.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 2/16/22 02:05, Greg KH wrote:
>>> How was this tested, and what do the maintainers of this subsystem
>>> think?  And will you be around to fix the bugs in this when they are
>>> found?
>> This has been trivial to reproduce, I've used a small repro which I've
>> put here: https://gist.github.com/bgaff/9f8cbfc8dd22e60f9492e4f0aff8f04f
>> , I also was able to reproduce this using the protection_keys self
>> tests on a 11th Gen Core i5-1135G7. I'm happy to commit to addressing
>> any bugs that may appear. I'll see what the maintainers say, but there
>> is also a smaller fix that just involves using this_cpu_read() in
>> switch_fpu_finish() for this specific issue, although that approach
>> isn't as clean.
> Can you add the test to the in-kernel tests so that we make sure it is
> fixed and never comes back?

It would be great if Brian could confirm this.  But, I'm 99% sure that
this can be reproduced in the vm/protection_keys.c selftest, if you run
it for long enough.

The symptom here is corruption of the PKRU register.  I created *lots*
of bugs like this during protection keys development so the selftest
keeps a shadow copy of the register to specifically watch for corruption.

It's _plausible_ that no one ever ran the pkey selftests with a
clang-compiled kernel for long enough to hit this issue.
