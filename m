Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C37D5599AB8
	for <lists+stable@lfdr.de>; Fri, 19 Aug 2022 13:18:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348250AbiHSLFj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Aug 2022 07:05:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49992 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348572AbiHSLFA (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 19 Aug 2022 07:05:00 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 49132F9963
        for <stable@vger.kernel.org>; Fri, 19 Aug 2022 04:04:59 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9B29661706
        for <stable@vger.kernel.org>; Fri, 19 Aug 2022 11:04:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A2243C433D6;
        Fri, 19 Aug 2022 11:04:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660907098;
        bh=ppGUdeGJXZRobgcgbIcU4j0tbpE4F+QAEZjGy8aQV+s=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=DNVP5MpKgO9MdOb4PVIBbj9nfX4lirP+PCK0Z0734CiDjXebn8rlZNTxlAKAQJsYx
         YxqwZWR7BpbPcos7MMkVJY+c60NAPJ3kWs0998+Qq+8CyyN+nvo9aKdGlbtY1gD+U0
         5O6/G9FWobVno0mmGjLTyXHqKsC/1qNqQJ9+wLZY=
Date:   Fri, 19 Aug 2022 13:04:55 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Tyler Hicks <tyhicks@linux.microsoft.com>
Cc:     asmadeus@codewreck.org, linux_oss@crudebyte.com,
        stable@vger.kernel.org
Subject: Re: [PATCH 5.10 5.4 4.19] net/9p: Initialize the iounit field during
 fid creation
Message-ID: <Yv9uV0/ucdSp6McY@kroah.com>
References: <1660564171201106@kroah.com>
 <20220816014925.336922-1-tyhicks@linux.microsoft.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220816014925.336922-1-tyhicks@linux.microsoft.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Aug 15, 2022 at 08:49:25PM -0500, Tyler Hicks wrote:
> [ Upstream commit aa7aeee169480e98cf41d83c01290a37e569be6d ]
> 
> Ensure that the fid's iounit field is set to zero when a new fid is
> created. Certain 9P operations, such as OPEN and CREATE, allow the
> server to reply with an iounit size which the client code assigns to the
> p9_fid struct shortly after the fid is created by p9_fid_create(). On
> the other hand, an XATTRWALK operation doesn't allow for the server to
> specify an iounit value. The iounit field of the newly allocated p9_fid
> struct remained uninitialized in that case. Depending on allocation
> patterns, the iounit value could have been something reasonable that was
> carried over from previously freed fids or, in the worst case, could
> have been arbitrary values from non-fid related usages of the memory
> location.
> 
> The bug was detected in the Windows Subsystem for Linux 2 (WSL2) kernel
> after the uninitialized iounit field resulted in the typical sequence of
> two getxattr(2) syscalls, one to get the size of an xattr and another
> after allocating a sufficiently sized buffer to fit the xattr value, to
> hit an unexpected ERANGE error in the second call to getxattr(2). An
> uninitialized iounit field would sometimes force rsize to be smaller
> than the xattr value size in p9_client_read_once() and the 9P server in
> WSL refused to chunk up the READ on the attr_fid and, instead, returned
> ERANGE to the client. The virtfs server in QEMU seems happy to chunk up
> the READ and this problem goes undetected there.
> 
> Link: https://lkml.kernel.org/r/20220710141402.803295-1-tyhicks@linux.microsoft.com
> Fixes: ebf46264a004 ("fs/9p: Add support user. xattr")
> Cc: stable@vger.kernel.org
> Signed-off-by: Tyler Hicks <tyhicks@linux.microsoft.com>
> Reviewed-by: Christian Schoenebeck <linux_oss@crudebyte.com>
> Signed-off-by: Dominique Martinet <asmadeus@codewreck.org>
> [tyhicks: Adjusted context due to:
>  - Lack of fid refcounting introduced in v5.11 commit 6636b6dcc3db ("9p:
>    add refcount to p9_fid struct")
>  - Difference in how buffer sizes are specified v5.16 commit
>    6e195b0f7c8e ("9p: fix a bunch of checkpatch warnings")]
> Signed-off-by: Tyler Hicks <tyhicks@linux.microsoft.com>
> ---
> 
> Tested on top of v5.10.136. Verified to apply to v5.4 and v4.19 and the
> resulting code was read for correctness.
> 

All now queued up, thanks.

greg k-h
