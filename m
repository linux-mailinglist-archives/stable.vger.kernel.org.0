Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7F2DD3BAE16
	for <lists+stable@lfdr.de>; Sun,  4 Jul 2021 19:33:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229689AbhGDRft convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Sun, 4 Jul 2021 13:35:49 -0400
Received: from coyote.holtmann.net ([212.227.132.17]:56605 "EHLO
        mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229575AbhGDRft (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 4 Jul 2021 13:35:49 -0400
Received: from smtpclient.apple (p5b3d2eb8.dip0.t-ipconnect.de [91.61.46.184])
        by mail.holtmann.org (Postfix) with ESMTPSA id 81438CECCC;
        Sun,  4 Jul 2021 19:33:11 +0200 (CEST)
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 14.0 \(3654.100.0.2.22\))
Subject: Re: [PATCH] bluetooth/virtio_bt: Fix dereference null return value
From:   Marcel Holtmann <marcel@holtmann.org>
In-Reply-To: <20210704145504.24756-1-john.wood@gmx.com>
Date:   Sun, 4 Jul 2021 19:33:10 +0200
Cc:     Johan Hedberg <johan.hedberg@gmail.com>,
        Luiz Augusto von Dentz <luiz.dentz@gmail.com>,
        stable <stable@vger.kernel.org>,
        Bluetooth Kernel Mailing List 
        <linux-bluetooth@vger.kernel.org>, linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8BIT
Message-Id: <EE77EBBE-EB8A-475D-A1DA-BC35DD14B3E0@holtmann.org>
References: <20210704145504.24756-1-john.wood@gmx.com>
To:     John Wood <john.wood@gmx.com>
X-Mailer: Apple Mail (2.3654.100.0.2.22)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi John,

> The alloc_skb function returns NULL on error. So, test this case and
> avoid a NULL dereference (skb->data).
> 
> Addresses-Coverity-ID: 1484718 ("Dereference null return value")
> Fixes: afd2daa26c7ab ("Bluetooth: Add support for virtio transport driver")
> Signed-off-by: John Wood <john.wood@gmx.com>
> ---
> drivers/bluetooth/virtio_bt.c | 2 ++
> 1 file changed, 2 insertions(+)
> 
> diff --git a/drivers/bluetooth/virtio_bt.c b/drivers/bluetooth/virtio_bt.c
> index c804db7e90f8..5f82574236c0 100644
> --- a/drivers/bluetooth/virtio_bt.c
> +++ b/drivers/bluetooth/virtio_bt.c
> @@ -34,6 +34,8 @@ static int virtbt_add_inbuf(struct virtio_bluetooth *vbt)
> 	int err;
> 
> 	skb = alloc_skb(1000, GFP_KERNEL);
> +	if (!skb)
> +		return -ENOMEM;
> 	sg_init_one(sg, skb->data, 1000);

this is already fixed.

Author: Colin Ian King <colin.king@canonical.com>
Date:   Fri Apr 9 17:53:14 2021 +0100

    Bluetooth: virtio_bt: add missing null pointer check on alloc_skb call return
    
    The call to alloc_skb with the GFP_KERNEL flag can return a null sk_buff
    pointer, so add a null check to avoid any null pointer deference issues.
    
    Addresses-Coverity: ("Dereference null return value")
    Fixes: afd2daa26c7a ("Bluetooth: Add support for virtio transport driver")
    Signed-off-by: Colin Ian King <colin.king@canonical.com>
    Signed-off-by: Marcel Holtmann <marcel@holtmann.org>

Regards

Marcel

