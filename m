Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 62ACA91434
	for <lists+stable@lfdr.de>; Sun, 18 Aug 2019 04:53:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726247AbfHRCxs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 17 Aug 2019 22:53:48 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:39508 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726215AbfHRCxs (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 17 Aug 2019 22:53:48 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=VufZf6qCH9xcIIdF+ObXMZETkYlQIHbI4jbwUKWJwWk=; b=Bp4v8HCDrXwCR1yaowmeSvvim
        jsQemrQQbCwT9+GMYnLRvkwiyV3cQMWJOlD/IZawDkYN72y6oXS+Ki9WiFyIcSJSN1wIEWMVa7zHb
        Aytw579lQckj7d075U1MrLG4/B1AlWWGu/VRQBeuv3lP5ZsUch5D8uiNkGyrxIvF59m9YEvCiQnII
        lWFnKQWEMTKJTiZe++NeydgRrmcBeDMKa3ZCzFIzLVuaA6zeTsHIRFIoFKqCNUjpFdoADzEo2RdEn
        Hx0yTipxJZm36fdl1dX9ogvKV8+9TkSSDKd1IO1NNkmaNshpIdA/a3DQPe1xSXlmsyfXD0qNRr1Da
        lG22ScPOA==;
Received: from willy by bombadil.infradead.org with local (Exim 4.92 #3 (Red Hat Linux))
        id 1hzBK7-0006nl-8P; Sun, 18 Aug 2019 02:53:39 +0000
Date:   Sat, 17 Aug 2019 19:53:39 -0700
From:   Matthew Wilcox <willy@infradead.org>
To:     Gao Xiang <hsiangkao@aol.com>
Cc:     Chao Yu <yuchao0@huawei.com>, Richard Weinberger <richard@nod.at>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        devel@driverdev.osuosl.org, linux-fsdevel@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>,
        linux-erofs@lists.ozlabs.org, Chao Yu <chao@kernel.org>,
        Miao Xie <miaoxie@huawei.com>, Fang Wei <fangwei1@huawei.com>,
        Gao Xiang <gaoxiang25@huawei.com>, stable@vger.kernel.org
Subject: Re: [PATCH v2] staging: erofs: fix an error handling in
 erofs_readdir()
Message-ID: <20190818025339.GB14592@bombadil.infradead.org>
References: <20190818014835.5874-1-hsiangkao@aol.com>
 <20190818015631.6982-1-hsiangkao@aol.com>
 <20190818022055.GA14592@bombadil.infradead.org>
 <20190818023240.GA7739@hsiangkao-HP-ZHAN-66-Pro-G1>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190818023240.GA7739@hsiangkao-HP-ZHAN-66-Pro-G1>
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, Aug 18, 2019 at 10:32:45AM +0800, Gao Xiang wrote:
> On Sat, Aug 17, 2019 at 07:20:55PM -0700, Matthew Wilcox wrote:
> > On Sun, Aug 18, 2019 at 09:56:31AM +0800, Gao Xiang wrote:
> > > @@ -82,8 +82,12 @@ static int erofs_readdir(struct file *f, struct dir_context *ctx)
> > >  		unsigned int nameoff, maxsize;
> > >  
> > >  		dentry_page = read_mapping_page(mapping, i, NULL);
> > > -		if (IS_ERR(dentry_page))
> > > -			continue;
> > > +		if (IS_ERR(dentry_page)) {
> > > +			errln("fail to readdir of logical block %u of nid %llu",
> > > +			      i, EROFS_V(dir)->nid);
> > > +			err = PTR_ERR(dentry_page);
> > > +			break;
> > 
> > I don't think you want to use the errno that came back from
> > read_mapping_page() (which is, I think, always going to be -EIO).
> > Rather you want -EFSCORRUPTED, at least if I understand the recent
> > patches to ext2/ext4/f2fs/xfs/...
> 
> Thanks for your reply and noticing this. :)
> 
> Yes, as I talked with you about read_mapping_page() in a xfs related
> topic earlier, I think I fully understand what returns here.
> 
> I actually had some concern about that before sending out this patch.
> You know the status is
>    PG_uptodate is not set and PG_error is set here.
> 
> But we cannot know it is actually a disk read error or due to
> corrupted images (due to lack of page flags or some status, and
> I think it could be a waste of page structure space for such
> corrupted image or disk error)...
> 
> And some people also like propagate errors from insiders...
> (and they could argue about err = -EFSCORRUPTED as well..)
> 
> I'd like hear your suggestion about this after my words above?
> still return -EFSCORRUPTED?

I don't think it matters whether it's due to a disk error or a corrupted
image.  We can't read the directory entry, so we should probably return
-EFSCORRUPTED.  Thinking about it some more, read_mapping_page() can
also return -ENOMEM, so it should probably look something like this:

		err = 0;
		if (dentry_page == ERR_PTR(-ENOMEM))
			err = -ENOMEM;
		else if (IS_ERR(dentry_page)) {
			errln("fail to readdir of logical block %u of nid %llu",
			      i, EROFS_V(dir)->nid);
			err = -EFSCORRUPTED;
		}

		if (err)
			break;
