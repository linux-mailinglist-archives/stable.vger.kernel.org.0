Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9DC053A4A4F
	for <lists+stable@lfdr.de>; Fri, 11 Jun 2021 22:48:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230233AbhFKUui (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 11 Jun 2021 16:50:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53916 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230298AbhFKUuf (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 11 Jun 2021 16:50:35 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 52B09C0617AF;
        Fri, 11 Jun 2021 13:48:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=PEdTCh+3iQ9aG3ty3r/97MIrJQbDTmwMwReez7sMv4o=; b=KYF6CaumPuQU2GTJfQ9sWJZiLO
        VSV+jNcwIUqBGNrabM4XoIO84fIz/hGxFl6Xxo3iqLsaxvpLMg8P1GgQT6mmgI3oweSzliuwOz4CC
        S5trjg6xjamxKjdbQ/npHNd5bjkHbR0qeY8Y+Gq1cP2wkqyypDkWOmrt2Y4+V/421oBbJpLjSz/7u
        cxGp2WbHBezt29x+8Dgn6iHdd1P/XWCxFLoaML45vIeM9XneB1SukbVt9WmOvs9mdsCrx+KdGserT
        hugNtOHYWr4JGC4mPUPWWqM9zsH8f5wR+Kw0Xbvfpr7ueK+TcGYXeDQDqA4DT164MfyV9ainWlarv
        hVjEXjyQ==;
Received: from willy by casper.infradead.org with local (Exim 4.94 #2 (Red Hat Linux))
        id 1lro4h-0037lR-Jd; Fri, 11 Jun 2021 20:48:23 +0000
Date:   Fri, 11 Jun 2021 21:48:19 +0100
From:   Matthew Wilcox <willy@infradead.org>
To:     Jeff Layton <jlayton@kernel.org>
Cc:     ceph-devel@vger.kernel.org, linux-cachefs@redhat.com,
        pfmeec@rit.edu, dhowells@redhat.com, idryomov@gmail.com,
        stable@vger.kernel.org, Andrew W Elble <aweits@rit.edu>
Subject: Re: [PATCH] ceph: fix write_begin optimization when write is beyond
 EOF
Message-ID: <YMPME0Bey8Tzz37l@casper.infradead.org>
References: <20210611195904.160416-1-jlayton@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210611195904.160416-1-jlayton@kernel.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Jun 11, 2021 at 03:59:04PM -0400, Jeff Layton wrote:
>  		if ((pos_in_page == 0 && len == PAGE_SIZE) ||
> -		    (pos >= i_size_read(inode)) ||
> +		    (index > (i_size_read(inode) / PAGE_SIZE)) ||

I think that wants to be ((i_size_read(inode) - 1) / PAGE_SIZE)

If your file is 4096 bytes long, that means bytes 0-4095 contain data.
Except that i_size can be 0, so ...

		if ((offset == 0 && len == PAGE_SIZE) || i_size == 0 ||
		    (index > (i_size - 1) / PAGE_SIZE) ||
		    (offset == 0 && pos + len >= i_size))
  			zero_user_segments(page, 0, pos_in_page,
  					   pos_in_page + len, PAGE_SIZE);

