Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 73AF754EA94
	for <lists+stable@lfdr.de>; Thu, 16 Jun 2022 22:14:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238054AbiFPUO0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Jun 2022 16:14:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57222 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231383AbiFPUOZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 16 Jun 2022 16:14:25 -0400
Received: from kylie.crudebyte.com (kylie.crudebyte.com [5.189.157.229])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A8A675A5B6;
        Thu, 16 Jun 2022 13:14:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=crudebyte.com; s=kylie; h=Content-Type:Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:
        Content-ID:Content-Description;
        bh=INFQxQGyDwYY69qxQzPfv36btcGaXW+MSiAs6Ux+E6s=; b=NR8T64pEbjb9gC9oGxieK4GKzh
        Ta32023+iPCIyOCG8I5qwwngxe2sZSPVJDqPSftqj/ngwk+7BfHFTLzHJlFt3oI4lJzfv6KLLgoR4
        oL2OFdOP6bDTC+MT+UmDjsHPmvGifYkbDsjPWUetbqGfeCez6pNdIGFBWkSknI48fsNqyYdy1XUjF
        Es7viVRkpv8BqHB+XHc9YSVZqT5wNrA3xagp9t/TC+gAyPYKLES1QFGbq9J47ny7KJXurPsb7J/N7
        BafpkXCsFK4+b3o7L6pwR+PmuqGrgj5O4foWNUpWCUoNkIPFm2zDQ9Zbi1qMc+At7lA2g2eaAKZU+
        hTJUuliUr0bgO5iX2DGCqs9XWrt0qeK2BYmmfnyvBS0nUONCMurnjFakMb95w3dyJM8jzgbvgad4A
        mm4m3czzW2sVnLwX6fArQOFTkxMJysEz3wnth4wEAe5D30m+UFJNDECHp7coxImDcTkSzXaHp7wme
        cTB5/lX/wijvQil7KAw6c94m6vn0jDkBcbEAMx8lj/7gDQ9PIUaveWTSjpv5Yf98oZJas2ZjokHfl
        PEpRQqgueQtViRwSvsrm7y0rc1U3tVCLskJLhd+imAXqy5OSmpCpZOrXpj8ulcs2zyzCtEX7/ghCK
        Ypfv6X8aMEc19qqQpSv2G2noX1SvCQNSU2qzyzjGc=;
From:   Christian Schoenebeck <linux_oss@crudebyte.com>
To:     Dominique Martinet <asmadeus@codewreck.org>
Cc:     Eric Van Hensbergen <ericvh@gmail.com>,
        Latchesar Ionkov <lucho@ionkov.net>,
        David Howells <dhowells@redhat.com>,
        linux-fsdevel@vger.kernel.org, stable@vger.kernel.org,
        v9fs-developer@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] 9p: fix EBADF errors in cached mode
Date:   Thu, 16 Jun 2022 22:14:16 +0200
Message-ID: <15767273.MGizftpLG7@silver>
In-Reply-To: <Yqs6BPVc3rNZ9byJ@codewreck.org>
References: <YqW5s+GQZwZ/DP5q@codewreck.org> <Yqs1Y8G/Emi/q+S2@codewreck.org>
 <Yqs6BPVc3rNZ9byJ@codewreck.org>
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

On Donnerstag, 16. Juni 2022 15:51:31 CEST Dominique Martinet wrote:
> Christian Schoenebeck wrote on Thu, Jun 16, 2022 at 03:35:59PM +0200:
> > 2. I fixed the conflict and gave your patch a test spin, and it triggers
> > the BUG_ON(!fid); that you added with that patch. Backtrace based on
> 
> > 30306f6194ca ("Merge tag 'hardening-v5.19-rc3' ..."):
> hm, that's probably the version I sent without the fallback to
> private_data fid if writeback fid was sent (I've only commented without
> sending a v2)

Right, I forgot that you queued another version, sorry. With your already 
queued patch (today's v2) that's fine now.

On Donnerstag, 16. Juni 2022 16:11:16 CEST Dominique Martinet wrote:
> Dominique Martinet wrote on Thu, Jun 16, 2022 at 10:51:31PM +0900:
> > > Did your patch work there for you? I mean I have not applied the other
> > > pending 9p patches, but they should not really make difference, right?
> > > I won't have time today, but I will continue to look at it tomorrow. If
> > > you already had some thoughts on this, that would be great of course.
> > 
> > Yes, my version passes basic tests at least, and I could no longer
> > reproduce the problem.
> 
> For what it's worth I've also tested a version of your patch:
> 
> -----
> diff --git a/fs/9p/vfs_addr.c b/fs/9p/vfs_addr.c
> index a8f512b44a85..d0833fa69faf 100644
> --- a/fs/9p/vfs_addr.c
> +++ b/fs/9p/vfs_addr.c
> @@ -58,8 +58,21 @@ static void v9fs_issue_read(struct netfs_io_subrequest
> *subreq) */
>  static int v9fs_init_request(struct netfs_io_request *rreq, struct file
> *file) {
> +	struct inode *inode = file_inode(file);
> +	struct v9fs_inode *v9inode = V9FS_I(inode);
>  	struct p9_fid *fid = file->private_data;
> 
> +	BUG_ON(!fid);
> +
> +	/* we might need to read from a fid that was opened write-only
> +	 * for read-modify-write of page cache, use the writeback fid
> +	 * for that */
> +	if (rreq->origin == NETFS_READ_FOR_WRITE &&
> +			(fid->mode & O_ACCMODE) == O_WRONLY) {
> +		fid = v9inode->writeback_fid;
> +		BUG_ON(!fid);
> +	}
> +
>  	refcount_inc(&fid->count);
>  	rreq->netfs_priv = fid;
>  	return 0;
> -----
> 
> And this also seems to work alright.
> 
> I was about to ask why the original code did writes with the writeback
> fid, but I'm noticing now the current code still does (through
> v9fs_vfs_write_folio_locked()), so that part hasn't changed from the old
> code, and init_request will only be getting reads? Which actually makes
> sense now I'm thinking about it because I recall David saying he's
> working on netfs writes now...
> 
> So that minimal version is probably what we want, give or take style
> adjustments (only initializing inode/v9inode in the if case or not) -- I
> sure hope compilers optimizes it away when not needed.
> 
> 
> I'll let you test one or both versions and will fixup the commit message
> again/credit you/resend if we go with this version, unless you want to
> send it.
> 
> --
> Dominique

I tested all 3 variants today, and they were all behaving correctly (no EBADF 
errors anymore, no other side effects observed).

The minimalistic version (i.e. your initial suggestion) performed 20% slower 
in my tests, but that could be due to the fact that it was simply the 1st 
version I tested, so caching on host side might be the reason. If necessary I 
can check the performance aspect more thoroughly.

Personally I would at least use the NETFS_READ_FOR_WRITE version, but that's 
up to you. On doubt, clarify with David's plans.

Feel free to add my RB and TB tags to any of the 3 version(s) you end up 
queuing:

Reviewed-by: Christian Schoenebeck <linux_oss@crudebyte.com>
Tested-by: Christian Schoenebeck <linux_oss@crudebyte.com>

Best regards,
Christian Schoenebeck


