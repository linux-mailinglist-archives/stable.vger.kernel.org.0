Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0558919596
	for <lists+stable@lfdr.de>; Fri, 10 May 2019 01:11:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726694AbfEIXLh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 May 2019 19:11:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:34100 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726682AbfEIXLh (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 9 May 2019 19:11:37 -0400
Received: from localhost.localdomain (c-73-223-200-170.hsd1.ca.comcast.net [73.223.200.170])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 50F642173C;
        Thu,  9 May 2019 23:11:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557443496;
        bh=4czGVVwxwttY99MriEH8D5p/ohHXnX9UEsQ9++fXAiw=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=AgZ9nGkinsJeJnmcfS5Jgm3wtmVHuRU5lptN1SIUZM/xc4SVbVTukk0uVJmEYFG63
         fMg9LLzPL0e+JcHsSReAaSejpacJiUpDr0BieQ4pJA82YRn7b8Ey8V+LYXI+wAGnu0
         Lk1B0ytS5mLdcAT5Yjxpl6AjFwv9CECO4jFRec8Y=
Date:   Thu, 9 May 2019 16:11:35 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     Mike Kravetz <mike.kravetz@oracle.com>
Cc:     yuyufen <yuyufen@huawei.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Michal Hocko <mhocko@kernel.org>,
        Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>,
        "Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>,
        stable@vger.kernel.org
Subject: Re: [PATCH] hugetlbfs: always use address space in inode for
 resv_map pointer
Message-Id: <20190509161135.00b542e5b4d0996b5089ea02@linux-foundation.org>
In-Reply-To: <5d7dc0d5-7cd3-eb95-a1e7-9c68fe393647@oracle.com>
References: <20190416065058.GB11561@dhcp22.suse.cz>
        <20190419204435.16984-1-mike.kravetz@oracle.com>
        <fafe9985-7db1-b65c-523d-875ab4b3b3b8@huawei.com>
        <5d7dc0d5-7cd3-eb95-a1e7-9c68fe393647@oracle.com>
X-Mailer: Sylpheed 3.5.1 (GTK+ 2.24.31; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, 8 May 2019 13:16:09 -0700 Mike Kravetz <mike.kravetz@oracle.com> wrote:

> > I think it is better to add fixes label, like:
> > Fixes: 58b6e5e8f1ad ("hugetlbfs: fix memory leak for resv_map")
> > 
> > Since the commit 58b6e5e8f1a has been merged to stable, this patch also be needed.
> > https://www.spinics.net/lists/stable/msg298740.html
> 
> It must have been the AI that decided 58b6e5e8f1a needed to go to stable.

grr.

> Even though this technically does not fix 58b6e5e8f1a, I'm OK with adding
> the Fixes: to force this to go to the same stable trees.

Why are we bothering with any of this, given that

: Luckily, private_data is NULL for address spaces in all such cases
: today but, there is no guarantee this will continue.

?

Even though 58b6e5e8f1ad was inappropriately backported, the above
still holds, so what problem does a backport of "hugetlbfs: always use
address space in inode for resv_map pointer" actually solve?

And yes, some review of this would be nice
