Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 46924265F4A
	for <lists+stable@lfdr.de>; Fri, 11 Sep 2020 14:11:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725792AbgIKMK6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 11 Sep 2020 08:10:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59380 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725811AbgIKMJs (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 11 Sep 2020 08:09:48 -0400
Received: from mail-wr1-x441.google.com (mail-wr1-x441.google.com [IPv6:2a00:1450:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5CFA4C061756;
        Fri, 11 Sep 2020 05:08:58 -0700 (PDT)
Received: by mail-wr1-x441.google.com with SMTP id x14so11206553wrl.12;
        Fri, 11 Sep 2020 05:08:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=HG2dGn3UgL48R/VgsGlJdb/1w1XSVMd74NKvmkSF/z4=;
        b=JoAOiF6xtu/RWt7yWKkNUzT76TdRC2ICIvu8q07twwDGkddoxhYaIZ/uGJ+EkNYEiu
         gg5XD1ABhvKK+JBNYUPbhAT4pN0jwlwFzPrCAdOZSrKjgEbfIjM+dxmPGrl6odM950Cq
         XSt7jR1R8LVuM4kYWP9Swddd/E1ZCDRCwxOBkTyDBAeW3iluZM+ovX6rIT2QuIzbaigy
         OYi6WubesP3A4GtNn/cYyJycnrkhI8B5Q67dhi86sYUla/9DLJfoajGXbXMW9CLv1zo/
         pgh63ccJsC9ZjOZeHDIUwCB3IEIUDQWmqBtwhMzW+y+YV+i0zZz+t9fIEdSMu5Mm+E+o
         sCyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=HG2dGn3UgL48R/VgsGlJdb/1w1XSVMd74NKvmkSF/z4=;
        b=DhOYtsgeqmFzr09vmjXjq/ZPGAfH6IC4vukQc5qn8OtSGYOrLqv68GwwrDuW3K9XrY
         yXyJQhnw2gPcaCpNHznsYFKs2JO7/rBdd8ihqKb9eoO65Lqo2JEVs+ttI5C+PXmiv+fg
         yJgzAcgkjGpyBTL21KVP8rJnPQus/2g1jRIGOUXxnREDfALco3n+XIQtSMigRG/27u3P
         LI8lTcwhiA/wR9mmVk4Phdv3TUDezCM/fm42N5JgBPDkuDyJl63nmFQJ17+InT3HwXfS
         bbH5xMDNkU5Bg7IRkN3rgR0TqdmuJCK48FKatPfXEXlv2m+a9MtVMwQ+HWfaqcUe/ute
         B2PQ==
X-Gm-Message-State: AOAM533X3kgF/IHmayuIw441IIPXSuLbg26VRaQNZGnO0EePvyrxC9iU
        q73BC+u1D87+6OMmMU8ryrM=
X-Google-Smtp-Source: ABdhPJwDbgnyvcpG8imVPKItjZfLkRfUwaWkKqNFrq/8QDz/kNEH7ZyY79zS1RnkODM4unDbETNvBA==
X-Received: by 2002:a5d:6cb0:: with SMTP id a16mr1718516wra.88.1599826137029;
        Fri, 11 Sep 2020 05:08:57 -0700 (PDT)
Received: from eldamar (80-218-24-251.dclient.hispeed.ch. [80.218.24.251])
        by smtp.gmail.com with ESMTPSA id q192sm4330677wme.13.2020.09.11.05.08.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 11 Sep 2020 05:08:55 -0700 (PDT)
Date:   Fri, 11 Sep 2020 14:08:54 +0200
From:   Salvatore Bonaccorso <carnil@debian.org>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Bob Peterson <rpeterso@redhat.com>,
        Andreas Gruenbacher <agruenba@redhat.com>,
        Sasha Levin <sashal@kernel.org>, Daniel.Craig@csiro.au,
        Nicolas Courtel <courtel@cena.fr>, cluster-devel@redhat.com
Subject: Re: [PATCH 4.19 142/206] gfs2: fix use-after-free on transaction ail
 lists
Message-ID: <20200911120854.GA221663@eldamar.local>
References: <20200623195316.864547658@linuxfoundation.org>
 <20200623195323.968867013@linuxfoundation.org>
 <20200910194319.GA131386@eldamar.local>
 <20200911115816.GB3717176@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200911115816.GB3717176@kroah.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Greg,

Thanks for your quick reply.

On Fri, Sep 11, 2020 at 01:58:16PM +0200, Greg Kroah-Hartman wrote:
> On Thu, Sep 10, 2020 at 09:43:19PM +0200, Salvatore Bonaccorso wrote:
> > Hi,
> > 
> > On Tue, Jun 23, 2020 at 09:57:50PM +0200, Greg Kroah-Hartman wrote:
> > > From: Bob Peterson <rpeterso@redhat.com>
> > > 
> > > [ Upstream commit 83d060ca8d90fa1e3feac227f995c013100862d3 ]
> > > 
> > > Before this patch, transactions could be merged into the system
> > > transaction by function gfs2_merge_trans(), but the transaction ail
> > > lists were never merged. Because the ail flushing mechanism can run
> > > separately, bd elements can be attached to the transaction's buffer
> > > list during the transaction (trans_add_meta, etc) but quickly moved
> > > to its ail lists. Later, in function gfs2_trans_end, the transaction
> > > can be freed (by gfs2_trans_end) while it still has bd elements
> > > queued to its ail lists, which can cause it to either lose track of
> > > the bd elements altogether (memory leak) or worse, reference the bd
> > > elements after the parent transaction has been freed.
> > > 
> > > Although I've not seen any serious consequences, the problem becomes
> > > apparent with the previous patch's addition of:
> > > 
> > > 	gfs2_assert_warn(sdp, list_empty(&tr->tr_ail1_list));
> > > 
> > > to function gfs2_trans_free().
> > > 
> > > This patch adds logic into gfs2_merge_trans() to move the merged
> > > transaction's ail lists to the sdp transaction. This prevents the
> > > use-after-free. To do this properly, we need to hold the ail lock,
> > > so we pass sdp into the function instead of the transaction itself.
> > > 
> > > Signed-off-by: Bob Peterson <rpeterso@redhat.com>
> > > Signed-off-by: Andreas Gruenbacher <agruenba@redhat.com>
> > > Signed-off-by: Sasha Levin <sashal@kernel.org>
> > > ---
> > >  fs/gfs2/log.c | 11 +++++++++--
> > >  1 file changed, 9 insertions(+), 2 deletions(-)
> > > 
> > > diff --git a/fs/gfs2/log.c b/fs/gfs2/log.c
> > > index d3f0612e33471..06752db213d21 100644
> > > --- a/fs/gfs2/log.c
> > > +++ b/fs/gfs2/log.c
> > > @@ -877,8 +877,10 @@ void gfs2_log_flush(struct gfs2_sbd *sdp, struct gfs2_glock *gl, u32 flags)
> > >   * @new: New transaction to be merged
> > >   */
> > >  
> > > -static void gfs2_merge_trans(struct gfs2_trans *old, struct gfs2_trans *new)
> > > +static void gfs2_merge_trans(struct gfs2_sbd *sdp, struct gfs2_trans *new)
> > >  {
> > > +	struct gfs2_trans *old = sdp->sd_log_tr;
> > > +
> > >  	WARN_ON_ONCE(!test_bit(TR_ATTACHED, &old->tr_flags));
> > >  
> > >  	old->tr_num_buf_new	+= new->tr_num_buf_new;
> > > @@ -890,6 +892,11 @@ static void gfs2_merge_trans(struct gfs2_trans *old, struct gfs2_trans *new)
> > >  
> > >  	list_splice_tail_init(&new->tr_databuf, &old->tr_databuf);
> > >  	list_splice_tail_init(&new->tr_buf, &old->tr_buf);
> > > +
> > > +	spin_lock(&sdp->sd_ail_lock);
> > > +	list_splice_tail_init(&new->tr_ail1_list, &old->tr_ail1_list);
> > > +	list_splice_tail_init(&new->tr_ail2_list, &old->tr_ail2_list);
> > > +	spin_unlock(&sdp->sd_ail_lock);
> > >  }
> > >  
> > >  static void log_refund(struct gfs2_sbd *sdp, struct gfs2_trans *tr)
> > > @@ -901,7 +908,7 @@ static void log_refund(struct gfs2_sbd *sdp, struct gfs2_trans *tr)
> > >  	gfs2_log_lock(sdp);
> > >  
> > >  	if (sdp->sd_log_tr) {
> > > -		gfs2_merge_trans(sdp->sd_log_tr, tr);
> > > +		gfs2_merge_trans(sdp, tr);
> > >  	} else if (tr->tr_num_buf_new || tr->tr_num_databuf_new) {
> > >  		gfs2_assert_withdraw(sdp, test_bit(TR_ALLOCED, &tr->tr_flags));
> > >  		sdp->sd_log_tr = tr;
> > > -- 
> > > 2.25.1
> > 
> > In Debian two user confirmed issues on writing on a GFS2 partition
> > with this commit applied. The initial Debian report is at
> > https://bugs.debian.org/968567 and Daniel Craig reported it into
> > Bugzilla at https://bugzilla.kernel.org/show_bug.cgi?id=209217 .
> > 
> > Writing to a gfs2 filesystem fails and results in a soft lookup of the
> > machine for kernels with that commit applied. I cannot reporduce the
> > issue myself due not having a respective setup available, but Daniel
> > described a minimal serieos of steps to reproduce the issue.
> > 
> > This might affect as well other stable series where this commit was
> > applied, as there was a similar report for someone running 5.4.58 in
> > https://www.redhat.com/archives/linux-cluster/2020-August/msg00000.html
> 
> Can you report this to the gfs2 developers?

Sure! Bob Peterson and Andreas Gruenbacher were already on the
recipient list but I forgot cluster-devel@redhat.com .

I can send there a separate report as followup if still needed.

Regards,
Salvatore
