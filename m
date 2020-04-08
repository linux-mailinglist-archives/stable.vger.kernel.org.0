Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0D9FF1A22D8
	for <lists+stable@lfdr.de>; Wed,  8 Apr 2020 15:23:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727376AbgDHNXQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 8 Apr 2020 09:23:16 -0400
Received: from forward101j.mail.yandex.net ([5.45.198.241]:49780 "EHLO
        forward101j.mail.yandex.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726996AbgDHNXQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 8 Apr 2020 09:23:16 -0400
X-Greylist: delayed 363 seconds by postgrey-1.27 at vger.kernel.org; Wed, 08 Apr 2020 09:23:14 EDT
Received: from forward101q.mail.yandex.net (forward101q.mail.yandex.net [IPv6:2a02:6b8:c0e:4b:0:640:4012:bb98])
        by forward101j.mail.yandex.net (Yandex) with ESMTP id 2B0DD1BE259D;
        Wed,  8 Apr 2020 16:17:10 +0300 (MSK)
Received: from mxback7q.mail.yandex.net (mxback7q.mail.yandex.net [IPv6:2a02:6b8:c0e:41:0:640:cbbf:d618])
        by forward101q.mail.yandex.net (Yandex) with ESMTP id 28170CF40007;
        Wed,  8 Apr 2020 16:17:10 +0300 (MSK)
Received: from vla4-2e76570dd7f5.qloud-c.yandex.net (vla4-2e76570dd7f5.qloud-c.yandex.net [2a02:6b8:c17:c8b:0:640:2e76:570d])
        by mxback7q.mail.yandex.net (mxback/Yandex) with ESMTP id yyyfb7s1NS-H9x026fN;
        Wed, 08 Apr 2020 16:17:10 +0300
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yandex.ru; s=mail; t=1586351830;
        bh=QICxSrOBFKEqCY/3Lc54+2QUvUNhDgqEpKodDF5z+hw=;
        h=In-Reply-To:Cc:To:From:Subject:References:Date:Message-ID;
        b=klGqDbBm6qFEA4IeFtQ84Wdke69SIVV36iC8bADRA9wueDhM1yAC6GowbEsiw/Ccb
         eD7P8wYUAbVkt8SD0Ry6rrhgZhsn9a7ophx/VaVEnPY2fzFDovdajeslBa6DIjrC14
         /0H3hJj0cVH66M5f+algGkygYfGXK+76FPieq+Nk=
Authentication-Results: mxback7q.mail.yandex.net; dkim=pass header.i=@yandex.ru
Received: by vla4-2e76570dd7f5.qloud-c.yandex.net (smtp/Yandex) with ESMTPSA id omL8cJmw5C-H8WaEfNU;
        Wed, 08 Apr 2020 16:17:08 +0300
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (Client certificate not present)
Message-ID: <e6140ec9728e5695bbd99270f1ed6b60aab8cf48.camel@yandex.ru>
Subject: Re: [PATCH] virtio: virtio_console: add missing
 MODULE_DEVICE_TABLE() for rproc serial
From:   Alexander Lobakin <bloodyreaper@yandex.ru>
To:     Amit Shah <amit@kernel.org>
Cc:     Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sjur Brandeland <sjur.brandeland@stericsson.com>,
        Rusty Russell <rusty@rustcorp.com.au>,
        virtualization@lists.linux-foundation.org, stable@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date:   Wed, 08 Apr 2020 16:17:07 +0300
In-Reply-To: <f09bacf3029edfc7f90097f7fc6e41176ddd4873.camel@kernel.org>
References: <20200310110538.19254-1-alobakin@dlink.ru>
         <f09bacf3029edfc7f90097f7fc6e41176ddd4873.camel@kernel.org>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, 2020-03-11 at 15:53 +0100, Amit Shah wrote:
> On Tue, 2020-03-10 at 14:05 +0300, Alexander Lobakin wrote:
> > rproc_serial_id_table lacks an exposure to module devicetable, so
> > when remoteproc firmware requests VIRTIO_ID_RPROC_SERIAL, no uevent
> > is generated and no module autoloading occurs.
> > Add missing MODULE_DEVICE_TABLE() annotation and move the existing
> > one for VIRTIO_ID_CONSOLE right to the table itself.
> > 
> > Fixes: 1b6370463e88 ("virtio_console: Add support for remoteproc
> > serial")
> > Cc: <stable@vger.kernel.org> # v3.8+
> > Signed-off-by: Alexander Lobakin <alobakin@dlink.ru>
> 
> Reviewed-by: Amit Shah <amit@kernel.org>

Thank you! Well, who will take this into his tree?

> Thanks,
> 
> > ---
> >  drivers/char/virtio_console.c | 3 ++-
> >  1 file changed, 2 insertions(+), 1 deletion(-)
> > 
> > diff --git a/drivers/char/virtio_console.c
> > b/drivers/char/virtio_console.c
> > index 4df9b40d6342..7e1bc0f580a2 100644
> > --- a/drivers/char/virtio_console.c
> > +++ b/drivers/char/virtio_console.c
> > @@ -2116,6 +2116,7 @@ static struct virtio_device_id id_table[] = {
> >  	{ VIRTIO_ID_CONSOLE, VIRTIO_DEV_ANY_ID },
> >  	{ 0 },
> >  };
> > +MODULE_DEVICE_TABLE(virtio, id_table);
> >  
> >  static unsigned int features[] = {
> >  	VIRTIO_CONSOLE_F_SIZE,
> > @@ -2128,6 +2129,7 @@ static struct virtio_device_id
> > rproc_serial_id_table[] = {
> >  #endif
> >  	{ 0 },
> >  };
> > +MODULE_DEVICE_TABLE(virtio, rproc_serial_id_table);
> >  
> >  static unsigned int rproc_serial_features[] = {
> >  };
> > @@ -2280,6 +2282,5 @@ static void __exit fini(void)
> >  module_init(init);
> >  module_exit(fini);
> >  
> > -MODULE_DEVICE_TABLE(virtio, id_table);
> >  MODULE_DESCRIPTION("Virtio console driver");
> >  MODULE_LICENSE("GPL");

