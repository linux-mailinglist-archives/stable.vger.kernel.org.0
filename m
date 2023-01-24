Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 24A9E67A37A
	for <lists+stable@lfdr.de>; Tue, 24 Jan 2023 20:59:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229872AbjAXT7a (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 Jan 2023 14:59:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56800 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230334AbjAXT70 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 24 Jan 2023 14:59:26 -0500
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E24316199;
        Tue, 24 Jan 2023 11:59:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=qIm8wL36iwpoekk73rrv9Q8YomfdW/WTpB+Pvm9Jxvc=; b=F014UayJlOj/pwPT/DRgjdfDgq
        TwaOLkTiFaKdBzt4ig39IBADYQ9AgQ9oeT+6Tazls5bs/h4fT95HT94bmyLTD1jzf8hUR3Z3hbzXB
        toE8TLnsV1TG2S3CuiSb+wir0wEm2bb/b+w/J6m+Oz3/1eY68/PJ9aCih/KEipiM55FRUdAjTnaSH
        otX5Zl1SGKlt1PVyRuNbjIN5X+YvLTX+Tk4F5e5Kco69ZXEGJENMAvKyCRSBnDI5aV1YutBjU9mMg
        srvt3F47BMhzjX6ii16t+boiVlkZ5EUIwo9JniFNxEFhTfBFDVFTlCEgvvAjj+SeYqZapL6xNPDyb
        vkvZ6m9g==;
Received: from mcgrof by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1pKPRW-0057vV-4v; Tue, 24 Jan 2023 19:58:54 +0000
Date:   Tue, 24 Jan 2023 11:58:54 -0800
From:   Luis Chamberlain <mcgrof@kernel.org>
To:     Petr Mladek <pmladek@suse.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        David Hildenbrand <david@redhat.com>,
        Davidlohr Bueso <dave@stgolabs.net>
Cc:     Petr Pavlu <petr.pavlu@suse.com>,
        Prarit Bhargava <prarit@redhat.com>,
        Vegard Nossum <vegard.nossum@oracle.com>,
        Borislav Petkov <bp@alien8.de>, NeilBrown <neilb@suse.de>,
        Goldwyn Rodrigues <rgoldwyn@suse.com>, david@redhat.com,
        Adam Manzanares <a.manzanares@samsung.com>, mwilck@suse.com,
        linux-modules@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH v2] module: Don't wait for GOING modules
Message-ID: <Y9A4fiobL6IHp//P@bombadil.infradead.org>
References: <20221205103557.18363-1-petr.pavlu@suse.com>
 <Y5gI/3crANzRv22J@bombadil.infradead.org>
 <Y5hRRnBGYaPby/RS@alley>
 <Y8c3hgVwKiVrKJM1@bombadil.infradead.org>
 <79aad139-5305-1081-8a84-42ef3763d4f4@suse.com>
 <Y8ll+eP+fb0TzFUh@alley>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y8ll+eP+fb0TzFUh@alley>
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

On Thu, Jan 19, 2023 at 04:47:05PM +0100, Petr Mladek wrote:
> I wonder if it races with module -r that removes the module before
> it tries to load it multiple times in parallel.
> 
> Does the test pass when you add sleep after the module -r, like this:
> 
> diff --git a/tools/testing/selftests/kmod/kmod.sh b/tools/testing/selftests/kmod/kmod.sh
> index 7189715d7960..8a020f90a3f6 100755
> --- a/tools/testing/selftests/kmod/kmod.sh
> +++ b/tools/testing/selftests/kmod/kmod.sh
> @@ -322,6 +322,7 @@ kmod_defaults_fs()
>  {
>  	config_reset
>  	modprobe -r $DEFAULT_KMOD_FS
> +	sleep 1
>  	config_set_fs $DEFAULT_KMOD_FS
>  	config_set_test_case_fs
>  }

FWIW I was curious if the kmod test 0009.sh now could pass with this
too, but alas it can sometimes fail too.

[  138.590663] misc test_kmod0: reset
[  139.729273] misc test_kmod0: Test case: TEST_KMOD_FS_TYPE (2)
[  139.732874] misc test_kmod0: Test filesystem to load: xfs
[  139.736230] misc test_kmod0: Number of threads to run: 62
[  139.739575] misc test_kmod0: Thread IDs will range from 0 - 61
[  140.402079] __request_module: 2 callbacks suppressed
[  140.402082] request_module: kmod_concurrent_max (0) close to 0 (max_modprobes: 50), for module fs-xfs, throttling...
[  140.418075] request_module: kmod_concurrent_max (0) close to 0 (max_modprobes: 50), for module fs-xfs, throttling...
[  140.430124] request_module: kmod_concurrent_max (0) close to 0 (max_modprobes: 50), for module fs-xfs, throttling...
[  140.450119] request_module: kmod_concurrent_max (0) close to 0 (max_modprobes: 50), for module fs-xfs, throttling...
[  140.478037] request_module: kmod_concurrent_max (0) close to 0 (max_modprobes: 50), for module fs-xfs, throttling...
[  140.498080] request_module: kmod_concurrent_max (0) close to 0 (max_modprobes: 50), for module fs-xfs, throttling...
[  140.518066] request_module: kmod_concurrent_max (0) close to 0 (max_modprobes: 50), for module fs-xfs, throttling...
[  140.530207] request_module: kmod_concurrent_max (0) close to 0 (max_modprobes: 50), for module fs-xfs, throttling...
[  140.549949] request_module: kmod_concurrent_max (0) close to 0 (max_modprobes: 50), for module fs-xfs, throttling...
[  140.562182] request_module: kmod_concurrent_max (0) close to 0 (max_modprobes: 50), for module fs-xfs, throttling...
[  140.582342] misc test_kmod0: No errors were found while initializing threads
[  145.385414] SGI XFS with ACLs, security attributes, realtime, quota, no debug enabled
[  145.461962] request_module: modprobe fs-xfs cannot be processed, kmod busy with 50 threads for more than 5 seconds now
[  145.652541] misc test_kmod0: Done: 62 threads have all run now
[  145.655020] misc test_kmod0: Last thread to run: 39
[  145.655831] misc test_kmod0: Results:
[  145.656450] misc test_kmod0: Sync thread 0 fs: xfs
[  145.657164] misc test_kmod0: Sync thread 1 fs: xfs
[  145.657875] misc test_kmod0: Sync thread 2 fs: xfs
[  145.658615] misc test_kmod0: Sync thread 3 fs: xfs
[  145.659324] misc test_kmod0: Sync thread 4 fs: xfs
[  145.660026] misc test_kmod0: Sync thread 5 fs: xfs
[  145.660948] misc test_kmod0: Sync thread 6 fs: xfs
[  145.661870] misc test_kmod0: Sync thread 7 fs: xfs
[  145.662625] misc test_kmod0: Sync thread 8 fs: xfs
[  145.663363] misc test_kmod0: Sync thread 9 fs: xfs
[  145.664073] misc test_kmod0: Sync thread 10 fs: xfs
[  145.664791] misc test_kmod0: Sync thread 11 fs: xfs
[  145.665509] misc test_kmod0: Sync thread 12 fs: xfs
[  145.666252] misc test_kmod0: Sync thread 13 fs: xfs
[  145.666971] misc test_kmod0: Sync thread 14 fs: xfs
[  145.667693] misc test_kmod0: Sync thread 15 fs: xfs
[  145.668405] misc test_kmod0: Sync thread 16 fs: xfs
[  145.669113] misc test_kmod0: Sync thread 17 fs: xfs
[  145.669823] misc test_kmod0: Sync thread 18 fs: xfs
[  145.670634] misc test_kmod0: Sync thread 19 fs: xfs
[  145.671390] misc test_kmod0: Sync thread 20 fs: xfs
[  145.672126] misc test_kmod0: Sync thread 21 fs: xfs
[  145.672842] misc test_kmod0: Sync thread 22 fs: xfs
[  145.673561] misc test_kmod0: Sync thread 23 fs: xfs
[  145.674327] misc test_kmod0: Sync thread 24 fs: xfs
[  145.675051] misc test_kmod0: Sync thread 25 fs: xfs
[  145.675772] misc test_kmod0: Sync thread 26 fs: xfs
[  145.676491] misc test_kmod0: Sync thread 27 fs: xfs
[  145.677207] misc test_kmod0: Sync thread 28 fs: xfs
[  145.677920] misc test_kmod0: Sync thread 29 fs: xfs
[  145.678658] misc test_kmod0: Sync thread 30 fs: xfs
[  145.679369] misc test_kmod0: Sync thread 31 fs: xfs
[  145.680075] misc test_kmod0: Sync thread 32 fs: xfs
[  145.680780] misc test_kmod0: Sync thread 33 fs: xfs
[  145.681481] misc test_kmod0: Sync thread 34 fs: xfs
[  145.682211] misc test_kmod0: Sync thread 35 fs: xfs
[  145.682925] misc test_kmod0: Sync thread 36 fs: xfs
[  145.683633] misc test_kmod0: Sync thread 37 fs: xfs
[  145.684363] misc test_kmod0: Sync thread 38 fs: xfs
[  145.685196] misc test_kmod0: Sync thread 39 fs: xfs
[  145.685896] misc test_kmod0: Sync thread 40 fs: xfs
[  145.687009] misc test_kmod0: Sync thread 41 fs: xfs
[  145.687800] misc test_kmod0: Sync thread 42 fs: xfs
[  145.688540] misc test_kmod0: Sync thread 43 fs: xfs
[  145.689227] misc test_kmod0: Sync thread 44 fs: xfs
[  145.689901] misc test_kmod0: Sync thread 45 fs: xfs
[  145.690924] misc test_kmod0: Sync thread 46 fs: xfs
[  145.691721] misc test_kmod0: Sync thread 47 fs: xfs
[  145.692533] misc test_kmod0: Sync thread 48 fs: xfs
[  145.693329] misc test_kmod0: Sync thread 49 fs: xfs
[  145.694140] misc test_kmod0: Sync thread 50 fs: xfs
[  145.694910] misc test_kmod0: Sync thread 51 fs: xfs
[  145.695695] misc test_kmod0: Sync thread 52 fs: NULL
[  145.696461] misc test_kmod0: Sync thread 53 fs: xfs
[  145.697229] misc test_kmod0: Sync thread 54 fs: xfs
[  145.698027] misc test_kmod0: Sync thread 55 fs: xfs
[  145.698898] misc test_kmod0: Sync thread 56 fs: xfs
[  145.699953] misc test_kmod0: Sync thread 57 fs: xfs
[  145.700667] misc test_kmod0: Sync thread 58 fs: xfs
[  145.701362] misc test_kmod0: Sync thread 59 fs: xfs
[  145.702078] misc test_kmod0: Sync thread 60 fs: xfs
[  145.702765] misc test_kmod0: Sync thread 61 fs: xfs
[  145.703456] misc test_kmod0: General test result: -22

The key here:

[  145.461962] request_module: modprobe fs-xfs cannot be processed, kmod busy with 50 threads for more than 5 seconds now

That is not printed when the test iterates and does not fail. That
comes from kernel/kmod.c:

	if (!ret) {                                                     
		pr_warn_ratelimited("request_module: %s cannot be processed, kmod busy with %d threads for more than %d seconds now",
				    module_name, MAX_KMOD_CONCURRENT, MAX_KMOD_ALL_BUSY_TIMEOUT);
		return -ETIME;   
	} ...

ETIME however is 62 as per include/uapi/asm-generic/errno.h. The loss
of the value comes from the fact get_fs_type() ignores error types and
so lib/test_kmod.c just sets err_ret = -EINVAL in tally_work_test() as
it cannot get more heuristics out of the kernel as to why get_fs_type()
failed.

This should mean that the failure observed with test 0009 on kmod is
very likely not due to module compression but just a timing issue, and
that compression just increases the probability of having 50 threads
busy concurrently on modprobe in 5 seconds with that test. I've
confirmed this by running a test with a modified kmod as follows
*after* booting into a kernel with no compression:

diff --git a/tools/modprobe.c b/tools/modprobe.c
index 3b7897c..0b7574d 100644
--- a/tools/modprobe.c
+++ b/tools/modprobe.c
@@ -1012,6 +1012,8 @@ static int do_modprobe(int argc, char **orig_argv)
 
 	log_setup_kmod_log(ctx, verbose);
 
+	usleep(5000000);
+
 	kmod_load_resources(ctx);
 
 	if (do_show_config)

Modules don't tend to be large in size but module compression is an
extrapolation of what could happen without compression if we had huge
modules often and userspace doing something wild. If you end up with 50
concurrent threads running modprobe for more than 5 seconds the kernel
pr_warn_ratelimited() would print though and it surely is a sign userspace
is doing something stupid. The sad part though is that a filesystem
mount *can* be triggered in these cases and so can fail to boot.

The above test were run with next-20230119 without the patch on this
thread, and so as noted before this doesn't create a regression, this is
a known issue now. And so -- further confirmation I'll move forward with
this patch for the next rc.

Note kernel/kmod.c in the kernel states:

/*                                                                              
 * This is a restriction on having *all* MAX_KMOD_CONCURRENT threads            
 * running at the same time without returning. When this happens we             
 * believe you've somehow ended up with a recursive module dependency           
 * creating a loop.                                                             
 *                                                                              
 * We have no option but to fail.                                               
 *                                                                              
 * Userspace should proactively try to detect and prevent these.                
 */                                                                             
#define MAX_KMOD_ALL_BUSY_TIMEOUT 5 

I can update the docs to reflect that this can be triggered by
the kernel trying to auto-loading DoS or each CPU count triggering
tons of unecessary duplicate auto-loading module requests. This is a self
kernel inflicted situation.

As for the DoS Vegard Nossum did report that user namespaces *could*
trigger / abuse kernel module autoloading and that they shouldn't be allowed
to do that as they can't load modules directly anyway (finit_module() won't work
for them). I'm waiting for a proper patch follow up from him, but *that* in
theory could then be another way to trigger this issue other than kmod test
0009, abuse user namespaces so to trigger a module failure by going over board on
auto-module loading. Boot likely can't be compromised unless creation of user
namespaces is allowed to be exploited early on boot. But post boot
kernel module auto-loading could be DoS'd with user namespaces.

As for the other case -- each additional CPU causing more module
auto-loading than before -- this is a real issue to monitor for and likely
can cause odd boot failures. This thread already dealt with
cpu-frequency modules as an example of abuse in the kernel for this.
Folks are working to fix this though but older kernels will have these
issues.

Since the kernel is the one that *is* dealing with throttling of this
auto-load situation, fixing these cases in-kernel is the right solution.
I don't think userspace can do much here as the limit hit is inherent to
auto-loading.

Perhaps the we should upgrade the pr_warn_ratelimited() to WARN_ONCE()?

[0] https://lore.kernel.org/all/Y8HkC1re3Fo46Ne3@bombadil.infradead.org/T/#u

  Luis
