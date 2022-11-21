Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 11D056321A9
	for <lists+stable@lfdr.de>; Mon, 21 Nov 2022 13:13:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229721AbiKUMNN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Nov 2022 07:13:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38622 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229379AbiKUMNM (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 21 Nov 2022 07:13:12 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 60DF21115;
        Mon, 21 Nov 2022 04:13:11 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 13315B80EFE;
        Mon, 21 Nov 2022 12:13:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D749AC433C1;
        Mon, 21 Nov 2022 12:13:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1669032788;
        bh=qUtGcuYmIfeTOG3iARX2bU9HeQuwvEPW3WZGDkOzAcs=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=MDzjrSWKjIo3x5E2+J+cWppNsLYn9v+QAQ0mdfoKHH5V3E1eUahpfZ3JLBMB2Jg8N
         8ghmjfN91iQh4FG7w0X7gKxoiEaq2mTIZaQkSY+/mLhD6FSykokgHA1MQ7JN5cxFsi
         J4nmGdTvoyePcr0bmz2x/KhI6hGmBTPu4JN6Q9Tg=
Date:   Mon, 21 Nov 2022 13:13:04 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Chandan Babu R <chandan.babu@oracle.com>
Cc:     sashal@kernel.org, mcgrof@kernel.org, linux-xfs@vger.kernel.org,
        stable@vger.kernel.org, djwong@kernel.org, amir73il@gmail.com,
        leah.rumancik@gmail.com
Subject: Re: [PATCH 5.4 V2] xfs: redesign the reflink remap loop to fix
 blkres depletion crash
Message-ID: <Y3trUDu2Y0LqQOot@kroah.com>
References: <20221111041025.87704-4-chandan.babu@oracle.com>
 <20221121095506.1190043-1-chandan.babu@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20221121095506.1190043-1-chandan.babu@oracle.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Nov 21, 2022 at 03:25:06PM +0530, Chandan Babu R wrote:
> From: "Darrick J. Wong" <darrick.wong@oracle.com>
> 
> commit 00fd1d56dd08a8ceaa9e4ee1a41fefd9f6c6bc7d upstream.
> 
> The existing reflink remapping loop has some structural problems that
> need addressing:
> 
> The biggest problem is that we create one transaction for each extent in
> the source file without accounting for the number of mappings there are
> for the same range in the destination file.  In other words, we don't
> know the number of remap operations that will be necessary and we
> therefore cannot guess the block reservation required.  On highly
> fragmented filesystems (e.g. ones with active dedupe) we guess wrong,
> run out of block reservation, and fail.
> 
> The second problem is that we don't actually use the bmap intents to
> their full potential -- instead of calling bunmapi directly and having
> to deal with its backwards operation, we could call the deferred ops
> xfs_bmap_unmap_extent and xfs_refcount_decrease_extent instead.  This
> makes the frontend loop much simpler.
> 
> Solve all of these problems by refactoring the remapping loops so that
> we only perform one remapping operation per transaction, and each
> operation only tries to remap a single extent from source to dest.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> Reviewed-by: Brian Foster <bfoster@redhat.com>
> Reported-by: Edwin Török <edwin@etorok.net>
> Tested-by: Edwin Török <edwin@etorok.net>
> [backported to 5.4.y - Tested-by above does not refer to the backport]
> Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
> Acked-by: Darrick J. Wong <djwong@kernel.org>
> ---
> Changelog:
> V1 -> V2:
>    1. Add a note in the commit message to indicate that the Tested-by
>       tag from the original commit is not applicable to the backport.

Text now updated, thanks.
