Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DA20E53E73C
	for <lists+stable@lfdr.de>; Mon,  6 Jun 2022 19:07:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234627AbiFFLAF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Jun 2022 07:00:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47070 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234625AbiFFLAE (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Jun 2022 07:00:04 -0400
Received: from smtp-8fab.mail.infomaniak.ch (smtp-8fab.mail.infomaniak.ch [IPv6:2001:1600:3:17::8fab])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0EC5F1409F
        for <stable@vger.kernel.org>; Mon,  6 Jun 2022 04:00:00 -0700 (PDT)
Received: from smtp-3-0001.mail.infomaniak.ch (unknown [10.4.36.108])
        by smtp-2-3000.mail.infomaniak.ch (Postfix) with ESMTPS id 4LGr9T3nLwzMprGn;
        Mon,  6 Jun 2022 12:59:57 +0200 (CEST)
Received: from ns3096276.ip-94-23-54.eu (unknown [23.97.221.149])
        by smtp-3-0001.mail.infomaniak.ch (Postfix) with ESMTPA id 4LGr9T0cHpzlkNB1;
        Mon,  6 Jun 2022 12:59:56 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=digikod.net;
        s=20191114; t=1654513197;
        bh=FqRGf4kpLKkr1NVbnLZw6bRcVLRJhdA0s+0fSCyzeUM=;
        h=Date:To:Cc:References:From:Subject:In-Reply-To:From;
        b=lMpgKecbHZvizhrZyviBEBPkb8jdG4GaX2ITMjriwUhaN8QJv2AbjXRDYLd92NU8R
         zJEVSSlbYp0bzlxI/UtQu3Wjni65dtQ5WvmxwUCfTg+IswjmvbEcFHGFXq/bABKngt
         RAW4uxXjBc3+cJrjSnnqaZ1H23j/HzgSx/UnWttk=
Message-ID: <f4619c73-9ff1-db8e-de06-3ba984b24399@digikod.net>
Date:   Mon, 6 Jun 2022 12:59:56 +0200
MIME-Version: 1.0
User-Agent: 
Content-Language: en-US
To:     gregkh@linuxfoundation.org
Cc:     stable@vger.kernel.org, Paul Moore <paul@paul-moore.com>
References: <165450152566@kroah.com>
From:   =?UTF-8?Q?Micka=c3=abl_Sala=c3=bcn?= <mic@digikod.net>
Subject: Re: WTF: patch "[PATCH] selftests/landlock: Format with clang-format"
 was seriously submitted to be applied to the 5.18-stable tree?
In-Reply-To: <165450152566@kroah.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Greg,

The 21 Landlock commits merged for 5.19-rc1 and tagged with Cc stable@ 
should indeed be backported up to 5.15 . The first commits are pure 
cosmetic changes but they need to be backported to avoid backport 
conflicts (for this series and future backports). They help maintain 
this subsystem, including to backport future changes. The following 
changes up to commit 8ba0005ff418 ("landlock: Fix same-layer rule 
unions") are required to fix some edge case issues (i.e. syscall 
argument ordering checks and same-layer rule unions). New tests are 
added to check that everything work as expected for these backportable 
changes, and to make it possible for more test environments to run. I 
successfully tested the backport of all these commits to 5.15 . Please 
backport them to all stable branches.

Here is the full list of the commits to backport (already marked with 
Cc: stable@vger.kernel.org):

8ba0005ff418 landlock: Fix same-layer rule unions
2cd7cd6eed88 landlock: Create find_rule() from unmask_layers()
75c542d6c6cc landlock: Reduce the maximum number of layers to 16
5f2ff33e1084 landlock: Define access_mask_t to enforce a consistent 
access mask size
6533d0c3a86e selftests/landlock: Test landlock_create_ruleset(2) 
argument check ordering
eba39ca4b155 landlock: Change landlock_restrict_self(2) check ordering
589172e5636c landlock: Change landlock_add_rule(2) argument check ordering
d1788ad99087 selftests/landlock: Add tests for O_PATH
6a1bdd4a0bfc selftests/landlock: Fully test file rename with "remove" access
d18955d094d0 selftests/landlock: Extend access right tests to directories
c56b3bf566da selftests/landlock: Add tests for unknown access rights
291865bd7e8b selftests/landlock: Extend tests for minimal valid 
attribute size
87129ef13603 selftests/landlock: Make tests build with old libc
a13e248ff90e landlock: Fix landlock_add_rule(2) documentation
81709f3dccac samples/landlock: Format with clang-format
9805a722db07 samples/landlock: Add clang-format exceptions
371183fa578a selftests/landlock: Format with clang-format
135464f9d29c selftests/landlock: Normalize array assignment
4598d9abf421 selftests/landlock: Add clang-format exceptions
06a1c40a09a8 landlock: Format with clang-format
6cc2df8e3a39 landlock: Add clang-format exceptions

Regards,
  Mickaël


On 06/06/2022 09:45, gregkh@linuxfoundation.org wrote:
> The patch below was submitted to be applied to the 5.18-stable tree.
> 
> I fail to see how this patch meets the stable kernel rules as found at
> Documentation/process/stable-kernel-rules.rst.
> 
> I could be totally wrong, and if so, please respond to
> <stable@vger.kernel.org> and let me know why this patch should be
> applied.  Otherwise, it is now dropped from my patch queues, never to be
> seen again.
> 
> thanks,
> 
> greg k-h
> 
> ------------------ original commit in Linus's tree ------------------
> 
>>From 371183fa578a4cf56b3ae12e54b7f01a4249add1 Mon Sep 17 00:00:00 2001
> From: =?UTF-8?q?Micka=C3=ABl=20Sala=C3=BCn?= <mic@digikod.net>
> Date: Fri, 6 May 2022 18:05:11 +0200
> Subject: [PATCH] selftests/landlock: Format with clang-format
> MIME-Version: 1.0
> Content-Type: text/plain; charset=UTF-8
> Content-Transfer-Encoding: 8bit
> 
> Let's follow a consistent and documented coding style.  Everything may
> not be to our liking but it is better than tacit knowledge.  Moreover,
> this will help maintain style consistency between different developers.
> 
> This contains only whitespace changes.
> 
> Automatically formatted with:
> clang-format-14 -i tools/testing/selftests/landlock/*.[ch]
> 
> Link: https://lore.kernel.org/r/20220506160513.523257-6-mic@digikod.net
> Cc: stable@vger.kernel.org
> [mic: Update style according to
> https://lore.kernel.org/r/02494cb8-2aa5-1769-f28d-d7206f284e5a@digikod.net]
> Signed-off-by: Mickaël Salaün <mic@digikod.net>
