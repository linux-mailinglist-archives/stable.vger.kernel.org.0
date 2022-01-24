Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 86834498883
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 19:42:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235972AbiAXSmh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 13:42:37 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:46482 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229862AbiAXSmg (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 13:42:36 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7E450B81213
        for <stable@vger.kernel.org>; Mon, 24 Jan 2022 18:42:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A7203C340E5;
        Mon, 24 Jan 2022 18:42:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643049754;
        bh=d3ND7f4WCxJaCg/TO8FI9oztxrVPR7MqQFT/QBvgm5o=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=d8a/ynugKIZqIKGxbMfboQRFJwaZg/3oc+Gg48jfpcqWlZQ0vZuNy+kDNHtBHidNM
         s/jIn+/hPBHdHDRzPhbpy+MOxkJ7EQvSqwZfUJEliD4AgAhH9oY6wMMtQv9z3PvNrC
         rkzSQOydka01TXIZ0htcu0sd73CST4Etpr1PMexU=
Date:   Mon, 24 Jan 2022 19:27:35 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Ben Hutchings <ben@decadent.org.uk>
Cc:     stable@vger.kernel.org,
        Michael Wakabayashi <mwakabayashi@vmware.com>,
        Trond Myklebust <trond.myklebust@hammerspace.com>
Subject: Re: [PATCH 4.14] NFSv4: Initialise connection to the server in
 nfs4_alloc_client()
Message-ID: <Ye7vl/KZArHHJTYU@kroah.com>
References: <Ye7T+vLMFpwBFsRW@decadent.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Ye7T+vLMFpwBFsRW@decadent.org.uk>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jan 24, 2022 at 05:29:46PM +0100, Ben Hutchings wrote:
> From: Trond Myklebust <trond.myklebust@hammerspace.com>
> 
> commit dd99e9f98fbf423ff6d365b37a98e8879170f17c upstream.
> 
> Set up the connection to the NFSv4 server in nfs4_alloc_client(), before
> we've added the struct nfs_client to the net-namespace's nfs_client_list
> so that a downed server won't cause other mounts to hang in the trunking
> detection code.
> 
> Reported-by: Michael Wakabayashi <mwakabayashi@vmware.com>
> Fixes: 5c6e5b60aae4 ("NFS: Fix an Oops in the pNFS files and flexfiles connection setup to the DS")
> Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
> [bwh: Backported to 4.14: adjust context]
> Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
> ---
>  fs/nfs/nfs4client.c | 82 +++++++++++++++++++++++----------------------
>  1 file changed, 42 insertions(+), 40 deletions(-)

Now queued up, thanks.

greg k-h
