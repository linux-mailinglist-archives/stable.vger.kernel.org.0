Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 905516EB9F8
	for <lists+stable@lfdr.de>; Sat, 22 Apr 2023 17:20:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229697AbjDVPUX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 22 Apr 2023 11:20:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37240 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229596AbjDVPUW (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 22 Apr 2023 11:20:22 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E089109;
        Sat, 22 Apr 2023 08:20:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 293E060B5C;
        Sat, 22 Apr 2023 15:20:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 35A64C433D2;
        Sat, 22 Apr 2023 15:20:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1682176820;
        bh=FOlJkgGZ6G9M2l1cmZWwgB09X0NECDhBxKDOoN1YeKY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=mwEVLSSWgkyOfrArixzsjSos+5edUsLutV3BoVzpawMwJD9LrVthRPDNkBc2bymWE
         JBbdLI7Eho1kg70dvQSRQFe1tMDXihSZ22vkGIIrK/BFO7WUkyBkG38882kGgXUa0N
         Y9Tz5UZMif2yDZYrq0oq5uFQjqYyGoUS/c559yKI=
Date:   Sat, 22 Apr 2023 17:20:17 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Amir Goldstein <amir73il@gmail.com>
Cc:     Sasha Levin <sashal@kernel.org>,
        Chandan Babu R <chandan.babu@oracle.com>,
        "Darrick J . Wong" <djwong@kernel.org>,
        Leah Rumancik <leah.rumancik@gmail.com>,
        linux-xfs@vger.kernel.org, stable@vger.kernel.org,
        Brian Foster <bfoster@redhat.com>,
        Christoph Hellwig <hch@lst.de>,
        Christian Theune <ct@flyingcircus.io>
Subject: Re: [PATCH 5.10] xfs: drop submit side trans alloc for append ioends
Message-ID: <2023042211-harmonica-ecology-a31b@gregkh>
References: <20230419161813.2044576-1-amir73il@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230419161813.2044576-1-amir73il@gmail.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Apr 19, 2023 at 07:18:13PM +0300, Amir Goldstein wrote:
> From: Brian Foster <bfoster@redhat.com>
> 
> commit 7cd3099f4925d7c15887d1940ebd65acd66100f5 upstream.
> 
> Per-inode ioend completion batching has a log reservation deadlock
> vector between preallocated append transactions and transactions
> that are acquired at completion time for other purposes (i.e.,
> unwritten extent conversion or COW fork remaps). For example, if the
> ioend completion workqueue task executes on a batch of ioends that
> are sorted such that an append ioend sits at the tail, it's possible
> for the outstanding append transaction reservation to block
> allocation of transactions required to process preceding ioends in
> the list.
> 
> Append ioend completion is historically the common path for on-disk
> inode size updates. While file extending writes may have completed
> sometime earlier, the on-disk inode size is only updated after
> successful writeback completion. These transactions are preallocated
> serially from writeback context to mitigate concurrency and
> associated log reservation pressure across completions processed by
> multi-threaded workqueue tasks.
> 
> However, now that delalloc blocks unconditionally map to unwritten
> extents at physical block allocation time, size updates via append
> ioends are relatively rare. This means that inode size updates most
> commonly occur as part of the preexisting completion time
> transaction to convert unwritten extents. As a result, there is no
> longer a strong need to preallocate size update transactions.
> 
> Remove the preallocation of inode size update transactions to avoid
> the ioend completion processing log reservation deadlock. Instead,
> continue to send all potential size extending ioends to workqueue
> context for completion and allocate the transaction from that
> context. This ensures that no outstanding log reservation is owned
> by the ioend completion worker task when it begins to process
> ioends.
> 
> Signed-off-by: Brian Foster <bfoster@redhat.com>
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> Reviewed-by: Darrick J. Wong <djwong@kernel.org>
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> Reported-by: Christian Theune <ct@flyingcircus.io>
> Link: https://lore.kernel.org/linux-xfs/CAOQ4uxjj2UqA0h4Y31NbmpHksMhVrXfXjLG4Tnz3zq_UR-3gSA@mail.gmail.com/
> Signed-off-by: Amir Goldstein <amir73il@gmail.com>
> Acked-by: Darrick J. Wong <djwong@kernel.org>
> ---
> 
> Greg,
> 
> One more fix from v5.13 that I missed from my backports.

Now queued up, thanks.

greg k-h
