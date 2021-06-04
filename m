Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 504E539BD49
	for <lists+stable@lfdr.de>; Fri,  4 Jun 2021 18:35:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229690AbhFDQgs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 4 Jun 2021 12:36:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:53528 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229809AbhFDQgs (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 4 Jun 2021 12:36:48 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 87A3361107;
        Fri,  4 Jun 2021 16:35:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1622824501;
        bh=aAR+RN2o3sEQzbyeppJPKOMN8R5oNYQVOCXQPWYbWZg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=BNtlqX2wS9AUigfg3xgEpFZVjDPeQrGNHbItogqEhtfwSLShImh86RNzckTzkTI7y
         Fzj/k74vCL98n+5PNE628ikOv0anxi1ZhrttMg1mCd1pY/b0seY9wWq5zHP/Xg13fF
         hS7/989lDIOTDyrRsWQ1DpjvEKyhwx7VaNh72VEEaQV9YLrj/FiLa+v4TCkf4+91ub
         dkBRsoQmdE8BkSYLKyHpTodDZhRHZpfxafKqmekEBudQPoJAxFRtc61LiRu26EsNdZ
         QYWLgfUEVuF0Wbh1osYw0cXUuvAY+X8A8sFBpduLmw/wHJAAbk2YNfRogS2moZEOfL
         6BfY98S/yi3Zg==
Date:   Fri, 4 Jun 2021 12:35:00 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     David Sterba <dsterba@suse.com>
Cc:     stable@vger.kernel.org, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 5.4, 5.10] btrfs: tree-checker: do not error out if
 extent ref hash doesn't match
Message-ID: <YLpWNDzRmvO9oyi/@sashalap>
References: <20210604155304.24315-1-dsterba@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1; format=flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20210604155304.24315-1-dsterba@suse.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Jun 04, 2021 at 05:53:04PM +0200, David Sterba wrote:
>From: Josef Bacik <josef@toxicpanda.com>
>
>commit 1119a72e223f3073a604f8fccb3a470ccd8a4416 upstream.
>
>The tree checker checks the extent ref hash at read and write time to
>make sure we do not corrupt the file system.  Generally extent
>references go inline, but if we have enough of them we need to make an
>item, which looks like
>
>key.objectid	= <bytenr>
>key.type	= <BTRFS_EXTENT_DATA_REF_KEY|BTRFS_TREE_BLOCK_REF_KEY>
>key.offset	= hash(tree, owner, offset)
>
>However if key.offset collide with an unrelated extent reference we'll
>simply key.offset++ until we get something that doesn't collide.
>Obviously this doesn't match at tree checker time, and thus we error
>while writing out the transaction.  This is relatively easy to
>reproduce, simply do something like the following
>
>  xfs_io -f -c "pwrite 0 1M" file
>  offset=2
>
>  for i in {0..10000}
>  do
>	  xfs_io -c "reflink file 0 ${offset}M 1M" file
>	  offset=$(( offset + 2 ))
>  done
>
>  xfs_io -c "reflink file 0 17999258914816 1M" file
>  xfs_io -c "reflink file 0 35998517829632 1M" file
>  xfs_io -c "reflink file 0 53752752058368 1M" file
>
>  btrfs filesystem sync
>
>And the sync will error out because we'll abort the transaction.  The
>magic values above are used because they generate hash collisions with
>the first file in the main subvol.
>
>The fix for this is to remove the hash value check from tree checker, as
>we have no idea which offset ours should belong to.
>
>Reported-by: Tuomas Lähdekorpi <tuomas.lahdekorpi@gmail.com>
>Fixes: 0785a9aacf9d ("btrfs: tree-checker: Add EXTENT_DATA_REF check")
>CC: stable@vger.kernel.org # 5.4+
>Reviewed-by: Filipe Manana <fdmanana@suse.com>
>Signed-off-by: Josef Bacik <josef@toxicpanda.com>
>Reviewed-by: David Sterba <dsterba@suse.com>
>[ add comment]
>Signed-off-by: David Sterba <dsterba@suse.com>
>---
>
>Generated on 5.4 where it applies cleanly and on 5.10 with line offset
>but otherwise clean.

Queued up, thanks!

-- 
Thanks,
Sasha
