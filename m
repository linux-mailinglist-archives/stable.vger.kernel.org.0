Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9000116BE81
	for <lists+stable@lfdr.de>; Tue, 25 Feb 2020 11:21:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728958AbgBYKVH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 25 Feb 2020 05:21:07 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:49228 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1729941AbgBYKVH (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 25 Feb 2020 05:21:07 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1582626066;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=HTDduFhSgGyXI8Pt5AT3Pqq77oijGM+3E0am3scvXRw=;
        b=E29bK7pZ97TLCjmiiLN8v+Xzdd1DzL+s9DLTKkEYmeQ/fpahoAnu3g9Cr0v4P/UYptZI1R
        i6TAbOi73EOe4ypBz0me/DxojLopmBurX/5YOrLzEzPcFQ31r2GjXgemQvW03nKH7gE4+p
        5NLfVVlJ3DtUJg1gGKkE/2af7MjKc6U=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-83-ywIDTBTWNM6D9v8QavJvlg-1; Tue, 25 Feb 2020 05:20:57 -0500
X-MC-Unique: ywIDTBTWNM6D9v8QavJvlg-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id D2B6080272E;
        Tue, 25 Feb 2020 10:20:55 +0000 (UTC)
Received: from ming.t460p (ovpn-8-31.pek2.redhat.com [10.72.8.31])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id EEAF81001B2D;
        Tue, 25 Feb 2020 10:20:49 +0000 (UTC)
Date:   Tue, 25 Feb 2020 18:20:45 +0800
From:   Ming Lei <ming.lei@redhat.com>
To:     Jan Kara <jack@suse.cz>
Cc:     Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org,
        tristmd@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH] blktrace: Protect q->blk_trace with RCU
Message-ID: <20200225102045.GB1771@ming.t460p>
References: <20200206142812.25989-1-jack@suse.cz>
 <20200219125947.GA29390@quack2.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200219125947.GA29390@quack2.suse.cz>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Feb 19, 2020 at 01:59:47PM +0100, Jan Kara wrote:
> On Thu 06-02-20 15:28:12, Jan Kara wrote:
> > KASAN is reporting that __blk_add_trace() has a use-after-free issue
> > when accessing q->blk_trace. Indeed the switching of block tracing (and
> > thus eventual freeing of q->blk_trace) is completely unsynchronized with
> > the currently running tracing and thus it can happen that the blk_trace
> > structure is being freed just while __blk_add_trace() works on it.
> > Protect accesses to q->blk_trace by RCU during tracing and make sure we
> > wait for the end of RCU grace period when shutting down tracing. Luckily
> > that is rare enough event that we can afford that. Note that postponing
> > the freeing of blk_trace to an RCU callback should better be avoided as
> > it could have unexpected user visible side-effects as debugfs files
> > would be still existing for a short while block tracing has been shut
> > down.
> > 
> > Link: https://bugzilla.kernel.org/show_bug.cgi?id=205711
> > CC: stable@vger.kernel.org
> > Reported-by: Tristan <tristmd@gmail.com>
> > Signed-off-by: Jan Kara <jack@suse.cz>
> 
> Jens, do you plan to pick up the patch? Also the reporter asked me to
> update the reference as:
> 
> Reported-by: Tristan Madani <tristmd@gmail.com>
> 
> Should I resend the patch with this update & reviewed-by's or will you fix
> it up on commit? Thanks.
> 

I have run concurrent quick/repeated blktrace & long-time heavy IO, looks
this patch just works fine, so:

Tested-by: Ming Lei <ming.lei@redhat.com>

Jens, any chance to take a look at this CVE issue?

Thanks,
Ming

