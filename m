Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A516CF1F7
	for <lists+stable@lfdr.de>; Tue, 30 Apr 2019 10:23:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725938AbfD3IXe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 30 Apr 2019 04:23:34 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:59880 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725790AbfD3IXe (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 30 Apr 2019 04:23:34 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=NZBXO1ME4yyhNikKDn25Wx/qhHtX/guFa4/8R+Ntg+Y=; b=G3TUd0H0Lh2EYnrNVTvuVyRLB
        p6pHt9vlLF0QLkapwZMYwuiZGgRG5nqILhQdEldK2Q5ku+eWhOMMsFZuRTthTK8Vaj6yNr9G54AXa
        VqzBhoWej4S3X7Se06W0n7BRMUS95nn89oFIyVjBt6OBJyEta7tADh+jbNq8OxpzU62PtyLDJZwcg
        A4qlbpX5xjzGIsu7w2QXJgno6DCXC7RAuuYRUvefMQtf42OsIemUxBmtQ72NTHQnWZ7Dpo5khsmeA
        vYBLOLAYixvT0RaOkkcLGB3tD4N4zSxUdTDkHqSrgzC1ej0rPOcG4a63mKQBQgyFGZirJJApeJEQf
        zvEKEnWhw==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=hirez.programming.kicks-ass.net)
        by bombadil.infradead.org with esmtpsa (Exim 4.90_1 #2 (Red Hat Linux))
        id 1hLO33-00082Z-LQ; Tue, 30 Apr 2019 08:23:33 +0000
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id 334EE29D2D6D6; Tue, 30 Apr 2019 10:23:32 +0200 (CEST)
Date:   Tue, 30 Apr 2019 10:23:32 +0200
From:   Peter Zijlstra <peterz@infradead.org>
To:     Andrea Parri <andrea.parri@amarulasolutions.com>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        "Yan, Zheng" <zyan@redhat.com>, Sage Weil <sage@redhat.com>,
        Ilya Dryomov <idryomov@gmail.com>, ceph-devel@vger.kernel.org
Subject: Re: [PATCH 4/5] ceph: fix improper use of smp_mb__before_atomic()
Message-ID: <20190430082332.GB2677@hirez.programming.kicks-ass.net>
References: <1556568902-12464-1-git-send-email-andrea.parri@amarulasolutions.com>
 <1556568902-12464-5-git-send-email-andrea.parri@amarulasolutions.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1556568902-12464-5-git-send-email-andrea.parri@amarulasolutions.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Apr 29, 2019 at 10:15:00PM +0200, Andrea Parri wrote:
> This barrier only applies to the read-modify-write operations; in
> particular, it does not apply to the atomic64_set() primitive.
> 
> Replace the barrier with an smp_mb().
> 

> @@ -541,7 +541,7 @@ static inline void __ceph_dir_set_complete(struct ceph_inode_info *ci,
>  					   long long release_count,
>  					   long long ordered_count)
>  {
> -	smp_mb__before_atomic();

same
	/*
	 * XXX: the comment that explain this barrier goes here.
	 */

> +	smp_mb();

>  	atomic64_set(&ci->i_complete_seq[0], release_count);
>  	atomic64_set(&ci->i_complete_seq[1], ordered_count);
>  }
> -- 
> 2.7.4
> 
