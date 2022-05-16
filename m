Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A4C1B528BD8
	for <lists+stable@lfdr.de>; Mon, 16 May 2022 19:22:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235087AbiEPRWc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 May 2022 13:22:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41012 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229695AbiEPRWb (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 May 2022 13:22:31 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E81FCFD;
        Mon, 16 May 2022 10:22:29 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C3B4C6129B;
        Mon, 16 May 2022 17:22:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED44CC385AA;
        Mon, 16 May 2022 17:22:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652721748;
        bh=NBGepjyX3p9GxdWdL3gWlKrcd6kEqJlE6R/ujFg1F30=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=TEeRn5rYaCsKqCkKjF1Lj3VSnWdl/pH0nEXS7kExWvMwXL7jibuTwKkGfOH9HFtWI
         DxKfk2KqvgXzwwx3RQW1R3RyGoKlOBn7aeXhyE6qrOvxXDO2JOChJKwrVGocm0LXIa
         m3OOHWf2lXWSpvH5QJRcZec4t+32vNyXzCtW+AKLHufgXIzDhuQ67BV84ydrExthTJ
         YgkIj2xm+TTKL6sPIx4ez7h09HgxnUY4hK1cygrOMvac+HzSqPYEch9mVNQ7mU/IZ5
         HO4GcN0TMm3ODD3BiMIxDFpKsNfZ2c2mG0pR8vUqAMI+I0QdFLqd2KD0M81QiXtK88
         ls7bLY7OtOtDg==
Date:   Mon, 16 May 2022 10:22:26 -0700
From:   Jaegeuk Kim <jaegeuk@kernel.org>
To:     Gabriel Krisman Bertazi <krisman@collabora.com>
Cc:     Eric Biggers <ebiggers@kernel.org>, linux-fscrypt@vger.kernel.org,
        stable@vger.kernel.org, Daniel Rosenberg <drosen@google.com>,
        linux-f2fs-devel@lists.sourceforge.net
Subject: Re: [f2fs-dev] [PATCH] f2fs: don't use casefolded comparison for "."
 and ".."
Message-ID: <YoKIUgM4ckAC1n/O@google.com>
References: <20220514175929.44439-1-ebiggers@kernel.org>
 <87r14txyrx.fsf@collabora.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87r14txyrx.fsf@collabora.com>
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Thanks, applied.

On 05/16, Gabriel Krisman Bertazi wrote:
> Eric Biggers <ebiggers@kernel.org> writes:
> 
> > From: Eric Biggers <ebiggers@google.com>
> >
> > Tryng to rename a directory that has all following properties fails with
> > EINVAL and triggers the 'WARN_ON_ONCE(!fscrypt_has_encryption_key(dir))'
> > in f2fs_match_ci_name():
> >
> >     - The directory is casefolded
> >     - The directory is encrypted
> >     - The directory's encryption key is not yet set up
> >     - The parent directory is *not* encrypted
> >
> > The problem is incorrect handling of the lookup of ".." to get the
> > parent reference to update.  fscrypt_setup_filename() treats ".." (and
> > ".") specially, as it's never encrypted.  It's passed through as-is, and
> > setting up the directory's key is not attempted.  As the name isn't a
> > no-key name, f2fs treats it as a "normal" name and attempts a casefolded
> > comparison.  That breaks the assumption of the WARN_ON_ONCE() in
> > f2fs_match_ci_name() which assumes that for encrypted directories,
> > casefolded comparisons only happen when the directory's key is set up.
> >
> > We could just remove this WARN_ON_ONCE().  However, since casefolding is
> > always a no-op on "." and ".." anyway, let's instead just not casefold
> > these names.  This results in the standard bytewise comparison.
> >
> > Fixes: 7ad08a58bf67 ("f2fs: Handle casefolding with Encryption")
> > Cc: <stable@vger.kernel.org> # v5.11+
> > Signed-off-by: Eric Biggers <ebiggers@google.com>
> > ---
> >  fs/f2fs/dir.c  |  3 ++-
> >  fs/f2fs/f2fs.h | 10 +++++-----
> >  fs/f2fs/hash.c | 11 ++++++-----
> >  3 files changed, 13 insertions(+), 11 deletions(-)
> 
> Hi Eric,
> 
> This looks good to me:
> 
> Reviewed-by: Gabriel Krisman Bertazi <krisman@collabora.com>
> 
> Thanks,
> 
> -- 
> Gabriel Krisman Bertazi
> 
> 
> _______________________________________________
> Linux-f2fs-devel mailing list
> Linux-f2fs-devel@lists.sourceforge.net
> https://lists.sourceforge.net/lists/listinfo/linux-f2fs-devel
