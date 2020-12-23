Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 465462E2081
	for <lists+stable@lfdr.de>; Wed, 23 Dec 2020 19:40:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727207AbgLWSjK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Dec 2020 13:39:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44948 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726923AbgLWSjK (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 23 Dec 2020 13:39:10 -0500
Received: from mail-pl1-x632.google.com (mail-pl1-x632.google.com [IPv6:2607:f8b0:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 33A14C06179C
        for <stable@vger.kernel.org>; Wed, 23 Dec 2020 10:38:30 -0800 (PST)
Received: by mail-pl1-x632.google.com with SMTP id r4so92183pls.11
        for <stable@vger.kernel.org>; Wed, 23 Dec 2020 10:38:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=CMW5ViyQU/+rcIAs5RIk2eLGKzZv3mRO/aQHaVo6mfk=;
        b=JBP3GT/OHoL328Abv/ONPBJ4yooRBcLu9sayT/XlJLorOhYHcVw27t6KNR5RUi1vJo
         edjiM0HUHLif0WHiNlNPT4Tt8bD1kw9Wqplm3nabEzBYO/OFh7u6KILjD2LhLRubWqf0
         5JehQIOVkmgeA5A9+gaCs5KC01VoWVqW4CGjZH3YkPTxanF/nTHmqAhkGHjtteZb+KXN
         Z5L/At2CAR+kTIVrAIWDJo2DkqYgTGYhIAvEyfvMXxo0kAdroq7m/4mU7l43b0/H9q3Z
         iwgMAwA9xJoTM4SJJNjrzZYip8x7Vx0jtM76j0jcBLM4qNnCK4ZF7rgY/7pBFMsyOH5U
         Aeqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=CMW5ViyQU/+rcIAs5RIk2eLGKzZv3mRO/aQHaVo6mfk=;
        b=DQ3Sn/w4IW656OOOxxC8HxuLRWFrNfO3rlKLFBsC7U+mRTfn9GZLRwKhr30k3luLhW
         S8FxJU0xZaJvijxovAAkamnzB4xXyMCY3cCyz5j2qJWEjQSySbQyeNPvnsG1miydLNEw
         EFYHhanNhY0gfRG8D/jtqK1gB/ahXBHB5LnHf1eefMRcRK/WbcC9bQuTHpRK8RvxMlMv
         enF5VU/6ofcG5OCKlmyU/LEbzjvKbQhYyfG4uKb4XrPuU8BI4Vfh5G7oMzfKd6O9F8UA
         txwxk8h667XLg02L9Vox7gtBc4FyCtujNlh56Msavdsb51LQWH7S/AXxbkkSBIyjphTK
         nzXQ==
X-Gm-Message-State: AOAM530Q194BRXtYb5o6rclSiaxsfMe1UtL4Hg91Lk7SUqndbZZx9klR
        usZt6Nu97d/mejkOmzpIpQ==
X-Google-Smtp-Source: ABdhPJz++IthAEp6/qryF75rQ5HmiFuATcLs9er8y083JRtNGpLhXaoEW7qVbNFph32dBHBKudFlzQ==
X-Received: by 2002:a17:90b:228b:: with SMTP id kx11mr936531pjb.122.1608748709677;
        Wed, 23 Dec 2020 10:38:29 -0800 (PST)
Received: from PWN (59-125-13-244.HINET-IP.hinet.net. [59.125.13.244])
        by smtp.gmail.com with ESMTPSA id 145sm23406916pfu.8.2020.12.23.10.38.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Dec 2020 10:38:28 -0800 (PST)
Date:   Wed, 23 Dec 2020 13:38:24 -0500
From:   Peilin Ye <yepeilin.cs@gmail.com>
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     marcel@holtmann.org, stable@vger.kernel.org
Subject: Re: [PATCH 4.14 4.9 4.4-stable] Bluetooth: Fix slab-out-of-bounds
 read in hci_le_direct_adv_report_evt()
Message-ID: <20201223183824.GA17390@PWN>
References: <20201223180446.17207-1-yepeilin.cs@gmail.com>
 <X+OJyx/VEBlfItDz@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <X+OJyx/VEBlfItDz@kroah.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Dec 23, 2020 at 07:17:47PM +0100, Greg KH wrote:
> On Wed, Dec 23, 2020 at 01:04:46PM -0500, Peilin Ye wrote:
> > commit f7e0e8b2f1b0a09b527885babda3e912ba820798 upstream.
> > 
> > `num_reports` is not being properly checked. A malformed event packet with
> > a large `num_reports` number makes hci_le_direct_adv_report_evt() read out
> > of bounds. Fix it.
> > 
> > Backporting notes:
> >   - Rebased on linux-4.14.y, commit 3f2ecb86cb90 ("Linux 4.14.212")
> >   - Retested by syzbot
> > 
> > Cc: stable@vger.kernel.org
> > Fixes: 2f010b55884e ("Bluetooth: Add support for handling LE Direct Advertising Report events")
> > Reported-and-tested-by: syzbot+24ebd650e20bd263ca01@syzkaller.appspotmail.com
> > Link: https://syzkaller.appspot.com/bug?extid=24ebd650e20bd263ca01
> > Signed-off-by: Peilin Ye <yepeilin.cs@gmail.com>
> > Signed-off-by: Marcel Holtmann <marcel@holtmann.org>
> > ---
> >  net/bluetooth/hci_event.c | 12 +++++-------
> >  1 file changed, 5 insertions(+), 7 deletions(-)
> 
> Thanks for the backport, now queued up!

<offlist>

No problem!  It's 24th in China - Merry Christmas!

Peilin

