Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 95AF32E31EE
	for <lists+stable@lfdr.de>; Sun, 27 Dec 2020 17:55:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726045AbgL0Qz3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 27 Dec 2020 11:55:29 -0500
Received: from mail.kernel.org ([198.145.29.99]:36788 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726032AbgL0Qz3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 27 Dec 2020 11:55:29 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4EA9622512;
        Sun, 27 Dec 2020 16:54:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609088088;
        bh=DBPbQXCZ/7Qw5VXBdV3/F053S+d3UwPj2quilP6sf6c=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=MUUvBuAV6Hzlk8raDUOCeaOJxuQzcTp5CQ3EBGe64uxHHBH0tieZsOJAXO/QrV92N
         qZkWYRVkxf0XdQ1uFmTDM7Z+uxI2o5UKkL0HyeQ14j7oejEwysbm3PSF6OjHeEiBJk
         iv3pMEDTsPWFYej7idNusLA3MUjoW7wj0mM/1eRM=
Date:   Sun, 27 Dec 2020 17:56:12 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Jussi Kivilinna <jussi.kivilinna@iki.fi>
Cc:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org, lwn@lwn.net,
        jslaby@suse.cz
Subject: Re: LXC broken with 5.10-stable?, ok with 5.9-stable (Re: Linux
 5.10.3)
Message-ID: <X+i8rPxFIkUziZYN@kroah.com>
References: <16089960203931@kroah.com>
 <5ab86253-7703-e892-52b7-e6a8af579822@iki.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5ab86253-7703-e892-52b7-e6a8af579822@iki.fi>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, Dec 27, 2020 at 06:32:41PM +0200, Jussi Kivilinna wrote:
> Hello,
> 
> Now that 5.9 series is EOL, I tried to move to 5.10.3. I ran in to regression where LXC containers do not start with newer kernel. I found that issue had been reported (bisected + with reduced test case) in bugzilla at: https://bugzilla.kernel.org/show_bug.cgi?id=209971
> 
> Has this been fixed in 5.11-rc? Is there any patch that I could backport and test with 5.10?

Have you tried Linus's tree to see if this works yet?  If not, it should
be a simple fix.  See 7cfc630e63b4 ("proc "single files": switch to
->read_iter") as an example of what is needed here.

I think we will see a lot of these "/proc files need to be fixed up"
issues over time as this is something that we hit in the 5.10-rc
sequence and fixed a bunch of them already...

thanks,

greg k-h
