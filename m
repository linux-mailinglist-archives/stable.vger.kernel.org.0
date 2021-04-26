Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0C49636ADF1
	for <lists+stable@lfdr.de>; Mon, 26 Apr 2021 09:39:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232823AbhDZHka (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Apr 2021 03:40:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:56118 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233199AbhDZHjN (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 26 Apr 2021 03:39:13 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0F424613A9;
        Mon, 26 Apr 2021 07:36:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1619422607;
        bh=GwPSu/fSJdWA+JCc7GkdYIaZyIKkZ5LE/IaMDsFYvgg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=bh1ErATCz22pvJhz6iHHblEiExj6g5T5hws8Zpuu6xqxdyBA2d/ihOYK/vBPbNOJ5
         +FCRDuq92diQbELDCx9kao4Q/it/nXvBt+fdGq8nYQ8XnW3w4tmW7SmkSyCN7S5sXr
         TvSSDMan30bD8Js56/Zb9m8hcgac18grO6JOyPwTnKINUDI/oHGvBvRvsszhpgqmQz
         rRyrv1GfzP5cTErIj9TflnFCjtgzhrl5qjt5n+zeujAlfa0joijKnZsP1MuEu/ztab
         eBbxE0iv36cWY2lj+8F9m693tC+4fsbAoGe6J/kQXe90ZN6rhgE/1dZfIHCYNg8nzs
         9vzEB5Pk324FQ==
Received: from johan by xi.lan with local (Exim 4.93.0.4)
        (envelope-from <johan@kernel.org>)
        id 1lavnd-0007u7-6e; Mon, 26 Apr 2021 09:36:57 +0200
Date:   Mon, 26 Apr 2021 09:36:57 +0200
From:   Johan Hovold <johan@kernel.org>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        syzbot+c49fe6089f295a05e6f8@syzkaller.appspotmail.com,
        Anirudh Rayabharam <mail@anirudhrb.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Subject: Re: [PATCH 4.4 22/32] net: hso: fix null-ptr-deref during tty device
 unregistration
Message-ID: <YIZtmT1CjlnwImlc@hovoldconsulting.com>
References: <20210426072816.574319312@linuxfoundation.org>
 <20210426072817.327441466@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210426072817.327441466@linuxfoundation.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Apr 26, 2021 at 09:29:20AM +0200, Greg Kroah-Hartman wrote:
> From: Anirudh Rayabharam <mail@anirudhrb.com>
> 
> commit 8a12f8836145ffe37e9c8733dce18c22fb668b66 upstream
> 
> Multiple ttys try to claim the same the minor number causing a double
> unregistration of the same device. The first unregistration succeeds
> but the next one results in a null-ptr-deref.
> 
> The get_free_serial_index() function returns an available minor number
> but doesn't assign it immediately. The assignment is done by the caller
> later. But before this assignment, calls to get_free_serial_index()
> would return the same minor number.
> 
> Fix this by modifying get_free_serial_index to assign the minor number
> immediately after one is found to be and rename it to obtain_minor()
> to better reflect what it does. Similary, rename set_serial_by_index()
> to release_minor() and modify it to free up the minor number of the
> given hso_serial. Every obtain_minor() should have corresponding
> release_minor() call.
> 
> Fixes: 72dc1c096c705 ("HSO: add option hso driver")
> Reported-by: syzbot+c49fe6089f295a05e6f8@syzkaller.appspotmail.com
> Tested-by: syzbot+c49fe6089f295a05e6f8@syzkaller.appspotmail.com
> Reviewed-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Signed-off-by: Anirudh Rayabharam <mail@anirudhrb.com>
> Signed-off-by: David S. Miller <davem@davemloft.net>
> [sudip: adjust context]
> Signed-off-by: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> ---
>  drivers/net/usb/hso.c |   33 ++++++++++++---------------------
>  1 file changed, 12 insertions(+), 21 deletions(-)

We just got a regression report against this one. Perhaps better to hold
off until that has been resolved.

	https://lore.kernel.org/r/20210425233509.9ce29da49037e1a421000bdd@aruba.it

Johan
