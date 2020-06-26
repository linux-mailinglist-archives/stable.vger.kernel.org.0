Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F2E4220B125
	for <lists+stable@lfdr.de>; Fri, 26 Jun 2020 14:11:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728103AbgFZMLL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 26 Jun 2020 08:11:11 -0400
Received: from cheddar.halon.org.uk ([93.93.131.118]:50534 "EHLO
        cheddar.halon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727977AbgFZMLL (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 26 Jun 2020 08:11:11 -0400
X-Greylist: delayed 2099 seconds by postgrey-1.27 at vger.kernel.org; Fri, 26 Jun 2020 08:11:10 EDT
Received: from bsmtp by cheddar.halon.org.uk with local-bsmtp (Exim 4.92)
        (envelope-from <steve@einval.com>)
        id 1jomeQ-0001Lv-DB; Fri, 26 Jun 2020 12:36:10 +0100
Received: from steve by tack.einval.org with local (Exim 4.92)
        (envelope-from <steve@einval.com>)
        id 1jomeE-0001Xk-BP; Fri, 26 Jun 2020 12:35:58 +0100
Date:   Fri, 26 Jun 2020 12:35:58 +0100
From:   Steve McIntyre <steve@einval.com>
To:     stable@vger.kernel.org
Cc:     963493@bugs.debian.org
Subject: Repeatable hard lockup running strace testsuite on 4.19.98+ onwards
Message-ID: <20200626113558.GA32542@unset.einval.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-attached: unknown
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi folks,

I'm the maintainer in Debian for strace. Trying to reproduce
https://bugs.debian.org/963462 on my machine (Thinkpad T470), I've
found a repeatable hard lockup running the strace testsuite. Each time
it seems to have failed in a slightly different place in the testsuite
(suggesting it's not one particular syscall test that's triggering the
failure). I initially found this using Debian's current Buster kernel
(4.19.118+2+deb10u1), then backtracking I found that 4.19.98+1+deb10u1
worked fine.

I've bisected to find the failure point along the linux-4.19.y stable
branch and what I've got to is the following commit:

e58f543fc7c0926f31a49619c1a3648e49e8d233 is the first bad commit
commit e58f543fc7c0926f31a49619c1a3648e49e8d233
Author: Jann Horn <jannh@google.com>
Date:   Thu Sep 13 18:12:09 2018 +0200

    apparmor: don't try to replace stale label in ptrace access check

    [ Upstream commit 1f8266ff58840d698a1e96d2274189de1bdf7969 ]

    As a comment above begin_current_label_crit_section() explains,
    begin_current_label_crit_section() must run in sleepable context because
    when label_is_stale() is true, aa_replace_current_label() runs, which uses
    prepare_creds(), which can sleep.
    Until now, the ptrace access check (which runs with a task lock held)
    violated this rule.

    Also add a might_sleep() assertion to begin_current_label_crit_section(),
    because asserts are less likely to be ignored than comments.

    Fixes: b2d09ae449ced ("apparmor: move ptrace checks to using labels")
    Signed-off-by: Jann Horn <jannh@google.com>
    Signed-off-by: John Johansen <john.johansen@canonical.com>
    Signed-off-by: Sasha Levin <sashal@kernel.org>

:040000 040000 ca92f885a38c1747b812116f19de6967084a647e 865a227665e460e159502f21e8a16e6fa590bf50 M security

Considering I'm running strace build tests to provoke this bug,
finding the failure in a commit talking about ptrace changes does look
very suspicious...!

Annoyingly, I can't reproduce this on my disparate other machines
here, suggesting it's maybe(?) timing related.

Hope this helps - happy to give more information, test things, etc.

-- 
Steve McIntyre, Cambridge, UK.                                steve@einval.com
"Managing a volunteer open source project is a lot like herding
 kittens, except the kittens randomly appear and disappear because they
 have day jobs." -- Matt Mackall

