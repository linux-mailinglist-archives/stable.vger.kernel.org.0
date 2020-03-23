Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0236B18FBB9
	for <lists+stable@lfdr.de>; Mon, 23 Mar 2020 18:44:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726769AbgCWRoT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 Mar 2020 13:44:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:58406 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725897AbgCWRoT (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 23 Mar 2020 13:44:19 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4347E20658;
        Mon, 23 Mar 2020 17:44:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1584985458;
        bh=XQjoDy6PYCRUu9ofiCpIWxXqMRknSqr1H7msslKyxNM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=B7hg9W635wmfS3CQsURJCl7t3KcuKRx2zD2xlEqLqXpg4ZmxL4etjTkEjgC92q/Ke
         ipCfYgPqOE8vWyIhRPBY7Y0mk58x9uwQIllwRQl/h9kVTUrQ3hRZr0Pl6fz9N6zKBa
         tqdWkWd6TnAm/fupSP2YZwZ6JqxE+Zed5BbxgIRM=
Date:   Mon, 23 Mar 2020 18:44:16 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Sasha Levin <sashal@kernel.org>
Cc:     fdmanana@suse.com, dsterba@suse.com, stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] btrfs: fix log context list corruption
 after rename whiteout" failed to apply to 4.14-stable tree
Message-ID: <20200323174416.GA590267@kroah.com>
References: <1584974582132143@kroah.com>
 <20200323164458.GY4189@sasha-vm>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200323164458.GY4189@sasha-vm>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Mar 23, 2020 at 12:44:58PM -0400, Sasha Levin wrote:
> On Mon, Mar 23, 2020 at 03:43:02PM +0100, gregkh@linuxfoundation.org wrote:
> > 
> > The patch below does not apply to the 4.14-stable tree.
> > If someone wants it applied there, or to any other stable or longterm
> > tree, then please email the backport, including the original git commit
> > id to <stable@vger.kernel.org>.
> > 
> > thanks,
> > 
> > greg k-h
> > 
> > ------------------ original commit in Linus's tree ------------------
> > 
> > > From 236ebc20d9afc5e9ff52f3cf3f365a91583aac10 Mon Sep 17 00:00:00 2001
> > From: Filipe Manana <fdmanana@suse.com>
> > Date: Tue, 10 Mar 2020 12:13:53 +0000
> > Subject: [PATCH] btrfs: fix log context list corruption after rename whiteout
> > error
> > 
> > During a rename whiteout, if btrfs_whiteout_for_rename() returns an error
> > we can end up returning from btrfs_rename() with the log context object
> > still in the root's log context list - this happens if 'sync_log' was
> > set to true before we called btrfs_whiteout_for_rename() and it is
> > dangerous because we end up with a corrupt linked list (root->log_ctxs)
> > as the log context object was allocated on the stack.
> > 
> > After btrfs_rename() returns, any task that is running btrfs_sync_log()
> > concurrently can end up crashing because that linked list is traversed by
> > btrfs_sync_log() (through btrfs_remove_all_log_ctxs()). That results in
> > the same issue that commit e6c617102c7e4 ("Btrfs: fix log context list
> > corruption after rename exchange operation") fixed.
> > 
> > Fixes: d4682ba03ef618 ("Btrfs: sync log after logging new name")
> > CC: stable@vger.kernel.org # 4.19+
> > Signed-off-by: Filipe Manana <fdmanana@suse.com>
> > Signed-off-by: David Sterba <dsterba@suse.com>
> 
> Greg, I'm not sure why you tried this for 4.14 - it's tagged 4.19+ and
> we don't have d4682ba03ef618 in 4.14 either.

Ah, I thought this was backported, as "simple" grep shows it showing up
in 4.14.110, but that was just a reference to the short git commit id.

I need to fix my scripts to always expand it to the full sha1 to prevent
that from catching.

thanks,

greg k-h
