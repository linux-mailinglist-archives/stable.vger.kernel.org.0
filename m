Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8F71378B3D
	for <lists+stable@lfdr.de>; Mon, 29 Jul 2019 14:02:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387665AbfG2MCd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Jul 2019 08:02:33 -0400
Received: from mx2.suse.de ([195.135.220.15]:48766 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2387637AbfG2MCd (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Jul 2019 08:02:33 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 2914DB61A;
        Mon, 29 Jul 2019 12:02:31 +0000 (UTC)
Received: by quack2.suse.cz (Postfix, from userid 1000)
        id 8355B1E3C1F; Mon, 29 Jul 2019 14:02:28 +0200 (CEST)
Date:   Mon, 29 Jul 2019 14:02:28 +0200
From:   Jan Kara <jack@suse.cz>
To:     Dan Williams <dan.j.williams@intel.com>
Cc:     Jan Kara <jack@suse.cz>, Matthew Wilcox <willy@infradead.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Boaz Harrosh <openosd@gmail.com>,
        stable <stable@vger.kernel.org>,
        Robert Barror <robert.barror@intel.com>,
        Seema Pandit <seema.pandit@intel.com>,
        linux-nvdimm <linux-nvdimm@lists.01.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] dax: Fix missed PMD wakeups
Message-ID: <20190729120228.GC17833@quack2.suse.cz>
References: <CAPcyv4gUiDw8Ma9mvbW5BamQtGZxWVuvBW7UrOLa2uijrXUWaw@mail.gmail.com>
 <20190705191004.GC32320@bombadil.infradead.org>
 <CAPcyv4jVARa38Qc4NjQ04wJ4ZKJ6On9BbJgoL95wQqU-p-Xp_w@mail.gmail.com>
 <20190710190204.GB14701@quack2.suse.cz>
 <20190710201539.GN32320@bombadil.infradead.org>
 <20190710202647.GA7269@quack2.suse.cz>
 <20190711141350.GS32320@bombadil.infradead.org>
 <20190711152550.GT32320@bombadil.infradead.org>
 <20190711154111.GA29284@quack2.suse.cz>
 <CAPcyv4hA+44EHpGN9F5eQD5Y_AuyPTKmovNWvccAFGhF_O2JMg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="opJtzjQTFsWo+cga"
Content-Disposition: inline
In-Reply-To: <CAPcyv4hA+44EHpGN9F5eQD5Y_AuyPTKmovNWvccAFGhF_O2JMg@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--opJtzjQTFsWo+cga
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue 16-07-19 20:39:46, Dan Williams wrote:
> On Fri, Jul 12, 2019 at 2:14 AM Jan Kara <jack@suse.cz> wrote:
> >
> > On Thu 11-07-19 08:25:50, Matthew Wilcox wrote:
> > > On Thu, Jul 11, 2019 at 07:13:50AM -0700, Matthew Wilcox wrote:
> > > > However, the XA_RETRY_ENTRY might be a good choice.  It doesn't normally
> > > > appear in an XArray (it may appear if you're looking at a deleted node,
> > > > but since we're holding the lock, we can't see deleted nodes).
> > >
> > ...
> >
> > > @@ -254,7 +267,7 @@ static void wait_entry_unlocked(struct xa_state *xas, void *entry)
> > >  static void put_unlocked_entry(struct xa_state *xas, void *entry)
> > >  {
> > >       /* If we were the only waiter woken, wake the next one */
> > > -     if (entry)
> > > +     if (entry && dax_is_conflict(entry))
> >
> > This should be !dax_is_conflict(entry)...
> >
> > >               dax_wake_entry(xas, entry, false);
> > >  }
> >
> > Otherwise the patch looks good to me so feel free to add:
> >
> > Reviewed-by: Jan Kara <jack@suse.cz>
> 
> Looks good, and passes the test case. Now pushed out to
> libnvdimm-for-next for v5.3 inclusion:
> 
> https://git.kernel.org/pub/scm/linux/kernel/git/nvdimm/nvdimm.git/commit/?h=libnvdimm-for-next&id=23c84eb7837514e16d79ed6d849b13745e0ce688

Thanks for picking up the patch but you didn't apply the fix I've mentioned
above. So put_unlocked_entry() is not waking up anybody anymore... Since
this got already to Linus' tree, I guess a separate fixup patch is needed
(attached).

								Honza

-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR

--opJtzjQTFsWo+cga
Content-Type: text/x-patch; charset=us-ascii
Content-Disposition: attachment; filename="0001-dax-Fix-missed-wakup-in-put_unlocked_entry.patch"

From 950204f7dfdb06198f40820be4d33ce824508f11 Mon Sep 17 00:00:00 2001
From: Jan Kara <jack@suse.cz>
Date: Mon, 29 Jul 2019 13:57:49 +0200
Subject: [PATCH] dax: Fix missed wakup in put_unlocked_entry()

The condition checking whether put_unlocked_entry() needs to wake up
following waiter got broken by commit 23c84eb78375 ("dax: Fix missed
wakeup with PMD faults"). We need to wake the waiter whenever the passed
entry is valid (i.e., non-NULL and not special conflict entry). This
could lead to processes never being woken up when waiting for entry
lock. Fix the condition.

CC: stable@vger.kernel.org
Fixes: 23c84eb78375 ("dax: Fix missed wakeup with PMD faults")
Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/dax.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/dax.c b/fs/dax.c
index a237141d8787..b64964ef44f6 100644
--- a/fs/dax.c
+++ b/fs/dax.c
@@ -266,7 +266,7 @@ static void wait_entry_unlocked(struct xa_state *xas, void *entry)
 static void put_unlocked_entry(struct xa_state *xas, void *entry)
 {
 	/* If we were the only waiter woken, wake the next one */
-	if (entry && dax_is_conflict(entry))
+	if (entry && !dax_is_conflict(entry))
 		dax_wake_entry(xas, entry, false);
 }
 
-- 
2.16.4


--opJtzjQTFsWo+cga--
