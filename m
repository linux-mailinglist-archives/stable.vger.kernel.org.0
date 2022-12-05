Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B0E23642921
	for <lists+stable@lfdr.de>; Mon,  5 Dec 2022 14:17:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232143AbiLENRf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Dec 2022 08:17:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41170 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232130AbiLENRb (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 5 Dec 2022 08:17:31 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 485291BEA8
        for <stable@vger.kernel.org>; Mon,  5 Dec 2022 05:16:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1670246190;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=eWVatloVfsLfuW7cRwzXXvxk65nGwMhmOiyvZy6kuoA=;
        b=borxP+nd5SZ5il+9xkQ5hmMiGlxAhmEQl1FP0ryDo/Fxfqie8W1e6SJtozReOwWw8ZaDes
        prI5V0YfFt2BZ1B0OYxS3ml6Ae1Da6upE5mUfzH+VOReHIZO58eAmOiGmsji56bIHl0VUD
        fSoDIcR64ym48jhia7YfEah643R5K20=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-168-gyXmo0YMNWOjucBUahmDIA-1; Mon, 05 Dec 2022 08:16:27 -0500
X-MC-Unique: gyXmo0YMNWOjucBUahmDIA-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id DFDDA185A79C;
        Mon,  5 Dec 2022 13:16:26 +0000 (UTC)
Received: from T590 (ovpn-8-24.pek2.redhat.com [10.72.8.24])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 506E9492B09;
        Mon,  5 Dec 2022 13:16:21 +0000 (UTC)
Date:   Mon, 5 Dec 2022 21:16:16 +0800
From:   Ming Lei <ming.lei@redhat.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        linux-block@vger.kernel.org, cuishw@inspur.com,
        Christoph Hellwig <hch@lst.de>, Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 5.10.y stable] block: unhash blkdev part inode when the
 part is deleted
Message-ID: <Y43vIJGZhSGMDlXr@T590>
References: <20221205122502.841896-1-ming.lei@redhat.com>
 <Y43lHGHDHkAERvJb@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y43lHGHDHkAERvJb@kroah.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.10
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Dec 05, 2022 at 01:33:32PM +0100, Greg Kroah-Hartman wrote:
> On Mon, Dec 05, 2022 at 08:25:02PM +0800, Ming Lei wrote:
> > v5.11 changes the blkdev lookup mechanism completely since commit
> > 22ae8ce8b892 ("block: simplify bdev/disk lookup in blkdev_get"),
> > and small part of the change is to unhash part bdev inode when
> > deleting partition. Turns out this kind of change does fix one
> > nasty issue in case of BLOCK_EXT_MAJOR:
> > 
> > 1) when one partition is deleted & closed, disk_put_part() is always
> > called before bdput(bdev), see blkdev_put(); so the part's devt can
> > be freed & re-used before the inode is dropped
> > 
> > 2) then new partition with same devt can be created just before the
> > inode in 1) is dropped, then the old inode/bdev structurein 1) is
> > re-used for this new partition, this way causes use-after-free and
> > kernel panic.
> > 
> > It isn't possible to backport the whole fbig patchset of "merge struct
> 
> "fbig"?

OK, will fix it in v2.

> 
> > block_device and struct hd_struct v4" for addressing this issue.
> > 
> > https://lore.kernel.org/linux-block/20201128161510.347752-1-hch@lst.de/
> > 
> > So fixes it by unhashing part bdev in delete_partition(), and this way
> > is actually aligned with v5.11+'s behavior.
> > 
> > Reported-by: cuishw@inspur.com
> > Tested-by: cuishw@inspur.com
> 
> We need a real name and this in a proper format as well (<>)

cuishw, care to share us your name? :-)

> 
> > Cc: Christoph Hellwig <hch@lst.de>
> > Cc: Jan Kara <jack@suse.cz>
> > Signed-off-by: Ming Lei <ming.lei@redhat.com>
> 
> What about for kernels older than 5.10?

All -stable kernels older should need this kind of fix. If this
patch is acked, I can backport to other -stable kernels.


Thanks,
Ming

