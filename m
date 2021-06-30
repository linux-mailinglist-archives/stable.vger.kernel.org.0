Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1477A3B8924
	for <lists+stable@lfdr.de>; Wed, 30 Jun 2021 21:27:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233690AbhF3TaX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 30 Jun 2021 15:30:23 -0400
Received: from smtp-out2.suse.de ([195.135.220.29]:36462 "EHLO
        smtp-out2.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233679AbhF3TaW (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 30 Jun 2021 15:30:22 -0400
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out2.suse.de (Postfix) with ESMTP id A0A9A1FEF3;
        Wed, 30 Jun 2021 19:27:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1625081272;
        h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
         cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=N2CVyFvWX8NyaeNckyr/gysZjg/caGEbfcMb0bAjW0U=;
        b=zdVj3NTn4A7mS9zskk5mNdlpBHEwclMmyJL3HoHCoNS7PkuQH/mzlh+thC/7T/EN8lK4n4
        uL7+lus5siXR1ZrEocJx+Nolxlc2OWDzkKJ0XAygAq41/skYmlJCHNSme+vgzQ+N0IgnrN
        gv+fL1fdAWUN4+bQ6+eKji1qNUGpzqw=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1625081272;
        h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
         cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=N2CVyFvWX8NyaeNckyr/gysZjg/caGEbfcMb0bAjW0U=;
        b=qcGEB25H9Oc09tsn3eyVF+atWRvaPo1UyabCRS4AP+UTMUO7liBGeBRcE+9hKPfXohvUCa
        kuPhqQMHmydDS6AA==
Received: from ds.suse.cz (ds.suse.cz [10.100.12.205])
        by relay2.suse.de (Postfix) with ESMTP id 6FE75A3B88;
        Wed, 30 Jun 2021 19:27:52 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 51A9BDA6FD; Wed, 30 Jun 2021 21:25:22 +0200 (CEST)
Date:   Wed, 30 Jun 2021 21:25:22 +0200
From:   David Sterba <dsterba@suse.cz>
To:     Naohiro Aota <naohiro.aota@wdc.com>
Cc:     linux-btrfs@vger.kernel.org, David Sterba <dsterba@suse.com>,
        stable@vger.kernel.org, Damien Le Moal <damien.lemoal@wdc.com>,
        Johannes Thumshirn <johannes.thumshirn@wdc.com>
Subject: Re: [PATCH] btrfs: properly split extent_map for REQ_OP_ZONE_APPEND
Message-ID: <20210630192522.GT2610@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Naohiro Aota <naohiro.aota@wdc.com>,
        linux-btrfs@vger.kernel.org, David Sterba <dsterba@suse.com>,
        stable@vger.kernel.org, Damien Le Moal <damien.lemoal@wdc.com>,
        Johannes Thumshirn <johannes.thumshirn@wdc.com>
References: <20210628085728.2813793-1-naohiro.aota@wdc.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210628085728.2813793-1-naohiro.aota@wdc.com>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jun 28, 2021 at 05:57:28PM +0900, Naohiro Aota wrote:
> Damien reported a test failure with btrfs/209. The test itself ran fine,
> but the fsck run afterwards reported a corrupted filesystem.
> 
> The filesystem corruption happens because we're splitting an extent and
> then writing the extent twice. We have to split the extent though, because
> we're creating too large extents for a REQ_OP_ZONE_APPEND operation.
> 
> When dumping the extent tree, we can see two EXTENT_ITEMs at the same
> start address but different lengths.
> 
> $ btrfs inspect dump-tree /dev/nullb1 -t extent
> ...
>    item 19 key (269484032 EXTENT_ITEM 126976) itemoff 15470 itemsize 53
>            refs 1 gen 7 flags DATA
>            extent data backref root FS_TREE objectid 257 offset 786432 count 1
>    item 20 key (269484032 EXTENT_ITEM 262144) itemoff 15417 itemsize 53
>            refs 1 gen 7 flags DATA
>            extent data backref root FS_TREE objectid 257 offset 786432 count 1
> 
> The duplicated EXTENT_ITEMs originally come from wrongly split extent_map in
> extract_ordered_extent(). Since extract_ordered_extent() uses
> create_io_em() to split an existing extent_map, we will have
> split->orig_start != split->start. Then, it will be logged with non-zero
> "extent data offset". Finally, the logged entries are replayed into
> a duplicated EXTENT_ITEM.
> 
> Introduce and use proper splitting function for extent_map. The function is
> intended to be simple and specific usage for extract_ordered_extent() e.g.
> not supporting compression case (we do not allow splitting compressed
> extent_map anyway).
> 
> Fixes: d22002fd37bd ("btrfs: zoned: split ordered extent when bio is sent")
> Cc: stable@vger.kernel.org # 5.12+
> Reported-by: Damien Le Moal <damien.lemoal@wdc.com>
> Cc: Johannes Thumshirn <johannes.thumshirn@wdc.com>
> Signed-off-by: Naohiro Aota <naohiro.aota@wdc.com>

Added to a topic branch, I think I've hit the problem this patch is
supposed to fix so I'll to reproduce it before adding it to misc-next.
I've added Daminen's answer to the changelog as it's really helpful to
understand why it's fixed that way.
