Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5EAD71137D5
	for <lists+stable@lfdr.de>; Wed,  4 Dec 2019 23:53:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728132AbfLDWxP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Dec 2019 17:53:15 -0500
Received: from mail.kernel.org ([198.145.29.99]:47012 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728011AbfLDWxP (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 4 Dec 2019 17:53:15 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D90E52464F;
        Wed,  4 Dec 2019 22:53:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1575499994;
        bh=nSce+C0PV3nNdjCe0SnUxQ5HD4mnSnWmbA4HaJPR62w=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=veiNJx7i6rZD7MlLzz1MscyYOIJP30VUvfOdBvr6LudveLFrcX9O3W1lDClYj/wR+
         sx/2tW2Vg6sFLtOrXzkgzRORhHxeo9rEM7Q/C+FXwpn7BUJOD4EqlhqmWWsLG6MVsK
         YQ1h4Yg+D7ua7rgMThwaulZqcdhFlQTOGzMyqcOQ=
Date:   Wed, 4 Dec 2019 23:53:12 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Vlastimil Babka <vbabka@suse.cz>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Sasha Levin <sashal@kernel.org>,
        Ben Hutchings <ben.hutchings@codethink.co.uk>
Subject: Re: [PATCH 4.9 105/125] mm, gup: add missing refcount overflow
 checks on x86 and s390
Message-ID: <20191204225312.GB3715390@kroah.com>
References: <20191204175308.377746305@linuxfoundation.org>
 <20191204175325.500930880@linuxfoundation.org>
 <7ca516fa-c526-b5e6-4b7c-855f229112ac@suse.cz>
 <20191204203711.GA3685601@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191204203711.GA3685601@kroah.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Dec 04, 2019 at 09:37:11PM +0100, Greg Kroah-Hartman wrote:
> On Wed, Dec 04, 2019 at 07:27:44PM +0100, Vlastimil Babka wrote:
> > On 12/4/19 6:56 PM, Greg Kroah-Hartman wrote:
> > > From: Vlastimil Babka <vbabka@suse.cz>
> > > 
> > > The mainline commit 8fde12ca79af ("mm: prevent get_user_pages() from
> > > overflowing page refcount") was backported to 4.9.y stable as commit
> > > 2ed768cfd895. The backport however missed that in 4.9, there are several
> > > arch-specific gup.c versions with fast gup implementations, so these do not
> > > prevent refcount overflow.
> > > 
> > > This is partially fixed for x86 in stable-only commit d73af79742e7 ("x86, mm,
> > > gup: prevent get_page() race with munmap in paravirt guest"). This stable-only
> > > commit adds missing parts to x86 version, as well as s390 version, both taken
> > > from the SUSE SLES/openSUSE 4.12-based kernels.
> > > 
> > > The remaining architectures with own gup.c are sparc, mips, sh. It's unlikely
> > > the known overflow scenario based on FUSE, which needs 140GB of RAM, is a
> > > problem for those architectures, and I don't feel confident enough to patch
> > > them.
> > > 
> > > Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
> > > Signed-off-by: Sasha Levin <sashal@kernel.org>
> > 
> > No, this one had a leak bug and I've sent updated version:
> > https://lore.kernel.org/linux-mm/e274291b-054f-2fad-28e8-59fabf312e61@suse.cz/
> 
> Ugh.  Ok, let me go fix that up...

Now done and I've pushed out a -rc2 with that fix in it.

thanks,

greg k-h
