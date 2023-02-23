Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AFB156A0563
	for <lists+stable@lfdr.de>; Thu, 23 Feb 2023 10:54:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234167AbjBWJyx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Feb 2023 04:54:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56280 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234170AbjBWJyl (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 Feb 2023 04:54:41 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA2934FAA3;
        Thu, 23 Feb 2023 01:54:39 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6C919B81991;
        Thu, 23 Feb 2023 09:54:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA4C9C433EF;
        Thu, 23 Feb 2023 09:54:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1677146077;
        bh=tzlp0We19KInWirh8J/R3X53YBq02wyMg36MmcYZucg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=rWHav/x5svyAQ2Kiupi0qIMdQsQIRNHbVu7V7cvhIG+FB2Ab9YOZbznomFKNVRU5c
         dJGp13n1+5gUWl60lh8PHfPhiLUUzRx/jkZWhR2U0IJ4QwSkA71R1sHDBM1LDZoGSQ
         K8nl4u6N+AgQlSy2sBaBWuu95IVveXkXHttSWa9s=
Date:   Thu, 23 Feb 2023 10:54:34 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Tom Saeger <tom.saeger@oracle.com>
Cc:     Sasha Levin <sashal@kernel.org>,
        Naresh Kamboju <naresh.kamboju@linaro.org>,
        John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>,
        Rich Felker <dalias@libc.org>,
        Masahiro Yamada <masahiroy@kernel.org>,
        Ard Biesheuvel <ardb@kernel.org>,
        Nathan Chancellor <nathan@kernel.org>,
        Dennis Gilmore <dennis@ausil.us>,
        Palmer Dabbelt <palmer@rivosinc.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        stable@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arch@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-riscv@lists.infradead.org, linuxppc-dev@lists.ozlabs.org,
        linux-s390@vger.kernel.org, linux-sh@vger.kernel.org,
        Jisheng Zhang <jszhang@kernel.org>,
        Nicolas Schier <nicolas@fjasle.eu>,
        Will Deacon <will@kernel.org>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Heiko Carstens <hca@linux.ibm.com>,
        Christoph Hellwig <hch@lst.de>,
        Yoshinori Sato <ysato@users.sourceforge.jp>
Subject: Re: [PATCH 6.1 v2 0/7] Backport Build ID fixes
Message-ID: <Y/c32nwwcfmqZqbc@kroah.com>
References: <20230210-tsaeger-upstream-linux-6-1-y-v2-0-3689d04e29fc@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230210-tsaeger-upstream-linux-6-1-y-v2-0-3689d04e29fc@oracle.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Feb 10, 2023 at 01:17:15PM -0700, Tom Saeger wrote:
> Keep 6.1 in-sync with Build ID fixes.
> 
> I've build tested this on {x86_64, arm64, riscv, powerpc, s390, sh}.
> 
> Changes for v2:
> - include 1/7 2348e6bf4421 ("riscv: remove special treatment for the link order of head.o")
> - include 2/7 994b7ac1697b ("arm64: remove special treatment for the link order of head.o")
> - rebase  7/7 c1c551bebf92 ("sh: define RUNTIME_DISCARD_EXIT") from upstream
> 
> Previous threads:
> [1] https://lore.kernel.org/all/cover.1674876902.git.tom.saeger@oracle.com/
> [2] https://lore.kernel.org/all/3df32572ec7016e783d37e185f88495831671f5d.1671143628.git.tom.saeger@oracle.com/
> [3] https://lore.kernel.org/all/cover.1670358255.git.tom.saeger@oracle.com/
> 
> Signed-off-by: Tom Saeger <tom.saeger@oracle.com>
> ---
> Jisheng Zhang (1):
>       riscv: remove special treatment for the link order of head.o
> 
> Masahiro Yamada (3):
>       arm64: remove special treatment for the link order of head.o
>       arch: fix broken BuildID for arm64 and riscv
>       s390: define RUNTIME_DISCARD_EXIT to fix link error with GNU ld < 2.36
> 
> Michael Ellerman (2):
>       powerpc/vmlinux.lds: Define RUNTIME_DISCARD_EXIT
>       powerpc/vmlinux.lds: Don't discard .rela* for relocatable builds
> 
> Tom Saeger (1):
>       sh: define RUNTIME_DISCARD_EXIT
> 
>  arch/powerpc/kernel/vmlinux.lds.S | 6 +++++-
>  arch/s390/kernel/vmlinux.lds.S    | 2 ++
>  arch/sh/kernel/vmlinux.lds.S      | 1 +
>  include/asm-generic/vmlinux.lds.h | 5 +++++
>  scripts/head-object-list.txt      | 2 --
>  5 files changed, 13 insertions(+), 3 deletions(-)
> ---
> base-commit: d60c95efffe84428e3611431bf688f50bfc13f4e
> change-id: 20230210-tsaeger-upstream-linux-6-1-y-06c93fbe5bc8

Now queued up, thanks.

greg k-h
