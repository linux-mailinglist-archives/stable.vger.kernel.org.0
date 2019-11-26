Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E7FAA10A301
	for <lists+stable@lfdr.de>; Tue, 26 Nov 2019 18:08:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728637AbfKZRIB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 Nov 2019 12:08:01 -0500
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:33335 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727309AbfKZRIB (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 26 Nov 2019 12:08:01 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1574788079;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=OE+pMqAYuSGW+8XsdUke2OVyATMfLxNIDaDUwn6m4HE=;
        b=SMQGTRY+gFKify20Q4ZblVNWYmcvAyc7cA1+BzjE9Wiqcy3U9VsNa/UdiYi5NwKs4ctI1+
        elv7dS06mAZ7/Inz2+df0L5soVjmUyg7oMKyTeHLKAauUhPXrfoFprwKgOlPiRKXQItH2P
        gfeGPXnGEEmXcsDrh0Dvq3VTBuQO0V4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-198-rA6ze4ZNPca1SNuY_xsLMw-1; Tue, 26 Nov 2019 12:07:58 -0500
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C72E81005509;
        Tue, 26 Nov 2019 17:07:56 +0000 (UTC)
Received: from localhost (unknown [10.18.25.174])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 8E56E5D9CD;
        Tue, 26 Nov 2019 17:07:56 +0000 (UTC)
Date:   Tue, 26 Nov 2019 12:07:55 -0500
From:   Mike Snitzer <snitzer@redhat.com>
To:     gregkh@linuxfoundation.org
Cc:     vcaputo@pengaru.com, stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] Revert "dm crypt: use WQ_HIGHPRI for the
 IO and crypt" failed to apply to 4.14-stable tree
Message-ID: <20191126170755.GB2718@redhat.com>
References: <1574764864161192@kroah.com>
MIME-Version: 1.0
In-Reply-To: <1574764864161192@kroah.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
X-MC-Unique: rA6ze4ZNPca1SNuY_xsLMw-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Nov 26 2019 at  5:41am -0500,
gregkh@linuxfoundation.org <gregkh@linuxfoundation.org> wrote:

>=20
> The patch below does not apply to the 4.14-stable tree.
> If someone wants it applied there, or to any other stable or longterm
> tree, then please email the backport, including the original git commit
> id to <stable@vger.kernel.org>.
>=20
> thanks,
>=20
> greg k-h

Same as 4.19 goes for 4.14, this worked for me:

git cherry-pick ed0302e83098d
git cherry-pick f612b2132db529feac4f965f28a1b9258ea7c22b

Do your stable@ scripts actually look at Requires: tags?

Mike


> ------------------ original commit in Linus's tree ------------------
>=20
> From f612b2132db529feac4f965f28a1b9258ea7c22b Mon Sep 17 00:00:00 2001
> From: Mike Snitzer <snitzer@redhat.com>
> Date: Wed, 20 Nov 2019 17:27:39 -0500
> Subject: [PATCH] Revert "dm crypt: use WQ_HIGHPRI for the IO and crypt
>  workqueues"
>=20
> This reverts commit a1b89132dc4f61071bdeaab92ea958e0953380a1.
>=20
> Revert required hand-patching due to subsequent changes that were
> applied since commit a1b89132dc4f61071bdeaab92ea958e0953380a1.
>=20
> Requires: ed0302e83098d ("dm crypt: make workqueue names device-specific"=
)
> Cc: stable@vger.kernel.org
> Bug: https://bugzilla.kernel.org/show_bug.cgi?id=3D199857
> Reported-by: Vito Caputo <vcaputo@pengaru.com>
> Signed-off-by: Mike Snitzer <snitzer@redhat.com>
>=20
> diff --git a/drivers/md/dm-crypt.c b/drivers/md/dm-crypt.c
> index f87f6495652f..eb9782fc93fe 100644
> --- a/drivers/md/dm-crypt.c
> +++ b/drivers/md/dm-crypt.c
> @@ -2700,21 +2700,18 @@ static int crypt_ctr(struct dm_target *ti, unsign=
ed int argc, char **argv)
>  =09}
> =20
>  =09ret =3D -ENOMEM;
> -=09cc->io_queue =3D alloc_workqueue("kcryptd_io/%s",
> -=09=09=09=09       WQ_HIGHPRI | WQ_CPU_INTENSIVE | WQ_MEM_RECLAIM,
> -=09=09=09=09       1, devname);
> +=09cc->io_queue =3D alloc_workqueue("kcryptd_io/%s", WQ_MEM_RECLAIM, 1, =
devname);
>  =09if (!cc->io_queue) {
>  =09=09ti->error =3D "Couldn't create kcryptd io queue";
>  =09=09goto bad;
>  =09}
> =20
>  =09if (test_bit(DM_CRYPT_SAME_CPU, &cc->flags))
> -=09=09cc->crypt_queue =3D alloc_workqueue("kcryptd/%s",
> -=09=09=09=09=09=09  WQ_HIGHPRI | WQ_CPU_INTENSIVE | WQ_MEM_RECLAIM,
> +=09=09cc->crypt_queue =3D alloc_workqueue("kcryptd/%s", WQ_CPU_INTENSIVE=
 | WQ_MEM_RECLAIM,
>  =09=09=09=09=09=09  1, devname);
>  =09else
>  =09=09cc->crypt_queue =3D alloc_workqueue("kcryptd/%s",
> -=09=09=09=09=09=09  WQ_HIGHPRI | WQ_CPU_INTENSIVE | WQ_MEM_RECLAIM | WQ_=
UNBOUND,
> +=09=09=09=09=09=09  WQ_CPU_INTENSIVE | WQ_MEM_RECLAIM | WQ_UNBOUND,
>  =09=09=09=09=09=09  num_online_cpus(), devname);
>  =09if (!cc->crypt_queue) {
>  =09=09ti->error =3D "Couldn't create kcryptd queue";
>=20

