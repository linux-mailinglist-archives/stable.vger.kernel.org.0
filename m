Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 246944790AC
	for <lists+stable@lfdr.de>; Fri, 17 Dec 2021 16:55:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235295AbhLQPz0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 17 Dec 2021 10:55:26 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:47318 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235120AbhLQPz0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 17 Dec 2021 10:55:26 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E39C26229B
        for <stable@vger.kernel.org>; Fri, 17 Dec 2021 15:55:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA8C1C36AE1;
        Fri, 17 Dec 2021 15:55:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1639756525;
        bh=ywM3b4R0yY78kibiNXScZPT2KSGJt1yWM7o6pARUa2c=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=UKHlQVa72ltp/SJixIOwB5qyBVP2zDblDgE0TWFbMn7fox0MkH/cr1IeFEoMB1mvM
         KrjM82zzPU1JVqP6Ewl1Zqycmh098R5A2+fW7bkZs2CMeaUcxG831zzaybMOV6TjQO
         dkCGlaIcY+hDkZkKMj6v9gqzwNALDoJyqpKQGMKd7UIb/ek8dC8TQ/rDSAtYxrnDC2
         CNxuKevmDWJ2LCQiyMiNhMAFzlec/jGrxQKwHi7ZWAMqkobEJif4M4gHNkMYg64voG
         dKHkNRvL3yO9AKomkfz+2gqZ5icjgeQOKfA61hKaO6WWqYtmiEFTLNvy3u8tt+piB6
         dycA2FGeRDVaQ==
Message-ID: <41797c9b2bfbd977427bd531db2337edfbcb4c92.camel@kernel.org>
Subject: Re: FAILED: patch "[PATCH] ceph: fix up non-directory creation in
 SGID directories" failed to apply to 5.10-stable tree
From:   Jeff Layton <jlayton@kernel.org>
To:     Greg KH <gregkh@linuxfoundation.org>,
        Christian Brauner <christian.brauner@ubuntu.com>
Cc:     idryomov@gmail.com, stable@vger.kernel.org
Date:   Fri, 17 Dec 2021 10:55:23 -0500
In-Reply-To: <YbynEbAeWpB5A2sj@kroah.com>
References: <163974910684103@kroah.com>
         <20211217142301.a5y45b54ut3ika4v@wittgenstein> <YbynEbAeWpB5A2sj@kroah.com>
Content-Type: text/plain; charset="ISO-8859-15"
User-Agent: Evolution 3.42.2 (3.42.2-1.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, 2021-12-17 at 16:04 +0100, Greg KH wrote:
> On Fri, Dec 17, 2021 at 03:23:01PM +0100, Christian Brauner wrote:
> > On Fri, Dec 17, 2021 at 02:51:46PM +0100, gregkh@linuxfoundation.org wrote:
> > > 
> > > The patch below does not apply to the 5.10-stable tree.
> > > If someone wants it applied there, or to any other stable or longterm
> > > tree, then please email the backport, including the original git commit
> > > id to <stable@vger.kernel.org>.
> > 
> > Oh? I just applied the patch on top of:
> > 
> > commit 272aedd4a305 ("Linux 5.10.87")
> > 
> > without any issues. Not sure what failed for you.
> 
> It fails to build :(

I think the issue is probably that capable_wrt_inode_uidgid in kernels
of that era didn't take a userns arg. I had to do a similar fixup for
the RHEL8 backport.
-- 
Jeff Layton <jlayton@kernel.org>
