Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 207CE4908C9
	for <lists+stable@lfdr.de>; Mon, 17 Jan 2022 13:38:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239934AbiAQMix (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Jan 2022 07:38:53 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:34697 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S239932AbiAQMix (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 Jan 2022 07:38:53 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1642423132;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=rqTVwBDvJkQkrgOjBOFOxTMhFtDY5gU77SJrn6Io5D8=;
        b=cGJtdDSeRoAya3wIzapLiDPUL49J32lLlfy8YkYf+Gw0rWPsMSUbEbaydLqBaloM+6O98A
        CBNGYdbX3p/Leb1jJMU/OpsLPEDAZVCvVkW2bQxRYH3hF+5b7PxgruubNif4x4+vEVKw2K
        OAl08QHpPnF9rGEb27uJJJRmJUYWpEo=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-646-QJzUXAueNpm3biCdYaoZbw-1; Mon, 17 Jan 2022 07:38:49 -0500
X-MC-Unique: QJzUXAueNpm3biCdYaoZbw-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 5010E1083F6B;
        Mon, 17 Jan 2022 12:38:48 +0000 (UTC)
Received: from localhost (unknown [10.39.194.14])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id E0A3974EB5;
        Mon, 17 Jan 2022 12:38:43 +0000 (UTC)
From:   Cornelia Huck <cohuck@redhat.com>
To:     "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Halil Pasic <pasic@linux.ibm.com>,
        virtualization@lists.linux-foundation.org
Subject: Re: [PATCH] virtio: acknowledge all features before access
In-Reply-To: <20220117032429-mutt-send-email-mst@kernel.org>
Organization: Red Hat GmbH
References: <20220114200744.150325-1-mst@redhat.com>
 <d6c4e521-1538-bbbf-30e6-f658a095b3ae@redhat.com>
 <20220117032429-mutt-send-email-mst@kernel.org>
User-Agent: Notmuch/0.34 (https://notmuchmail.org)
Date:   Mon, 17 Jan 2022 13:38:42 +0100
Message-ID: <87mtjuv8od.fsf@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jan 17 2022, "Michael S. Tsirkin" <mst@redhat.com> wrote:

> On Mon, Jan 17, 2022 at 02:31:49PM +0800, Jason Wang wrote:
>>=20
>> =E5=9C=A8 2022/1/15 =E4=B8=8A=E5=8D=884:09, Michael S. Tsirkin =E5=86=99=
=E9=81=93:
>> > @@ -495,6 +494,10 @@ int virtio_device_restore(struct virtio_device *d=
ev)
>> >   	/* We have a driver! */
>> >   	virtio_add_status(dev, VIRTIO_CONFIG_S_DRIVER);
>> > +	ret =3D dev->config->finalize_features(dev);
>> > +	if (ret)
>> > +		goto err;
>>=20
>>=20
>> Is this part of code related?
>>=20
>> Thanks
>>=20
>
> Yes. virtio_finalize_features no longer calls dev->config->finalize_featu=
res.
>
> I think the dev->config->finalize_features callback is actually
> a misnomer now, it just sends the features to device,
> finalize is FEATURES_OK. Renaming that is a bigger
> patch though, and I'd like this one to be cherry-pickable
> to stable.

Do we want to add a comment before the calls to ->finalize_features()
(/* write features to device */) and adapt the comment in virtio_ring.h?
Should still be stable-friendly, and giving the callback a better name
can be a follow-up patch.

>
>> > +
>> >   	ret =3D virtio_finalize_features(dev);
>> >   	if (ret)
>> >   		goto err;

