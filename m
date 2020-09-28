Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CC65A27B403
	for <lists+stable@lfdr.de>; Mon, 28 Sep 2020 20:03:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726578AbgI1SDj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Sep 2020 14:03:39 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:21184 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726562AbgI1SDj (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 28 Sep 2020 14:03:39 -0400
Dkim-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1601316217;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=9QdrK73XoL/ToqhLhrQZEkhU3f0W1jMYZP75p9zkGh0=;
        b=cU2w3SnDkAiIgckcAYJCmDmIt6Zs3tQzjCzrbsoMMPT6crDeiGwt0z/7yHKk6zZdb/nbOF
        WprXt3U9GUkax7cjg2VrzDu0Tf7dQxtWFlTPqIxxAKWAg4r4CVzoK8OhYE4psSOGFhTKJy
        DXt9Ypx8lAWIXFNdDh1lW3AmqKoRkKo=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-107-gqBqamAQNc2DoMY2wlVrkg-1; Mon, 28 Sep 2020 14:03:34 -0400
X-MC-Unique: gqBqamAQNc2DoMY2wlVrkg-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 77A1F1018F64;
        Mon, 28 Sep 2020 18:03:33 +0000 (UTC)
Received: from localhost (unknown [10.18.25.174])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id E9B5D3782;
        Mon, 28 Sep 2020 18:03:26 +0000 (UTC)
Date:   Mon, 28 Sep 2020 14:03:26 -0400
From:   Mike Snitzer <snitzer@redhat.com>
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     ming.lei@redhat.com, stable@vger.kernel.org
Subject: Re: [PATCH 5.4, 5.8] dm: fix bio splitting and its bio completion
 order for regular IO
Message-ID: <20200928180325.GA23926@redhat.com>
References: <1601301410240130@kroah.com>
 <20200928152941.GA66303@lobo>
 <20200928173144.GA2042505@kroah.com>
 <20200928175229.GA2202997@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200928175229.GA2202997@kroah.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Sep 28 2020 at  1:52pm -0400,
Greg KH <gregkh@linuxfoundation.org> wrote:

> On Mon, Sep 28, 2020 at 07:31:44PM +0200, Greg KH wrote:
> > On Mon, Sep 28, 2020 at 11:29:41AM -0400, Mike Snitzer wrote:
> > > This backport applies (with mild offset) to both v5.4.67 and v5.8.11:
> > > 
> > > >From ee1dfad5325ff1cfb2239e564cd411b3bfe8667a Mon Sep 17 00:00:00 2001
> > > From: Mike Snitzer <snitzer@redhat.com>
> > > Date: Mon, 14 Sep 2020 13:04:19 -0400
> > > Subject: [PATCH] dm: fix bio splitting and its bio completion order for regular IO
> > > 
> > > dm_queue_split() is removed because __split_and_process_bio() _must_
> > > handle splitting bios to ensure proper bio submission and completion
> > > ordering as a bio is split.
> > > 
> > > Otherwise, multiple recursive calls to ->submit_bio will cause multiple
> > > split bios to be allocated from the same ->bio_split mempool at the same
> > > time. This would result in deadlock in low memory conditions because no
> > > progress could be made (only one bio is available in ->bio_split
> > > mempool).
> > > 
> > > This fix has been verified to still fix the loss of performance, due
> > > to excess splitting, that commit 120c9257f5f1 provided.
> > > 
> > > Fixes: 120c9257f5f1 ("Revert "dm: always call blk_queue_split() in dm_process_bio()"")
> > > Cc: stable@vger.kernel.org # 5.0+, requires custom backport due to 5.9 changes
> > > Reported-by: Ming Lei <ming.lei@redhat.com>
> > > Signed-off-by: Mike Snitzer <snitzer@redhat.com>
> > 
> > What is the git id of this patch in Linus's tree?
> 
> I dug it up:
> 	ee1dfad5325f ("dm: fix bio splitting and its bio completion order for regular IO")

I thought this line was adequate in my original email:
"From ee1dfad5325ff1cfb2239e564cd411b3bfe8667a Mon Sep 17 00:00:00 2001"

Maybe it was too subtle?  For future knowledge, how would you like to
see the git id of Linus's tree referenced?

Thanks,
Mike

