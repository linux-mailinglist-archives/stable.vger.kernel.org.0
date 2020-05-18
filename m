Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EF5BD1D7271
	for <lists+stable@lfdr.de>; Mon, 18 May 2020 10:05:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726876AbgERIDa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 May 2020 04:03:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:36368 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726489AbgERID3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 18 May 2020 04:03:29 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3654A20787;
        Mon, 18 May 2020 08:03:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589789009;
        bh=mmzwWq+x+YwuOlGAZGoYiIL6vmZz6USIebAEuTVHsoI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=LUbxTyMJoLhlFyJf6S+Z4mA1VGurHEXkQR8E3CWtDnlF4QNEWJ13lsZRMgaSbcNT3
         TYdgn3nLl4KA894AygpL2ERKc75sdjqujxr8PuA9DYtuPtr4tTqrUGsRR+B3r826Q1
         XnoFtKY/VztwzbA1h2Ewjxcl3BKSvC6zacF1ry4M=
Date:   Mon, 18 May 2020 10:03:27 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Saravana Kannan <saravanak@google.com>
Cc:     "Rafael J. Wysocki" <rafael@kernel.org>,
        stable <stable@vger.kernel.org>,
        Android Kernel Team <kernel-team@android.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v1] driver core: Fix memory leak when adding
 SYNC_STATE_ONLY device links
Message-ID: <20200518080327.GA3126260@kroah.com>
References: <20200516080718.166676-1-saravanak@google.com>
 <CAGETcx8Ro_tsmYEQwzZKsm2xzimw=MBcChbSW5Nx9arUni53wQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAGETcx8Ro_tsmYEQwzZKsm2xzimw=MBcChbSW5Nx9arUni53wQ@mail.gmail.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, May 18, 2020 at 12:48:42AM -0700, Saravana Kannan wrote:
> On Sat, May 16, 2020 at 1:07 AM Saravana Kannan <saravanak@google.com> wrote:
> >
> > When SYNC_STATE_ONLY support was added in commit 05ef983e0d65 ("driver
> > core: Add device link support for SYNC_STATE_ONLY flag"),
> > device_link_add() incorrectly skipped adding the new SYNC_STATE_ONLY
> > device link to the supplier's and consumer's "device link" list. So the
> > "device link" is lost forever from driver core if the caller didn't keep
> > track of it (typically isn't expected to).
> >
> > If the same SYNC_STATE_ONLY device link is created again using
> > device_link_add(), instead of returning the pointer to the previously
> > created device link, a new device link is created and returned. This can
> > cause memory leaks in conjunction with fw_devlinks.
> >
> > Cc: stable@vger.kernel.org
> > Fixes: 05ef983e0d65 ("driver core: Add device link support for SYNC_STATE_ONLY flag")
> > Signed-off-by: Saravana Kannan <saravanak@google.com>
> 
> Greg/Rafael,
> 
> This patch causes a warning for SYNC_STATE_ONLY links because they
> allow consumers to probe before suppliers but the device link
> status/state change code wasn't written with that possibility in mind.
> So I need to fix up that warning or state change code.

What type of warning happens?

> Depending on how urgent you think memory leak fixes are, you can take
> it as is for now and I can send a separate patch to fix the
> warning/state change code later. Or if we can sit on this memory leak
> for a week, I might be able to fix the warning before then.

memory leaks are not ok, but neither is adding runtime warnings.  Any
chance we can't just get a fix for both?  :)

thanks,

greg k-h
