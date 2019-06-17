Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6AC67493A1
	for <lists+stable@lfdr.de>; Mon, 17 Jun 2019 23:32:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730102AbfFQVcV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Jun 2019 17:32:21 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:33662 "EHLO
        ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729121AbfFQVcT (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 Jun 2019 17:32:19 -0400
Received: from viro by ZenIV.linux.org.uk with local (Exim 4.92 #3 (Red Hat Linux))
        id 1hczEZ-0008Fy-L0; Mon, 17 Jun 2019 21:32:11 +0000
Date:   Mon, 17 Jun 2019 22:32:11 +0100
From:   Al Viro <viro@zeniv.linux.org.uk>
To:     Christian Brauner <christian@brauner.io>
Cc:     torvalds@linux-foundation.org, ebiederm@xmission.com,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH v1] fs/namespace: fix unprivileged mount propagation
Message-ID: <20190617213211.GV17978@ZenIV.linux.org.uk>
References: <20190617212214.29868-1-christian@brauner.io>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190617212214.29868-1-christian@brauner.io>
User-Agent: Mutt/1.11.3 (2019-02-01)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jun 17, 2019 at 11:22:14PM +0200, Christian Brauner wrote:
> When propagating mounts across mount namespaces owned by different user
> namespaces it is not possible anymore to move or umount the mount in the
> less privileged mount namespace.
> 
> Here is a reproducer:
> 
>   sudo mount -t tmpfs tmpfs /mnt
>   sudo --make-rshared /mnt
> 
>   # create unprivileged user + mount namespace and preserve propagation
>   unshare -U -m --map-root --propagation=unchanged
> 
>   # now change back to the original mount namespace in another terminal:
>   sudo mkdir /mnt/aaa
>   sudo mount -t tmpfs tmpfs /mnt/aaa
> 
>   # now in the unprivileged user + mount namespace
>   mount --move /mnt/aaa /opt
> 
> Unfortunately, this is a pretty big deal for userspace since this is
> e.g. used to inject mounts into running unprivileged containers.
> So this regression really needs to go away rather quickly.
> 
> The problem is that a recent change falsely locked the root of the newly
> added mounts by setting MNT_LOCKED. Fix this by only locking the mounts
> on copy_mnt_ns() and not when adding a new mount.

Applied.  Linus, if you want to apply it directly, feel free to add my
Acked-by.  Alternatively, wait until tonight and I'll send a pull request
with that (as well as missing mntget() in fsmount(2) fix, at least).

Al, down to ~3Kmail in the pile...
