Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F0CEA1AB4DA
	for <lists+stable@lfdr.de>; Thu, 16 Apr 2020 02:42:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404677AbgDPAl5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Apr 2020 20:41:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:39016 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404556AbgDPAl4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 15 Apr 2020 20:41:56 -0400
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 68860206D9;
        Thu, 16 Apr 2020 00:41:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1586997715;
        bh=I47Y2hzECAl1SkiDnSaDX4HY+1SJMXL4uAMQcn672SQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=XHnHQdL7Ipdfkv9NkV8b+zo1+H/uMY5rZQt3vomRVAUmb8mZR+C0Hwsph2Ysy4uXB
         LW+N0/MQ6pa74Wl2KAA2rcKiho0WJfaNgWR+eIXwm5NcV7Bl6mLq7HOEZnpHCwLhoM
         HQEeGQKmqIe9VoJRO8S0pv87sdmG+VBQ+gtJKYow=
Date:   Wed, 15 Apr 2020 20:41:54 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     gregkh@linuxfoundation.org
Cc:     josef@toxicpanda.com, dsterba@suse.com, johannes.thumshirn@wdc.com,
        nborisov@suse.com, wqu@suse.com, stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] btrfs: handle logged extent failure
 properly" failed to apply to 5.6-stable tree
Message-ID: <20200416004154.GN1068@sasha-vm>
References: <158687410512288@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <158687410512288@kroah.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Apr 14, 2020 at 04:21:45PM +0200, gregkh@linuxfoundation.org wrote:
>
>The patch below does not apply to the 5.6-stable tree.
>If someone wants it applied there, or to any other stable or longterm
>tree, then please email the backport, including the original git commit
>id to <stable@vger.kernel.org>.
>
>thanks,
>
>greg k-h
>
>------------------ original commit in Linus's tree ------------------
>
>From ab9b2c7b32e6be53cac2e23f5b2db66815a7d972 Mon Sep 17 00:00:00 2001
>From: Josef Bacik <josef@toxicpanda.com>
>Date: Thu, 13 Feb 2020 10:47:30 -0500
>Subject: [PATCH] btrfs: handle logged extent failure properly
>
>If we're allocating a logged extent we attempt to insert an extent
>record for the file extent directly.  We increase
>space_info->bytes_reserved, because the extent entry addition will call
>btrfs_update_block_group(), which will convert the ->bytes_reserved to
>->bytes_used.  However if we fail at any point while inserting the
>extent entry we will bail and leave space on ->bytes_reserved, which
>will trigger a WARN_ON() on umount.  Fix this by pinning the space if we
>fail to insert, which is what happens in every other failure case that
>involves adding the extent entry.
>
>CC: stable@vger.kernel.org # 5.4+
>Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
>Reviewed-by: Nikolay Borisov <nborisov@suse.com>
>Reviewed-by: Qu Wenruo <wqu@suse.com>
>Signed-off-by: Josef Bacik <josef@toxicpanda.com>
>Reviewed-by: David Sterba <dsterba@suse.com>
>Signed-off-by: David Sterba <dsterba@suse.com>

Greg, I've noticed that you've fixed it up for 5.5 and 5.4 but no for
5.6? I've queued it up for 5.6 as well.

-- 
Thanks,
Sasha
