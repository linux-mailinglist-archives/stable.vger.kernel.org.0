Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ADD831AD7FE
	for <lists+stable@lfdr.de>; Fri, 17 Apr 2020 09:51:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729159AbgDQHvw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 17 Apr 2020 03:51:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58086 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729042AbgDQHvw (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 17 Apr 2020 03:51:52 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3FC31C061A0C;
        Fri, 17 Apr 2020 00:51:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=9MNSuC5hg6YPkaUcYIiqoAvVuBbZW4lemK9V50L0u08=; b=Fb4A1FWhj8E9zcaEYfE85nKg6P
        YLH6oMxcEIRi/phD3Wef+KVxWUVRPUMGk4r2ue+r3QpdXUQS1GSP8RixvZX1Yl0qSI+aGARfN1ulq
        ROJ0rEjLtBXP2Nu2x/JJeH5z40Kc0NKxjlDd3CQlVwNCVNDblxXvD2+efokonBLzHfCs7FFDS6/5c
        /Zvzm5gZz9Pj17rT4hbw5syuRXrgzyE0CfAcvPHUmcLfdimzqUvWk6EaVEFcfSpjFI1i+fPIUSQZ5
        qwu/n8Pe1D6gRhqI1HeZpPW2YWCYpYTJT/V4kUqTVYGJ5lcHP/76l31wBtArfzO4Oo6tSHGQApbLP
        /jZFwyZQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jPLmw-0008Id-UU; Fri, 17 Apr 2020 07:51:50 +0000
Date:   Fri, 17 Apr 2020 00:51:50 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Max Kellermann <mk@cm4all.com>
Cc:     linux-fsdevel@vger.kernel.org, linux-nfs@vger.kernel.org,
        trond.myklebust@hammerspace.com, bfields@redhat.com, tytso@mit.edu,
        viro@zeniv.linux.org.uk, agruenba@redhat.com,
        linux-kernel@vger.kernel.org, Jan Kara <jack@suse.cz>,
        stable@vger.kernel.org
Subject: Re: [PATCH v3 3/4] linux/fs.h: fix umask on NFS with
 CONFIG_FS_POSIX_ACL=n
Message-ID: <20200417075150.GC598@infradead.org>
References: <20200407142243.2032-1-mk@cm4all.com>
 <20200407142243.2032-3-mk@cm4all.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200407142243.2032-3-mk@cm4all.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

> +#ifdef CONFIG_FS_POSIX_ACL
>  #define IS_POSIXACL(inode)	__IS_FLG(inode, SB_POSIXACL)
> +#else
> +#define IS_POSIXACL(inode)	0
> +#endif

Looks good, but I'd simplify this down to:

#define IS_POSIXACL(inode) \
	(IS_ENABLED(CONFIG_FS_POSIX_ACL) && __IS_FLG(inode, SB_POSIXACL))
