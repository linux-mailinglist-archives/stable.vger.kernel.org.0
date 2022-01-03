Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 07E86482F96
	for <lists+stable@lfdr.de>; Mon,  3 Jan 2022 10:46:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230393AbiACJqN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Jan 2022 04:46:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32816 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230153AbiACJqM (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Jan 2022 04:46:12 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 532EBC061761;
        Mon,  3 Jan 2022 01:46:12 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E45A360FA6;
        Mon,  3 Jan 2022 09:46:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B162AC36AE9;
        Mon,  3 Jan 2022 09:46:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1641203171;
        bh=WyDTdExxTsqLjt9MtswmMyXYXYhiT7+KODkoSqxm+HU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=KeI3nF7MRTNO6zbcnE6fa6N/nLNh/cHF5lYTFb82G7491NKM4gzRMGwA9w761Fpv7
         UQAwnOVxC5wqs/KOP+RKZh0epP1anYeqv1M3umiwQGmBC8Jay3BFeH7JreVsD/6mZF
         shQxtgL34m2NXbHHvA1QH+lzDfEFMXgfRlN6ZSsI=
Date:   Mon, 3 Jan 2022 10:46:08 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     SeongJae Park <sj@kernel.org>
Cc:     stable@vger.kernel.org, akpm@linux-foundation.org,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH for-v5.15.x] mm/damon/dbgfs: fix 'struct pid' leaks in
 'dbgfs_target_ids_write()'
Message-ID: <YdLF4OSx30hpmwKB@kroah.com>
References: <20220102112141.12281-1-sj@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220102112141.12281-1-sj@kernel.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, Jan 02, 2022 at 11:21:41AM +0000, SeongJae Park wrote:
> commit ebb3f994dd92f8fb4d70c7541091216c1e10cb71 upstream.
> 
> DAMON debugfs interface increases the reference counts of 'struct pid's
> for targets from the 'target_ids' file write callback
> ('dbgfs_target_ids_write()'), but decreases the counts only in DAMON
> monitoring termination callback ('dbgfs_before_terminate()').
> 
> Therefore, when 'target_ids' file is repeatedly written without DAMON
> monitoring start/termination, the reference count is not decreased and
> therefore memory for the 'struct pid' cannot be freed.  This commit
> fixes this issue by decreasing the reference counts when 'target_ids' is
> written.
> 
> Link: https://lkml.kernel.org/r/20211229124029.23348-1-sj@kernel.org
> Fixes: 4bc05954d007 ("mm/damon: implement a debugfs-based user space interface")
> Signed-off-by: SeongJae Park <sj@kernel.org>
> Cc: <stable@vger.kernel.org> # 5.15.x
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
> ---
> This is a backport of a DAMON fix that merged in the mainline, for
> v5.15.x stable series.

Now queued up, thanks.

greg k-h
