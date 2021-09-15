Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5F55840CBF9
	for <lists+stable@lfdr.de>; Wed, 15 Sep 2021 19:53:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229647AbhIORzE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Sep 2021 13:55:04 -0400
Received: from rfvt.org.uk ([37.187.119.221]:50456 "EHLO rfvt.org.uk"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229479AbhIORzD (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 15 Sep 2021 13:55:03 -0400
X-Greylist: delayed 485 seconds by postgrey-1.27 at vger.kernel.org; Wed, 15 Sep 2021 13:55:03 EDT
Received: from wylie.me.uk (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by rfvt.org.uk (Postfix) with ESMTPS id 16E5B827CB;
        Wed, 15 Sep 2021 18:45:34 +0100 (BST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=wylie.me.uk;
        s=mydkim005; t=1631727934;
        bh=Vd3/6etrg7grVFKe0V8XPsHbhxyz/XnafufXnkG8w1Q=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To;
        b=piltGsaHd0Rq3lFOVYJAfKkOBaD8u48GvEE5a6f+PHrKgTZFIt3WvkZ/HID0Ny9Sk
         4hxNOuUY3vCXI1JqEXoTY1yyry3XIAl5EF4+0RjQ81/xAVTWX3ABYKNW0fpd22pv67
         zVwu2N8qLa+a5jSWIbWCcuxTGAln3pTXY1cX55y8Oa2jcCOyW9TWRvjZqoPbdUOUbD
         txexZMj2hdCnWfVFwjvU8FEFr+Rj5K0WSY8TwSpbvQVk2ldf6TJ6rEzCSFrXen0sRp
         4wBkwfXGS2nevZCDiKCjRk5pqQOvVmPTR0uJvu9LH7ssDT+Bms8W60zMTsR95d7kkG
         dwjtVNWz6gs7Q==
From:   alan@wylie.me.uk (Alan J. Wylie)
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Frederic Weisbecker <frederic@kernel.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Regression in posix-cpu-timers.c (was Re: Linux 5.14.4)
References: <1631693373201133@kroah.com>
Date:   Wed, 15 Sep 2021 18:45:33 +0100
In-Reply-To: <1631693373201133@kroah.com> (Greg Kroah-Hartman's message of
        "Wed, 15 Sep 2021 10:09:33 +0200")
Message-ID: <87ilz1pwaq.fsf@wylie.me.uk>
User-Agent: Gnus/5.130012 (Ma Gnus v0.12) Emacs/27 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


Greg Kroah-Hartman <gregkh@linuxfoundation.org> writes:

> I'm announcing the release of the 5.14.4 kernel.

I'm seeing a regression in 5.14.4

Running Nextcloud (a PHP web application) with a PostgreSQL backend

All was fine with 5.14.3

With 5.14.4, Nextcloud hangs loading events/contacts, etc.

As well as the web interface hanging, running this command on the command
line also errors:

# su apache -s /bin/bash -c "cd /var/www/htdocs/nextcloud/ && php occ maintenance:mode --on"
PHP Fatal error:  Maximum execution time of 0 seconds exceeded in
/var/www/htdocs/nextcloud/lib/private/Files/AppData/AppData.php on line 41

# su apache -s /bin/bash -c "cd /var/www/htdocs/nextcloud/ && php occ maintenance:mode --on"
PHP Fatal error:  Maximum execution time of 0 seconds exceeded in
/var/www/htdocs/nextcloud/3rdparty/symfony/console/Application.php on line 65

# su apache -s /bin/bash -c "cd /var/www/htdocs/nextcloud/ && php occ maintenance:mode --on"
PHP Fatal error:  Maximum execution time of 0 seconds exceeded in
/var/www/htdocs/nextcloud/lib/public/Files/SimpleFS/ISimpleRoot.php on line 68

# su apache -s /bin/bash -c "cd /var/www/htdocs/nextcloud/ && php occ maintenance:mode --on"
PHP Fatal error:  Maximum execution time of 0 seconds exceeded in
/var/www/htdocs/nextcloud/apps/theming/lib/ImageManager.php on line 313

Note that the above commands were all run immediately after each other,
but showed up in different php scripts.

Similar errors appear in the Apache log.

After reverting this commit in 5.14.4, Nextcloud resumed working.

$ git revert 564005805aadec9cb7e5dc4e14071b8f87cd6b58

This commit is 406dd42bd1ba0c01babf9cde169bb319e52f6147 in Linus's tree

I'll be more than happy to help with debugging / diagnosing this

The server is running up-to-date Gentoo.

postgres (PostgreSQL) 13.3
PHP 7.4.21 (cli) (built: Jul 11 2021 06:14:49) ( ZTS )
Server version: Apache/2.4.48 (Unix)
Nextcloud 21.0.3

$ git bisect bad
564005805aadec9cb7e5dc4e14071b8f87cd6b58 is the first bad commit
commit 564005805aadec9cb7e5dc4e14071b8f87cd6b58
Author: Frederic Weisbecker <frederic@kernel.org>
Date:   Mon Jul 26 14:55:10 2021 +0200

    posix-cpu-timers: Force next expiration recalc after itimer reset
    
    [ Upstream commit 406dd42bd1ba0c01babf9cde169bb319e52f6147 ]
    
    When an itimer deactivates a previously armed expiration, it simply doesn't
    do anything. As a result the process wide cputime counter keeps running and
    the tick dependency stays set until it reaches the old ghost expiration
    value.
    
    This can be reproduced with the following snippet:
    
            void trigger_process_counter(void)
            {
                    struct itimerval n = {};
    
                    n.it_value.tv_sec = 100;
                    setitimer(ITIMER_VIRTUAL, &n, NULL);
                    n.it_value.tv_sec = 0;
                    setitimer(ITIMER_VIRTUAL, &n, NULL);
            }
    
    Fix this with resetting the relevant base expiration. This is similar to
    disarming a timer.
    
    Signed-off-by: Frederic Weisbecker <frederic@kernel.org>
    Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
    Acked-by: Peter Zijlstra (Intel) <peterz@infradead.org>
    Link: https://lore.kernel.org/r/20210726125513.271824-4-frederic@kernel.org
    Signed-off-by: Sasha Levin <sashal@kernel.org>

 kernel/time/posix-cpu-timers.c | 2 --
 1 file changed, 2 deletions(-)
$ 

$ git bisect log
git bisect start
# bad: [d6f7bb5bb29096b2935c55deeb545616dab74406] Linux 5.14.4
git bisect bad d6f7bb5bb29096b2935c55deeb545616dab74406
# good: [d27a14321366788cef927dbe69854f34460b3f7c] Linux 5.14.3
git bisect good d27a14321366788cef927dbe69854f34460b3f7c
# bad: [203baf2a84d30b468ae80868344e7685b8f4124b] net: dsa: tag_sja1105: optionally build as module when switch driver is module if PTP is enabled
git bisect bad 203baf2a84d30b468ae80868344e7685b8f4124b
# bad: [d031746f556b344d87033bc9dcee1a65dd6a56a3] drm/panfrost: Fix missing clk_disable_unprepare() on error in panfrost_clk_init()
git bisect bad d031746f556b344d87033bc9dcee1a65dd6a56a3
# bad: [115540457feae9a215e5c16e434f71b80860038f] io-wq: remove GFP_ATOMIC allocation off schedule out path
git bisect bad 115540457feae9a215e5c16e434f71b80860038f
# bad: [923c1c5ca5a81958a8bfd891bc16c319c4bb9e6d] nvme-tcp: don't update queue count when failing to set io queues
git bisect bad 923c1c5ca5a81958a8bfd891bc16c319c4bb9e6d
# good: [f02146cf84e6165cae177aea30acdea7b8d76cf3] EDAC/mce_amd: Do not load edac_mce_amd module on guests
git bisect good f02146cf84e6165cae177aea30acdea7b8d76cf3
# bad: [796c0a620178d68900fb2f4bf987cd89a9b38090] udf: Fix iocharset=utf8 mount option
git bisect bad 796c0a620178d68900fb2f4bf987cd89a9b38090
# bad: [0d7541f439be37dabb7546889503d16ac59ec29f] hrtimer: Avoid double reprogramming in __hrtimer_start_range_ns()
git bisect bad 0d7541f439be37dabb7546889503d16ac59ec29f
# bad: [564005805aadec9cb7e5dc4e14071b8f87cd6b58] posix-cpu-timers: Force next expiration recalc after itimer reset
git bisect bad 564005805aadec9cb7e5dc4e14071b8f87cd6b58
# first bad commit: [564005805aadec9cb7e5dc4e14071b8f87cd6b58] posix-cpu-timers: Force next expiration recalc after itimer reset
$

-- 
Alan J. Wylie                                          https://www.wylie.me.uk/

Dance like no-one's watching. / Encrypt like everyone is.
Security is inversely proportional to convenience
