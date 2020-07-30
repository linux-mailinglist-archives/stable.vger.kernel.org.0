Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8E6B5233106
	for <lists+stable@lfdr.de>; Thu, 30 Jul 2020 13:35:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726951AbgG3LfJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 Jul 2020 07:35:09 -0400
Received: from smtp-fw-6002.amazon.com ([52.95.49.90]:56591 "EHLO
        smtp-fw-6002.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726631AbgG3LfI (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 30 Jul 2020 07:35:08 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1596108908; x=1627644908;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   mime-version;
  bh=j41KC+1XDl93tyoex2UKMqkfEfMm8VkxpaoA98a3XK4=;
  b=aXkEsqAc3GoUmM1WA5VaFUouwGKBZ/FLXVTMElA56LEfkkgnmqJbJ/8n
   FE3gTyPn/mlhGCH8amFmnUksnp8cnZf/sl9iOQq+wgEiZAMv5RrOn8XHD
   Yw4Fwx7GEqAf2+JKG4vnUnesfIsF//+TZI9TpmH/alYyGeeTGQT3dY+/g
   s=;
IronPort-SDR: H8ecPjeO38f1B/8hwViuPnOTe4Nzztp8Pwz6pkJnQHif/q/p9vvtXA2wSvyGz/sXcPr0RiN8ph
 vyvTeELyGtrw==
X-IronPort-AV: E=Sophos;i="5.75,414,1589241600"; 
   d="scan'208";a="45038184"
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-1e-62350142.us-east-1.amazon.com) ([10.43.8.6])
  by smtp-border-fw-out-6002.iad6.amazon.com with ESMTP; 30 Jul 2020 11:35:06 +0000
Received: from EX13MTAUEA002.ant.amazon.com (iad55-ws-svc-p15-lb9-vlan2.iad.amazon.com [10.40.159.162])
        by email-inbound-relay-1e-62350142.us-east-1.amazon.com (Postfix) with ESMTPS id DC61CA22F3;
        Thu, 30 Jul 2020 11:35:03 +0000 (UTC)
Received: from EX13D31EUA001.ant.amazon.com (10.43.165.15) by
 EX13MTAUEA002.ant.amazon.com (10.43.61.77) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Thu, 30 Jul 2020 11:35:03 +0000
Received: from u886c93fd17d25d.ant.amazon.com (10.43.160.26) by
 EX13D31EUA001.ant.amazon.com (10.43.165.15) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Thu, 30 Jul 2020 11:34:55 +0000
From:   SeongJae Park <sjpark@amazon.com>
To:     <gregkh@linuxfoundation.org>, <sashal@kernel.org>,
        <stable@vger.kernel.org>
CC:     Andrew Morton <akpm@linux-foundation.org>, <linux-mm@kvack.org>,
        "Josef Bacik" <josef@toxicpanda.com>, Robert Stupp <snazy@gmx.de>,
        Minchan Kim <minchan@kernel.org>, Jan Kara <jack@suse.cz>
Subject: Re: [PATCH] mm: Don't bother dropping mmap_sem for zero size readahead
Date:   Thu, 30 Jul 2020 13:34:35 +0200
Message-ID: <20200730113435.2280-1-sjpark@amazon.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200212101356.30759-1-jack@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.43.160.26]
X-ClientProxiedBy: EX13D41UWC001.ant.amazon.com (10.43.162.107) To
 EX13D31EUA001.ant.amazon.com (10.43.165.15)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hello,


The commit fixed by this patch[1] was merged in v5.1 and this patch was merged
in the mainline in v5.7 (5c72feee3e45b40a3c96c7145ec422899d0e8964).  Thus, the
issue affects [v5.1, v5.6].  I was also able to reproduce the issue and confirm
the fix works on v5.4 based kernels.

However, I couldn't find this fix in neither latest stable/linux-5.4.y, nor
stable-queue/master.  Could you please put this patch in the queue?

[1] https://lore.kernel.org/linux-mm/20200212101356.30759-1-jack@suse.cz/


Thanks,
SeongJae Park

On Wed, 12 Feb 2020 11:13:56 +0100 Jan Kara <jack@suse.cz> wrote:

> When handling a page fault, we drop mmap_sem to start async readahead so
> that we don't block on IO submission with mmap_sem held.  However
> there's no point to drop mmap_sem in case readahead is disabled. Handle
> that case to avoid pointless dropping of mmap_sem and retrying the
> fault. This was actually reported to block mlockall(MCL_CURRENT)
> indefinitely.
> 
> Fixes: 6b4c9f446981 ("filemap: drop the mmap_sem for all blocking operations")
> Reported-by: Minchan Kim <minchan@kernel.org>
> Reported-by: Robert Stupp <snazy@gmx.de>
> Signed-off-by: Jan Kara <jack@suse.cz>
> ---
>  mm/filemap.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> Andrew, could you please pick up this patch? Minchan also tripped over this
> bug...
> 
> diff --git a/mm/filemap.c b/mm/filemap.c
> index 1146fcfa3215..3d39c437b07e 100644
> --- a/mm/filemap.c
> +++ b/mm/filemap.c
> @@ -2458,7 +2458,7 @@ static struct file *do_async_mmap_readahead(struct vm_fault *vmf,
>  	pgoff_t offset = vmf->pgoff;
>  
>  	/* If we don't want any read-ahead, don't bother */
> -	if (vmf->vma->vm_flags & VM_RAND_READ)
> +	if (vmf->vma->vm_flags & VM_RAND_READ || !ra->ra_pages)
>  		return fpin;
>  	if (ra->mmap_miss > 0)
>  		ra->mmap_miss--;
> -- 
> 2.16.4
