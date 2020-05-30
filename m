Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DEAD01E92CF
	for <lists+stable@lfdr.de>; Sat, 30 May 2020 19:18:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729181AbgE3RSU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 30 May 2020 13:18:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36780 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728927AbgE3RST (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 30 May 2020 13:18:19 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B095FC03E969;
        Sat, 30 May 2020 10:18:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=L01rcThTXQGPtzbd1sl02vy/AZKkMVDpxcktglSDj/Y=; b=HBJu6SnmC5B1P9o9UOfR2HZWJF
        AiFIR3Id9rSPCYStLx2L6hC4V6jDcbiu2BxjaA+pTXEFjbHsWlPqYF25uodE12GuP/0Zjgf8XvKbr
        hkL7GP7CwiJ0FSMTYk56M9ldfCihszDY4LJyfIzZwp5nNDg78qvwF/iFloICjidC7u1E0w3Uzr2/K
        TZuae9dpDqIxbBro4CThKmqZe6WoJMmo4MK7+xZeHi0fm6uiYFPk0QST0Vn5gMNPD584cNn4pMYw5
        6WeizdsrEO7j/X/cGP42rGjJ72GVK1oOyKRVLfZBzMSJEIylXmZGTL1DribFuW5jTuegTqrgmdUMl
        dZRvZHBw==;
Received: from willy by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jf57e-0000cg-Ga; Sat, 30 May 2020 17:18:14 +0000
Date:   Sat, 30 May 2020 10:18:14 -0700
From:   Matthew Wilcox <willy@infradead.org>
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net, stable@vger.kernel.org,
        Al Viro <viro@zeniv.linux.org.uk>,
        Daniel Rosenberg <drosen@google.com>,
        Gabriel Krisman Bertazi <krisman@collabora.co.uk>
Subject: Re: [PATCH] ext4: avoid utf8_strncasecmp() with unstable name
Message-ID: <20200530171814.GD19604@bombadil.infradead.org>
References: <20200530060216.221456-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200530060216.221456-1-ebiggers@kernel.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, May 29, 2020 at 11:02:16PM -0700, Eric Biggers wrote:
> +	if (len <= DNAME_INLINE_LEN - 1) {
> +		unsigned int i;
> +
> +		for (i = 0; i < len; i++)
> +			strbuf[i] = READ_ONCE(str[i]);
> +		strbuf[len] = 0;

This READ_ONCE is going to force the compiler to use byte accesses.
What's wrong with using a plain memcpy()?

> +		qstr.name = strbuf;
> +	}
> +
>  	return ext4_ci_compare(inode, name, &qstr, false);
>  }
>  
> -- 
> 2.26.2
> 
