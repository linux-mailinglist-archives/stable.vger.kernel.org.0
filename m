Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 16664670EB7
	for <lists+stable@lfdr.de>; Wed, 18 Jan 2023 01:36:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229447AbjARAgz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Jan 2023 19:36:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34994 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229748AbjARAgW (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 17 Jan 2023 19:36:22 -0500
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 23AD363E09;
        Tue, 17 Jan 2023 16:04:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=ZR/zKwfuyZJZgDgsd6BVo1jA66dvTFg1Bvt4qava1GI=; b=UVsJC/C/0DlAjRBsSx0O4LO/9K
        zfqrBGJVi+zP+o2CiMGAUhwfudn1gdDNr1lthRcO6QzWO3AYPIjxnMQJYSQwSsP3Mdnypxa+bk1Mx
        DjBGJWQjcjz/vSU5viO1PykJOQBy9L3ej3vr3npvlr/dhXa8Ea2+liFQwKo5WelkfDnnXjh95w6ZK
        J/hVMFZBSCwfXXw+rDLENPtXqGpWCFhyDueqtdTNhHlnDkVp8zGRQjtVc6Xbifj2XoFZtGpGGmgbD
        cmFFPPHAEwTYhVN9bdGY7Wjm3yL/WSh94cc+IJrOzauxbvcAt/IYf0jUWKpr+DtXPDlMy6I2wqR8F
        wY5aU8Jw==;
Received: from mcgrof by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1pHvwE-00GJGD-Mn; Wed, 18 Jan 2023 00:04:22 +0000
Date:   Tue, 17 Jan 2023 16:04:22 -0800
From:   Luis Chamberlain <mcgrof@kernel.org>
To:     Petr Mladek <pmladek@suse.com>,
        Prarit Bhargava <prarit@redhat.com>,
        Vegard Nossum <vegard.nossum@oracle.com>,
        Borislav Petkov <bp@alien8.de>, NeilBrown <neilb@suse.de>,
        Goldwyn Rodrigues <rgoldwyn@suse.com>
Cc:     Petr Pavlu <petr.pavlu@suse.com>, david@redhat.com,
        mwilck@suse.com, linux-modules@vger.kernel.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH v2] module: Don't wait for GOING modules
Message-ID: <Y8c3hgVwKiVrKJM1@bombadil.infradead.org>
References: <20221205103557.18363-1-petr.pavlu@suse.com>
 <Y5gI/3crANzRv22J@bombadil.infradead.org>
 <Y5hRRnBGYaPby/RS@alley>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y5hRRnBGYaPby/RS@alley>
Sender: Luis Chamberlain <mcgrof@infradead.org>
X-Spam-Status: No, score=-4.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Dec 13, 2022 at 11:17:42AM +0100, Petr Mladek wrote:
> On Mon 2022-12-12 21:09:19, Luis Chamberlain wrote:
> > On Mon, Dec 05, 2022 at 11:35:57AM +0100, Petr Pavlu wrote:
> > > diff --git a/kernel/module/main.c b/kernel/module/main.c
> > > index d02d39c7174e..7a627345d4fd 100644
> > > --- a/kernel/module/main.c
> > > +++ b/kernel/module/main.c
> > > @@ -2386,7 +2386,8 @@ static bool finished_loading(const char *name)
> > >  	sched_annotate_sleep();
> > >  	mutex_lock(&module_mutex);
> > >  	mod = find_module_all(name, strlen(name), true);
> > > -	ret = !mod || mod->state == MODULE_STATE_LIVE;
> > > +	ret = !mod || mod->state == MODULE_STATE_LIVE
> > > +		|| mod->state == MODULE_STATE_GOING;
> > >  	mutex_unlock(&module_mutex);
> > >  
> > >  	return ret;
> > > @@ -2562,20 +2563,35 @@ static int add_unformed_module(struct module *mod)
> > >  
> > >  	mod->state = MODULE_STATE_UNFORMED;
> > >  
> > > -again:
> > 
> > So this is part of my biggest concern for regression, the removal of
> > this tag and its use.
> > 
> > Before this we always looped back to trying again and again.
> 
> Just to be sure that we are on the same page.
> 
> The loop was _not_ infinite. It serialized all attempts to load
> the same module. In our case, it serialized all failures and
> prolonged the pain.

That's fair yes. The loop happens so long as an already existing module is
present with the same name.

> > >  	mutex_lock(&module_mutex);
> > >  	old = find_module_all(mod->name, strlen(mod->name), true);
> > >  	if (old != NULL) {
> > > -		if (old->state != MODULE_STATE_LIVE) {
> > > +		if (old->state == MODULE_STATE_COMING
> > > +		    || old->state == MODULE_STATE_UNFORMED) {
> > >  			/* Wait in case it fails to load. */
> > >  			mutex_unlock(&module_mutex);
> > >  			err = wait_event_interruptible(module_wq,
> > >  					       finished_loading(mod->name));
> > >  			if (err)
> > >  				goto out_unlocked;
> > > -			goto again;
> > 
> > We essentially bound this now, and before we didn't.
> > 
> > Yes we we wait for finished_loading() of the module -- but if udev is
> > hammering tons of same requests, well, we *will* surely hit this, as
> > many requests managed to get in before userspace saw the module present.
> > 
> > While this typically can be useful, it means *quite a bit* of conditions which
> > definitely *did* happen before will now *bail out* fast, to the extent
> > that I'm not even sure why we just re-try once now.
> 
> I do not understand this. We do _not_ re-try the load in the new
> version. We just wait for the result of the parallel attempt to
> load the module.
> 
> Maybe, you are confused that we repeat find_module_all(). But it is
> the way how to find the result of the parallel load.

My point is that prior to the buggy commit 6e6de3dee51a ("kernel/module.c: Only
return -EEXIST for modules that have finished loading") and even after that
commit it we 'goto again' if an old request is found. We now simply bound this
right away. Yes, the loop was not infinite, but in theory at least a few
iterations were possible before whereas now immediately return -EBUSY
and I don't think all use cases may be ready yet.

> > If we're going to 
> > just re-check *once* why not do something graceful like *at least*
> > cond_resched() to let the system breathe for a *tiny bit*.
> 
> We must check the result under module_mutex. We have to take this
> sleeping lock. There is actually a rescheduling. I do not think that
> cond_resched() would do any difference.

Makes sense.

> > > +
> > > +			/* The module might have gone in the meantime. */
> > > +			mutex_lock(&module_mutex);
> > > +			old = find_module_all(mod->name, strlen(mod->name),
> > > +					      true);
> > >  		}
> > > -		err = -EEXIST;
> > > +
> > > +		/*
> > > +		 * We are here only when the same module was being loaded. Do
> > > +		 * not try to load it again right now. It prevents long delays
> > > +		 * caused by serialized module load failures. It might happen
> > > +		 * when more devices of the same type trigger load of
> > > +		 * a particular module.
> > > +		 */
> > > +		if (old && old->state == MODULE_STATE_LIVE)
> > > +			err = -EEXIST;
> > > +		else
> > > +			err = -EBUSY;
> > 
> > And for all those use cases we end up here now, with -EBUSY. So udev
> > before was not bounded, and kept busy-looping on the retry in-kernel,
> > and we now immediately bound its condition to just 2 tries to see if the
> > old module existed and now *return* a new value to userspace.
> > 
> > My main concerns are:
> > 
> > 0) Why not use cond_resched() if we're just going to check twice?
> 
> We take module_mutex. It should cause even bigger delay than cond_resched().

ACK.

> > 1) How are we sure we are not regressing userspace by removing the boundless
> > loop there? (even if the endless loop was stupid)
> 
> We could not be sure. On the other hand, if more attempts help to load
> the module then it is racy and not reliable. The new approach would
> make it better reproducible and fix the race.

Yes, but the short cut it is a userspace visible change.

> > 2) How is it we expect that we won't resgress userspace now by bounding
> > that check and pretty much returning -EBUSY right away? This last part
> > seems dangerous, in that if userspace did not expect -EBUSY and if an
> > error before caused a module to fail and fail boot, why wouldn't we fail
> > boot now by bailing out faster??
> 
> Same answer as for 1)
> 
> 
> > 3) *Fixing* a kernel regression by adding new expected API for testing
> > against -EBUSY seems not ideal.
> 
> IMHO, the right solution is to fix the subsystems so that they send
> only one uevent.

Makes sense, but that can take time and some folks are stuck on old kernels
and perhaps porting fixes for this on subsystems may take time to land
to some enterprisy kernels. And then there is also systemd that issues
the requests too, at least that was reflected in commit 6e6de3dee51a
("kernel/module.c: Only return -EEXIST for modules that have finished loading")
that commit claims it was systemd issueing the requests which I mean to
interpret finit_module(), not calling modprobe.

The rationale for making a regression fix with a new userspace return value
is fair given the old fix made things even much worse the point some kernel
boots would fail. So the rationale to suggest we *must* short-cut
parallel loads as effectively as possible seems sensible *iff* that
could not make things worse too but sadly I've found an isssue
proactively with this fix, or at least that this issue is also not fixed:

./tools/testing/selftests/kmod/kmod.sh -t 0006
Tue Jan 17 23:18:13 UTC 2023
Running test: kmod_test_0006 - run #0
kmod_test_0006: OK! - loading kmod test
kmod_test_0006: FAIL, test expects SUCCESS (0) - got -EINVAL (-22)
----------------------------------------------------
Custom trigger configuration for: test_kmod0
Number of threads:      50
Test_case:      TEST_KMOD_FS_TYPE (2)
driver: test_module
fs:     xfs
----------------------------------------------------
Test completed

When can multiple get_fs_type() calls be issued on a system? When
mounting a large number of filesystems. Sadly though this issue seems
to have gone unnoticed for a while now. Even reverting commit
6e6de3dee51a doesn't fix it, and I've run into issues with trying
to bisect, first due to missing Kees' patch which fixes a compiler
failure on older kernel [0] and now I'm seeing this while trying to
build v5.1:

ld: arch/x86/boot/compressed/pgtable_64.o:(.bss+0x0): multiple definition of `__force_order';
arch/x86/boot/compressed/kaslr_64.o:(.bss+0x0): first defined here
ld: warning: arch/x86/boot/compressed/efi_thunk_64.o: missing .note.GNU-stack section implies executable stack
ld: NOTE: This behaviour is deprecated and will be removed in a future version of the linker
ld: arch/x86/boot/compressed/head_64.o: warning: relocation in read-only section `.head.text'
ld: warning: arch/x86/boot/compressed/vmlinux has a LOAD segment with RWX permissions
ld: warning: creating DT_TEXTREL in a PIE
make[2]: *** [arch/x86/boot/compressed/Makefile:118: arch/x86/boot/compressed/vmlinux] Error 1
make[1]: *** [arch/x86/boot/Makefile:112: arch/x86/boot/compressed/vmlinux] Error 2
make: *** [arch/x86/Makefile:283: bzImage] Error 2

[0] http://lore.kernel.org/lkml/20220213182443.4037039-1-keescook@chromium.org

But we should try to bisect to see what cauased the above kmod test 0006
to start failing.

> The question is how the module loader would deal with "broken"
> subsystems. Petr Pavlu, please, fixme. I think that there are
> more subsystems doing this ugly thing.
> 
> I personally thing that returning -EBUSY is better than serializing
> all the loads. It makes eventual problem easier to reproduce and fix.

I agree with this assessment, however given the multiple get_fs_type()
calls as an example, I am not sure if there are other areas which rely on the
old busy-wait mechanism.

*If* we knew this issue was not so common I'd go so far as to say we
should pr_warn_once() on failure, but at this point in time I think it'd
be pretty chatty.

I don't yet have confidence that the new fast track to -EXIST or -EBUSY may
not create regressions, so the below I think would be too chatty. If it
wasn't true, I'd say we should keep record of these uses so we fix the
callers.

diff --git a/kernel/module/main.c b/kernel/module/main.c
index d3be89de706d..d1ad0b510cb8 100644
--- a/kernel/module/main.c
+++ b/kernel/module/main.c
@@ -2589,13 +2589,6 @@ static int add_unformed_module(struct module *mod)
 					      true);
 		}
 
-		/*
-		 * We are here only when the same module was being loaded. Do
-		 * not try to load it again right now. It prevents long delays
-		 * caused by serialized module load failures. It might happen
-		 * when more devices of the same type trigger load of
-		 * a particular module.
-		 */
 		if (old && old->state == MODULE_STATE_LIVE)
 			err = -EEXIST;
 		else
@@ -2610,6 +2603,15 @@ static int add_unformed_module(struct module *mod)
 out:
 	mutex_unlock(&module_mutex);
 out_unlocked:
+	/*
+	 * We get an error here only when there is an attempt to load the
+	 * same module. Subsystems should strive to only issue one request
+	 * for a needed module. Multiple requests might happen when more devices
+	 * of the same type trigger load of a particular module.
+	 */
+	if (err)
+		pr_warn_once("%: dropping duplicate module request, err: %d\n",
+			     mod->name, err);
 	return err;
 }
 

  Luis
