Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 10D2114AA8D
	for <lists+stable@lfdr.de>; Mon, 27 Jan 2020 20:35:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725845AbgA0Tfw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Jan 2020 14:35:52 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:49904 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725990AbgA0Tfw (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Jan 2020 14:35:52 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=IoDsogQztWNxpuY+vnlbI0hiBbp6fUybRbb8amKHsKY=; b=lODGCgcsQOBjJTzSj8vhd8O2w
        n6wKIqb0X5NqdICXs8/HIx+5tgDzesIVu8toY13vEAX/yr27PmGtuZZt6BT9S05Vqa7vTfbBJ4Zq3
        hLDsRkca1ESDRPKY7R4XiBwqirSn1IioD9fAJIfBYqgG/9pRtQeXyFQSxc1K7EMI5BJw3yY+0M7xp
        Urh6iR1RWlmtV2XlCibPass/WZxso1JWttjwuh7KNcO1imqXuoSa2/F6iRRRG93ecxmwE9L6eh+jm
        B9kooeY07xsYG3Y6YL3Wp/JPgDua8j/NsPeu1Ysye83QWUKKkjjI9zYm2wZLeo++SmSXlgHz8TkBD
        4a96zTX4w==;
Received: from willy by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1iwAAk-0003q2-3v; Mon, 27 Jan 2020 19:35:46 +0000
Date:   Mon, 27 Jan 2020 11:35:46 -0800
From:   Matthew Wilcox <willy@infradead.org>
To:     Yang Shi <yang.shi@linux.alibaba.com>
Cc:     mhocko@suse.com, richardw.yang@linux.intel.com,
        akpm@linux-foundation.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [v3 PATCH] mm: move_pages: report the number of non-attempted
 pages
Message-ID: <20200127193546.GB8708@bombadil.infradead.org>
References: <1580144268-79620-1-git-send-email-yang.shi@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1580144268-79620-1-git-send-email-yang.shi@linux.alibaba.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

> @@ -1627,8 +1627,18 @@ static int do_pages_move(struct mm_struct *mm, nodemask_t task_nodes,
>  			start = i;
>  		} else if (node != current_node) {
>  			err = do_move_pages_to_node(mm, &pagelist, current_node);
> -			if (err)
> +			if (err) {
> +				/*
> +				 * Possitive err means the number of failed

"positive"

> +				 * pages to migrate.  Since we are going to
> +				 * abort and return the number of non-migrated
> +				 * pages, so need incude the rest of the

"need to include"

> +				 * nr_pages that have not attempted as well.

"have not been attempted"

> @@ -1674,6 +1687,13 @@ static int do_pages_move(struct mm_struct *mm, nodemask_t task_nodes,
>  
>  	/* Make sure we do not overwrite the existing error */
>  	err1 = do_move_pages_to_node(mm, &pagelist, current_node);
> +	/*
> +	 * Don't have to report non-attempted pages here since:
> +	 *     - If the above loop is done gracefully there is not non-attempted

"all pages have been attempted"

> +	 *       page.
> +	 *     - If the above loop is aborted to it means more fatal error

s/to// s/more/a/

> +	 *       happened, should return err.
> +	 */   

I'd also be tempted to rename "err" to "ret" since it has meanings beyond
"error" now.


