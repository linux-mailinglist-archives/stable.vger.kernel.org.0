Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AC28F4257C5
	for <lists+stable@lfdr.de>; Thu,  7 Oct 2021 18:21:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232323AbhJGQXF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 7 Oct 2021 12:23:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:37332 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241846AbhJGQXE (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 7 Oct 2021 12:23:04 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 85CE061245;
        Thu,  7 Oct 2021 16:21:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1633623671;
        bh=BalsQIewaM6OZkJRMKgt4kFUsr36Qobh/+HBXkovAsc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=y6Xs1be47WqT0hbyAxXWOXgLhzPJqv324AjeinCjB5EwuxW2nCL+3jVTqN3Eut4Rp
         pK25QjEfVNzObZVMj9ZY/oV4CWe5p87JLz8VzVnLhSRI8pAPXFQgSQ+d7yJBZVhM+1
         S0fykHY/yLcLt09glThJFAA5xohUVMFG2jX2nykc=
Date:   Thu, 7 Oct 2021 18:21:08 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Jann Horn <jannh@google.com>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Eric Dumazet <edumazet@google.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
        Marcel Holtmann <marcel@holtmann.org>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 4.14 54/75] af_unix: fix races in sk_peer_pid and
 sk_peer_cred accesses
Message-ID: <YV8edF6SILKaJ/o2@kroah.com>
References: <20211004125031.530773667@linuxfoundation.org>
 <20211004125033.335733437@linuxfoundation.org>
 <CAG48ez1yJxTZJNPsxgy7FVq40MVXoc0_h4-s0gH-xfM1s2tStA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAG48ez1yJxTZJNPsxgy7FVq40MVXoc0_h4-s0gH-xfM1s2tStA@mail.gmail.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Oct 07, 2021 at 05:57:54PM +0200, Jann Horn wrote:
> On Mon, Oct 4, 2021 at 3:00 PM Greg Kroah-Hartman
> <gregkh@linuxfoundation.org> wrote:
> >
> > From: Eric Dumazet <edumazet@google.com>
> >
> > [ Upstream commit 35306eb23814444bd4021f8a1c3047d3cb0c8b2b ]
> >
> > Jann Horn reported that SO_PEERCRED and SO_PEERGROUPS implementations
> > are racy, as af_unix can concurrently change sk_peer_pid and sk_peer_cred.
> >
> > In order to fix this issue, this patch adds a new spinlock that needs
> > to be used whenever these fields are read or written.
> >
> > Jann also pointed out that l2cap_sock_get_peer_pid_cb() is currently
> > reading sk->sk_peer_pid which makes no sense, as this field
> > is only possibly set by AF_UNIX sockets.
> > We will have to clean this in a separate patch.
> > This could be done by reverting b48596d1dc25 "Bluetooth: L2CAP: Add get_peer_pid callback"
> > or implementing what was truly expected.
> >
> > Fixes: 109f6e39fa07 ("af_unix: Allow SO_PEERCRED to work across namespaces.")
> 
> >From what I can tell, this fix only went into the stable trees for
> >=4.14? SO_PEERGROUPS only appeared in 4.13, but the SO_PEERCRED in
> 4.4 and 4.9 seems to have exactly the same UAF read as it has on the
> newer kernels.

It doesn't apply cleanly there, can you provide a working backport?

thanks,

greg k-h
