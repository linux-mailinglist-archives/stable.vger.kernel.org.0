Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CE0F66A053F
	for <lists+stable@lfdr.de>; Thu, 23 Feb 2023 10:51:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234128AbjBWJvv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Feb 2023 04:51:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52478 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233354AbjBWJvu (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 Feb 2023 04:51:50 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 33C964E5F5;
        Thu, 23 Feb 2023 01:51:49 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A7CD461629;
        Thu, 23 Feb 2023 09:51:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE07EC433EF;
        Thu, 23 Feb 2023 09:51:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1677145908;
        bh=00vV012v5IGFYupEfY8cRFX6H7hj6D67NRk/FGmf4tA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=YKN0HiTB8aCX3lOBp4YzZBOc2xpCFZlbfBq3sS4elxzCo2DgNpiZvRfAWw0EEZPsY
         1Of0ObePM7oOGZSXHavj/fw/9VtCuHNTRtjKVOIOkZsnPDjlBnZOMH/qYnzeemOMYn
         QCvYeMdiLvlizuKv6Sq3UBy1YChubHjmOCkJD0iI=
Date:   Thu, 23 Feb 2023 10:51:45 +0100
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
        linux-s390@vger.kernel.org, linux-sh@vger.kernel.org
Subject: Re: [PATCH 5.15 v2 1/5] arch: fix broken BuildID for arm64 and riscv
Message-ID: <Y/c3MSvnN4DcvzSx@kroah.com>
References: <20230210-tsaeger-upstream-linux-stable-5-15-v2-0-6c68622745e9@oracle.com>
 <20230210-tsaeger-upstream-linux-stable-5-15-v2-1-6c68622745e9@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230210-tsaeger-upstream-linux-stable-5-15-v2-1-6c68622745e9@oracle.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Feb 10, 2023 at 01:18:40PM -0700, Tom Saeger wrote:
> From: Masahiro Yamada <masahiroy@kernel.org>
> 
> commit 99cb0d917ffa1ab628bb67364ca9b162c07699b1 upstream.
> 
> Dennis Gilmore reports that the BuildID is missing in the arm64 vmlinux
> since commit 994b7ac1697b ("arm64: remove special treatment for the
> link order of head.o").
> 
> The issue is that the type of .notes section, which contains the BuildID,
> changed from NOTES to PROGBITS.
> 
> Ard Biesheuvel figured out that whichever object gets linked first gets
> to decide the type of a section. The PROGBITS type is the result of the
> compiler emitting .note.GNU-stack as PROGBITS rather than NOTE.
> 
> While Ard provided a fix for arm64, I want to fix this globally because
> the same issue is happening on riscv since commit 2348e6bf4421 ("riscv:
> remove special treatment for the link order of head.o"). This problem
> will happen in general for other architectures if they start to drop
> unneeded entries from scripts/head-object-list.txt.
> 
> Discard .note.GNU-stack in include/asm-generic/vmlinux.lds.h.
> 
> Link: https://lore.kernel.org/lkml/CAABkxwuQoz1CTbyb57n0ZX65eSYiTonFCU8-LCQc=74D=xE=rA@mail.gmail.com/
> Fixes: 994b7ac1697b ("arm64: remove special treatment for the link order of head.o")
> Fixes: 2348e6bf4421 ("riscv: remove special treatment for the link order of head.o")

Why are we adding a commit to 5.15.y that fixes an issue that only
showed up in 6.1.y?

We need a good comment somewhere saying why this is needed...

thanks,

greg k-h
