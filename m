Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6CD6A6B9E27
	for <lists+stable@lfdr.de>; Tue, 14 Mar 2023 19:20:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229815AbjCNSUa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Mar 2023 14:20:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48582 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229616AbjCNSU3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 14 Mar 2023 14:20:29 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 80DCC8F517;
        Tue, 14 Mar 2023 11:20:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1E5A061865;
        Tue, 14 Mar 2023 18:20:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A942C433D2;
        Tue, 14 Mar 2023 18:20:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678818016;
        bh=JlqsKonhMEf6gDtyf8JSKNHgwCqX/wnttVAxy2Tn+Fo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=WDGz1vGDDgF4rzmWdJv5wdNXKUfoYvGsIfWgPilF1aP8uHXhl25g5lWh2gJuHW9P+
         Ikb/Dn/0laagNxWb+Lq1ySsMSicg67leVjXhSfjUDbtQ3hpr4OIwRTOjWL7A48PhZk
         p/0fDukzp6M1GGwexjV9gZFm62s5slHmCMFkUqItrw9ToxyxWoLD1cA8ApWyWFzCYi
         CMpLL8Fc+TzgBWDJaO1l8sl+kDjictSYNhhkOrxfvR6T3OqzeUjxuekvjSvkhdocXU
         thg/dtTy46k6YHye2NC16GaXKV4CfIuYJlt1McaMl3Q0/gPNszUCjpRec6ogDljpx7
         K/HengPnYYtyA==
Date:   Tue, 14 Mar 2023 11:20:14 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     Nathan Huckleberry <nhuck@google.com>
Cc:     linux-block@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        linux-fscrypt@vger.kernel.org, stable@vger.kernel.org,
        Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH v2 1/4] blk-mq: release crypto keyslot before reporting
 I/O complete
Message-ID: <ZBC63ry7EFMr+Xzk@sol.localdomain>
References: <20230308193645.114069-1-ebiggers@kernel.org>
 <20230308193645.114069-2-ebiggers@kernel.org>
 <CAJkfWY76-fUf92YZid3bOPrufXwCzM-q9L1ezqkLZ+WJiWL3jQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJkfWY76-fUf92YZid3bOPrufXwCzM-q9L1ezqkLZ+WJiWL3jQ@mail.gmail.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Mar 13, 2023 at 02:26:00PM -0700, Nathan Huckleberry wrote:
> > diff --git a/block/blk-merge.c b/block/blk-merge.c
> > index 6460abdb2426..65e75efa9bd3 100644
> > --- a/block/blk-merge.c
> > +++ b/block/blk-merge.c
> > @@ -867,6 +867,8 @@ static struct request *attempt_merge(struct request_queue *q,
> >         if (!blk_discard_mergable(req))
> >                 elv_merge_requests(q, req, next);
> >
> > +       blk_crypto_rq_put_keyslot(next);
> > +
> 
> This looks good to me, but it looks like there was a pre-existing bug
> in the blk-merge code. The elv_merged_request function is only called
> when the request does not merge. Does anyone know if that behavior is
> correct?

That's very confusing to me too!

I did notice that attempt_merge() calls elv_merge_requests() (not to be confused
with elv_merged_request()) if it merges the requests.

So it seems there is elv_merge_requests() which means the request was merged,
and elv_merged_request() which means the request was *not* merged...  I have no
idea what is going on there :-(
	
> This patch itself looks good to me.
> 
> Reviewed-by: Nathan Huckleberry <nhuck@google.com>

Thanks.

Jens, Christoph, etc., anyone else want to take a look too?

- Eric
