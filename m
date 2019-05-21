Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EB1B1245EC
	for <lists+stable@lfdr.de>; Tue, 21 May 2019 04:18:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727047AbfEUCSQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 May 2019 22:18:16 -0400
Received: from mx1.redhat.com ([209.132.183.28]:41042 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726335AbfEUCSP (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 May 2019 22:18:15 -0400
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 7DBBA4E908;
        Tue, 21 May 2019 02:18:15 +0000 (UTC)
Received: from [10.72.12.71] (ovpn-12-71.pek2.redhat.com [10.72.12.71])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 6D2E360C62;
        Tue, 21 May 2019 02:18:09 +0000 (UTC)
Subject: Re: [PATCH 4/4] ceph: fix improper use of smp_mb__before_atomic()
To:     Andrea Parri <andrea.parri@amarulasolutions.com>,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, Sage Weil <sage@redhat.com>,
        Ilya Dryomov <idryomov@gmail.com>, ceph-devel@vger.kernel.org,
        "Paul E. McKenney" <paulmck@linux.ibm.com>,
        Peter Zijlstra <peterz@infradead.org>
References: <1558373038-5611-1-git-send-email-andrea.parri@amarulasolutions.com>
 <1558373038-5611-5-git-send-email-andrea.parri@amarulasolutions.com>
From:   "Yan, Zheng" <zyan@redhat.com>
Message-ID: <a1dcab3f-6018-9d4d-ee6d-505b4086f097@redhat.com>
Date:   Tue, 21 May 2019 10:18:07 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <1558373038-5611-5-git-send-email-andrea.parri@amarulasolutions.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.38]); Tue, 21 May 2019 02:18:15 +0000 (UTC)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 5/21/19 1:23 AM, Andrea Parri wrote:
> This barrier only applies to the read-modify-write operations; in
> particular, it does not apply to the atomic64_set() primitive.
> 
> Replace the barrier with an smp_mb().
> 
> Fixes: fdd4e15838e59 ("ceph: rework dcache readdir")
> Cc: stable@vger.kernel.org
> Reported-by: "Paul E. McKenney" <paulmck@linux.ibm.com>
> Reported-by: Peter Zijlstra <peterz@infradead.org>
> Signed-off-by: Andrea Parri <andrea.parri@amarulasolutions.com>
> Cc: "Yan, Zheng" <zyan@redhat.com>
> Cc: Sage Weil <sage@redhat.com>
> Cc: Ilya Dryomov <idryomov@gmail.com>
> Cc: ceph-devel@vger.kernel.org
> Cc: "Paul E. McKenney" <paulmck@linux.ibm.com>
> Cc: Peter Zijlstra <peterz@infradead.org>
> ---
>   fs/ceph/super.h | 7 ++++++-
>   1 file changed, 6 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/ceph/super.h b/fs/ceph/super.h
> index 6edab9a750f8a..e02f4ff0be3f1 100644
> --- a/fs/ceph/super.h
> +++ b/fs/ceph/super.h
> @@ -541,7 +541,12 @@ static inline void __ceph_dir_set_complete(struct ceph_inode_info *ci,
>   					   long long release_count,
>   					   long long ordered_count)
>   {
> -	smp_mb__before_atomic();
> +	/*
> +	 * Makes sure operations that setup readdir cache (update page
> +	 * cache and i_size) are strongly ordered w.r.t. the following
> +	 * atomic64_set() operations.
> +	 */
> +	smp_mb();
>   	atomic64_set(&ci->i_complete_seq[0], release_count);
>   	atomic64_set(&ci->i_complete_seq[1], ordered_count);
>   }
> 

Applied, thanks

