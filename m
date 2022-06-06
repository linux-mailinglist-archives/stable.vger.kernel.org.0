Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 61FDD53EB39
	for <lists+stable@lfdr.de>; Mon,  6 Jun 2022 19:09:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235283AbiFFLUe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Jun 2022 07:20:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59606 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235285AbiFFLUd (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Jun 2022 07:20:33 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B5C374E3B7
        for <stable@vger.kernel.org>; Mon,  6 Jun 2022 04:20:31 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0E98160F47
        for <stable@vger.kernel.org>; Mon,  6 Jun 2022 11:20:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0AD13C34119;
        Mon,  6 Jun 2022 11:20:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654514430;
        bh=+sdbXWqPF3A5txr4n4F4E8SNGv7Tjx97VCebQrLwxwc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=lmhqxIKffWiotbziCHmVifNVUSSxtFE3FMZg76KZaM4XpNQz32towQCXkqLVq91va
         ctvJJs6SetBzmNKN6QD+JXiZh7M7lcBx00cZOdXVMAqsuyXGTwEe6N4Hm4ggzlDN/9
         OTLFQ0uVKpdhHQgYhIfu5l9mVcvsgzR8u8ktcMR8=
Date:   Mon, 6 Jun 2022 13:20:27 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     =?iso-8859-1?Q?Micka=EBl_Sala=FCn?= <mic@digikod.net>
Cc:     stable@vger.kernel.org, Paul Moore <paul@paul-moore.com>
Subject: Re: WTF: patch "[PATCH] selftests/landlock: Format with
 clang-format" was seriously submitted to be applied to the 5.18-stable tree?
Message-ID: <Yp3i++t/OJVTdPyB@kroah.com>
References: <165450152566@kroah.com>
 <f4619c73-9ff1-db8e-de06-3ba984b24399@digikod.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <f4619c73-9ff1-db8e-de06-3ba984b24399@digikod.net>
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jun 06, 2022 at 12:59:56PM +0200, Mickaël Salaün wrote:
> Hi Greg,
> 
> The 21 Landlock commits merged for 5.19-rc1 and tagged with Cc stable@
> should indeed be backported up to 5.15 . The first commits are pure cosmetic
> changes but they need to be backported to avoid backport conflicts (for this
> series and future backports). They help maintain this subsystem, including
> to backport future changes.

Ick, that's not how to submit patches for backporting ideally.

Usually you submit the bugfixes first, and then we can backport them
easily.

If you decide to reformat the codebase, well, you get to deal with the
backport issues later on (why is it reformatted, isn't it checkpatch
clean already?

> The following changes up to commit 8ba0005ff418
> ("landlock: Fix same-layer rule unions") are required to fix some edge case
> issues (i.e. syscall argument ordering checks and same-layer rule unions).
> New tests are added to check that everything work as expected for these
> backportable changes, and to make it possible for more test environments to
> run. I successfully tested the backport of all these commits to 5.15 .
> Please backport them to all stable branches.

This is just backporting all files here, which seems crazy.

> 
> Here is the full list of the commits to backport (already marked with Cc:
> stable@vger.kernel.org):
> 
> 8ba0005ff418 landlock: Fix same-layer rule unions
> 2cd7cd6eed88 landlock: Create find_rule() from unmask_layers()
> 75c542d6c6cc landlock: Reduce the maximum number of layers to 16
> 5f2ff33e1084 landlock: Define access_mask_t to enforce a consistent access
> mask size
> 6533d0c3a86e selftests/landlock: Test landlock_create_ruleset(2) argument
> check ordering
> eba39ca4b155 landlock: Change landlock_restrict_self(2) check ordering
> 589172e5636c landlock: Change landlock_add_rule(2) argument check ordering
> d1788ad99087 selftests/landlock: Add tests for O_PATH
> 6a1bdd4a0bfc selftests/landlock: Fully test file rename with "remove" access
> d18955d094d0 selftests/landlock: Extend access right tests to directories
> c56b3bf566da selftests/landlock: Add tests for unknown access rights
> 291865bd7e8b selftests/landlock: Extend tests for minimal valid attribute
> size
> 87129ef13603 selftests/landlock: Make tests build with old libc
> a13e248ff90e landlock: Fix landlock_add_rule(2) documentation
> 81709f3dccac samples/landlock: Format with clang-format
> 9805a722db07 samples/landlock: Add clang-format exceptions
> 371183fa578a selftests/landlock: Format with clang-format
> 135464f9d29c selftests/landlock: Normalize array assignment
> 4598d9abf421 selftests/landlock: Add clang-format exceptions
> 06a1c40a09a8 landlock: Format with clang-format
> 6cc2df8e3a39 landlock: Add clang-format exceptions

What order is this in?  And what's the overall diffstat?  And again, why
use clang-format at all, what is it helping with here?

thanks,

greg k-h
