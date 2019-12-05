Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 47D101147CF
	for <lists+stable@lfdr.de>; Thu,  5 Dec 2019 20:45:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726946AbfLETpu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 5 Dec 2019 14:45:50 -0500
Received: from gentwo.org ([3.19.106.255]:47108 "EHLO gentwo.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726589AbfLETpu (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 5 Dec 2019 14:45:50 -0500
Received: by gentwo.org (Postfix, from userid 1002)
        id 4909D3EBB9; Thu,  5 Dec 2019 19:45:49 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
        by gentwo.org (Postfix) with ESMTP id 46EA23E95C;
        Thu,  5 Dec 2019 19:45:49 +0000 (UTC)
Date:   Thu, 5 Dec 2019 19:45:49 +0000 (UTC)
From:   Christopher Lameter <cl@linux.com>
X-X-Sender: cl@www.lameter.com
To:     Yang Shi <yang.shi@linux.alibaba.com>
cc:     fabecassis@nvidia.com, jhubbard@nvidia.com, mhocko@suse.com,
        vbabka@suse.cz, mgorman@techsingularity.net,
        akpm@linux-foundation.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [v3 PATCH] mm: move_pages: return valid node id in status if
 the page is already on the target node
In-Reply-To: <1575572053-128363-1-git-send-email-yang.shi@linux.alibaba.com>
Message-ID: <alpine.DEB.2.21.1912051944030.10280@www.lameter.com>
References: <1575572053-128363-1-git-send-email-yang.shi@linux.alibaba.com>
User-Agent: Alpine 2.21 (DEB 202 2017-01-01)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, 6 Dec 2019, Yang Shi wrote:

> Felix Abecassis reports move_pages() would return random status if the
> pages are already on the target node by the below test program:

Looks ok.

Acked-by: Christoph Lameter <cl@linux.com>

Nitpicks:

> @@ -1553,7 +1555,7 @@ static int add_page_for_migration(struct mm_struct *mm, unsigned long addr,
>  	if (PageHuge(page)) {
>  		if (PageHead(page)) {
>  			isolate_huge_page(page, pagelist);
> -			err = 0;
> +			err = 1;

Add a meaningful constant instead of 1?

>  out:
>  	up_read(&mm->mmap_sem);
> +
>  	return err;

Dont do that.
