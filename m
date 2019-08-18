Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 70A0E91422
	for <lists+stable@lfdr.de>; Sun, 18 Aug 2019 04:21:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726408AbfHRCVG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 17 Aug 2019 22:21:06 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:39230 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726208AbfHRCVG (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 17 Aug 2019 22:21:06 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=rTepqUiIUx2nnEvuuf1IfBTS43BjeweB+IeE+bLV2H0=; b=jA5GcXNq9MfyEvl9UgqfCv2uN
        KduJxuHrPS02dFDVNAioWXKihTJvtK+MC0OIWgHKRKgWVRh4vlxhFM2sqx+9PkAGFxQrdG3sbHW/Q
        YLQSj9SqVXiZFbfvnfC2q5R/l8VeTCUNqYUCKj9DL5w+R8UYF9PUDDPy5h54axO+TzRK/pgQQZqmE
        sKb71/Rdfb4ZEcyOREIhAspSOIeiiM14fnbtnYO7e6jxzsJ7jaEW+encFkdeMqG/W9MaXcZS7Y/zA
        w/Dgbb9xXuEE95rAY/kK8se2W7Yn2s8XtVyvkFNLYO3smemDaVVdEajDo74CszfjMM7gXz/Flg7uU
        +/+5Qy5SA==;
Received: from willy by bombadil.infradead.org with local (Exim 4.92 #3 (Red Hat Linux))
        id 1hzAoR-0001XG-Pw; Sun, 18 Aug 2019 02:20:55 +0000
Date:   Sat, 17 Aug 2019 19:20:55 -0700
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
Message-ID: <20190818022055.GA14592@bombadil.infradead.org>
References: <20190818014835.5874-1-hsiangkao@aol.com>
 <20190818015631.6982-1-hsiangkao@aol.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190818015631.6982-1-hsiangkao@aol.com>
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, Aug 18, 2019 at 09:56:31AM +0800, Gao Xiang wrote:
> @@ -82,8 +82,12 @@ static int erofs_readdir(struct file *f, struct dir_context *ctx)
>  		unsigned int nameoff, maxsize;
>  
>  		dentry_page = read_mapping_page(mapping, i, NULL);
> -		if (IS_ERR(dentry_page))
> -			continue;
> +		if (IS_ERR(dentry_page)) {
> +			errln("fail to readdir of logical block %u of nid %llu",
> +			      i, EROFS_V(dir)->nid);
> +			err = PTR_ERR(dentry_page);
> +			break;

I don't think you want to use the errno that came back from
read_mapping_page() (which is, I think, always going to be -EIO).
Rather you want -EFSCORRUPTED, at least if I understand the recent
patches to ext2/ext4/f2fs/xfs/...
