Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 385C320B8F5
	for <lists+stable@lfdr.de>; Fri, 26 Jun 2020 21:03:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725811AbgFZTDM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 26 Jun 2020 15:03:12 -0400
Received: from cheddar.halon.org.uk ([93.93.131.118]:57656 "EHLO
        cheddar.halon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725803AbgFZTDM (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 26 Jun 2020 15:03:12 -0400
Received: from bsmtp by cheddar.halon.org.uk with local-bsmtp (Exim 4.92)
        (envelope-from <steve@einval.com>)
        id 1jotd0-00030i-E2; Fri, 26 Jun 2020 20:03:10 +0100
Received: from steve by tack.einval.org with local (Exim 4.92)
        (envelope-from <steve@einval.com>)
        id 1jotbC-0005mW-VS; Fri, 26 Jun 2020 20:01:18 +0100
Date:   Fri, 26 Jun 2020 20:01:18 +0100
From:   Steve McIntyre <steve@einval.com>
To:     John Johansen <john.johansen@canonical.com>
Cc:     Jann Horn <jannh@google.com>, Greg KH <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>,
        stable <stable@vger.kernel.org>, 963493@bugs.debian.org
Subject: Re: Repeatable hard lockup running strace testsuite on 4.19.98+
 onwards
Message-ID: <20200626190118.GA21186@tack.einval.com>
References: <20200626113558.GA32542@unset.einval.com>
 <20200626134132.GB4024297@kroah.com>
 <CAG48ez3fQroA2Drx3vCUB38=f82Bv0t+MnR6chhH3GM7y-SziQ@mail.gmail.com>
 <20200626165000.GB2950@unset.einval.com>
 <eed65f58-b63e-bfa4-ac74-1501cef58466@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <eed65f58-b63e-bfa4-ac74-1501cef58466@canonical.com>
X-attached: unknown
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Jun 26, 2020 at 10:29:28AM -0700, John Johansen wrote:
>On 6/26/20 9:50 AM, Steve McIntyre wrote:
>> 
>> OK, will try that second...
>> 
>
>I have not been able to reproduce but
>
>So looking at linux-4.19.y it looks like
>1f8266ff5884 apparmor: don't try to replace stale label in ptrace access check
>
>was picked without
>ca3fde5214e1 apparmor: don't try to replace stale label in ptraceme check
>
>Both of them are marked as
>Fixes: b2d09ae449ced ("apparmor: move ptrace checks to using labels")
>
>so I would expect them to be picked together.
>
>ptraceme is potentially updating the task's cred while the access check is
>running.
>
>Try building after picking
>ca3fde5214e1 apparmor: don't try to replace stale label in ptraceme check

Bingo! With that one change the test suite runs to completion, no lockup.

\o/

Thanks guys, I think we've found the cause here.

-- 
Steve McIntyre, Cambridge, UK.                                steve@einval.com
"The whole problem with the world is that fools and fanatics are
 always so certain of themselves, and wiser people so full of doubts."
   -- Bertrand Russell

