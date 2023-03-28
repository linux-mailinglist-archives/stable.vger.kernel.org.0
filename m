Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 97F3D6CC16C
	for <lists+stable@lfdr.de>; Tue, 28 Mar 2023 15:52:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231976AbjC1Nwl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Mar 2023 09:52:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60254 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231424AbjC1Nwk (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 28 Mar 2023 09:52:40 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2466E40EE
        for <stable@vger.kernel.org>; Tue, 28 Mar 2023 06:52:40 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id AFFAA617A7
        for <stable@vger.kernel.org>; Tue, 28 Mar 2023 13:52:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC609C433EF;
        Tue, 28 Mar 2023 13:52:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1680011559;
        bh=QThtAYBctl4ZF0TdOu9mqdLeJgeOJlgbh5jK+mftH7w=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=y8VIIhD/uhmI4tJx87Zn9eA+rSZ+UkpvsvrVaL/U9Yu48iZ5FbJR5t5oHQ9xykVnc
         jzQo8LGE8W0Zx0iJbmse0OPoLFF+FRJ6w9nIU/+zy0Ugl3w81ffK6D/KK9zfAwfQWn
         fmK3adf1yeMvCzFjhruJVzWbHJXDZbp9HpEhLpsg=
Date:   Tue, 28 Mar 2023 15:52:35 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Joseph Qi <joseph.qi@linux.alibaba.com>
Cc:     stable@vger.kernel.org,
        Jan Kara via Ocfs2-devel <ocfs2-devel@oss.oracle.com>,
        Jan Kara <jack@suse.cz>, Mark Fasheh <mark@fasheh.com>,
        Joel Becker <jlbec@evilplan.org>,
        Junxiao Bi <junxiao.bi@oracle.com>,
        Changwei Ge <gechangwei@live.cn>, Gang He <ghe@suse.com>,
        Jun Piao <piaojun@huawei.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] ocfs2: fix data corruption after failed write
Message-ID: <ZCLxIwF1Yfi35tqk@kroah.com>
References: <16793134471133@kroah.com>
 <20230321032024.165992-1-joseph.qi@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230321032024.165992-1-joseph.qi@linux.alibaba.com>
X-Spam-Status: No, score=-5.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Mar 21, 2023 at 11:20:24AM +0800, Joseph Qi wrote:
> From: Jan Kara via Ocfs2-devel <ocfs2-devel@oss.oracle.com>
> 
> commit 90410bcf873cf05f54a32183afff0161f44f9715 upstream.
> 
> When buffered write fails to copy data into underlying page cache page,
> ocfs2_write_end_nolock() just zeroes out and dirties the page.  This can
> leave dirty page beyond EOF and if page writeback tries to write this page
> before write succeeds and expands i_size, page gets into inconsistent
> state where page dirty bit is clear but buffer dirty bits stay set
> resulting in page data never getting written and so data copied to the
> page is lost.  Fix the problem by invalidating page beyond EOF after
> failed write.
> 
> Link: https://lkml.kernel.org/r/20230302153843.18499-1-jack@suse.cz
> Fixes: 6dbf7bb55598 ("fs: Don't invalidate page buffers in block_write_full_page()")
> Signed-off-by: Jan Kara <jack@suse.cz>
> Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>
> Cc: Mark Fasheh <mark@fasheh.com>
> Cc: Joel Becker <jlbec@evilplan.org>
> Cc: Junxiao Bi <junxiao.bi@oracle.com>
> Cc: Changwei Ge <gechangwei@live.cn>
> Cc: Gang He <ghe@suse.com>
> Cc: Jun Piao <piaojun@huawei.com>
> Cc: <stable@vger.kernel.org>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> [ replace block_invalidate_folio to block_invalidatepage ]
> Signed-off-by: Joseph Qi <joseph.qi@linux.alibaba.com>
> ---
>  fs/ocfs2/aops.c | 18 ++++++++++++++++--
>  1 file changed, 16 insertions(+), 2 deletions(-)
> 

Now queued up, thanks.

greg k-h
