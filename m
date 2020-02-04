Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A1F73151851
	for <lists+stable@lfdr.de>; Tue,  4 Feb 2020 11:00:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726375AbgBDKAV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 4 Feb 2020 05:00:21 -0500
Received: from mail.kernel.org ([198.145.29.99]:38910 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726329AbgBDKAV (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 4 Feb 2020 05:00:21 -0500
Received: from localhost (unknown [212.187.182.163])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 398F3217BA;
        Tue,  4 Feb 2020 10:00:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1580810420;
        bh=i4/pV3yXt1Xq5NaSU6N3KYYw34q7CC7h07LBX1XrFKI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=WcZprKCXPGJibCXsrLvxeuo1CW7VAvOY7oSXtV1zu8WkgBtiFdtvj6hdD97dmZyH4
         c/SHnqYnyNp9da4tCocaDR/ZG+4kOJWSm+pH/u5z+8YA3yXKHgWbfgC3lx5cTmHK02
         n+HpahEMU8dyzKY5EbnkoaewR/3Al7PnMd0MnJqM=
Date:   Tue, 4 Feb 2020 10:00:16 +0000
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Johan Hovold <johan@kernel.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Amitkumar Karwar <amitkarwar@gmail.com>,
        Siva Rebbagondla <siva8118@gmail.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Denis Efremov <efremov@linux.com>
Subject: Re: [PATCH 5.4 117/203] rsi: fix potential null dereference in
 rsi_probe()
Message-ID: <20200204100016.GA1088789@kroah.com>
References: <20200116231745.218684830@linuxfoundation.org>
 <20200116231755.604943633@linuxfoundation.org>
 <20200204083332.GE26725@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200204083332.GE26725@localhost>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Feb 04, 2020 at 09:33:32AM +0100, Johan Hovold wrote:
> On Fri, Jan 17, 2020 at 12:17:14AM +0100, Greg Kroah-Hartman wrote:
> > From: Denis Efremov <efremov@linux.com>
> > 
> > commit f170d44bc4ec2feae5f6206980e7ae7fbf0432a0 upstream.
> > 
> > The id pointer can be NULL in rsi_probe(). It is checked everywhere except
> > for the else branch in the idProduct condition. The patch adds NULL check
> > before the id dereference in the rsi_dbg() call.
> > 
> > Fixes: 54fdb318c111 ("rsi: add new device model for 9116")
> > Cc: Amitkumar Karwar <amitkarwar@gmail.com>
> > Cc: Siva Rebbagondla <siva8118@gmail.com>
> > Cc: Kalle Valo <kvalo@codeaurora.org>
> > Signed-off-by: Denis Efremov <efremov@linux.com>
> > Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
> > Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> 
> This commit is bogus and was reverted shortly after it was applied in
> order to prevent autosel from picking it up for stable (reverted by
> c5dcf8f0e850 ("Revert "rsi: fix potential null dereference in
> rsi_probe()"")).
> 
> The revert has now been picked up by Sasha, but shouldn't an
> explicit revert in the same pull-request prevent a bad patch from being
> backported in the first place? Seems like something that could be
> scripted. But perhaps the net-stable oddities come into play here.

This was my fault, I picked it up, and didn't run a "has this patch been
reverted" type search on them.  I'll add that to my workflow, sorry.

greg k-h
