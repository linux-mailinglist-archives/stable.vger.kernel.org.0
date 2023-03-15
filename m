Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B41B86BAA94
	for <lists+stable@lfdr.de>; Wed, 15 Mar 2023 09:17:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231563AbjCOIRk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Mar 2023 04:17:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37932 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231575AbjCOIRj (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 Mar 2023 04:17:39 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 29CC469CD8;
        Wed, 15 Mar 2023 01:17:38 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A36B061BFA;
        Wed, 15 Mar 2023 08:17:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B4A6DC433D2;
        Wed, 15 Mar 2023 08:17:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678868257;
        bh=129136KonHnvA/Qh8RW1qIvuJJElxgMtb5QysSBmDXM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=RuemUmY2H9Pp6TblhS05t/859Psk8kNxoHNN44y8h+cATtrNYdKX+soy5I1nMggi7
         YRqT7Za/2WY/HDqjB5PJlux0L0jyAMdxo5mhSRMSiIdu8dqn8KRtcrFAcr7RvFd1fc
         XBBgN1LifzGAl45oGYVNIIx4HRN/pB5rDtUHIuYk=
Date:   Wed, 15 Mar 2023 09:17:34 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Tudor Ambarus <tudor.ambarus@linaro.org>
Cc:     stable@vger.kernel.org, tytso@mit.edu, adilger.kernel@dilger.ca,
        linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
        joneslee@google.com
Subject: Re: [PATCH][for stable 5.{15, 10} 0/4] ext4: Fix kernel BUG in
 ext4_free_blocks
Message-ID: <ZBF/HpuRkBVQxcrp@kroah.com>
References: <20230302153610.1204653-1-tudor.ambarus@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230302153610.1204653-1-tudor.ambarus@linaro.org>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Mar 02, 2023 at 03:36:06PM +0000, Tudor Ambarus wrote:
> Hi,
> 
> This patch set is intended for stable/linux-5.{15, 10}.y. The patches
> applied cleanly without deviations from the original upstream patches.
> The last patch is fixing the bug reported at [1]. The other three are
> prerequisites for the last commit. I tested the patches and I confirm
> that the reproducer no longer complains on linux-5.{15, 10}.y. Older
> LTS kernels have more dependencies, let's fix these until I sort out
> what else should be backported for the older LTS kernels.
> 
> [1] LINK: https://syzkaller.appspot.com/bug?id=5266d464285a03cee9dbfda7d2452a72c3c2ae7c 
> 
> Cheers,
> ta
> 
> Lukas Czerner (1):
>   ext4: block range must be validated before use in ext4_mb_clear_bb()
> 
> Ritesh Harjani (3):
>   ext4: refactor ext4_free_blocks() to pull out ext4_mb_clear_bb()
>   ext4: add ext4_sb_block_valid() refactored out of
>     ext4_inode_block_valid()
>   ext4: add strict range checks while freeing blocks
> 
>  fs/ext4/block_validity.c |  26 +++--
>  fs/ext4/ext4.h           |   3 +
>  fs/ext4/mballoc.c        | 205 +++++++++++++++++++++++----------------
>  3 files changed, 139 insertions(+), 95 deletions(-)

Now queued up, thanks.

greg k-h
