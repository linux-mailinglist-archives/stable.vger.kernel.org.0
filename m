Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A32C7116408
	for <lists+stable@lfdr.de>; Sun,  8 Dec 2019 23:52:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726684AbfLHWwA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 8 Dec 2019 17:52:00 -0500
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:40033 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726661AbfLHWwA (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 8 Dec 2019 17:52:00 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1575845519;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=uxowTAVazvKFjO4M9Fa4G18zrvWzg1FDkS8+HQr9N4E=;
        b=hUkUJjNCiFIvfhc4ImVFq9lWWrt2Zmpg9E3UKMSlq2k2ZVPwZWeScQHGCCGEE6x2iVMdaN
        WrhkWGgtqrQ6MsPOVHbTFawDxzc3khGl7+nb9tX9i/tKtWau0mC+j62Iz2IMw644kkRclV
        BA/Voz73y4e5ipFnBeYDriPDiWJ9sVw=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-316-zxUypHxhPRW5qQAZlAoKyg-1; Sun, 08 Dec 2019 17:51:55 -0500
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 5EA40107ACC4;
        Sun,  8 Dec 2019 22:51:54 +0000 (UTC)
Received: from rh2.redhat.com (ovpn-120-141.rdu2.redhat.com [10.10.120.141])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 000B319C5B;
        Sun,  8 Dec 2019 22:51:52 +0000 (UTC)
From:   Mike Christie <mchristi@redhat.com>
To:     sunke32@huawei.com, nbd@other.debian.org, axboe@kernel.dk,
        josef@toxicpanda.com, linux-block@vger.kernel.org
Cc:     Mike Christie <mchristi@redhat.com>, stable@vger.kernel.org
Subject: [PATCH] nbd: fix shutdown and recv work deadlock v2
Date:   Sun,  8 Dec 2019 16:51:50 -0600
Message-Id: <20191208225150.5944-1-mchristi@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
X-MC-Unique: zxUypHxhPRW5qQAZlAoKyg-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This fixes a regression added with:

commit e9e006f5fcf2bab59149cb38a48a4817c1b538b4
Author: Mike Christie <mchristi@redhat.com>
Date:   Sun Aug 4 14:10:06 2019 -0500

    nbd: fix max number of supported devs

where we can deadlock during device shutdown. The problem occurs if
the recv_work's nbd_config_put occurs after nbd_start_device_ioctl has
returned and the userspace app has droppped its reference via closing
the device and running nbd_release. The recv_work nbd_config_put call
would then drop the refcount to zero and try to destroy the config which
would try to do destroy_workqueue from the recv work.

This patch just has nbd_start_device_ioctl do a flush_workqueue when it
wakes so we know after the ioctl returns running works have exited. This
also fixes a possible race where we could try to reuse the device while
old recv_works are still running.

Cc: stable@vger.kernel.org
Signed-off-by: Mike Christie <mchristi@redhat.com>
---
v2:
- Drop the taking/dropping of a config_refs around the ioctl. This is
not needed because the caller has incremented the refcount already via
the open() call before doing the ioctl().

 drivers/block/nbd.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/block/nbd.c b/drivers/block/nbd.c
index 57532465fb83..b4607dd96185 100644
--- a/drivers/block/nbd.c
+++ b/drivers/block/nbd.c
@@ -1296,10 +1296,10 @@ static int nbd_start_device_ioctl(struct nbd_device=
 *nbd, struct block_device *b
 =09mutex_unlock(&nbd->config_lock);
 =09ret =3D wait_event_interruptible(config->recv_wq,
 =09=09=09=09=09 atomic_read(&config->recv_threads) =3D=3D 0);
-=09if (ret) {
+=09if (ret)
 =09=09sock_shutdown(nbd);
-=09=09flush_workqueue(nbd->recv_workq);
-=09}
+=09flush_workqueue(nbd->recv_workq);
+
 =09mutex_lock(&nbd->config_lock);
 =09nbd_bdev_reset(bdev);
 =09/* user requested, ignore socket errors */
--=20
2.20.1

