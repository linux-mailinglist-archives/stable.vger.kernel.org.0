Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 15A31102940
	for <lists+stable@lfdr.de>; Tue, 19 Nov 2019 17:23:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727560AbfKSQXC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Nov 2019 11:23:02 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:29039 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727646AbfKSQW7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 19 Nov 2019 11:22:59 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1574180577;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=9dqMi9w8FGMz0iOTrsEVSdaPR96qMxP3SmDt20AyNaA=;
        b=YCWenkjtBbg6mjmkweV+uhkNdCoBHEnmrjPdbMPNvlyGm3B75Z7/8WnTX3MH1PzzpIHrnH
        WZmcZTHTaispbmJfczfFgnocKi6FyO9owHYE/hR61jJnDcxjo48EWnrZO10igBrtx/y8kB
        VENF2wwtYEGcFAS15T4vW2U/ti7nQBw=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-168-UanJR99WNNSuLTN67p4xeQ-1; Tue, 19 Nov 2019 11:22:54 -0500
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 1E3338018A1;
        Tue, 19 Nov 2019 16:22:53 +0000 (UTC)
Received: from [10.10.121.199] (ovpn-121-199.rdu2.redhat.com [10.10.121.199])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 361F55E243;
        Tue, 19 Nov 2019 16:22:52 +0000 (UTC)
Subject: Re: [v2] nbd:fix memory leak in nbd_get_socket()
To:     Sun Ke <sunke32@huawei.com>, josef@toxicpanda.com, axboe@kernel.dk,
        linux-block@vger.kernel.org, nbd@other.debian.org,
        linux-kernel@vger.kernel.org
References: <1574143751-138680-1-git-send-email-sunke32@huawei.com>
Cc:     stable@vger.kernel.org
From:   Mike Christie <mchristi@redhat.com>
Message-ID: <5DD416DB.1040302@redhat.com>
Date:   Tue, 19 Nov 2019 10:22:51 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:38.0) Gecko/20100101
 Thunderbird/38.6.0
MIME-Version: 1.0
In-Reply-To: <1574143751-138680-1-git-send-email-sunke32@huawei.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
X-MC-Unique: UanJR99WNNSuLTN67p4xeQ-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 11/19/2019 12:09 AM, Sun Ke wrote:
> Before return NULL,put the sock first.
>=20
> Cc: stable@vger.kernel.org
> Fixes: cf1b2326b734 ("nbd: verify socket is supported during setup")
> Signed-off-by: Sun Ke <sunke32@huawei.com>
> ---
> v2: add cc:stable tag
> ---
>  drivers/block/nbd.c | 1 +
>  1 file changed, 1 insertion(+)
>=20
> diff --git a/drivers/block/nbd.c b/drivers/block/nbd.c
> index a94ee45..19e7599 100644
> --- a/drivers/block/nbd.c
> +++ b/drivers/block/nbd.c
> @@ -993,6 +993,7 @@ static struct socket *nbd_get_socket(struct nbd_devic=
e *nbd, unsigned long fd,
>  =09if (sock->ops->shutdown =3D=3D sock_no_shutdown) {
>  =09=09dev_err(disk_to_dev(nbd->disk), "Unsupported socket: shutdown call=
out must be supported.\n");
>  =09=09*err =3D -EINVAL;
> +=09=09sockfd_put(sock);
>  =09=09return NULL;
>  =09}
> =20
>=20

Reviewed-by: Mike Christie <mchristi@redhat.com>

