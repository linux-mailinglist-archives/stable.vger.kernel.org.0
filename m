Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 144DE1DB4EF
	for <lists+stable@lfdr.de>; Wed, 20 May 2020 15:27:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726443AbgETN1k (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 20 May 2020 09:27:40 -0400
Received: from mx2.suse.de ([195.135.220.15]:40010 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726439AbgETN1k (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 20 May 2020 09:27:40 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 06420AC7B;
        Wed, 20 May 2020 13:27:40 +0000 (UTC)
Received: by quack2.suse.cz (Postfix, from userid 1000)
        id C2DF41E126B; Wed, 20 May 2020 15:27:37 +0200 (CEST)
Date:   Wed, 20 May 2020 15:27:37 +0200
From:   Jan Kara <jack@suse.cz>
To:     Andreas Dilger <adilger@dilger.ca>
Cc:     Jan Kara <jack@suse.cz>, Ted Tso <tytso@mit.edu>,
        linux-ext4@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH 2/2] jbd2: Avoid leaking transaction credits when
 unreserving handle
Message-ID: <20200520132737.GC30597@quack2.suse.cz>
References: <20200518092120.10322-1-jack@suse.cz>
 <20200518092120.10322-3-jack@suse.cz>
 <20AA140E-877B-4240-9BEF-91D24215AF45@dilger.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20AA140E-877B-4240-9BEF-91D24215AF45@dilger.ca>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue 19-05-20 18:44:25, Andreas Dilger wrote:
> On May 18, 2020, at 3:21 AM, Jan Kara <jack@suse.cz> wrote:
> > 
> > When reserved transaction handle is unused, we subtract its reserved
> > credits in __jbd2_journal_unreserve_handle() called from
> > jbd2_journal_stop(). However this function forgets to remove reserved
> > credits from transaction->t_outstanding_credits and thus the transaction
> > space that was reserved remains effectively leaked. The leaked
> > transaction space can be quite significant in some cases and leads to
> > unnecessarily small transactions and thus reducing throughput of the
> > journalling machinery. E.g. fsmark workload creating lots of 4k files
> > was observed to have about 20% lower throughput due to this when ext4 is
> > mounted with dioread_nolock mount option.
> > 
> > Subtract reserved credits from t_outstanding_credits as well.
> > 
> > CC: stable@vger.kernel.org
> > Fixes: 8f7d89f36829 ("jbd2: transaction reservation support")
> > Signed-off-by: Jan Kara <jack@suse.cz>
> 
> Patch looks reasonable, with one minor nit below.
> 
> Reviewed-by: Andreas Dilger <adilger@dilger.ca>

Thanks!


> > @@ -721,8 +728,10 @@ static void stop_this_handle(handle_t *handle)
> > 	}
> > 	atomic_sub(handle->h_total_credits,
> > 		   &transaction->t_outstanding_credits);
> > -	if (handle->h_rsv_handle)
> > -		__jbd2_journal_unreserve_handle(handle->h_rsv_handle);
> > +	if (handle->h_rsv_handle) {
> > +		__jbd2_journal_unreserve_handle(handle->h_rsv_handle,
> > +						transaction);
> > +	}
> 
> There isn't any need for braces {} around this one-line if-block.

Yeah, I'm always undecided about this. I agree that in this case the code
wouldn't be any less readable without the braces. So I'll remove them and
resend with your tag.

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
