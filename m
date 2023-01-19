Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DB95B673DE0
	for <lists+stable@lfdr.de>; Thu, 19 Jan 2023 16:48:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231390AbjASPsO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 Jan 2023 10:48:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45608 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231391AbjASPrz (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 19 Jan 2023 10:47:55 -0500
Received: from smtp-out2.suse.de (smtp-out2.suse.de [IPv6:2001:67c:2178:6::1d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E5428875A;
        Thu, 19 Jan 2023 07:47:10 -0800 (PST)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out2.suse.de (Postfix) with ESMTP id A54C05CFD5;
        Thu, 19 Jan 2023 15:47:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1674143228; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=hHqpVN9DzGS4tivxMt2BcVTb/csx+XiOhf00+x8+hOQ=;
        b=pVn6jVVMaKAA8cvLkiEttUC+gaYWNhHFk/VjjM8sry2zNYG7bwASTceiNcUgn+lGP5nVuu
        4yGoDUB6axJxsGzBzfPOmOJ1f1Xay943KMsd3DPHdKJ5zh4oZWRmlSNal9sFlvqAk7fzrA
        oT0Xnau8jEhtnQnqxYhsWkpcIwXIW6Q=
Received: from suse.cz (unknown [10.100.201.202])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by relay2.suse.de (Postfix) with ESMTPS id 2C1D52C141;
        Thu, 19 Jan 2023 15:47:08 +0000 (UTC)
Date:   Thu, 19 Jan 2023 16:47:05 +0100
From:   Petr Mladek <pmladek@suse.com>
To:     Petr Pavlu <petr.pavlu@suse.com>
Cc:     Luis Chamberlain <mcgrof@kernel.org>,
        Prarit Bhargava <prarit@redhat.com>,
        Vegard Nossum <vegard.nossum@oracle.com>,
        Borislav Petkov <bp@alien8.de>, NeilBrown <neilb@suse.de>,
        Goldwyn Rodrigues <rgoldwyn@suse.com>, david@redhat.com,
        mwilck@suse.com, linux-modules@vger.kernel.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH v2] module: Don't wait for GOING modules
Message-ID: <Y8ll+eP+fb0TzFUh@alley>
References: <20221205103557.18363-1-petr.pavlu@suse.com>
 <Y5gI/3crANzRv22J@bombadil.infradead.org>
 <Y5hRRnBGYaPby/RS@alley>
 <Y8c3hgVwKiVrKJM1@bombadil.infradead.org>
 <79aad139-5305-1081-8a84-42ef3763d4f4@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <79aad139-5305-1081-8a84-42ef3763d4f4@suse.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed 2023-01-18 16:12:05, Petr Pavlu wrote:
> On 1/18/23 01:04, Luis Chamberlain wrote:
> > On Tue, Dec 13, 2022 at 11:17:42AM +0100, Petr Mladek wrote:
> >> On Mon 2022-12-12 21:09:19, Luis Chamberlain wrote:
> >>> 3) *Fixing* a kernel regression by adding new expected API for testing
> >>> against -EBUSY seems not ideal.
> >>
> >> IMHO, the right solution is to fix the subsystems so that they send
> >> only one uevent.
> > 
> > Makes sense, but that can take time and some folks are stuck on old kernels
> > and perhaps porting fixes for this on subsystems may take time to land
> > to some enterprisy kernels. And then there is also systemd that issues
> > the requests too, at least that was reflected in commit 6e6de3dee51a
> > ("kernel/module.c: Only return -EEXIST for modules that have finished loading")
> > that commit claims it was systemd issueing the requests which I mean to
> > interpret finit_module(), not calling modprobe.
> > 
> > The rationale for making a regression fix with a new userspace return value
> > is fair given the old fix made things even much worse the point some kernel
> > boots would fail. So the rationale to suggest we *must* short-cut
> > parallel loads as effectively as possible seems sensible *iff* that
> > could not make things worse too but sadly I've found an isssue
> > proactively with this fix, or at least that this issue is also not fixed:
> > 
> > ./tools/testing/selftests/kmod/kmod.sh -t 0006
> > Tue Jan 17 23:18:13 UTC 2023
> > Running test: kmod_test_0006 - run #0
> > kmod_test_0006: OK! - loading kmod test
> > kmod_test_0006: FAIL, test expects SUCCESS (0) - got -EINVAL (-22)
> > ----------------------------------------------------
> > Custom trigger configuration for: test_kmod0
> > Number of threads:      50
> > Test_case:      TEST_KMOD_FS_TYPE (2)
> > driver: test_module
> > fs:     xfs
> > ----------------------------------------------------
> > Test completed
> > 
> > When can multiple get_fs_type() calls be issued on a system? When
> > mounting a large number of filesystems.

This patch should not change the behavior that much. The parallel
load still waits until the pending one finishes.

The difference is that it does not try to load it once again.
But when the first load fails then something is broken anyway.

I could imagine that this could cause regression from the user POV
when the first failure is not important from some reasons. But
it means that the things work only by chance and the problem
might hit the user later anyway.

Another difference is that the parallel load finishes immediately
also when it sees a going module. But it should not affect that
much the multiple get_fs_type() calls. They are all trying
to load the module.


> Sadly though this issue seems
> > to have gone unnoticed for a while now. Even reverting commit
> > 6e6de3dee51a doesn't fix it, and I've run into issues with trying
> > to bisect, first due to missing Kees' patch which fixes a compiler
> > failure on older kernel [0] and now I'm seeing this while trying to
> > build v5.1:
> > 
> > ld: arch/x86/boot/compressed/pgtable_64.o:(.bss+0x0): multiple definition of `__force_order';
> > arch/x86/boot/compressed/kaslr_64.o:(.bss+0x0): first defined here
> > ld: warning: arch/x86/boot/compressed/efi_thunk_64.o: missing .note.GNU-stack section implies executable stack
> > ld: NOTE: This behaviour is deprecated and will be removed in a future version of the linker
> > ld: arch/x86/boot/compressed/head_64.o: warning: relocation in read-only section `.head.text'
> > ld: warning: arch/x86/boot/compressed/vmlinux has a LOAD segment with RWX permissions
> > ld: warning: creating DT_TEXTREL in a PIE
> > make[2]: *** [arch/x86/boot/compressed/Makefile:118: arch/x86/boot/compressed/vmlinux] Error 1
> > make[1]: *** [arch/x86/boot/Makefile:112: arch/x86/boot/compressed/vmlinux] Error 2
> > make: *** [arch/x86/Makefile:283: bzImage] Error 2
> > 
> > [0] http://lore.kernel.org/lkml/20220213182443.4037039-1-keescook@chromium.org
> > 
> > But we should try to bisect to see what cauased the above kmod test 0006
> > to start failing.
> 
> It is not clear to me from your description if the observed failure of
> kmod_test_0006 is related to the fix in this thread.
> 
> The problem was not possible for me to reproduce on my system. My test was on
> an 8-CPU x86_64 machine using v6.2-rc4 with "defconfig + kvm_guest.config +
> tools/testing/selftests/kmod/config".

I can't reproduce it either. I guess that it needs some "good" timing,
probably more CPUs or so.

I wonder if it races with module -r that removes the module before
it tries to load it multiple times in parallel.

Does the test pass when you add sleep after the module -r, like this:

diff --git a/tools/testing/selftests/kmod/kmod.sh b/tools/testing/selftests/kmod/kmod.sh
index 7189715d7960..8a020f90a3f6 100755
--- a/tools/testing/selftests/kmod/kmod.sh
+++ b/tools/testing/selftests/kmod/kmod.sh
@@ -322,6 +322,7 @@ kmod_defaults_fs()
 {
 	config_reset
 	modprobe -r $DEFAULT_KMOD_FS
+	sleep 1
 	config_set_fs $DEFAULT_KMOD_FS
 	config_set_test_case_fs
 }



> Could you perhaps trace the test to determine where the EINVAL value comes
> from?

Yes, the -EINVAL error is strange. It is returned also in
kernel/module/main.c on few locations. But neither of them
looks like a good candidate.

My assumption is that it is more likely returned by the module_init()
callback from the loaded module. But it is just a guess and I might be wrong.

I wonder if it is cause by a delayed release of some resources,
when the module is removed, e.g. sysfs or so. It might theoretically
cause conflict when they still exist and the reloaded module
tries to create them again.

Best Regards,
Petr
