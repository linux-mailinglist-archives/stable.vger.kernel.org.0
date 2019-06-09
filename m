Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3DE743A6DB
	for <lists+stable@lfdr.de>; Sun,  9 Jun 2019 18:38:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728858AbfFIQia (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 9 Jun 2019 12:38:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:37188 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728678AbfFIQia (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 9 Jun 2019 12:38:30 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 039C3206C3;
        Sun,  9 Jun 2019 16:38:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1560098309;
        bh=79QRfsPQqPY0okGXzSNRFKdqiw8IAWcQjpMsIY34bDo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=hQ+OT9SKRIM9UPCGhSeRnzjCR4H9e7Wb5SGvxoR+VVFLW5jxI+gtyPRo9sXzzEIg7
         dG5k2rHtPQm6knDDawL0Lb9KB4/3ZgNW9EWtYbGdBsoQcDz8YHvjZ3agQMxkX9wPsj
         EeRHttjwSXV+zBpBvL2f/tI3pI5GIYnIzC7JuTTQ=
Date:   Sun, 9 Jun 2019 18:38:26 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Kirill Smelkov <kirr@nexedi.com>
Cc:     stable@vger.kernel.org, Sasha Levin <sashal@kernel.org>,
        Ben Hutchings <ben@decadent.org.uk>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Miklos Szeredi <miklos@szeredi.hu>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4.14 0/2] Fix FUSE read/write deadlock on stream-like
 files
Message-ID: <20190609163826.GB26671@kroah.com>
References: <20190609123831.11489-1-kirr@nexedi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190609123831.11489-1-kirr@nexedi.com>
User-Agent: Mutt/1.12.0 (2019-05-25)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, Jun 09, 2019 at 12:39:08PM +0000, Kirill Smelkov wrote:
> Hello stable team,
> 
> Please consider applying the following 2 patches to Linux-4.14 stable
> tree. The patches fix regression introduced in 3.14 where both read and
> write started to run under lock taken, which resulted in FUSE (and many
> other drivers) deadlocks for cases where stream-like files are used with
> read and write being run simultaneously.
> 
> Please see complete problem description in upstream commit 10dce8af3422
> ("fs: stream_open - opener for stream-like files so that read and write
> can run simultaneously without deadlock").
> 
> The actual FUSE fix (upstream commit bbd84f33652f "fuse: Add
> FOPEN_STREAM to use stream_open()") was merged into 5.2 with `Cc:
> stable@vger.kernel.org # v3.14+` mark and is already included into 5.1,
> 5.0 and 4.19 stable trees. However for some reason it is not (yet ?)
> included into 4.14, 4.9, 4.4, 3.18 and 3.16 trees.
> 
> The patches fix a real problem into which my FUSE filesystem ran, and
> which also likely affects OSSPD (full details are in the patches
> description). Please consider including the fixes into 4.14 (as well as
> into earlier stable trees - I will send corresponding series separately -
> - one per tree).

Many thanks for these.  I've queued up all but the 3.16 patches (those
are for Ben).

I hadn't done the backport yet, as I didn't know how "severe" this was,
and didn't have the time to do it.  Thanks for making it easy :)

greg k-h
