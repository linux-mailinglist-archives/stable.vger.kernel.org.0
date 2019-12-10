Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 55114117D93
	for <lists+stable@lfdr.de>; Tue, 10 Dec 2019 03:12:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726646AbfLJCM2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 9 Dec 2019 21:12:28 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:50371 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726605AbfLJCM2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 9 Dec 2019 21:12:28 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1575943946;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=AqNXb1DdFGH0UEVoh/67mONToQvKGHBSfZkAshMis24=;
        b=OkWDO0W2Y/Td11zNJQipGS2QyxGSwwGIyTvxtYMLqp5NKx9EiFQ8oQ6iL9xQ3tr7r6XlvD
        mJzHGWfIeEYv2HzYab/EJZUOQV/+PjNNxU7n0KcU5LMATyAIBu6mucWf8btKW16LP17+In
        MMG0l9+nEB9Tx8qsQLOwkcfK3N+0izc=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-232-YLXilXRBOQ-dHbPintc99A-1; Mon, 09 Dec 2019 21:12:23 -0500
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E60FE801E53;
        Tue, 10 Dec 2019 02:12:21 +0000 (UTC)
Received: from ming.t460p (ovpn-8-25.pek2.redhat.com [10.72.8.25])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 522541001925;
        Tue, 10 Dec 2019 02:12:14 +0000 (UTC)
Date:   Tue, 10 Dec 2019 10:12:10 +0800
From:   Ming Lei <ming.lei@redhat.com>
To:     Andreas Gruenbacher <agruenba@redhat.com>
Cc:     Jens Axboe <axboe@kernel.dk>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Junichi Nomura <j-nomura@ce.jp.nec.com>,
        Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>,
        linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH] block: fix "check bi_size overflow before merge"
Message-ID: <20191210021210.GB25022@ming.t460p>
References: <20191209191114.17266-1-agruenba@redhat.com>
MIME-Version: 1.0
In-Reply-To: <20191209191114.17266-1-agruenba@redhat.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
X-MC-Unique: YLXilXRBOQ-dHbPintc99A-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Dec 09, 2019 at 08:11:14PM +0100, Andreas Gruenbacher wrote:
> This partially reverts commit e3a5d8e386c3fb973fa75f2403622a8f3640ec06.
>=20
> Commit e3a5d8e386c3 ("check bi_size overflow before merge") adds a bio_fu=
ll
> check to __bio_try_merge_page.  This will cause __bio_try_merge_page to f=
ail
> when the last bi_io_vec has been reached.  Instead, what we want here is =
only
> the bi_size overflow check.
>=20
> Fixes: e3a5d8e386c3 ("block: check bi_size overflow before merge")
> Cc: stable@vger.kernel.org # v5.4+
> Signed-off-by: Andreas Gruenbacher <agruenba@redhat.com>
> ---
>  block/bio.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
>=20
> diff --git a/block/bio.c b/block/bio.c
> index 9d54aa37ce6c..a5d75f6bf4c7 100644
> --- a/block/bio.c
> +++ b/block/bio.c
> @@ -754,10 +754,12 @@ bool __bio_try_merge_page(struct bio *bio, struct p=
age *page,
>  =09if (WARN_ON_ONCE(bio_flagged(bio, BIO_CLONED)))
>  =09=09return false;
> =20
> -=09if (bio->bi_vcnt > 0 && !bio_full(bio, len)) {
> +=09if (bio->bi_vcnt > 0) {
>  =09=09struct bio_vec *bv =3D &bio->bi_io_vec[bio->bi_vcnt - 1];
> =20
>  =09=09if (page_is_mergeable(bv, page, len, off, same_page)) {
> +=09=09=09if (bio->bi_iter.bi_size > UINT_MAX - len)
> +=09=09=09=09return false;
>  =09=09=09bv->bv_len +=3D len;
>  =09=09=09bio->bi_iter.bi_size +=3D len;
>  =09=09=09return true;

page merging doesn't consume new bvec, so this patch is correct:

Reviewed-by: Ming Lei <ming.lei@redhat.com>

Thanks,
Ming

