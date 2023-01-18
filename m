Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3DEC1672746
	for <lists+stable@lfdr.de>; Wed, 18 Jan 2023 19:42:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229641AbjARSmm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 18 Jan 2023 13:42:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59656 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229813AbjARSml (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 18 Jan 2023 13:42:41 -0500
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 287CD36687;
        Wed, 18 Jan 2023 10:42:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=5ArG0GpJf+HULjLl2ntj9EQBFMeEY8HNHyMbNuCq+oo=; b=QnP+ckqNsIodyu08ivxR2vxDFu
        +8MO3UpwZdxlR2jjtHxrMNmvCW4yX+Xo3rJWUKJxPlF23M9tgiJdoRXhENXCJ3I1zK7vfdO8n07Qr
        tHkt/MNv4vyKVI6HQLHH/N6KQZNPNqyiPhH+thoj7eA0H1Fc8RZuSy5AkXvU2FLKclPiwblrd3dl4
        w1egtA/4sdUKn+dg9q/xiuMAT/dXqx5t3en2wwY4Br6/aSxLt+/rggo42weXJLoLq9kNJr1yogwFV
        HM/yzAeMTwFIsHt89QZi6kjMHTtO4b8PBs/pbdhORvh6vG3uKa+XWAilOBObOqXHwiOnm1kmq00bF
        wW5k+U8g==;
Received: from mcgrof by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1pIDOH-002Mdd-9w; Wed, 18 Jan 2023 18:42:29 +0000
Date:   Wed, 18 Jan 2023 10:42:29 -0800
From:   Luis Chamberlain <mcgrof@kernel.org>
To:     Petr Pavlu <petr.pavlu@suse.com>
Cc:     Petr Mladek <pmladek@suse.com>,
        Prarit Bhargava <prarit@redhat.com>,
        Vegard Nossum <vegard.nossum@oracle.com>,
        Borislav Petkov <bp@alien8.de>, NeilBrown <neilb@suse.de>,
        Goldwyn Rodrigues <rgoldwyn@suse.com>, david@redhat.com,
        mwilck@suse.com, linux-modules@vger.kernel.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH v2] module: Don't wait for GOING modules
Message-ID: <Y8g9lTBnCgB7g08/@bombadil.infradead.org>
References: <20221205103557.18363-1-petr.pavlu@suse.com>
 <Y5gI/3crANzRv22J@bombadil.infradead.org>
 <Y5hRRnBGYaPby/RS@alley>
 <Y8c3hgVwKiVrKJM1@bombadil.infradead.org>
 <79aad139-5305-1081-8a84-42ef3763d4f4@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <79aad139-5305-1081-8a84-42ef3763d4f4@suse.com>
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

On Wed, Jan 18, 2023 at 04:12:05PM +0100, Petr Pavlu wrote:
> On 1/18/23 01:04, Luis Chamberlain wrote:
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
> > mounting a large number of filesystems. Sadly though this issue seems
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

The issue happens with and without the patch in this thread, I'd just hate to
exacerbate the issue further.

> The problem was not possible for me to reproduce on my system. My test was on
> an 8-CPU x86_64 machine using v6.2-rc4 with "defconfig + kvm_guest.config +
> tools/testing/selftests/kmod/config".

With the patch?

> Could you perhaps trace the test to determine where the EINVAL value comes
> from?

Sure, it'll take a bit.

  Luis
