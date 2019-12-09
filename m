Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E5D3111753A
	for <lists+stable@lfdr.de>; Mon,  9 Dec 2019 20:11:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726605AbfLITL0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 9 Dec 2019 14:11:26 -0500
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:21471 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726354AbfLITLZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 9 Dec 2019 14:11:25 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1575918684;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=WMZhpd4KgDtITiVnjNf/OLy9fA5Low7LZqWUO8jcLHM=;
        b=fH1caN+BCaHv4Y5ubqpdX44FIJ6iCyelIHAJ5L12Zk0H2RyAgZ8mYheDLflyQ9mfmtWkil
        m9Exd/YkPB8szXcIMb9yo2FrK6psVektDBJe0Unh82NuootgroQzda3CkJu3miiwgEHQ3+
        M5av3wOC10MBhhXsmBzDqFog0uvKcaE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-362-ULGsp7UxMWalpjBMxNes9A-1; Mon, 09 Dec 2019 14:11:23 -0500
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id DFBDB8017DF;
        Mon,  9 Dec 2019 19:11:21 +0000 (UTC)
Received: from max.com (ovpn-205-78.brq.redhat.com [10.40.205.78])
        by smtp.corp.redhat.com (Postfix) with ESMTP id EBBFE6055E;
        Mon,  9 Dec 2019 19:11:16 +0000 (UTC)
From:   Andreas Gruenbacher <agruenba@redhat.com>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        Junichi Nomura <j-nomura@ce.jp.nec.com>,
        Christoph Hellwig <hch@lst.de>, Ming Lei <ming.lei@redhat.com>,
        Hannes Reinecke <hare@suse.de>, linux-block@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Andreas Gruenbacher <agruenba@redhat.com>,
        stable@vger.kernel.org
Subject: [PATCH] block: fix "check bi_size overflow before merge"
Date:   Mon,  9 Dec 2019 20:11:14 +0100
Message-Id: <20191209191114.17266-1-agruenba@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
X-MC-Unique: ULGsp7UxMWalpjBMxNes9A-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This partially reverts commit e3a5d8e386c3fb973fa75f2403622a8f3640ec06.

Commit e3a5d8e386c3 ("check bi_size overflow before merge") adds a bio_full
check to __bio_try_merge_page.  This will cause __bio_try_merge_page to fai=
l
when the last bi_io_vec has been reached.  Instead, what we want here is on=
ly
the bi_size overflow check.

Fixes: e3a5d8e386c3 ("block: check bi_size overflow before merge")
Cc: stable@vger.kernel.org # v5.4+
Signed-off-by: Andreas Gruenbacher <agruenba@redhat.com>
---
 block/bio.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/block/bio.c b/block/bio.c
index 9d54aa37ce6c..a5d75f6bf4c7 100644
--- a/block/bio.c
+++ b/block/bio.c
@@ -754,10 +754,12 @@ bool __bio_try_merge_page(struct bio *bio, struct pag=
e *page,
 =09if (WARN_ON_ONCE(bio_flagged(bio, BIO_CLONED)))
 =09=09return false;
=20
-=09if (bio->bi_vcnt > 0 && !bio_full(bio, len)) {
+=09if (bio->bi_vcnt > 0) {
 =09=09struct bio_vec *bv =3D &bio->bi_io_vec[bio->bi_vcnt - 1];
=20
 =09=09if (page_is_mergeable(bv, page, len, off, same_page)) {
+=09=09=09if (bio->bi_iter.bi_size > UINT_MAX - len)
+=09=09=09=09return false;
 =09=09=09bv->bv_len +=3D len;
 =09=09=09bio->bi_iter.bi_size +=3D len;
 =09=09=09return true;
--=20
2.20.1

