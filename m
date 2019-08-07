Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7FAB184A1A
	for <lists+stable@lfdr.de>; Wed,  7 Aug 2019 12:51:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729285AbfHGKvb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 7 Aug 2019 06:51:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:55190 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729160AbfHGKv3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 7 Aug 2019 06:51:29 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6AC7E21E6E;
        Wed,  7 Aug 2019 10:51:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1565175088;
        bh=WxYKmhU/d5C298A+QtBpNasoo7mco0vHhZ0d36pXWmI=;
        h=Date:From:To:Subject:References:In-Reply-To:From;
        b=S0RRfBTRawE6q8RXJDyAjSHYILuXDbyvegg0dkISG3juePwVznQWaSGWPC+Ga9en4
         12hNxlMT7eLaennWRaH/xK2EyAw9Kc45Jpq+//XWvPanG7w8UgeB93w9Vjlj9vz5tt
         lFWjghhhY1rhRW03ghl1JK7ifWKZPcBRCOdDD7Fg=
Date:   Wed, 7 Aug 2019 12:51:26 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     dsterba@suse.cz, Sasha Levin <sashal@kernel.org>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        David Sterba <dsterba@suse.com>,
        Filipe Manana <fdmanana@suse.com>, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH AUTOSEL 4.19 12/32] Btrfs: fix deadlock between fiemap
 and transaction commits
Message-ID: <20190807105126.GA14880@kroah.com>
References: <20190806213522.19859-1-sashal@kernel.org>
 <20190806213522.19859-12-sashal@kernel.org>
 <20190807094759.GQ28208@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190807094759.GQ28208@suse.cz>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Aug 07, 2019 at 11:47:59AM +0200, David Sterba wrote:
> On Tue, Aug 06, 2019 at 05:35:00PM -0400, Sasha Levin wrote:
> > From: Filipe Manana <fdmanana@suse.com>
> > 
> > [ Upstream commit a6d155d2e363f26290ffd50591169cb96c2a609e ]
> > 
> > Fixes: 03628cdbc64db6 ("Btrfs: do not start a transaction during fiemap")
> 
> The commit is a regression fix during the 5.2 cycle, how it could end up
> in a 4.19 stable candidate?
> 
> $ git describe  03628cdbc64db6
> v5.1-rc7-201-g03628cdbc64d
> 
> $ git describe --contains 03628cdbc64db6
> v5.2-rc1~163^2~26
> 
> And it does not belong to 5.2 either, git cherry-pick on top of 5.2
> fails.
> 
> I think such sanity check can be done automatically so the patches don't
> accidentally land in trees where don't belong.


Commit 03628cdbc64d ("Btrfs: do not start a transaction during fiemap")
was tagged for the stable trees, and ended up in the following releases:
	4.14.121 4.19.45 5.0.18 5.1.4 5.2
so yes, it does need to go back to all of those locations if this patch
really does fix the issue there.

thanks,

greg k-h
