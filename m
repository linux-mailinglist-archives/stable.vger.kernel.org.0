Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 84E1020B983
	for <lists+stable@lfdr.de>; Fri, 26 Jun 2020 21:58:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725780AbgFZT57 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 26 Jun 2020 15:57:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:42436 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725275AbgFZT57 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 26 Jun 2020 15:57:59 -0400
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9EB45206BE;
        Fri, 26 Jun 2020 19:57:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1593201478;
        bh=BJoUR1xZSuVVlfX4JPT4JuMWZiU/SS/nH/hboi9MQcs=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=uVwgEg+h5vZTLbwgtfdou172jbhSZKGI0DLOwx7Qp11svxv7Qq9FNXEdiD78LDJ+j
         VXIV9Rkt0wb7ssRVm0NRnliyAgyyXYVucp8C6475QcOQrUu7L+UMaeuNRXgaV/tCB7
         bUpYOOGDIEJL/L04i03CkuP13CwlWY+BF/baaC6o=
Date:   Fri, 26 Jun 2020 15:57:57 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     Steve McIntyre <steve@einval.com>
Cc:     John Johansen <john.johansen@canonical.com>,
        Jann Horn <jannh@google.com>,
        Greg KH <gregkh@linuxfoundation.org>,
        stable <stable@vger.kernel.org>, 963493@bugs.debian.org
Subject: Re: Repeatable hard lockup running strace testsuite on 4.19.98+
 onwards
Message-ID: <20200626195757.GJ1931@sasha-vm>
References: <20200626113558.GA32542@unset.einval.com>
 <20200626134132.GB4024297@kroah.com>
 <CAG48ez3fQroA2Drx3vCUB38=f82Bv0t+MnR6chhH3GM7y-SziQ@mail.gmail.com>
 <20200626165000.GB2950@unset.einval.com>
 <eed65f58-b63e-bfa4-ac74-1501cef58466@canonical.com>
 <20200626190118.GA21186@tack.einval.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20200626190118.GA21186@tack.einval.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Jun 26, 2020 at 08:01:18PM +0100, Steve McIntyre wrote:
>On Fri, Jun 26, 2020 at 10:29:28AM -0700, John Johansen wrote:
>>On 6/26/20 9:50 AM, Steve McIntyre wrote:
>>>
>>> OK, will try that second...
>>>
>>
>>I have not been able to reproduce but
>>
>>So looking at linux-4.19.y it looks like
>>1f8266ff5884 apparmor: don't try to replace stale label in ptrace access check
>>
>>was picked without
>>ca3fde5214e1 apparmor: don't try to replace stale label in ptraceme check
>>
>>Both of them are marked as
>>Fixes: b2d09ae449ced ("apparmor: move ptrace checks to using labels")
>>
>>so I would expect them to be picked together.
>>
>>ptraceme is potentially updating the task's cred while the access check is
>>running.
>>
>>Try building after picking
>>ca3fde5214e1 apparmor: don't try to replace stale label in ptraceme check
>
>Bingo! With that one change the test suite runs to completion, no lockup.

I've queued ca3fde5214e1 for 4.19 and 4.14, thank you for your work!

-- 
Thanks,
Sasha
