Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9FEAC4E68E5
	for <lists+stable@lfdr.de>; Thu, 24 Mar 2022 19:53:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352751AbiCXSzH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 24 Mar 2022 14:55:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44038 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347682AbiCXSzF (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 24 Mar 2022 14:55:05 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 135B924F17;
        Thu, 24 Mar 2022 11:53:32 -0700 (PDT)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out2.suse.de (Postfix) with ESMTP id 471AF1F745;
        Thu, 24 Mar 2022 18:53:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1648148011;
        h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
         cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=mxmc7ediERSNp/9oSucpGCHIBIwx+Z1tUQd5pDNQoeU=;
        b=SMSoMF/bJ+WqVhBx2VnpeAnW0h2DTDGFa9k9yn4j+F4XRJKrDOc+P2fd/xeQt+brez3zWc
        JY/CjJl/fgfGO/ApgJdVrZMSWY168n+17fPnUEYnZyoSeUxlMIgpiywo6Lp8GnaOWaZdN0
        dA4ZPr2vF/Un2Kj4efMQCJtlKq7f+d0=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1648148011;
        h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
         cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=mxmc7ediERSNp/9oSucpGCHIBIwx+Z1tUQd5pDNQoeU=;
        b=eMzOJ5+VRV5jfX49BQ5f1H4FKDb83yFqWdTeugv9hJpSYxyxtBQRx5YUXrRnWcS58rzWld
        cgeOet6JGELJgVAw==
Received: from ds.suse.cz (ds.suse.cz [10.100.12.205])
        by relay2.suse.de (Postfix) with ESMTP id 3106CA3B82;
        Thu, 24 Mar 2022 18:53:31 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 36686DA7F3; Thu, 24 Mar 2022 19:49:36 +0100 (CET)
Date:   Thu, 24 Mar 2022 19:49:36 +0100
From:   David Sterba <dsterba@suse.cz>
To:     Nathan Chancellor <nathan@kernel.org>
Cc:     Chris Mason <clm@fb.com>, Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>,
        Nick Desaulniers <ndesaulniers@google.com>,
        linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org,
        llvm@lists.linux.dev, patches@lists.linux.dev,
        stable@vger.kernel.org
Subject: Re: [PATCH] btrfs: Remove unused variable in
 btrfs_{start,write}_dirty_block_groups()
Message-ID: <20220324184936.GL2237@suse.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Nathan Chancellor <nathan@kernel.org>,
        Chris Mason <clm@fb.com>, Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>,
        Nick Desaulniers <ndesaulniers@google.com>,
        linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org,
        llvm@lists.linux.dev, patches@lists.linux.dev,
        stable@vger.kernel.org
References: <20220324153644.4079376-1-nathan@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220324153644.4079376-1-nathan@kernel.org>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Mar 24, 2022 at 08:36:45AM -0700, Nathan Chancellor wrote:
> Clang's version of -Wunused-but-set-variable recently gained support for
> unary operations, which reveals two unused variables:
> 
>   fs/btrfs/block-group.c:2949:6: error: variable 'num_started' set but not used [-Werror,-Wunused-but-set-variable]
>           int num_started = 0;
>               ^
>   fs/btrfs/block-group.c:3116:6: error: variable 'num_started' set but not used [-Werror,-Wunused-but-set-variable]
>           int num_started = 0;
>               ^
>   2 errors generated.
> 
> These variables appear to be unused from their introduction, so just
> remove them to silence the warnings.
> 
> Cc: stable@vger.kernel.org
> Fixes: c9dc4c657850 ("Btrfs: two stage dirty block group writeout")
> Fixes: 1bbc621ef284 ("Btrfs: allow block group cache writeout outside critical section in commit")
> Link: https://github.com/ClangBuiltLinux/linux/issues/1614
> Signed-off-by: Nathan Chancellor <nathan@kernel.org>

Added to misc-next, thanks.

> I am requesting a stable backport because this is visible with
> allmodconfig, which enables CONFIG_WERROR, breaking the build.

Yeah warning fixes are accepted in stable trees and we care about
warning-free builds. My gcc 11.1 does not produce any warning with
-Wunused-but-set-variable and we have extended the set of warnings in
the directory fs/btrfs/ that also includes that one.

> To quote Linus:
> 
> "EVERYBODY should have CONFIG_WERROR=y on at least x86-64 and other
> serious architectures, unless you have some completely random
> experimental (and broken) compiler."

I have CONFIG_WERROR disabled, for own development it's quite annoying
when build fails outside of the code I care about, while I apply visual
checks of warning-free builds.
