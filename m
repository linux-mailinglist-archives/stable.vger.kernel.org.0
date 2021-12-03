Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DB7D4467521
	for <lists+stable@lfdr.de>; Fri,  3 Dec 2021 11:31:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1380064AbhLCKeo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 Dec 2021 05:34:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54536 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351513AbhLCKee (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 3 Dec 2021 05:34:34 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED635C06174A
        for <stable@vger.kernel.org>; Fri,  3 Dec 2021 02:31:10 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 45C34CE2596
        for <stable@vger.kernel.org>; Fri,  3 Dec 2021 10:31:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E22E9C53FCB;
        Fri,  3 Dec 2021 10:31:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1638527467;
        bh=2mUf6zyHZyptuotSkRb5u7YuM/ztD3ngU73FQqqj8O8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=KaI/S9yM4ws/PP2d4mpwBWHMHlfQ3yxVvzy+gb0yWRMyM9bfjEUtpiJs2X5sk0hu6
         dcYNcbqaxnTwoDdf+3FzICR7dKzasyVNppiM40DfrG3vAGWZR2otzU2OdNv5zAlJA4
         MHTxh0rvIojVewh3NLIOE+NWcAZ7mxNl90PWbnh0=
Date:   Fri, 3 Dec 2021 11:31:04 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Stan Hu <stanhu@gmail.com>
Cc:     stable@vger.kernel.org, Miklos Szeredi <mszeredi@redhat.com>
Subject: Re: Request for cherry-picking overlayfs fixes in 5.10.x stable
Message-ID: <Yanx6KobwiQoBQfU@kroah.com>
References: <CAMBWrQ=1MKxnMT_6Jnqp_xxr7psVywPBJc6p1qCy9ENY8RF2Qw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMBWrQ=1MKxnMT_6Jnqp_xxr7psVywPBJc6p1qCy9ENY8RF2Qw@mail.gmail.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Dec 02, 2021 at 04:29:34PM -0800, Stan Hu wrote:
> A number of users have reported that under certain conditions using
> the overlay filesystem, copy_file_range() can unexpectedly create a
> 0-byte file. [0]
> 
> This bug can cause significant problems because applications that copy
> files expect the target file to match the source immediately after the
> copy. After upgrading from Linux 5.4 to Linux 5.10, our Docker-based
> CI tests started failing due to this bug, since Ruby's IO.copy_stream
> uses this system call. We have worked around the problem by touching
> the target file before using it, but this shouldn't be necessary.
> Other projects, such as Rust, have added similar workarounds. [1]
> 
> As discussed in the linux-fsdevel mailing list [2], the bug appears to
> be present in Linux 5.6 to 5.10, but not in Linux 5.11. We should be
> able to cherry-pick the following upstream patches to fix this. Could
> you cherry-pick them to 5.10.x stable? I've confirmed that these
> patches, applied from top to bottom to that branch, pass the
> reproduction test [3]:
> 
> 82a763e61e2b601309d696d4fa514c77d64ee1be
> 9b91b6b019fda817eb52f728eb9c79b3579760bc
> 
> The diffstat:
> 
>  fs/overlayfs/file.c | 59
> +++++++++++++++++++++++++++++++----------------------------
>  1 file changed, 31 insertions(+), 28 deletions(-)
> 
> Note that these patches do not pick cleanly into 5.6.x - 5.9.x stable.
> 
> [0] https://github.com/docker/for-linux/issues/1015
> [1] https://github.com/rust-lang/rust/blob/342db70ae4ecc3cd17e4fa6497f0a8d9534ccfeb/library/std/src/sys/unix/kernel_copy.rs#L565-L569
> [2] https://marc.info/?l=linux-fsdevel&m=163847383311699&w=2
> [3] https://github.com/docker/for-linux/issues/1015#issuecomment-841915668

Now queued up, thanks,

greg k-h

