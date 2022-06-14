Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B059854B226
	for <lists+stable@lfdr.de>; Tue, 14 Jun 2022 15:17:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243990AbiFNNRQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Jun 2022 09:17:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34838 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231859AbiFNNRQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 14 Jun 2022 09:17:16 -0400
X-Greylist: delayed 1800 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Tue, 14 Jun 2022 06:17:14 PDT
Received: from kylie.crudebyte.com (kylie.crudebyte.com [5.189.157.229])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A539369FA;
        Tue, 14 Jun 2022 06:17:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=crudebyte.com; s=kylie; h=Content-Type:Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:
        Content-ID:Content-Description;
        bh=JAv4LCz3gTxKSnfh4LIXx7N89/orNIUqz4pbzgwAvLc=; b=KmsKEA5hRPt0/BP4UopWUQqD+5
        rLLETgl2Q0pg+Xn/V5a0IeRYq+A+oYqKM91rAyj7h2Bp8nAb+dTu12NTrdQK+wBWR6To12H7KRRId
        f4cgiw98gA6dvNtCur0CGgdhUsXgbBUHix6Tclb00sJFqL54OJmspQ6tL0S02d8gKxdO06Ij37MdA
        sdIgnbs9MvjU/xNUb8jDnp0gfX29L/ZALkeOFIpNX3Utl8UQXPICcSiD2XSV4eidajMEGegrvma5Z
        +kV4eVasKkXmtR8slsBzLvfe61BZi850HLm8ektrc6UVXt147XexmDbI++GTaIWnMtYLyrzQ0Y8sC
        nckC5mxjk0uLCWE28zdRmoJNFa60ZiqVhiADeTD+s1XKkoYw7y3NT7ij1wfY8YEw5Q3tYqkr+rsDd
        L1NYrsk2aULFPxvREhFiIkiVdAObB1uBEmj4ANx2TFZ4BZQqRVo634an2GxKeUwW0Qp7ugwIOR/Os
        0yVXKJDCCb1y6WXDy8RDu/PdCNaUZxmKYlLMm9YFfpErtAHCNbAVR+jqOpwoByhZSl/wzuhS1EMjf
        WmB9r8o/0LabK66WbR0WYKsM/ouVcUyMuV9o/SCsXnPBOX2q0bAEpUBL5LTHl76r6JU+nqPo2OOIc
        UkPTNjyX05lMvy5w3pBG538R0kmK7oTQDiL8yGI8M=;
From:   Christian Schoenebeck <linux_oss@crudebyte.com>
To:     Eric Van Hensbergen <ericvh@gmail.com>,
        Latchesar Ionkov <lucho@ionkov.net>,
        David Howells <dhowells@redhat.com>,
        Dominique Martinet <asmadeus@codewreck.org>
Cc:     linux-fsdevel@vger.kernel.org, stable@vger.kernel.org,
        v9fs-developer@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] 9p: fix EBADF errors in cached mode
Date:   Tue, 14 Jun 2022 14:10:01 +0200
Message-ID: <19026878.01OTk6HtWb@silver>
In-Reply-To: <YqgDdNUxC0hV6KR9@codewreck.org>
References: <YqW5s+GQZwZ/DP5q@codewreck.org>
 <20220614033802.1606738-1-asmadeus@codewreck.org>
 <YqgDdNUxC0hV6KR9@codewreck.org>
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

On Dienstag, 14. Juni 2022 05:41:40 CEST Dominique Martinet wrote:
> Dominique Martinet wrote on Tue, Jun 14, 2022 at 12:38:02PM +0900:
> > cached operations sometimes need to do invalid operations (e.g. read
> > on a write only file)
> > Historic fscache had added a "writeback fid" for this, but the conversion
> > to new fscache somehow lost usage of it: use the writeback fid instead
> > of normal one.
> > 
> > Note that the way this works (writeback fid being linked to inode) means
> > we might use overprivileged fid for some operations, e.g. write as root
> > when we shouldn't.
> > Ideally we should keep both fids handy, and only use the writeback fid
> > when really required e.g. reads to a write-only file to fill in the page
> > cache (read-modify-write); but this is the situation we've always had
> > and this commit only fixes an issue we've had for too long.
> > 
> > Fixes: eb497943fa21 ("9p: Convert to using the netfs helper lib to do
> > reads and caching") Cc: stable@vger.kernel.org
> > Cc: David Howells <dhowells@redhat.com>
> > Reported-By: Christian Schoenebeck <linux_oss@crudebyte.com>
> > Signed-off-by: Dominique Martinet <asmadeus@codewreck.org>
> > ---
> > Ok so finally had time to look at this, and it's not a lot so this is
> > the most straight forward way to do: just reverting to how the old
> > fscache worked.
> > 
> > This appears to work from quick testing, Chiristian could you test it?
> > 
> > I think the warnings you added in p9_client_read/write that check
> > fid->mode might a lot of sense, if you care to resend it as
> > WARN_ON((fid->mode & ACCMODE) == O_xyz);
> > instead I'll queue that for 5.20
> > 
> > 
> > @Stable people, I've checked it applies to 5.17 and 5.18 so should be
> > good to grab once I submit it for inclusion (that commit was included in
> > 5.16, which is no longer stable)
> > 
> >  fs/9p/vfs_addr.c | 6 +++++-
> >  1 file changed, 5 insertions(+), 1 deletion(-)
> > 
> > diff --git a/fs/9p/vfs_addr.c b/fs/9p/vfs_addr.c
> > index 7382c5227e94..262968d02f55 100644
> > --- a/fs/9p/vfs_addr.c
> > +++ b/fs/9p/vfs_addr.c
> > @@ -58,7 +58,11 @@ static void v9fs_issue_read(struct netfs_io_subrequest
> > *subreq)> 
> >   */
> >  
> >  static int v9fs_init_request(struct netfs_io_request *rreq, struct file
> >  *file) {
> > 
> > -	struct p9_fid *fid = file->private_data;
> > +	struct inode *inode = file_inode(file);
> > +	struct v9fs_inode *v9inode = V9FS_I(inode);
> > +	struct p9_fid *fid = v9inode->writeback_fid;
> > +
> 
> Sorry for mails back-to-back (grmbl I hate git commit --amend not
> warning I only have unstaged changes), this is missing the following
> here:

I think git does actually. It shows you staged and unstaged changes as comment 
below the commit log text inside the editor. Not as a big fat warning, but the 
info is there.

> +    /* If there is no writeback fid this file only ever has had
> +     * read-only opens, so we can use file's fid which should
> +     * always be set instead */
> +    if (!fid)
> +        fid = file->private_data;
> 
> Christian, you can find it here to test:
> https://github.com/martinetd/linux/commit/a6e033c41cc9f0ec105f5d208b0a820118
> e2bda8
> > +	BUG_ON(!fid);
> > 
> >  	p9_fid_get(fid);
> >  	rreq->netfs_priv = fid;

It definitely goes into the right direction, but I think it's going a bit too 
far by using writeback_fid also in cases where it is not necessary and wasn't 
used before in the past.

What about something like this in v9fs_init_request() (yet untested):

    /* writeback_fid is always opened O_RDWR (instead of just O_WRONLY) 
     * explicitly for this case: partial write backs that require a read
     * prior to actual write and therefore requires a fid with read
     * capability.
     */
    if (rreq->origin == NETFS_READ_FOR_WRITE)
        fid = v9inode->writeback_fid;

If desired, this could be further constrained later on like:

    if (rreq->origin == NETFS_READ_FOR_WRITE &&
        (fid->mode & O_ACCMODE) == O_WRONLY)
    {
        fid = v9inode->writeback_fid;
    }

I will definitely give these options some test spins here, a short feedback 
ahead would be appreciated though.

Thanks Dominique!

Best regards,
Christian Schoenebeck


