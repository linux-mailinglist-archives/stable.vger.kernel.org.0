Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 02FDD670EDD
	for <lists+stable@lfdr.de>; Wed, 18 Jan 2023 01:42:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229560AbjARAmB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Jan 2023 19:42:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36266 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229785AbjARAlb (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 17 Jan 2023 19:41:31 -0500
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A89893CE01;
        Tue, 17 Jan 2023 16:18:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=HHnUDmeU0abCJ7K1eaIuJ1LiMmq1mJinxP4XhHWb9LA=; b=apwku60VJAkz4oX0uxzKIueYkV
        Q0WK3ctzgQMMC0m3BhBIDfycxRH5jklswx5A8m6aHDCGkxaioWHI3NwLemWtgJfRS3od2LrZM+Qr5
        CMq3wPORGlgpPeJ2UYHc4amHzPrN4GdLrMzD4jWmrvfyZoNwF2WmFGEWEE4Jf8XTNzSV9ElyAEXzi
        cfYYmTSKfRZ7aqWIn2Ln52yXAZOpKHeU0L9LA3pFGNNBk5fAii1XxOjFFmma5CqKDlGE/SzN+l9DZ
        1591XMd5fuTOw/xf6btYReTAsqwpNcsdPEfc+uS6nkbZZvtgZjOuq70xsp9hQ2fm82i3zbSzsstWi
        O8E5QQkQ==;
Received: from mcgrof by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1pHwAB-00GKKJ-JB; Wed, 18 Jan 2023 00:18:47 +0000
Date:   Tue, 17 Jan 2023 16:18:47 -0800
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
Message-ID: <Y8c652Dlbc9yarFx@bombadil.infradead.org>
References: <20221205103557.18363-1-petr.pavlu@suse.com>
 <Y5gI/3crANzRv22J@bombadil.infradead.org>
 <Y5hRRnBGYaPby/RS@alley>
 <Y8c3hgVwKiVrKJM1@bombadil.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y8c3hgVwKiVrKJM1@bombadil.infradead.org>
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

On Tue, Jan 17, 2023 at 04:04:22PM -0800, Luis Chamberlain wrote:
> ./tools/testing/selftests/kmod/kmod.sh -t 0006
> Tue Jan 17 23:18:13 UTC 2023
> Running test: kmod_test_0006 - run #0
> kmod_test_0006: OK! - loading kmod test
> kmod_test_0006: FAIL, test expects SUCCESS (0) - got -EINVAL (-22)
> ----------------------------------------------------
> Custom trigger configuration for: test_kmod0
> Number of threads:      50
> Test_case:      TEST_KMOD_FS_TYPE (2)
> driver: test_module
> fs:     xfs
> ----------------------------------------------------
> Test completed
> 
> When can multiple get_fs_type() calls be issued on a system? When
> mounting a large number of filesystems. Sadly though this issue seems
> to have gone unnoticed for a while now. Even reverting commit
> 6e6de3dee51a doesn't fix it, and I've run into issues with trying
> to bisect, first due to missing Kees' patch which fixes a compiler
> failure on older kernel [0] and now I'm seeing this while trying to
> build v5.1:
> 
> ld: arch/x86/boot/compressed/pgtable_64.o:(.bss+0x0): multiple definition of `__force_order';
> arch/x86/boot/compressed/kaslr_64.o:(.bss+0x0): first defined here
> ld: warning: arch/x86/boot/compressed/efi_thunk_64.o: missing .note.GNU-stack section implies executable stack
> ld: NOTE: This behaviour is deprecated and will be removed in a future version of the linker
> ld: arch/x86/boot/compressed/head_64.o: warning: relocation in read-only section `.head.text'
> ld: warning: arch/x86/boot/compressed/vmlinux has a LOAD segment with RWX permissions
> ld: warning: creating DT_TEXTREL in a PIE
> make[2]: *** [arch/x86/boot/compressed/Makefile:118: arch/x86/boot/compressed/vmlinux] Error 1
> make[1]: *** [arch/x86/boot/Makefile:112: arch/x86/boot/compressed/vmlinux] Error 2
> make: *** [arch/x86/Makefile:283: bzImage] Error 2
> 
> [0] http://lore.kernel.org/lkml/20220213182443.4037039-1-keescook@chromium.org
> 
> But we should try to bisect to see what cauased the above kmod test 0006
> to start failing.

BTW if someone beats me to bisecting the above it would be appreciated.
I have a feeling having old gcc / linker, etc would be easier.

  Luis
