Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4CFE163D66E
	for <lists+stable@lfdr.de>; Wed, 30 Nov 2022 14:16:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235626AbiK3NQk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 30 Nov 2022 08:16:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53942 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232519AbiK3NQi (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 30 Nov 2022 08:16:38 -0500
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0BE7556D4B;
        Wed, 30 Nov 2022 05:16:38 -0800 (PST)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out2.suse.de (Postfix) with ESMTP id BE7B21F8D4;
        Wed, 30 Nov 2022 13:16:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1669814196; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=InTVSiPNY3KgtbrUipVQFtm2qipHlsJxEeslMAjnJJE=;
        b=BHU3Y2gSx5A154Ec4LapeBDMjO30vp7ImX6Pe0CIiWmpCzBx36Rav8CtnBHvJ9o09Iy2Sh
        Eh5nxlF5Mi4lyF03rytpUKZ406LvN4ozuj3q0AkmlWC/P65NwZoBsAby16H3WFAXpkQIjf
        Cjx2ulVvezXsLbJ6m5oMv98KyGPCE9w=
Received: from suse.cz (unknown [10.100.208.146])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by relay2.suse.de (Postfix) with ESMTPS id 9DCDA2C14F;
        Wed, 30 Nov 2022 13:16:35 +0000 (UTC)
Date:   Wed, 30 Nov 2022 14:16:32 +0100
From:   Petr Mladek <pmladek@suse.com>
To:     David Laight <David.Laight@aculab.com>
Cc:     'Petr Pavlu' <petr.pavlu@suse.com>,
        "mcgrof@kernel.org" <mcgrof@kernel.org>,
        "prarit@redhat.com" <prarit@redhat.com>,
        "david@redhat.com" <david@redhat.com>,
        "mwilck@suse.com" <mwilck@suse.com>,
        "linux-modules@vger.kernel.org" <linux-modules@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: Re: [PATCH] module: Don't wait for GOING modules
Message-ID: <Y4dXsNKve02fGGEl@alley>
References: <20221123131226.24359-1-petr.pavlu@suse.com>
 <Y348QNmO2AHh3eNr@alley>
 <a26ed87f-9e4c-7c1f-515b-edaaff9140fd@suse.com>
 <8224e68169eb49ec9866c253be84b09b@AcuMS.aculab.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8224e68169eb49ec9866c253be84b09b@AcuMS.aculab.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun 2022-11-27 11:21:45, David Laight wrote:
> From: Petr Pavlu
> > Sent: 26 November 2022 14:43
> > 
> > On 11/23/22 16:29, Petr Mladek wrote:
> > > On Wed 2022-11-23 14:12:26, Petr Pavlu wrote:
> > >> During a system boot, it can happen that the kernel receives a burst of
> > >> requests to insert the same module but loading it eventually fails
> > >> during its init call. For instance, udev can make a request to insert
> > >> a frequency module for each individual CPU when another frequency module
> > >> is already loaded which causes the init function of the new module to
> > >> return an error.
> > >>
> > >> Since commit 6e6de3dee51a ("kernel/module.c: Only return -EEXIST for
> > >> modules that have finished loading"), the kernel waits for modules in
> > >> MODULE_STATE_GOING state to finish unloading before making another
> > >> attempt to load the same module.
> > >>
> > >> This creates unnecessary work in the described scenario and delays the
> > >> boot. In the worst case, it can prevent udev from loading drivers for
> > >> other devices and might cause timeouts of services waiting on them and
> > >> subsequently a failed boot.
> > >>
> > >> This patch attempts a different solution for the problem 6e6de3dee51a
> > >> was trying to solve. Rather than waiting for the unloading to complete,
> > >> it returns a different error code (-EBUSY) for modules in the GOING
> > >> state. This should avoid the error situation that was described in
> > >> 6e6de3dee51a (user space attempting to load a dependent module because
> > >> the -EEXIST error code would suggest to user space that the first module
> > >> had been loaded successfully), while avoiding the delay situation too.
> > >>
> 
> While people have all this code cached in their brains
> there is related problem I can easily hit.
> 
> If two processes create sctp sockets at the same time and sctp
> module has to be loaded then the second process can enter the
> module code before is it fully initialised.
> This might be because the try_module_get() succeeds before the
> module initialisation function returns.

Right, the race is there. And it is true that nobody should use
the module until mod->init() succeeds.

Well, I am not sure if there is an easy solution. It might require
reviewing what all try_module_get() callers expect.

We could not easily wait. For example, __sock_create() calls
try_module_get() under rcu_read_lock().

And various callers might want special handing when the module
is coming, going, and when it is not there at all.

I guess that it would require adding some new API and update
the various callers.

> I've avoided the issue by ensuring the socket creates are serialised.

I see. It would be great to have a clean solution, definitely.

Sigh, there are more issues with the module life time. For example,
kobjects might call the release() callback asynchronously and
it might happen when the module/code has gone, see
https://lore.kernel.org/all/20211105063710.4092936-1-ming.lei@redhat.com/

Best Regards,
PEtr
