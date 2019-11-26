Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9FD5D10A3FF
	for <lists+stable@lfdr.de>; Tue, 26 Nov 2019 19:15:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725870AbfKZSPq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 Nov 2019 13:15:46 -0500
Received: from mail.kernel.org ([198.145.29.99]:51944 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725990AbfKZSPq (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 26 Nov 2019 13:15:46 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7924B20727;
        Tue, 26 Nov 2019 18:15:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574792145;
        bh=COH748/XQuHt14eNPywlJKfxyGyc7akxJKODjbiHQXA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=g4ZKYO6I4i2TRKbhxmsgq1GnVf6SccgM2ky07d8Uq7reIGxXLltGFKjK92wqr7vO8
         FBXQ1WgSMGQJvTufExFW6LCJlU+JqQEE1blrfdo06YnGd0wr1aNFYJS9DC4dixc0nl
         H7JuAGUFm6mE67kLKcLs2rws13g3eRhf475SvBag=
Date:   Tue, 26 Nov 2019 19:15:43 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Mike Snitzer <snitzer@redhat.com>
Cc:     vcaputo@pengaru.com, stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] Revert "dm crypt: use WQ_HIGHPRI for the
 IO and crypt" failed to apply to 4.19-stable tree
Message-ID: <20191126181543.GA1671058@kroah.com>
References: <157476486318662@kroah.com>
 <20191126170550.GA2718@redhat.com>
 <20191126172828.GA1665391@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20191126172828.GA1665391@kroah.com>
User-Agent: Mutt/1.12.2 (2019-09-21)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Nov 26, 2019 at 06:28:29PM +0100, Greg KH wrote:
> On Tue, Nov 26, 2019 at 12:05:50PM -0500, Mike Snitzer wrote:
> > On Tue, Nov 26 2019 at  5:41am -0500,
> > gregkh@linuxfoundation.org <gregkh@linuxfoundation.org> wrote:
> > 
> > > 
> > > The patch below does not apply to the 4.19-stable tree.
> > > If someone wants it applied there, or to any other stable or longterm
> > > tree, then please email the backport, including the original git commit
> > > id to <stable@vger.kernel.org>.
> > > 
> > > thanks,
> > > 
> > > greg k-h
> > > 
> > 
> > I assume you didn't first pull in the prereq commit detailed in the
> > commit header with:
> >  Requires: ed0302e83098d ("dm crypt: make workqueue names device-specific")
> > 
> > ?
> > 
> > Because this worked for me:
> > git cherry-pick ed0302e83098d
> > git cherry-pick f612b2132db529feac4f965f28a1b9258ea7c22b
> 
> Oops, missed that, will go try that now, sorry for the noise...

Nope, that did not work, the build breaks on both 4.14.y and 4.19.y:

drivers/md/dm-crypt.c: In function ‘crypt_ctr’:
drivers/md/dm-crypt.c:2674:24: error: implicit declaration of function ‘dm_table_device_name’; did you mean ‘dm_device_name’? [-Werror=implicit-function-declaration]
 2674 |  const char *devname = dm_table_device_name(ti->table);
      |                        ^~~~~~~~~~~~~~~~~~~~
      |                        dm_device_name

So we need working backports for 4.14.y and 4.19.y please.  I'm going to
go drop these patches from those queues now.

thanks,

greg k-h
