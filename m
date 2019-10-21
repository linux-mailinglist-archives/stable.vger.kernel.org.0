Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0BFCFDE6FC
	for <lists+stable@lfdr.de>; Mon, 21 Oct 2019 10:47:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727482AbfJUIrn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Oct 2019 04:47:43 -0400
Received: from mx2.suse.de ([195.135.220.15]:51340 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727309AbfJUIrk (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 21 Oct 2019 04:47:40 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id D3542B730;
        Mon, 21 Oct 2019 08:47:38 +0000 (UTC)
Received: by quack2.suse.cz (Postfix, from userid 1000)
        id 18AF91E4AA0; Mon, 21 Oct 2019 10:47:38 +0200 (CEST)
Date:   Mon, 21 Oct 2019 10:47:38 +0200
From:   Jan Kara <jack@suse.cz>
To:     Dan Williams <dan.j.williams@intel.com>
Cc:     linux-fsdevel@vger.kernel.org, Jeff Smits <jeff.smits@intel.com>,
        Doug Nelson <doug.nelson@intel.com>, stable@vger.kernel.org,
        Jan Kara <jack@suse.cz>,
        "Matthew Wilcox (Oracle)" <willy@infradead.org>,
        linux-nvdimm@lists.01.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] fs/dax: Fix pmd vs pte conflict detection
Message-ID: <20191021084738.GA17810@quack2.suse.cz>
References: <157150237973.3940076.12626102230619807187.stgit@dwillia2-desk3.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <157150237973.3940076.12626102230619807187.stgit@dwillia2-desk3.amr.corp.intel.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat 19-10-19 09:26:19, Dan Williams wrote:
> Check for NULL entries before checking the entry order, otherwise NULL
> is misinterpreted as a present pte conflict. The 'order' check needs to
> happen before the locked check as an unlocked entry at the wrong order
> must fallback to lookup the correct order.
> 
> Reported-by: Jeff Smits <jeff.smits@intel.com>
> Reported-by: Doug Nelson <doug.nelson@intel.com>
> Cc: <stable@vger.kernel.org>
> Fixes: 23c84eb78375 ("dax: Fix missed wakeup with PMD faults")
> Cc: Jan Kara <jack@suse.cz>
> Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
> Signed-off-by: Dan Williams <dan.j.williams@intel.com>

Good catch! The patch looks good to me. You can add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

> ---
>  fs/dax.c |    5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/dax.c b/fs/dax.c
> index a71881e77204..08160011d94c 100644
> --- a/fs/dax.c
> +++ b/fs/dax.c
> @@ -221,10 +221,11 @@ static void *get_unlocked_entry(struct xa_state *xas, unsigned int order)
>  
>  	for (;;) {
>  		entry = xas_find_conflict(xas);
> +		if (!entry || WARN_ON_ONCE(!xa_is_value(entry)))
> +			return entry;
>  		if (dax_entry_order(entry) < order)
>  			return XA_RETRY_ENTRY;
> -		if (!entry || WARN_ON_ONCE(!xa_is_value(entry)) ||
> -				!dax_is_locked(entry))
> +		if (!dax_is_locked(entry))
>  			return entry;
>  
>  		wq = dax_entry_waitqueue(xas, entry, &ewait.key);
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
