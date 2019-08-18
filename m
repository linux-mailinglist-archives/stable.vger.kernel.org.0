Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 86C6A91694
	for <lists+stable@lfdr.de>; Sun, 18 Aug 2019 14:33:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726208AbfHRMdZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 18 Aug 2019 08:33:25 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:54184 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726073AbfHRMdY (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 18 Aug 2019 08:33:24 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=xzB0N5KXoocholH/YOkGDtfICAB0yGZ8RmgdPY4pQBk=; b=D8+f2WvkG3p4WYc9upT4VTsHh
        f5SeQ1l6W8TPkD72cRq3W/6BHXnBllsfy1ZRsOACKqpIfcdUUAeByjXNJlgPSq9O6kKyUS/vDaaB4
        TMH0oiTgiT4gbsjz/lmiTBkQV/X1Ifiq/f5X6PXYemIACo1rf3KK5yxYaJhdlgAXXPwEktdLrNdly
        3vYZcGes35B0aRNrWAwQ16HHXF/hiODC26eK1gpfhSbGTlhsZcluX2QuzZAsAYbte77evggr1Piz0
        UKbu6+itGXx4A24C1YJJc27Hgbnu4ZqXCrZ0eNPmmHhmA+VZctKuXUPyxYACWV2lHw2uck+Y+2NYi
        qkVoejm9Q==;
Received: from willy by bombadil.infradead.org with local (Exim 4.92 #3 (Red Hat Linux))
        id 1hzKN0-0004ZF-AZ; Sun, 18 Aug 2019 12:33:14 +0000
Date:   Sun, 18 Aug 2019 05:33:14 -0700
From:   Matthew Wilcox <willy@infradead.org>
To:     Gao Xiang <hsiangkao@aol.com>
Cc:     Chao Yu <yuchao0@huawei.com>, Richard Weinberger <richard@nod.at>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        devel@driverdev.osuosl.org, linux-fsdevel@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>,
        linux-erofs@lists.ozlabs.org, Chao Yu <chao@kernel.org>,
        Miao Xie <miaoxie@huawei.com>, Fang Wei <fangwei1@huawei.com>,
        Gao Xiang <gaoxiang25@huawei.com>, stable@vger.kernel.org
Subject: Re: [PATCH v3 RESEND] staging: erofs: fix an error handling in
 erofs_readdir()
Message-ID: <20190818123314.GA29733@bombadil.infradead.org>
References: <20190818030109.GA8225@hsiangkao-HP-ZHAN-66-Pro-G1>
 <20190818032111.9862-1-hsiangkao@aol.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190818032111.9862-1-hsiangkao@aol.com>
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, Aug 18, 2019 at 11:21:11AM +0800, Gao Xiang wrote:
> +		if (dentry_page == ERR_PTR(-ENOMEM)) {
> +			errln("no memory to readdir of logical block %u of nid %llu",
> +			      i, EROFS_V(dir)->nid);

I don't think you need the error message.  If we get a memory allocation
failure, there's already going to be a lot of spew in the logs from the
mm system.  And if we do fail to allocate memory, we don't need to know
the logical block number or the nid -- it has nothiing to do with those;
the system simply ran out of memory.

> +			err = -ENOMEM;
> +			break;
> +		} else if (IS_ERR(dentry_page)) {
> +			errln("fail to readdir of logical block %u of nid %llu",
> +			      i, EROFS_V(dir)->nid);
> +			err = -EFSCORRUPTED;
> +			break;
> +		}
>  
>  		de = (struct erofs_dirent *)kmap(dentry_page);
>  
> -- 
> 2.17.1
> 
