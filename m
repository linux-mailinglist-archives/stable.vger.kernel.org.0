Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3668554B19F
	for <lists+stable@lfdr.de>; Tue, 14 Jun 2022 14:56:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232575AbiFNMqI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Jun 2022 08:46:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57112 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230242AbiFNMqG (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 14 Jun 2022 08:46:06 -0400
Received: from nautica.notk.org (ipv6.notk.org [IPv6:2001:41d0:1:7a93::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8FAB525C5;
        Tue, 14 Jun 2022 05:46:04 -0700 (PDT)
Received: by nautica.notk.org (Postfix, from userid 108)
        id 6D9ECC01E; Tue, 14 Jun 2022 14:46:02 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=codewreck.org; s=2;
        t=1655210762; bh=RBQSMhJpK15hWi9SMdepI4O7Y2eSyNHR2US+GQyQ36o=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=LilRbVJUfwYoA1//wDU1shCOR5jIlx8SHihvxDmteQ1l1gMs5kgxlk7aM3k7hIFAw
         3A0uRVv0xz4CtRSZK6YZUxF2bAZ3e18O0OOswRu9skzz4N90QpkV2qKn83rSv6KWtd
         vqViBfUVAGcvn02WxoMFlmUDsnA6ae6ww+mwbzj3On574KLvCb1Q9U4rZqn27j9CfH
         +7vb3NOKulwEBsUfb9dWM1abLj30rBDKUOuCh8WHT8VRH1UfOWGJuIdS68MLBfruDo
         maz9BHaJqUwPxGX4Ic2m8vmia6GxKVZP5tvrZ0APgofnHBnqIm5W8Op4BIZNPjboaJ
         Qrkz60btiZZ0A==
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
X-Spam-Level: 
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
Received: from odin.codewreck.org (localhost [127.0.0.1])
        by nautica.notk.org (Postfix) with ESMTPS id 6B33DC009;
        Tue, 14 Jun 2022 14:45:59 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=codewreck.org; s=2;
        t=1655210761; bh=RBQSMhJpK15hWi9SMdepI4O7Y2eSyNHR2US+GQyQ36o=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=VUcy+z4XRKn7+vtvt02If6n53Kq01LfCtnbgiQl1vimsdQQuBo7mMmbPyEj1vKTzU
         UkuQcg3gu2kaXLwSRZ0hWQzJxlgsVZc5CweX9hlL64WeGSNSM/qvhOphK9x5NB3NGC
         nQT2qVZ2nLp2RQIEvrPV+ESJDRrNgoCglQYndTU6cHhI+VdWUGCsTBL9vzb531YY6w
         qrEQXM6+rUxhbXlpWZzw24Gt/M26s/px/ctjthKXsvmdF7S+wKYUkkkl7lodK1FDe5
         UWqFGS0xf/iWIbj8BLlkuSSb6Nqu4LomRlCFD1gyJktnqi3qD3YgWYFn9zqVMfg9Z4
         ohkHGDvGz9xXQ==
Received: from localhost (odin.codewreck.org [local])
        by odin.codewreck.org (OpenSMTPD) with ESMTPA id 81288279;
        Tue, 14 Jun 2022 12:45:53 +0000 (UTC)
Date:   Tue, 14 Jun 2022 21:45:38 +0900
From:   Dominique Martinet <asmadeus@codewreck.org>
To:     Christian Schoenebeck <linux_oss@crudebyte.com>
Cc:     Eric Van Hensbergen <ericvh@gmail.com>,
        Latchesar Ionkov <lucho@ionkov.net>,
        David Howells <dhowells@redhat.com>,
        linux-fsdevel@vger.kernel.org, stable@vger.kernel.org,
        v9fs-developer@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] 9p: fix EBADF errors in cached mode
Message-ID: <YqiC8luskkxUftQl@codewreck.org>
References: <YqW5s+GQZwZ/DP5q@codewreck.org>
 <20220614033802.1606738-1-asmadeus@codewreck.org>
 <YqgDdNUxC0hV6KR9@codewreck.org>
 <19026878.01OTk6HtWb@silver>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <19026878.01OTk6HtWb@silver>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Christian Schoenebeck wrote on Tue, Jun 14, 2022 at 02:10:01PM +0200:
> It definitely goes into the right direction, but I think it's going a bit too 
> far by using writeback_fid also in cases where it is not necessary and wasn't 
> used before in the past.

Would help if I had an idea of what was used where in the past.. :)

From a quick look at the code, checking out v5.10,
v9fs_vfs_writepage_locked() used the writeback fid always for all writes
v9fs_vfs_readpages is a bit more complex but only seems to be using the
"direct" private_data fid for reads...
It took me a bit of time but I think the reads you were seeing on
writeback fid come from v9fs_write_begin that does some readpage on the
writeback fid to populate the page before a non-filling write happens.

> What about something like this in v9fs_init_request() (yet untested):
> 
>     /* writeback_fid is always opened O_RDWR (instead of just O_WRONLY) 
>      * explicitly for this case: partial write backs that require a read
>      * prior to actual write and therefore requires a fid with read
>      * capability.
>      */
>     if (rreq->origin == NETFS_READ_FOR_WRITE)
>         fid = v9inode->writeback_fid;

... Which seems to be exactly what this origin is about, so if that
works I'm all for it.

> If desired, this could be further constrained later on like:
> 
>     if (rreq->origin == NETFS_READ_FOR_WRITE &&
>         (fid->mode & O_ACCMODE) == O_WRONLY)
>     {
>         fid = v9inode->writeback_fid;
>     }

That also makes sense, if the fid mode has read permissions we might as
well use these as the writeback fid would needlessly be doing root IOs.

> I will definitely give these options some test spins here, a short feedback 
> ahead would be appreciated though.

Please let me know how that works out, I'd be happy to use either of
your versions instead of mine.
If I can be greedy though I'd like to post it together with the other
couple of fixes next week, so having something before the end of the
week would be great -- I think even my first overkill version early and
building on it would make sense at this point.

But I think you've got the right end, so hopefully won't be needing to
delay


Cheers,
-- 
Dominique
