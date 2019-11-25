Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4DA6B1092FE
	for <lists+stable@lfdr.de>; Mon, 25 Nov 2019 18:42:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726957AbfKYRmE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 25 Nov 2019 12:42:04 -0500
Received: from mail.kernel.org ([198.145.29.99]:46694 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725851AbfKYRmE (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 25 Nov 2019 12:42:04 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 61D7C20740;
        Mon, 25 Nov 2019 17:42:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574703722;
        bh=CohrJBY/KK/MsSlut0eDpTSADgl4HfTfoWzUCb0wUio=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=oaA+7pwo1dJ73DJbIH9vIOWf71yRlJ5f2h13o7EFXe3evwoBPgK1CC8QnUDrUYDOT
         E4Pc0nuT/HDzkdl4nN7VkSJa41bIkMnG/YwuHNGsPaeBVPb3Vrfq6uYtgoS8ZXDM5g
         iwnLuKuHp6wPVQ2VqnrK8rzVG77ID7pFMpz5eqSA=
Date:   Mon, 25 Nov 2019 18:42:00 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Stefano Garzarella <sgarzare@redhat.com>
Cc:     stable@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Michael Tsirkin <mst@redhat.com>
Subject: Re: Please backport 6dbd3e66e778 vhost/vsock: split packets to send
 using multiple buffers
Message-ID: <20191125174200.GB2872072@kroah.com>
References: <CAGxU2F5NAbrFGF7LaVSyWSNy2kdkL=dATfujaUi3V7iXwqRcGg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAGxU2F5NAbrFGF7LaVSyWSNy2kdkL=dATfujaUi3V7iXwqRcGg@mail.gmail.com>
User-Agent: Mutt/1.12.2 (2019-09-21)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Nov 25, 2019 at 04:39:00PM +0100, Stefano Garzarella wrote:
> Hi,
> with Michael, we realized that this patch merged upstream solves an
> issue in the device emulation in the vhost-vsock module.
> Before this patch, the emulation did not meet the VIRTIO vsock
> specification, assuming that the buffer in the RX virtqueue was always 4 KB,
> without checking the actual size.
> 
> Please, backport the following patch to fix this issue:
> 
> commit 6dbd3e66e7785a2f055bf84d98de9b8fd31ff3f5
> Author: Stefano Garzarella <sgarzare@redhat.com>
> Date:   Tue Jul 30 17:43:33 2019 +0200
> 
>     vhost/vsock: split packets to send using multiple buffers
>    
>     If the packets to sent to the guest are bigger than the buffer
>     available, we can split them, using multiple buffers and fixing
>     the length in the packet header.
>     This is safe since virtio-vsock supports only stream sockets.
>    
>     Signed-off-by: Stefano Garzarella <sgarzare@redhat.com>
>     Reviewed-by: Stefan Hajnoczi <stefanha@redhat.com>
>     Acked-by: Michael S. Tsirkin <mst@redhat.com>
>     Signed-off-by: David S. Miller <davem@davemloft.net>
> 
> 
> The commit applies and builds against 4.14, 4.19, and 5.3

Now queud up, thanks.

greg k-h
