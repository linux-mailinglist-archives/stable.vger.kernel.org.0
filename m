Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D57FA38E6E8
	for <lists+stable@lfdr.de>; Mon, 24 May 2021 14:48:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232486AbhEXMt7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 May 2021 08:49:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:59978 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232371AbhEXMt6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 24 May 2021 08:49:58 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7E5B861151;
        Mon, 24 May 2021 12:48:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621860509;
        bh=88p1LsDSeIyYmr0LjZKRYI8XHO8DCV3Y80uXd0IDVoQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=muxDto7rjLof4qsfi/Gk7YZF78yoCBQB0enNaFe9jNqSGkRixv/mkff/3gvPQyjpR
         96vkEAFNuca7iXV9Z94+w7aAF8mA0Ndl5mvMkZccalg3QbIZfWb3DE2xZ3Aj/DmI4Y
         Zy396X7Rd1Kr0rkaPn8bnvqabQN4C74PSnCA1KTk=
Date:   Mon, 24 May 2021 14:48:27 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Zubin Mithra <zsm@chromium.org>
Cc:     stable@vger.kernel.org, groeck@chromium.org, apusaka@chromium.org,
        luiz.von.dentz@intel.com, marcel@holtmann.org
Subject: Re: [v5.4.y] Bluetooth: L2CAP: Fix handling LE modes by L2CAP_OPTIONS
Message-ID: <YKugm0CAEVC+JVSJ@kroah.com>
References: <20210519175502.602799-1-zsm@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210519175502.602799-1-zsm@chromium.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, May 19, 2021 at 10:55:02AM -0700, Zubin Mithra wrote:
> From: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
> 
> L2CAP_OPTIONS shall only be used with BR/EDR modes.
> 
> Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
> Signed-off-by: Marcel Holtmann <marcel@holtmann.org>
> (cherry picked from commit b86b0b150fed840c376145383ef5105116c81b0c)
> Signed-off-by: Zubin Mithra <zsm@chromium.org>
> ---
> * Syzkaller triggered a GPF with the following stacktrace:
>  l2cap_chan_send+0xa6e/0x1c30 net/bluetooth/l2cap_core.c:2532
>  l2cap_sock_sendmsg+0x1da/0x1fd net/bluetooth/l2cap_sock.c:985
>  sock_sendmsg_nosec+0x88/0xb4 net/socket.c:638
>  sock_sendmsg+0x5e/0x6f net/socket.c:658
>  ____sys_sendmsg+0x45c/0x5a5 net/socket.c:2298
>  ___sys_sendmsg+0x13e/0x19f net/socket.c:2352
>  __sys_sendmmsg+0x298/0x38c net/socket.c:2455
>  __do_sys_sendmmsg net/socket.c:2484 [inline]
>  __se_sys_sendmmsg net/socket.c:2481 [inline]
>  __x64_sys_sendmmsg+0xad/0xb6 net/socket.c:2481
>  do_syscall_64+0x10b/0x144 arch/x86/entry/common.c:299
>  entry_SYSCALL_64_after_hwframe+0x49/0xbe
> 
> * This commit is present in 5.10.y and newer. 4.19.y
> and older do not need this fix.

Now queued up, thanks.

greg k-h
