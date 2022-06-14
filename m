Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4AFF654B2CF
	for <lists+stable@lfdr.de>; Tue, 14 Jun 2022 16:12:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234697AbiFNOLr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Jun 2022 10:11:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54282 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236262AbiFNOLq (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 14 Jun 2022 10:11:46 -0400
Received: from kylie.crudebyte.com (kylie.crudebyte.com [5.189.157.229])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4AC6F344C8;
        Tue, 14 Jun 2022 07:11:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=crudebyte.com; s=kylie; h=Content-Type:Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:
        Content-ID:Content-Description;
        bh=0up0HQhrsxc90C88YMmJQmlVHMrBI86sKQklFU28KR8=; b=Hp1+8w4PUY58i0Tlkd3yeyLr1t
        d+416tMt71AkGKbx1PRjrgGubVu2CXrnBDpBbOFaBdEqpkvYB8C6w0aNophxcs4gWQR/KIi23kUYS
        eqjPJOORRCQ6F8TvdPT1A4BrmbM94f4UU15NqaO8OhfRs9kLxSkms6mHkPz0uGdIBaAkgiPHvSLs4
        ODNsEb4eEx0Z5cMEzrgDmqfDAA9slhFg/jpbigImbW9YKf+EKQHLrU961QQpO96oP5oz4GgzE9G0Y
        rSE0lUykUF5rhIZ/Mtf2q8mCxqjJO5cfB2r/YAeutwggT/qTVApUrNSQtSyZk1V0iOte8BdAD1PQc
        yvesVwal19dT9zYIdQ56uNLn9Kurfr7tiBLrfQC1upVxd/OkXfVJJ3OMskAf8O61wVRlGWUwH8exR
        MUge0IC5VloTMaquBTx2Ar46bMg1RyoRrYfyeLUj+MwtwbvwN3SdgGRXwbjS6nQ6/DnS9cC8RuCeT
        NuSia+FFUU/KTMyKGeQQ4t1ufx4/736ogVnN3cIkPnDkm+jnMVMpdElh9vrOQeOw1DrUxSs81vwyJ
        h4PRMK2TxpwLa+4YAkGqSNjsSr5tmjpddr7jWVsakCBVVZcaVjRpq/shELYc6KDRLkvWr1jRQds5L
        VzX8eOOz15rMBARpKWHy3gPVUNq1YCLWDmZv6YE9c=;
From:   Christian Schoenebeck <linux_oss@crudebyte.com>
To:     Dominique Martinet <asmadeus@codewreck.org>
Cc:     Eric Van Hensbergen <ericvh@gmail.com>,
        Latchesar Ionkov <lucho@ionkov.net>,
        David Howells <dhowells@redhat.com>,
        linux-fsdevel@vger.kernel.org, stable@vger.kernel.org,
        v9fs-developer@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] 9p: fix EBADF errors in cached mode
Date:   Tue, 14 Jun 2022 16:11:35 +0200
Message-ID: <1796737.mFSqR1lx0c@silver>
In-Reply-To: <YqiC8luskkxUftQl@codewreck.org>
References: <YqW5s+GQZwZ/DP5q@codewreck.org> <19026878.01OTk6HtWb@silver>
 <YqiC8luskkxUftQl@codewreck.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Dienstag, 14. Juni 2022 14:45:38 CEST Dominique Martinet wrote:
> Christian Schoenebeck wrote on Tue, Jun 14, 2022 at 02:10:01PM +0200:
> > It definitely goes into the right direction, but I think it's going a bit
> > too far by using writeback_fid also in cases where it is not necessary
> > and wasn't used before in the past.
> 
> Would help if I had an idea of what was used where in the past.. :)
> 
> From a quick look at the code, checking out v5.10,
> v9fs_vfs_writepage_locked() used the writeback fid always for all writes
> v9fs_vfs_readpages is a bit more complex but only seems to be using the
> "direct" private_data fid for reads...
> It took me a bit of time but I think the reads you were seeing on
> writeback fid come from v9fs_write_begin that does some readpage on the
> writeback fid to populate the page before a non-filling write happens.

Yes, the overall picture in the past was not clear to me either.

To be more specific, I was reading your patch as if it would e.g. also use the 
writeback_fid if somebody explicitly called read() (i.e. not an implied read 
caused by a partial write back), and was concerned about a potential privilege 
escalation. Maybe it's just a theoretical issue, as this case is probably 
already catched on a higher, general fs handling level, but worth 
consideration.

> > What about something like this in v9fs_init_request() (yet untested):
> >     /* writeback_fid is always opened O_RDWR (instead of just O_WRONLY)
> >     
> >      * explicitly for this case: partial write backs that require a read
> >      * prior to actual write and therefore requires a fid with read
> >      * capability.
> >      */
> >     
> >     if (rreq->origin == NETFS_READ_FOR_WRITE)
> >     
> >         fid = v9inode->writeback_fid;
> 
> ... Which seems to be exactly what this origin is about, so if that
> works I'm all for it.
> 
> > If desired, this could be further constrained later on like:
> >     if (rreq->origin == NETFS_READ_FOR_WRITE &&
> >     
> >         (fid->mode & O_ACCMODE) == O_WRONLY)
> >     
> >     {
> >     
> >         fid = v9inode->writeback_fid;
> >     
> >     }
> 
> That also makes sense, if the fid mode has read permissions we might as
> well use these as the writeback fid would needlessly be doing root IOs.
> 
> > I will definitely give these options some test spins here, a short
> > feedback
> > ahead would be appreciated though.
> 
> Please let me know how that works out, I'd be happy to use either of
> your versions instead of mine.
> If I can be greedy though I'd like to post it together with the other
> couple of fixes next week, so having something before the end of the
> week would be great -- I think even my first overkill version early and
> building on it would make sense at this point.
> 
> But I think you've got the right end, so hopefully won't be needing to
> delay

I need a day or two for testing, then I will report back for sure. So it 
should perfectly fit into your intended schedule.

Thanks!

Best regards,
Christian Schoenebeck


