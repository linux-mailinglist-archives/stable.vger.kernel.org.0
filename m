Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8CC0A4A49D7
	for <lists+stable@lfdr.de>; Mon, 31 Jan 2022 16:08:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242381AbiAaPI3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 Jan 2022 10:08:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45552 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235301AbiAaPI2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 31 Jan 2022 10:08:28 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 48854C061714;
        Mon, 31 Jan 2022 07:08:28 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 04705B82B3A;
        Mon, 31 Jan 2022 15:08:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D7F2C340E8;
        Mon, 31 Jan 2022 15:08:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1643641705;
        bh=DJv8QiHD+2J/NbX3ujdDj7noq1FHPrQE+g5GGbv7o0Y=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=LDkxIsuTE0aBZUOT/fEgGwsiZaz+f1oc1RWFEYgeEraqnxW/NtRoxAiyk9SOphpkT
         F41eyvm/sLrTo6vlJjMgpxGZKNF3wuS+yBJnxy8Jqn5UQQURoeP1CduMAjB8FakLoJ
         ErjD7ZQ9oKjBFGdnnLzG9hoUwGO840Tzn76GWTAAX/f+Ifc+s1uqhfF+PX1gTshwqZ
         LYIoJDvLumom64rKjQIYUgLmvoGSnWb8l+R/2F23ng4DVN/it1ucqvpMpSHrS/HUPU
         XEUsJW4yIliFm4txFkdeRLoJXjLx6moKAWH7mjHg+LDmhCzJSv/zR0DuTOLFo3RS4v
         yTsxjbq3Y3niQ==
Date:   Mon, 31 Jan 2022 16:08:19 +0100
From:   Christian Brauner <brauner@kernel.org>
To:     kernel test robot <oliver.sang@intel.com>,
        Kees Cook <keescook@chromium.org>,
        Ariadne Conill <ariadne@dereferenced.org>
Cc:     Ariadne Conill <ariadne@dereferenced.org>,
        0day robot <lkp@intel.com>,
        Michael Kerrisk <mtk.manpages@gmail.com>,
        Matthew Wilcox <willy@infradead.org>,
        Rich Felker <dalias@libc.org>,
        Eric Biederman <ebiederm@xmission.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        LKML <linux-kernel@vger.kernel.org>, lkp@lists.01.org,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
        stable@vger.kernel.org
Subject: Re: [fs/exec]  80bd5afdd8: xfstests.generic.633.fail
Message-ID: <20220131150819.iuqlz3rz6q7cheap@wittgenstein>
References: <20220127000724.15106-1-ariadne@dereferenced.org>
 <20220131144352.GE16385@xsang-OptiPlex-9020>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20220131144352.GE16385@xsang-OptiPlex-9020>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jan 31, 2022 at 10:43:52PM +0800, kernel test robot wrote:
> 
> 
> Greeting,
> 
> FYI, we noticed the following commit (built with gcc-9):
> 
> commit: 80bd5afdd8568e41fc3a75c695bb179e0d9eee4d ("[PATCH v3] fs/exec: require argv[0] presence in do_execveat_common()")
> url: https://github.com/0day-ci/linux/commits/Ariadne-Conill/fs-exec-require-argv-0-presence-in-do_execveat_common/20220127-080829
> base: https://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git 2c271fe77d52a0555161926c232cd5bc07178b39
> patch link: https://lore.kernel.org/lkml/20220127000724.15106-1-ariadne@dereferenced.org
> 
> in testcase: xfstests
> version: xfstests-x86_64-972d710-1_20220127
> with following parameters:
> 
> 	disk: 4HDD
> 	fs: f2fs
> 	test: generic-group-31
> 	ucode: 0xe2
> 
> test-description: xfstests is a regression test suite for xfs and other files ystems.
> test-url: git://git.kernel.org/pub/scm/fs/xfs/xfstests-dev.git
> 
> 
> on test machine: 4 threads Intel(R) Core(TM) i5-6500 CPU @ 3.20GHz with 32G memory
> 
> caused below changes (please refer to attached dmesg/kmsg for entire log/backtrace):
> 
> 
> 
> 
> If you fix the issue, kindly add following tag
> Reported-by: kernel test robot <oliver.sang@intel.com>
> 
> 
> 
> user  :warn  : [  208.077271] run fstests generic/633 at 2022-01-30 04:50:49
> kern  :warn  : [  208.529090] Attempted to run process '/dev/fd/5/file1' with NULL argv
> user  :notice: [  208.806756] generic/633       [failed, exit status 1]- output mismatch (see /lkp/benchmarks/xfstests/results//generic/633.out.bad)
> 
> user  :notice: [  208.826454]     --- tests/generic/633.out     2022-01-27 11:54:16.000000000 +0000
> 
> user  :notice: [  208.842458]     +++ /lkp/benchmarks/xfstests/results//generic/633.out.bad     2022-01-30 04:50:49.769538285 +0000
> 
> user  :notice: [  208.859622]     @@ -1,2 +1,4 @@
> 
> user  :warn  : [  208.860623] run fstests generic/634 at 2022-01-30 04:50:49
> user  :notice: [  208.866037]      QA output created by 633
> 
> user  :notice: [  208.889262]      Silence is golden
> 
> user  :notice: [  208.901240]     +idmapped-mounts.c: 3608: setid_binaries - Invalid argument - failure: sys_execveat

This is from the generic part of the vfs testsuite.
It verifies that set*id binaries are executed with the right e{g,u}id.
Part of that test calls execveat() as:

static char *argv[] = {
	NULL,
};

static char *envp[] = {
	"EXPECTED_EUID=5000",
	"EXPECTED_EGID=5000",
	NULL,
};

syscall(__NR_execveat, fd, some_path, argv, envp, 0);

I can fix this rather simply in our upstream fstests with:

static char *argv[] = {
	"",
};

I guess.

But doesn't

static char *argv[] = {
	NULL,
};

seem something that should work especially with execveat()?

Christian
