Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6628D492C45
	for <lists+stable@lfdr.de>; Tue, 18 Jan 2022 18:26:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347068AbiARRZv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Jan 2022 12:25:51 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:23553 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1347083AbiARRZv (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 18 Jan 2022 12:25:51 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1642526749;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=rR/bu37Is80SlqeUGWI0t9CgSie0s+VhhWDwdSOZaOM=;
        b=RWgdM5xQ7zosII5pAJiQKnPWw03CgZWk7+ZgUaLK3F4fLfo19cNlOUf5jKYEucEchnWbaR
        FfxW6kMDIL+/fEr6UK20x1UcR0RCoAbCJvOR+oUtniZDK5NYfjq4n6KXI9QplccN1MyKCi
        2kakOTfNbGdWGXku4Xdwf9V7ps3mYL0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-632-p40EvUEhNN6kNZ7FxO2S4Q-1; Tue, 18 Jan 2022 12:25:46 -0500
X-MC-Unique: p40EvUEhNN6kNZ7FxO2S4Q-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 51FCB11185D0;
        Tue, 18 Jan 2022 17:10:07 +0000 (UTC)
Received: from localhost (unknown [10.39.194.139])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id B74817A3F9;
        Tue, 18 Jan 2022 17:10:06 +0000 (UTC)
From:   Cornelia Huck <cohuck@redhat.com>
To:     "Michael S. Tsirkin" <mst@redhat.com>
Cc:     Jason Wang <jasowang@redhat.com>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, Halil Pasic <pasic@linux.ibm.com>,
        virtualization@lists.linux-foundation.org
Subject: Re: [PATCH] virtio: acknowledge all features before access
In-Reply-To: <20220118104318-mutt-send-email-mst@kernel.org>
Organization: Red Hat GmbH
References: <20220114200744.150325-1-mst@redhat.com>
 <d6c4e521-1538-bbbf-30e6-f658a095b3ae@redhat.com>
 <20220117032429-mutt-send-email-mst@kernel.org>
 <87mtjuv8od.fsf@redhat.com>
 <20220118104318-mutt-send-email-mst@kernel.org>
User-Agent: Notmuch/0.34 (https://notmuchmail.org)
Date:   Tue, 18 Jan 2022 18:10:05 +0100
Message-ID: <871r15dl76.fsf@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jan 18 2022, "Michael S. Tsirkin" <mst@redhat.com> wrote:

> On Mon, Jan 17, 2022 at 01:38:42PM +0100, Cornelia Huck wrote:
>> On Mon, Jan 17 2022, "Michael S. Tsirkin" <mst@redhat.com> wrote:
>>=20
>> > On Mon, Jan 17, 2022 at 02:31:49PM +0800, Jason Wang wrote:
>> >>=20
>> >> =E5=9C=A8 2022/1/15 =E4=B8=8A=E5=8D=884:09, Michael S. Tsirkin =E5=86=
=99=E9=81=93:
>> >> > @@ -495,6 +494,10 @@ int virtio_device_restore(struct virtio_device=
 *dev)
>> >> >   	/* We have a driver! */
>> >> >   	virtio_add_status(dev, VIRTIO_CONFIG_S_DRIVER);
>> >> > +	ret =3D dev->config->finalize_features(dev);
>> >> > +	if (ret)
>> >> > +		goto err;
>> >>=20
>> >>=20
>> >> Is this part of code related?
>> >>=20
>> >> Thanks
>> >>=20
>> >
>> > Yes. virtio_finalize_features no longer calls dev->config->finalize_fe=
atures.
>> >
>> > I think the dev->config->finalize_features callback is actually
>> > a misnomer now, it just sends the features to device,
>> > finalize is FEATURES_OK. Renaming that is a bigger
>> > patch though, and I'd like this one to be cherry-pickable
>> > to stable.
>>=20
>> Do we want to add a comment before the calls to ->finalize_features()
>> (/* write features to device */) and adapt the comment in virtio_ring.h?
>> Should still be stable-friendly, and giving the callback a better name
>> can be a follow-up patch.
>
> Sorry which comment in virtio_ring.h?
> Could not find anything.

Typo; I ment virtio_config.h...

>
>> >
>> >> > +
>> >> >   	ret =3D virtio_finalize_features(dev);
>> >> >   	if (ret)
>> >> >   		goto err;

