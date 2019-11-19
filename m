Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E5BCF1021DB
	for <lists+stable@lfdr.de>; Tue, 19 Nov 2019 11:17:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727522AbfKSKRj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Nov 2019 05:17:39 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:27096 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725798AbfKSKRi (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 19 Nov 2019 05:17:38 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1574158657;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=0AOHcP3c9sS8PxErrT8l0/ogvBo+AjMH4hXjQihxI48=;
        b=g3Z7ZstKpJXGCXyZMQgVuJhptwlUO2FpbhMoex6ESE+k5CW2SibhykB9L3uQeBvZinlw8I
        D1GSgMTY0+s0MrcXHn7YJ4DQNjobei0wiQIQIq/xbQx1nd/zUHQ3TecEfE/r7q/gKd9Kxq
        Lxltb26jbViUAtwPOizs9rnsMdY1jpI=
Received: from mail-qk1-f200.google.com (mail-qk1-f200.google.com
 [209.85.222.200]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-227-PjBoM3T3MSyicfXP8lRD7Q-1; Tue, 19 Nov 2019 05:17:34 -0500
Received: by mail-qk1-f200.google.com with SMTP id a16so13274140qka.10
        for <stable@vger.kernel.org>; Tue, 19 Nov 2019 02:17:34 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition;
        bh=C3HkNm0+qQCyAC+XqSx4v/T4ymH2FW2P53DRSUplgxI=;
        b=Y43jK+CyURHx7Z7dI7yk8EU8BPe+Lu+u54gQK8lG/GRdeqidbue2FLWqnaBjCa4UtL
         U2Fzp2pcRcPfIZu1/LDN9vM3EhuRS8T/M/jXZFYmtOJFaCkFIpgS7AJ5nchtk8yvAV3m
         MxNE5JD+scOtPUYsTr92hLxiFJF6K6JNgYJu25OXAdR1idv4zDcpxIGFctjhOFj54XX+
         y/hyuuTVamdBzMB2szmZ9r7717wOYtktujO0K3YeL4qS+q9v+w+uQFtwBf9I4SLH/tNB
         LdANJX7DPsXTtVHrfTnaDkG1pJUWxRAxxzB8PqAzUirKjI4a50t9YQCC9A6a+Kv/Kn7X
         pWyA==
X-Gm-Message-State: APjAAAU3e08evdpdXe7NnPJUT9ff8eK+VqEKWbGQZ4pqlQvRV/oo/7KX
        hMiuAAdA63T72bmvziX/W3PasH5jPS38dx4kM6p1rHTL1saz1qr4HKzj7sRx7LQDdzmCzZrJLn/
        j+0Lvi9XtGyFqiTeG
X-Received: by 2002:a05:620a:1011:: with SMTP id z17mr28468366qkj.39.1574158653943;
        Tue, 19 Nov 2019 02:17:33 -0800 (PST)
X-Google-Smtp-Source: APXvYqySINoqX1Sr8Hk/5Eicx5OQ3SzUok/k0A0P8yPzqN+DDvTxHFFHeaMwsTVFb7bvD7eMWcSBZA==
X-Received: by 2002:a05:620a:1011:: with SMTP id z17mr28468353qkj.39.1574158653599;
        Tue, 19 Nov 2019 02:17:33 -0800 (PST)
Received: from redhat.com (bzq-79-176-6-42.red.bezeqint.net. [79.176.6.42])
        by smtp.gmail.com with ESMTPSA id f35sm11988511qtd.35.2019.11.19.02.17.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 Nov 2019 02:17:32 -0800 (PST)
Date:   Tue, 19 Nov 2019 05:17:28 -0500
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, Khazhismel Kumykov <khazhy@google.com>,
        Wei Wang <wei.w.wang@intel.com>,
        Jason Wang <jasowang@redhat.com>,
        virtualization@lists.linux-foundation.org
Subject: [PATCH] virtio_balloon: fix shrinker scan number of pages
Message-ID: <20191119101718.38976-1-mst@redhat.com>
MIME-Version: 1.0
X-Mailer: git-send-email 2.22.0.678.g13338e74b8
X-Mutt-Fcc: =sent
X-MC-Unique: PjBoM3T3MSyicfXP8lRD7Q-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

virtio_balloon_shrinker_scan should return number of system pages freed,
but because it's calling functions that deal with balloon pages, it gets
confused and sometimes returns the number of balloon pages.

It does not matter practically as the exact number isn't
used, but it seems better to be consistent in case someone
starts using this API.

Further, if we ever tried to iteratively leak pages as
virtio_balloon_shrinker_scan tries to do, we'd run into issues - this is
because freed_pages was accumulating total freed pages, but was also
subtracted on each iteration from pages_to_free, which can result in
either leaking less memory than we were supposed to free, or or more if
pages_to_free underruns.

On a system with 4K pages we are lucky that we are never asked to leak
more than 128 pages while we can leak up to 256 at a time,
but it looks like a real issue for systems with page size !=3D 4K.

Cc: stable@vger.kernel.org
Fixes: 71994620bb25 ("virtio_balloon: replace oom notifier with shrinker")
Reported-by: Khazhismel Kumykov <khazhy@google.com>
Reviewed-by: Wei Wang <wei.w.wang@intel.com>
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
---
 drivers/virtio/virtio_balloon.c | 17 +++++++++++------
 1 file changed, 11 insertions(+), 6 deletions(-)

diff --git a/drivers/virtio/virtio_balloon.c b/drivers/virtio/virtio_balloo=
n.c
index 226fbb995fb0..7cee05cdf3fb 100644
--- a/drivers/virtio/virtio_balloon.c
+++ b/drivers/virtio/virtio_balloon.c
@@ -772,6 +772,13 @@ static unsigned long shrink_free_pages(struct virtio_b=
alloon *vb,
 =09return blocks_freed << VIRTIO_BALLOON_FREE_PAGE_ORDER;
 }
=20
+static unsigned long leak_balloon_pages(struct virtio_balloon *vb,
+                                          unsigned long pages_to_free)
+{
+=09return leak_balloon(vb, pages_to_free * VIRTIO_BALLOON_PAGES_PER_PAGE) =
/
+=09=09VIRTIO_BALLOON_PAGES_PER_PAGE;
+}
+
 static unsigned long shrink_balloon_pages(struct virtio_balloon *vb,
 =09=09=09=09=09  unsigned long pages_to_free)
 {
@@ -782,11 +789,9 @@ static unsigned long shrink_balloon_pages(struct virti=
o_balloon *vb,
 =09 * VIRTIO_BALLOON_ARRAY_PFNS_MAX balloon pages, so we call it
 =09 * multiple times to deflate pages till reaching pages_to_free.
 =09 */
-=09while (vb->num_pages && pages_to_free) {
-=09=09pages_freed +=3D leak_balloon(vb, pages_to_free) /
-=09=09=09=09=09VIRTIO_BALLOON_PAGES_PER_PAGE;
-=09=09pages_to_free -=3D pages_freed;
-=09}
+=09while (vb->num_pages && pages_freed < pages_to_free)
+=09=09pages_freed +=3D leak_balloon_pages(vb, pages_to_free);
+
 =09update_balloon_size(vb);
=20
 =09return pages_freed;
@@ -799,7 +804,7 @@ static unsigned long virtio_balloon_shrinker_scan(struc=
t shrinker *shrinker,
 =09struct virtio_balloon *vb =3D container_of(shrinker,
 =09=09=09=09=09struct virtio_balloon, shrinker);
=20
-=09pages_to_free =3D sc->nr_to_scan * VIRTIO_BALLOON_PAGES_PER_PAGE;
+=09pages_to_free =3D sc->nr_to_scan;
=20
 =09if (virtio_has_feature(vb->vdev, VIRTIO_BALLOON_F_FREE_PAGE_HINT))
 =09=09pages_freed =3D shrink_free_pages(vb, pages_to_free);
--=20
MST

