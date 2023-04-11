Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 531B36DD600
	for <lists+stable@lfdr.de>; Tue, 11 Apr 2023 10:56:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229525AbjDKI4X (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 11 Apr 2023 04:56:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47694 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229617AbjDKI4W (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 11 Apr 2023 04:56:22 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B8401FDD;
        Tue, 11 Apr 2023 01:56:22 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id AB32161D5E;
        Tue, 11 Apr 2023 08:56:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 97C9BC433D2;
        Tue, 11 Apr 2023 08:56:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1681203381;
        bh=7083kajNwzY+ryJVAy0E4LGL0ceCyH58LiPuWNnEGJU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=mKMf3rZpqXCpBZTZUxvCmTjnGpPg1QzWLl6xVpzPliSjU3EWRcoRF9gIu1l9+2pyt
         /2CU520rE/7f+OkELiM7uhcaweq8bqJk9RoerR3PhlQsjOeRo5f59Kwr4tNi2jUE8y
         Fh6lJMb1vqZdV9GFnSB/14hu4enJqI30REKtyN/NxT6cSoMzgrBtynt9XckgaR1STz
         6ktzhEA/DQOauxprMZzOeu4J+woaQWl9gYxPp0lFC1E8G4mtk4lIKaPlaYIfNAn3Yq
         4nXw+IZ759vcGjzgZjAxCX4UvfeLLrsf7tCRPmH26w49kfKLJ47SxVfKO8kKXOk9dk
         LVC4yZnxCDLFw==
Date:   Tue, 11 Apr 2023 10:56:16 +0200
From:   Christian Brauner <brauner@kernel.org>
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     fsverity@lists.linux.dev, linux-fsdevel@vger.kernel.org,
        stable@vger.kernel.org,
        syzbot+51177e4144d764827c45@syzkaller.appspotmail.com
Subject: Re: [PATCH] fsverity: reject FS_IOC_ENABLE_VERITY on mode 3 fds
Message-ID: <20230411-abwegen-division-b2370b5667d9@brauner>
References: <20230406215106.235829-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20230406215106.235829-1-ebiggers@kernel.org>
X-Spam-Status: No, score=-5.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Apr 06, 2023 at 02:51:06PM -0700, Eric Biggers wrote:
> From: Eric Biggers <ebiggers@google.com>
> 
> Commit 56124d6c87fd ("fsverity: support enabling with tree block size <
> PAGE_SIZE") changed FS_IOC_ENABLE_VERITY to use __kernel_read() to read
> the file's data, instead of direct pagecache accesses.
> 
> An unintended consequence of this is that the
> 'WARN_ON_ONCE(!(file->f_mode & FMODE_READ))' in __kernel_read() became
> reachable by fuzz tests.  This happens if FS_IOC_ENABLE_VERITY is called
> on a fd opened with access mode 3, which means "ioctl access only".
> 
> Arguably, FS_IOC_ENABLE_VERITY should work on ioctl-only fds.  But
> ioctl-only fds are a weird Linux extension that is rarely used and that
> few people even know about.  (The documentation for FS_IOC_ENABLE_VERITY
> even specifically says it requires O_RDONLY.)  It's probably not
> worthwhile to make the ioctl internally open a new fd just to handle
> this case.  Thus, just reject the ioctl on such fds for now.
> 
> Fixes: 56124d6c87fd ("fsverity: support enabling with tree block size < PAGE_SIZE")
> Reported-by: syzbot+51177e4144d764827c45@syzkaller.appspotmail.com
> Link: https://syzkaller.appspot.com/bug?id=2281afcbbfa8fdb92f9887479cc0e4180f1c6b28
> Cc: stable@vger.kernel.org
> Signed-off-by: Eric Biggers <ebiggers@google.com>
> ---

Looks good to me,
Reviewed-by: Christian Brauner <brauner@kernel.org>
