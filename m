Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1F29D6A2E56
	for <lists+stable@lfdr.de>; Sun, 26 Feb 2023 06:30:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229554AbjBZFaq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 26 Feb 2023 00:30:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52190 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229515AbjBZFap (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 26 Feb 2023 00:30:45 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 39EEED303;
        Sat, 25 Feb 2023 21:30:42 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E0C16B80B49;
        Sun, 26 Feb 2023 05:30:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A6D3C433D2;
        Sun, 26 Feb 2023 05:30:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1677389439;
        bh=7hX/pPKKPtiF07aEdqR7BMzOcRIU6iwU4g8cV2SDxLU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ajKzDQKJujjZZXjMPLrddb2FN5dNYAWhqhJLPl1qOoMRR6mNi6N0BDIbxjruBl5Dn
         HZon+lmy9ufnmzG49x4a8W008R1g55RCWFGjAFGZvCVdzefmVrLS1sLH3K06unJZqq
         Q8bLO11aA7Z4lRd+n6fgVv1OPfoclB4HmrkfOo1swOyrr7pVDkps1FLDnAM9OsQtNr
         AxTu+tZoYG+mJM/OI1dxqDcXmrMYGx9UoVZaeBu1yD2huECD7v6myuUVs1ZePUPhok
         jEqcHM0Xt4q4RJ3WehpxX4MbLSf8cAjXRRLndEXZsu5FiX0jc5cpgEbkDncpfuS9AY
         e5wxSanMhz3wA==
Date:   Sat, 25 Feb 2023 21:30:37 -0800
From:   Eric Biggers <ebiggers@kernel.org>
To:     Sasha Levin <sashal@kernel.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        viro@zeniv.linux.org.uk, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH AUTOSEL 6.1 12/21] fs/super.c: stop calling
 fscrypt_destroy_keyring() from __put_super()
Message-ID: <Y/rufenGRpoJVXZr@sol.localdomain>
References: <20230226034256.771769-1-sashal@kernel.org>
 <20230226034256.771769-12-sashal@kernel.org>
 <Y/rbGxq8oAEsW28j@sol.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y/rbGxq8oAEsW28j@sol.localdomain>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, Feb 25, 2023 at 08:07:55PM -0800, Eric Biggers wrote:
> On Sat, Feb 25, 2023 at 10:42:47PM -0500, Sasha Levin wrote:
> > From: Eric Biggers <ebiggers@google.com>
> > 
> > [ Upstream commit ec64036e68634231f5891faa2b7a81cdc5dcd001 ]
> > 
> > Now that the key associated with the "test_dummy_operation" mount option
> > is added on-demand when it's needed, rather than immediately when the
> > filesystem is mounted, fscrypt_destroy_keyring() no longer needs to be
> > called from __put_super() to avoid a memory leak on mount failure.
> > 
> > Remove this call, which was causing confusion because it appeared to be
> > a sleep-in-atomic bug (though it wasn't, for a somewhat-subtle reason).
> > 
> > Signed-off-by: Eric Biggers <ebiggers@google.com>
> > Link: https://lore.kernel.org/r/20230208062107.199831-5-ebiggers@kernel.org
> > Signed-off-by: Sasha Levin <sashal@kernel.org>
> 
> Why is this being backported?
> 
> - Eric

BTW, can you please permanently exclude all commits authored by me from AUTOSEL
so that I don't have to repeatedly complain about every commit individually?
Especially when these mails often come on weekends and holidays.

I know how to use Cc stable, and how to ask explicitly for a stable backport if
I find out after the fact that one is needed.  (And other real people can always
ask too... not counting AUTOSEL, even though you are sending the AUTOSEL emails,
since clearly they go through no or very little human review.)

Of course, it's not just me that AUTOSEL isn't working for.  So, you'll still
continue backporting random commits that I have to spend hours bisecting, e.g.
https://lore.kernel.org/stable/20220921155332.234913-7-sashal@kernel.org.

But at least I won't have to deal with this garbage for my own commits.

Now, I'm not sure I'll get a response to this --- I received no response to my
last AUTOSEL question at
https://lore.kernel.org/stable/Y1DTFiP12ws04eOM@sol.localdomain.  So to
hopefully entice you to actually do something, I'm also letting you know that I
won't be reviewing any AUTOSEL mails for my commits anymore.

- Eric
