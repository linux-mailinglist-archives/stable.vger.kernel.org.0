Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4EFD5108EE6
	for <lists+stable@lfdr.de>; Mon, 25 Nov 2019 14:30:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727506AbfKYNau (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 25 Nov 2019 08:30:50 -0500
Received: from mail.kernel.org ([198.145.29.99]:53230 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725862AbfKYNau (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 25 Nov 2019 08:30:50 -0500
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 718342075C;
        Mon, 25 Nov 2019 13:30:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574688649;
        bh=DKTxTYEHpLN4507rM9teodEJoPOpeztx1Ui9fnbERaQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=SR5y8ETh0yuekRDgK3zvnCDsnV7fPWk3iXhNnBvmRtQ/6b4Top6E2yUTcaP06ilCZ
         SvIeBBzfhj5XkP1P7i8cEINWOlbcgZ0p1ehdYMi16n4SCWjEfsmzt8c9oiVqE4BRAn
         0APjRq6zlUgNbWIoOLUnhNsBrBTDbttiq5xI2Bj8=
Date:   Mon, 25 Nov 2019 08:30:48 -0500
From:   Sasha Levin <sashal@kernel.org>
To:     Willy Tarreau <w@1wt.eu>
Cc:     Bob Funk <bobfunk11@gmail.com>,
        Greg KH <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Subject: Re: Bug Report - Kernel Branch 4.4.y - asus-wmi.c
Message-ID: <20191125133048.GA12367@sasha-vm>
References: <33bfa93a-3853-85f5-47f9-8a69ed9c656e@gmail.com>
 <20191123092701.GA2129125@kroah.com>
 <e452278c-4b5c-59fc-441c-94b41d817503@gmail.com>
 <20191123192244.GA16156@1wt.eu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20191123192244.GA16156@1wt.eu>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, Nov 23, 2019 at 08:22:44PM +0100, Willy Tarreau wrote:
>On Sat, Nov 23, 2019 at 01:08:03PM -0600, Bob Funk wrote:
>> For the record, the patch that Willy offered does fix the issue on my
>> affected
>> system. That might be a better choice than my request to revert as per the
>> original email.
>
>Greg, FWIW I did nothing more than a regular backport so that you can take
>it as-is. I think you dropped it from 4.4 because it did not apply well
>and was not worth the hassle, but given that it fixes a regression caused
>by another backport I think it makes sense to take it, at least so that
>some users do not stop updating. The fix was only merged into 4.19, not
>4.4/4.9/4.14.
>
>The backports for 4.9 and 4.14 are easy to do, if you're willing to take
>the patches I can do them as well, just let me know.

Let's try something like this:

For 4.14 and 4.9 I'll also grab db2582afa744 ("platform/x86:
asus-nb-wmi: Support ALS on the Zenbook UX430UQ") which makes 401fee819
apply cleanly.

For 4.4, I'll grab this long list:

92a505e8055f ("platform/x86: asus-wmi: add SERIO_I8042 dependency")
db2582afa744 ("platform/x86: asus-nb-wmi: Support ALS on the Zenbook UX430UQ")
71f38c11cdb8 ("platform/x86: asus-wmi: Set specified XUSB2PR value for X550LB")
999d4376c628 ("platform/x86: asus-wmi: fix asus ux303ub brightness issue")
a961a285b479 ("asus-wmi: Add quirk_no_rfkill_wapf4 for the Asus X456UF")
a977e59c0c67 ("asus-wmi: Create quirk for airplane_mode LED")
6b7ff2af5286 ("asus-wmi: Add quirk_no_rfkill for the Asus Z550MA")
02db9ff7af18 ("asus-wmi: Add quirk_no_rfkill for the Asus U303LB")
2d735244b798 ("asus-wmi: Add quirk_no_rfkill for the Asus N552VW")
b5643539b825 ("platform/x86: asus-wmi: Filter buggy scan codes on ASUS Q500A")
7c1c184bb571 ("platform/x86: asus-wmi: try to set als by default")
aca234f63788 ("asus-wmi: provide access to ALS control")

Which looks scary, but it's all quirks for laptops folks are actually
using with this kernel. Then 401fee819 also applies cleanly on 4.4.

-- 
Thanks,
Sasha
