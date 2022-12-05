Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 76C8F642D1D
	for <lists+stable@lfdr.de>; Mon,  5 Dec 2022 17:38:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232383AbiLEQiy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Dec 2022 11:38:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34614 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232676AbiLEQi0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 5 Dec 2022 11:38:26 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D78B20F54;
        Mon,  5 Dec 2022 08:36:52 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 9BF54CE0EDA;
        Mon,  5 Dec 2022 16:36:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 89511C433D6;
        Mon,  5 Dec 2022 16:36:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1670258206;
        bh=fbpcwdKaJc7AJTNyA9TDEKsFnJyGmmESF0Wd/ZFzdbI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Kh583MNyjgC8duE4cNwoW6/cRGCCa4/0sjHjB9ls5BYonNjN0x1V20qj3usHKybqK
         O7iHhhkkqNdd5sgIbS06TLzofkIX+yW9e24EjFGdfbAjrQl1+JT0KQb9VXNjlQGG1S
         mc4pUBDKzu6gSU+rgriGXEwraHrc7CzK+wjxj3rA=
Date:   Mon, 5 Dec 2022 17:36:44 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Ming Lei <ming.lei@redhat.com>, stable@vger.kernel.org,
        linux-block@vger.kernel.org, Shiwei Cui <cuishw@inspur.com>,
        Christoph Hellwig <hch@lst.de>, Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 5.10.y stable v2] block: unhash blkdev part inode when
 the part is deleted
Message-ID: <Y44eHHkdnOoLfHMw@kroah.com>
References: <20221205132739.844399-1-ming.lei@redhat.com>
 <Y44JWBw9opr2HVyN@kroah.com>
 <50de97fe-43f1-188f-511a-f29611944ce7@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <50de97fe-43f1-188f-511a-f29611944ce7@kernel.dk>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Dec 05, 2022 at 08:19:23AM -0700, Jens Axboe wrote:
> On 12/5/22 8:08 AM, Greg Kroah-Hartman wrote:
> > On Mon, Dec 05, 2022 at 09:27:39PM +0800, Ming Lei wrote:
> >> v5.11 changes the blkdev lookup mechanism completely since commit
> >> 22ae8ce8b892 ("block: simplify bdev/disk lookup in blkdev_get"),
> >> and small part of the change is to unhash part bdev inode when
> >> deleting partition. Turns out this kind of change does fix one
> >> nasty issue in case of BLOCK_EXT_MAJOR:
> >>
> >> 1) when one partition is deleted & closed, disk_put_part() is always
> >> called before bdput(bdev), see blkdev_put(); so the part's devt can
> >> be freed & re-used before the inode is dropped
> >>
> >> 2) then new partition with same devt can be created just before the
> >> inode in 1) is dropped, then the old inode/bdev structurein 1) is
> >> re-used for this new partition, this way causes use-after-free and
> >> kernel panic.
> >>
> >> It isn't possible to backport the whole big patchset of "merge struct
> >> block_device and struct hd_struct v4" for addressing this issue.
> >>
> >> https://lore.kernel.org/linux-block/20201128161510.347752-1-hch@lst.de/
> >>
> >> So fixes it by unhashing part bdev in delete_partition(), and this way
> >> is actually aligned with v5.11+'s behavior.
> >>
> >> Reported-by: Shiwei Cui <cuishw@inspur.com>
> >> Tested-by: Shiwei Cui <cuishw@inspur.com>
> >> Cc: Christoph Hellwig <hch@lst.de>
> >> Cc: Jan Kara <jack@suse.cz>
> >> Signed-off-by: Ming Lei <ming.lei@redhat.com>
> >> ---
> >> V2:
> >> 	- fix one typo and Shiwei's email format
> >>
> >>  block/partitions/core.c | 7 +++++++
> > 
> > I need an ack from the block maintainers/developers to be able to take
> > this.
> 
> Acked-by: Jens Axboe <axboe@kernel.dk>

Thanks, now queued up for 5.10.y

greg k-h
