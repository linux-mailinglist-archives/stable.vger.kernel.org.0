Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D30884B75C6
	for <lists+stable@lfdr.de>; Tue, 15 Feb 2022 21:48:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235757AbiBORz3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 15 Feb 2022 12:55:29 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:41514 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233741AbiBORz3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 15 Feb 2022 12:55:29 -0500
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 22D5BFEB34;
        Tue, 15 Feb 2022 09:55:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1644947719; x=1676483719;
  h=message-id:date:mime-version:to:cc:references:from:
   subject:in-reply-to:content-transfer-encoding;
  bh=WrTqW/MTMMAtSIFLsehmFFuDfgHFboDGMW3aqd59c2k=;
  b=M+yG+oMi9auL/Ns4gmTwrINxF0zRyZaqQ5QIWIBjfLpzWttCKoDfKh2L
   dnBB+jkfyWFPoAxLpsMNN6AvKDm89TKMFOuAEmUYXl+UtQyOrTAwF51BY
   V/ZE5A7aomIveycfC9oQuTVPlIMYr7x6LI7MMWBGRjdhsOAV5CdnIAJUI
   RnHV+VpGweTday9/dv/dP1xvPmyYoA5hcjr/9OnPpYJzXzNqw2ggLahJ8
   sQVYdnVW+LK9Vvs3E//n1xozX7F6N10E9bGJXN2djT2CaskNyNd0JqED3
   ud7qyxWng/eKL2NDW7/4szNI8yvTrx+g7fkLQzlSQakmiySPmgliYmL8F
   w==;
X-IronPort-AV: E=McAfee;i="6200,9189,10259"; a="274989548"
X-IronPort-AV: E=Sophos;i="5.88,371,1635231600"; 
   d="scan'208";a="274989548"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Feb 2022 09:55:16 -0800
X-IronPort-AV: E=Sophos;i="5.88,371,1635231600"; 
   d="scan'208";a="528990176"
Received: from tngodup-mobl.amr.corp.intel.com (HELO [10.209.32.98]) ([10.209.32.98])
  by orsmga007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Feb 2022 09:55:13 -0800
Message-ID: <543efc25-9b99-53cd-e305-d8b4d917b64b@intel.com>
Date:   Tue, 15 Feb 2022 09:55:09 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Content-Language: en-US
To:     Brian Geffon <bgeffon@google.com>
Cc:     Thomas Gleixner <tglx@linutronix.de>,
        Willis Kung <williskung@google.com>,
        Guenter Roeck <groeck@google.com>,
        Borislav Petkov <bp@suse.de>,
        Andy Lutomirski <luto@kernel.org>,
        "# v4 . 10+" <stable@vger.kernel.org>,
        the arch/x86 maintainers <x86@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
References: <20220215153644.3654582-1-bgeffon@google.com>
 <56fc0ced-d8d2-146f-6ca8-b95bd7e0b4f5@intel.com>
 <CADyq12x2sd4hrfX9XeG7pCbJx8ZHGb9FZo=9G1BavkrAUX7r-g@mail.gmail.com>
From:   Dave Hansen <dave.hansen@intel.com>
Subject: Re: [PATCH] x86/fpu: Correct pkru/xstate inconsistency
In-Reply-To: <CADyq12x2sd4hrfX9XeG7pCbJx8ZHGb9FZo=9G1BavkrAUX7r-g@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_HI,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 2/15/22 09:50, Brian Geffon wrote:
>>> is not a kernel thread as kernel threads will never use PKRU. It's
>>> possible that this_cpu_read_stable() on current_task (ie.
>>> get_current()) is returning an old cached value. By forcing the read
>>> with this_cpu_read() the correct task is used. Without this it's
>>> possible when switching from a kernel thread to a userspace thread
>>> that we'll still observe the PF_KTHREAD flag and never restore the
>>> PKRU. And as a result this issue only occurs when switching from a
>>> kernel thread to a userspace thread, switching from a non kernel
>>> thread works perfectly fine because all we consider in that situation
>>> is the flags from some other non kernel task and the next fpu is
>>> passed in to switch_fpu_finish().
>>
>> It makes *sense* that there would be a place in the context switch code
>> where 'current' is wonky, but I never realized this.  This seems really
>> fragile, but *also* trivially detectable.
>>
>> Is the PKRU code really the only code to use 'current' in a buggy way
>> like this?
> 
> Yes, because the remaining code in __switch_to() references the next
> task as next_p rather than current. Technically, it might be more
> correct to pass next_p to switch_fpu_finish(), what do you think? This
> may make sense since we're also passing the next fpu anyway.

Yeah, passing next_p instead of next_fpu makes a lot of sense to me.

