Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 99976659BE0
	for <lists+stable@lfdr.de>; Fri, 30 Dec 2022 21:22:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235408AbiL3UWc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 30 Dec 2022 15:22:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49224 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235468AbiL3UW3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 30 Dec 2022 15:22:29 -0500
Received: from outgoing.mit.edu (outgoing-auth-1.mit.edu [18.9.28.11])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A43814D14
        for <stable@vger.kernel.org>; Fri, 30 Dec 2022 12:22:29 -0800 (PST)
Received: from letrec.thunk.org (host-67-21-23-146.mtnsat.com [67.21.23.146] (may be forged))
        (authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
        by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 2BUKM0a3010174
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 30 Dec 2022 15:22:10 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mit.edu; s=outgoing;
        t=1672431732; bh=tE6+QatUZ4TgbJ1osuqxvSZAcNLGiSz1o9L4JHZPmCk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To;
        b=YS7zl6XoXD9b02Ln9yW0VIUuTsQf4GK9cqBfKdiaoUA3Dq25b8/POkGNYDmUiZrsf
         TkbKX4/0IrrD9jYybc5zeVVxxLXfOelYtx1++YfV3TNfnFBs9pbgy8WCGLIbMb3boB
         FyFO6fvpRYaXC70FI6BLLEEsLyFD0iuoOUdLxSoYwdaiM5HnBL5O9j094TL/PB6G9P
         9VhT5W52KJkhA+HtxxVdqWfK28qDFA3zTizGl3SjNxGYSY23CjD2ik/jbT+Cm9meXL
         x1MB2UwE5SR0wxg5Rncv6BW7JeIYDp3LPuCLSOrbYnWLXXU76A+aBWLVuZW64eSISb
         SZn4vHHNh7q2Q==
Received: by letrec.thunk.org (Postfix, from userid 15806)
        id 80A838C08C0; Fri, 30 Dec 2022 15:22:00 -0500 (EST)
Date:   Fri, 30 Dec 2022 15:22:00 -0500
From:   "Theodore Ts'o" <tytso@mit.edu>
To:     Tudor Ambarus <tudor.ambarus@linaro.org>
Cc:     Eric Biggers <ebiggers@kernel.org>, adilger.kernel@dilger.ca,
        linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
        joneslee@google.com,
        syzbot+0827b4b52b5ebf65f219@syzkaller.appspotmail.com,
        stable@vger.kernel.org
Subject: Re: [PATCH v2] ext4: Fix possible use-after-free in ext4_find_extent
Message-ID: <Y69IaMqZvnGk5skX@mit.edu>
References: <20221230062931.2344157-1-tudor.ambarus@linaro.org>
 <Y66LkPumQjHC2U7d@sol.localdomain>
 <cf1be149-392d-afa0-092a-c3426868f852@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cf1be149-392d-afa0-092a-c3426868f852@linaro.org>
X-Spam-Status: No, score=-4.0 required=5.0 tests=BAYES_00,DKIM_INVALID,
        DKIM_SIGNED,MAY_BE_FORGED,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Dec 30, 2022 at 01:42:45PM +0200, Tudor Ambarus wrote:
> > This is (incompletely) validating the extent header in the inode.  Isn't that
> > supposed to happen when the inode is loaded?  See how __ext4_iget() calls
> > ext4_ext_check_inode().  Why isn't that working here?
> > 
> 
> Seems that __ext4_iget() is not called on writes. You can find below the
> sequence of calls that leads to the bug. The debug was done on v6.2-rc1.
> I assume the extents check is no longer done on writes since
> commit 7a262f7c69163cd4811f2f838faef5c5b18439c9. The commit doesn't
> specify the reason though.

Commit 7a262f7c6916 no longer does the check if the inode is already
in memory (which is the case when there is an open file descriptor).
That's because it should have been checked when it was first read into
memory.

So the the question is, did the inode get corrupted somehow after it
was read in from disk?  If so that's the real problem, and that's what
needs to be root caused and fixed.  It's not sufficient to just to
make the syzbot reproducer only longer reproduce.  The question is
understanding what is fundamentally going on and fixing the real root
problem.

Regards,

						- Ted
