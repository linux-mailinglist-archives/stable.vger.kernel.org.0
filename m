Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EEF9B265F6E
	for <lists+stable@lfdr.de>; Fri, 11 Sep 2020 14:22:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725885AbgIKMWB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 11 Sep 2020 08:22:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:33506 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725876AbgIKMUz (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 11 Sep 2020 08:20:55 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CC44821D40;
        Fri, 11 Sep 2020 12:20:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599826818;
        bh=p0dMZYlvMuBFRvmCSlPIVCxaoQeDTgEw+OKygz501WY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=j6OvDJk9lxBEbRg4B+J1hnhaSFZ0S/2rb1x8+sJ/FOilMRPj58ezUJmV6D19UauvF
         nkSocYDX6gFzgo3xcje+GaziUM4uhAsw9W56BGftYo/mz0h4wN8n0x9oZUTZ/60Pbx
         USU/zyrOBaXf379zyB0fBe/zkmRgv1cLGH3MfeeI=
Date:   Fri, 11 Sep 2020 14:20:24 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Bob Peterson <rpeterso@redhat.com>
Cc:     Salvatore Bonaccorso <carnil@debian.org>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Andreas Gruenbacher <agruenba@redhat.com>,
        Sasha Levin <sashal@kernel.org>,
        Daniel Craig <Daniel.Craig@csiro.au>,
        Nicolas Courtel <courtel@cena.fr>
Subject: Re: [PATCH 4.19 142/206] gfs2: fix use-after-free on transaction ail
 lists
Message-ID: <20200911122024.GA3758477@kroah.com>
References: <20200623195316.864547658@linuxfoundation.org>
 <20200623195323.968867013@linuxfoundation.org>
 <20200910194319.GA131386@eldamar.local>
 <20200911115816.GB3717176@kroah.com>
 <942693093.16771250.1599826115915.JavaMail.zimbra@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <942693093.16771250.1599826115915.JavaMail.zimbra@redhat.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Sep 11, 2020 at 08:08:35AM -0400, Bob Peterson wrote:
> ----- Original Message -----
> > On Thu, Sep 10, 2020 at 09:43:19PM +0200, Salvatore Bonaccorso wrote:
> > > Hi,
> > > 
> > > On Tue, Jun 23, 2020 at 09:57:50PM +0200, Greg Kroah-Hartman wrote:
> > > > From: Bob Peterson <rpeterso@redhat.com>
> > > > 
> > > > [ Upstream commit 83d060ca8d90fa1e3feac227f995c013100862d3 ]
> > > > 
> > > > Before this patch, transactions could be merged into the system
> > > > transaction by function gfs2_merge_trans(), but the transaction ail
> > > > lists were never merged. Because the ail flushing mechanism can run
> > > > separately, bd elements can be attached to the transaction's buffer
> > > > list during the transaction (trans_add_meta, etc) but quickly moved
> > > > to its ail lists. Later, in function gfs2_trans_end, the transaction
> > > > can be freed (by gfs2_trans_end) while it still has bd elements
> > > > queued to its ail lists, which can cause it to either lose track of
> > > > the bd elements altogether (memory leak) or worse, reference the bd
> > > > elements after the parent transaction has been freed.
> > > > 
> > > > Although I've not seen any serious consequences, the problem becomes
> > > > apparent with the previous patch's addition of:
> > > > 
> > > > 	gfs2_assert_warn(sdp, list_empty(&tr->tr_ail1_list));
> > > > 
> > > > to function gfs2_trans_free().
> > > > 
> > > > This patch adds logic into gfs2_merge_trans() to move the merged
> > > > transaction's ail lists to the sdp transaction. This prevents the
> > > > use-after-free. To do this properly, we need to hold the ail lock,
> > > > so we pass sdp into the function instead of the transaction itself.
> > > > 
> > > > Signed-off-by: Bob Peterson <rpeterso@redhat.com>
> > > > Signed-off-by: Andreas Gruenbacher <agruenba@redhat.com>
> > > > Signed-off-by: Sasha Levin <sashal@kernel.org>
> (snip)
> > > 
> > > In Debian two user confirmed issues on writing on a GFS2 partition
> > > with this commit applied. The initial Debian report is at
> > > https://bugs.debian.org/968567 and Daniel Craig reported it into
> > > Bugzilla at https://bugzilla.kernel.org/show_bug.cgi?id=209217 .
> > > 
> > > Writing to a gfs2 filesystem fails and results in a soft lookup of the
> > > machine for kernels with that commit applied. I cannot reporduce the
> > > issue myself due not having a respective setup available, but Daniel
> > > described a minimal serieos of steps to reproduce the issue.
> > > 
> > > This might affect as well other stable series where this commit was
> > > applied, as there was a similar report for someone running 5.4.58 in
> > > https://www.redhat.com/archives/linux-cluster/2020-August/msg00000.html
> > 
> > Can you report this to the gfs2 developers?
> > 
> > thanks,
> > 
> > greg k-h
> 
> Hi Greg,
> 
> No need. The patch came from the gfs2 developers. I think he just wants
> it added to a stable release.

What commit needs to be added to a stable release?

confused,

greg k-h
