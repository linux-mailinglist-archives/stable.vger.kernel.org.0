Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6F3C45867F7
	for <lists+stable@lfdr.de>; Mon,  1 Aug 2022 13:14:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229878AbiHALOa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Aug 2022 07:14:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35066 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229862AbiHALO3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 1 Aug 2022 07:14:29 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 424E8E03A
        for <stable@vger.kernel.org>; Mon,  1 Aug 2022 04:14:29 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D57D86121C
        for <stable@vger.kernel.org>; Mon,  1 Aug 2022 11:14:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E273EC433C1;
        Mon,  1 Aug 2022 11:14:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1659352468;
        bh=nZJcw7G6vREK8IWPwsV8bXpzom8q1xoEB4pT0Df+DxE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=fjh3E3R5KBSN465L5r5Y6F5rQH+VWbGlBkY3cjlRFO/RGAtPh0Pw2s56ImpBuVp6b
         +hoDBG0vQzlMQPCso+mpL19l9X4OKyHGIZPI9E9YonY5Y+ycbAl6jZxH5ar3/MWQDC
         CWGhXLDcji1RsdSoHn0RpInepkuSTbLSt+Ipmq0Y=
Date:   Mon, 1 Aug 2022 13:14:25 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Alexander Grund <theflamefire89@gmail.com>
Cc:     stable@vger.kernel.org
Subject: Re: [PATCH 4.9 0/6] Convert isec->lock into a spinlock fixing
 deadlock on GFS2
Message-ID: <Yue1kQ6DLRnDRMEz@kroah.com>
References: <20220730170343.11477-1-theflamefire89@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220730170343.11477-1-theflamefire89@gmail.com>
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, Jul 30, 2022 at 07:03:37PM +0200, Alexander Grund wrote:
> This patchset backports basically upstream commit 9287aed2
> (selinux: Convert isec->lock into a spinlock). This
> "fixes a deadlock between selinux and GFS2 when GFS2 invalidates a security label",
> see the original discussion at
> https://lore.kernel.org/all/1478812710-17190-2-git-send-email-agruenba@redhat.com/T/
> It also contains the follow-up fixes to make this correct.
> 
> The first 3 commits (by Andreas) are valuable on their own too as
> they fix a documentation bug, avoid partially initialized structs
> and (slightly) improve performance while making the code cleaner.
> 
> Andreas Gruenbacher (4):
>   selinux: Minor cleanups
>   proc: Pass file mode to proc_pid_make_inode
>   selinux: Clean up initialization of isec->sclass
>   selinux: Convert isec->lock into a spinlock
> 
> Paul Moore (1):
>   selinux: fix inode_doinit_with_dentry() LABEL_INVALID error handling
> 
> Tianyue Ren (1):
>   selinux: fix error initialization in inode_doinit_with_dentry()
> 
>  fs/proc/base.c                    |  23 +++---
>  fs/proc/fd.c                      |   6 +-
>  fs/proc/internal.h                |   2 +-
>  fs/proc/namespaces.c              |   3 +-
>  security/selinux/hooks.c          | 123 +++++++++++++++++++-----------
>  security/selinux/include/objsec.h |   5 +-
>  security/selinux/selinuxfs.c      |   4 +-
>  7 files changed, 96 insertions(+), 70 deletions(-)
> 
> -- 
> 2.25.1
> 

All look good, now queued up, thanks,


greg k-h
