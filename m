Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CC3BE26ACCE
	for <lists+stable@lfdr.de>; Tue, 15 Sep 2020 21:00:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727933AbgIOS7Q (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 15 Sep 2020 14:59:16 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:27392 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727860AbgIORLn (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 15 Sep 2020 13:11:43 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1600189880;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=loEBv4Feu/uhuUMsYWaNbRsF9hQKeLg7J5OdvPtrWdU=;
        b=IWmDzkFJ1PSJ6CHE50SX+kN+z1bXENocSFYO7oDkYj9PM9LZ+a87EXfs81Bs+GX2ArMx+g
        tVLMwbtt/D+LWcJFhUVY4mBjAArphtzx1QLrJtMe73mkFsZZahLt6LkgXcD9W17EHwx8VG
        966994MY4z7LuxKzSdhdI0dRAncBG4E=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-205-XpKsoTYeMbagOUIEzuuRFQ-1; Tue, 15 Sep 2020 12:52:06 -0400
X-MC-Unique: XpKsoTYeMbagOUIEzuuRFQ-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 5D174109106A;
        Tue, 15 Sep 2020 16:52:04 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 5159175124;
        Tue, 15 Sep 2020 16:52:04 +0000 (UTC)
Received: from zmail21.collab.prod.int.phx2.redhat.com (zmail21.collab.prod.int.phx2.redhat.com [10.5.83.24])
        by colo-mx.corp.redhat.com (Postfix) with ESMTP id BD66A18338EF;
        Tue, 15 Sep 2020 16:52:03 +0000 (UTC)
Date:   Tue, 15 Sep 2020 12:52:01 -0400 (EDT)
From:   Bob Peterson <rpeterso@redhat.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Andreas Gruenbacher <agruenba@redhat.com>,
        Sasha Levin <sashal@kernel.org>,
        Daniel Craig <Daniel.Craig@csiro.au>,
        Nicolas Courtel <courtel@cena.fr>,
        Salvatore Bonaccorso <carnil@debian.org>
Message-ID: <1934025224.17237499.1600188721184.JavaMail.zimbra@redhat.com>
In-Reply-To: <20200912064713.GA291675@eldamar.local>
References: <20200623195316.864547658@linuxfoundation.org> <20200623195323.968867013@linuxfoundation.org> <20200910194319.GA131386@eldamar.local> <20200911115816.GB3717176@kroah.com> <942693093.16771250.1599826115915.JavaMail.zimbra@redhat.com> <20200911122024.GA3758477@kroah.com> <1542145456.16781948.1599828554609.JavaMail.zimbra@redhat.com> <20200912064713.GA291675@eldamar.local>
Subject: Re: [PATCH 4.19 142/206] gfs2: fix use-after-free on transaction
 ail lists
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.3.112.23, 10.4.195.2]
Thread-Topic: gfs2: fix use-after-free on transaction ail lists
Thread-Index: JUQwB/kHy/7oSBolHvvd5mXAxiqiBw==
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

----- Original Message -----
> Hi Bob, hi Greg,
> 
> On Fri, Sep 11, 2020 at 08:49:14AM -0400, Bob Peterson wrote:
> > ----- Original Message -----
> > > On Fri, Sep 11, 2020 at 08:08:35AM -0400, Bob Peterson wrote:
> > > > ----- Original Message -----
> > > > > On Thu, Sep 10, 2020 at 09:43:19PM +0200, Salvatore Bonaccorso wrote:
> > > > > > Hi,
> > > > > > 
> > > > > > On Tue, Jun 23, 2020 at 09:57:50PM +0200, Greg Kroah-Hartman wrote:
> > > > > > > From: Bob Peterson <rpeterso@redhat.com>
> > > > > > > 
> > > > > > > [ Upstream commit 83d060ca8d90fa1e3feac227f995c013100862d3 ]
> > > > > > > 
> > > > > > > Before this patch, transactions could be merged into the system
> > > > > > > transaction by function gfs2_merge_trans(), but the transaction
> > > > > > > ail
> > > > > > > lists were never merged. Because the ail flushing mechanism can
> > > > > > > run
> > > > > > > separately, bd elements can be attached to the transaction's
> > > > > > > buffer
> > > > > > > list during the transaction (trans_add_meta, etc) but quickly
> > > > > > > moved
> > > > > > > to its ail lists. Later, in function gfs2_trans_end, the
> > > > > > > transaction
> > > > > > > can be freed (by gfs2_trans_end) while it still has bd elements
> > > > > > > queued to its ail lists, which can cause it to either lose track
> > > > > > > of
> > > > > > > the bd elements altogether (memory leak) or worse, reference the
> > > > > > > bd
> > > > > > > elements after the parent transaction has been freed.
> > > > > > > 
> > > > > > > Although I've not seen any serious consequences, the problem
> > > > > > > becomes
> > > > > > > apparent with the previous patch's addition of:
> > > > > > > 
> > > > > > > 	gfs2_assert_warn(sdp, list_empty(&tr->tr_ail1_list));
> > > > > > > 
> > > > > > > to function gfs2_trans_free().
> > > > > > > 
> > > > > > > This patch adds logic into gfs2_merge_trans() to move the merged
> > > > > > > transaction's ail lists to the sdp transaction. This prevents the
> > > > > > > use-after-free. To do this properly, we need to hold the ail
> > > > > > > lock,
> > > > > > > so we pass sdp into the function instead of the transaction
> > > > > > > itself.
> > > > > > > 
> > > > > > > Signed-off-by: Bob Peterson <rpeterso@redhat.com>
> > > > > > > Signed-off-by: Andreas Gruenbacher <agruenba@redhat.com>
> > > > > > > Signed-off-by: Sasha Levin <sashal@kernel.org>
> > > > (snip)
> > > > > > 
> > > > > > In Debian two user confirmed issues on writing on a GFS2 partition
> > > > > > with this commit applied. The initial Debian report is at
> > > > > > https://bugs.debian.org/968567 and Daniel Craig reported it into
> > > > > > Bugzilla at https://bugzilla.kernel.org/show_bug.cgi?id=209217 .
> > > > > > 
> > > > > > Writing to a gfs2 filesystem fails and results in a soft lookup of
> > > > > > the
> > > > > > machine for kernels with that commit applied. I cannot reporduce
> > > > > > the
> > > > > > issue myself due not having a respective setup available, but
> > > > > > Daniel
> > > > > > described a minimal serieos of steps to reproduce the issue.
> > > > > > 
> > > > > > This might affect as well other stable series where this commit was
> > > > > > applied, as there was a similar report for someone running 5.4.58
> > > > > > in
> > > > > > https://www.redhat.com/archives/linux-cluster/2020-August/msg00000.html
> > > > > 
> > > > > Can you report this to the gfs2 developers?
> > > > > 
> > > > > thanks,
> > > > > 
> > > > > greg k-h
> > > > 
> > > > Hi Greg,
> > > > 
> > > > No need. The patch came from the gfs2 developers. I think he just wants
> > > > it added to a stable release.
> > > 
> > > What commit needs to be added to a stable release?
> > > 
> > > confused,
> > > 
> > > greg k-h
> > 
> > Sorry Greg,
> > 
> > It's pretty early here and the caffeine hadn't quite hit my system.
> > The problem is most likely that 4.19.132 is missing this upstream patch:
> > 
> > cbcc89b630447ec7836aa2b9242d9bb1725f5a61
> > 
> > I'm not sure how or why 83d060ca8d90fa1e3feac227f995c013100862d3 got
> > put into stable without a stable CC but cbcc89b6304 is definitely
> > required.
> > 
> > I'd like to suggest Salvatore try cherry-picking this patch to see if
> > it fixes the problem, and if so, perhaps Greg can add it to stable.
> 
> I can confirm (Daniel was able to test): Applying cbcc89b63044 ("gfs2:
> initialize transaction tr_ailX_lists earlier") fixes the issue. So
> would be great if you can pick that up for stable for those series
> which had 83d060ca8d90 ("gfs2: fix use-after-free on transaction ail
> lists") as well.
> 
> Regards,
> Salvatore
> 
> 

Hi Greg,

As per Salvatore's email above, can you please cherry-pick GFS2 patch
cbcc89b630447ec7836aa2b9242d9bb1725f5a61 to the stable releases like
4.19 to which ("gfs2: fix use-after-free on transaction ail lists")
(83d060ca8d90fa1e3feac227f995c013100862d3) was applied? Thanks.

Regards,

Bob Peterson
GFS2 File System

