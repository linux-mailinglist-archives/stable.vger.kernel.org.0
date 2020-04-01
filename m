Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E824B19A8AF
	for <lists+stable@lfdr.de>; Wed,  1 Apr 2020 11:32:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726335AbgDAJcj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Apr 2020 05:32:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:39118 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726205AbgDAJci (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 1 Apr 2020 05:32:38 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A4F2A2077D;
        Wed,  1 Apr 2020 09:32:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1585733558;
        bh=xtE1mv8YAvKB5Kfv9vt5dhKztsixpt9Lc6n4TMDHWpM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=BqUYMJRlqIA7NMvhigFl1OrlYqFzLjdVooC6suZoS1kwA8qhb+RCRIDyZ4r9iGhjB
         1v8Q2uMlxdtdr3Me2BUwo6np6eBZ/kt2oS3MoRx+YGQD453ltp5kmJy6ZuOcu9l5gv
         9247W3Wd1mcYlf9liVFsU48RBJD/4e0RfmRZenGo=
Date:   Wed, 1 Apr 2020 11:32:35 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     "Schmid, Carsten" <Carsten_Schmid@mentor.com>
Cc:     "sashal@kernel.org" <sashal@kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: Re: [PATCH Backport to stable/linux-4.14.y] make
 'user_access_begin()' do 'access_ok()'
Message-ID: <20200401093235.GB2055942@kroah.com>
References: <8a297704c58b4b4e867efecb08214040@SVR-IES-MBX-03.mgc.mentorg.com>
 <1585733082992.99012@mentor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1585733082992.99012@mentor.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Apr 01, 2020 at 09:24:43AM +0000, Schmid, Carsten wrote:
> >From eb5a13ddc30824c20f1e2b662d2c821ad3808526 Mon Sep 17 00:00:00 2001
> From: Linus Torvalds <torvalds@linux-foundation.org>
> Date: Fri, 4 Jan 2019 12:56:09 -0800
> Subject: [PATCH] make 'user_access_begin()' do 'access_ok()'
> 
> [ Upstream commit 594cc251fdd0d231d342d88b2fdff4bc42fb0690 ]
> 
> Fixes CVE-2018-20669
> Backported from v5.0-rc1
> Patch 1/1

Also, that cve was "supposed" to already be fixed in the 4.19.13 kernel
release for some reason, and it's a drm issue, not a core access_ok()
issue.

So why is this needed for 4.14?

> 
> Originally, the rule used to be that you'd have to do access_ok()
> separately, and then user_access_begin() before actually doing the
> direct (optimized) user access.
> 
> But experience has shown that people then decide not to do access_ok()
> at all, and instead rely on it being implied by other operations or
> similar.  Which makes it very hard to verify that the access has
> actually been range-checked.
> 
> If you use the unsafe direct user accesses, hardware features (either
> SMAP - Supervisor Mode Access Protection - on x86, or PAN - Privileged
> Access Never - on ARM) do force you to use user_access_begin().  But
> nothing really forces the range check.
> 
> By putting the range check into user_access_begin(), we actually force
> people to do the right thing (tm), and the range check vill be visible
> near the actual accesses.  We have way too long a history of people
> trying to avoid them.
> 
> Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>

No s-o-by from you?

> ---
> Rationale:
> When working on stability and security for a project with 4.14 kernel,
> i backported patches from upstream.
> Want to give this work back to the community, as 4.14 is a SLTS.

What is "SLTS"?

thanks,

greg k-h
