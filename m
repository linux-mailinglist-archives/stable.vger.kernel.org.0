Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 100D34C0F5A
	for <lists+stable@lfdr.de>; Wed, 23 Feb 2022 10:40:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233156AbiBWJlW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Feb 2022 04:41:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35366 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238560AbiBWJlV (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 23 Feb 2022 04:41:21 -0500
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C3ED45BD0A;
        Wed, 23 Feb 2022 01:40:53 -0800 (PST)
From:   Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1645609251;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=xNvnPnCpT9O1x7W+FCLzsXogbMkkom8B4NtjL9EQYWE=;
        b=v3d7r6XaE8O02Vw0Fg1n+35vYWWt7Te13DPbCNXzgwLoeSuGpgLRPqmfXJyX9v0fVaOYO6
        VNc+E6+oGyWiJPGUd938SmolIRGhXxPB3ngDgDjdqVzK/YYpLYcVrBNok6kO6NWhQvwciB
        Qtd04rALEzN5fQAgdGHrAMgKlumak3PHZ3cowMVYwYoluzJgFXJ19dgYNvtoQZyd9qcZDs
        Y5pW6nD2Y7DVEG69eK75R8D3xRuNbDh/U+2sXacFL5KEeDVQCAMGR+gj+38kevAXseMo3R
        cTUKVKrwVQb+1azFjKRg3x90ptyRa9m5D1NhGfOR5vBggXId8+L/JYAM9Fthyg==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1645609251;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=xNvnPnCpT9O1x7W+FCLzsXogbMkkom8B4NtjL9EQYWE=;
        b=b7cHkAXQKZ0D/4G0SSNUOBKHQeacxVvj2DHMU4Fao/VvmWRUqFewZi6d+LTwzs+9ohoE/r
        5uk0F4DzpFurc/DA==
To:     "Rafael J. Wysocki" <rafael@kernel.org>,
        Feng Tang <feng.tang@intel.com>
Cc:     srinivas pandruvada <srinivas.pandruvada@linux.intel.com>,
        Doug Smythies <dsmythies@telus.net>,
        "Zhang, Rui" <rui.zhang@intel.com>,
        "paulmck@kernel.org" <paulmck@kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>
Subject: Re: CPU excessively long times between frequency scaling driver
 calls - bisected
In-Reply-To: <CAJZ5v0iXQ=qXiZoF_qb1hdBh=yfZ13-of3y3LFu2m6gZh9peTw@mail.gmail.com>
References: <003f01d81c8c$d20ee3e0$762caba0$@telus.net>
 <20220208023940.GA5558@shbuild999.sh.intel.com>
 <CAAYoRsXrwOQgzAcED+JfVG0=JQNEXuyGcSGghL4Z5xnFgkp+TQ@mail.gmail.com>
 <20220208091525.GA7898@shbuild999.sh.intel.com>
 <CAAYoRsXkyWf0vmEE2HvjF6pzCC4utxTF=7AFx1PJv4Evh=C+Ow@mail.gmail.com>
 <e185b89fb97f47758a5e10239fc3eed0@intel.com>
 <CAAYoRsXbBJtvJzh91nTXATLL1eb2EKbTVb8vEWa3Y6DfCWhZeg@mail.gmail.com>
 <aaace653f12b79336b6f986ef5c4f9471445372a.camel@linux.intel.com>
 <20220222073435.GB78951@shbuild999.sh.intel.com>
 <CAJZ5v0iXQ=qXiZoF_qb1hdBh=yfZ13-of3y3LFu2m6gZh9peTw@mail.gmail.com>
Date:   Wed, 23 Feb 2022 10:40:50 +0100
Message-ID: <87ley1j4yl.ffs@tglx>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Rafael,

On Tue, Feb 22 2022 at 19:04, Rafael J. Wysocki wrote:
> On Tue, Feb 22, 2022 at 8:41 AM Feng Tang <feng.tang@intel.com> wrote:
>> There is periodic activity in between, related to active load balancing
>> in scheduler (since last frequency was higher these small work will
>> also run at higher frequency). But those threads are not CFS class, so
>> scheduler callback will not be called for them.
>>
>> So removing the patch removed a trigger which would have caused a
>> sched_switch to a CFS task and call a cpufreq/intel_pstate callback.
>
> And so this behavior needs to be restored for the time being which
> means reverting the problematic commit for 5.17 if possible.

No. This is just papering over the problem. Just because the clocksource
watchdog has the side effect of making cpufreq "work", does not make it
a prerequisite for cpufreq. The commit unearthed a problem in the
cpufreq code, so it needs to be fixed there.

Even if we'd revert it then, you can produce the same effect by adding
'tsc=reliable' to the kernel command line which disables the clocksource
watchdog too. The commit is there to deal with modern hardware without
requiring people to add 'tsc=reliable' to the command line.

Thanks,

        tglx
