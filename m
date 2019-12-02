Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B838D10F267
	for <lists+stable@lfdr.de>; Mon,  2 Dec 2019 22:52:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726179AbfLBVwE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 2 Dec 2019 16:52:04 -0500
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:36623 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725825AbfLBVwE (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 2 Dec 2019 16:52:04 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1575323523;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=b0+29zshaUbRjfxHy1HWRGMyTGil9Zlb7of0bIH6jfk=;
        b=bB6VERFmm9mB26AWcz3100XE4Jl3YMjxLN4YIzbtg4FOzBSAggWxcoqnswH3c1VplwStVX
        bEKFWaQ8TWwc/YMYBAif44IL1PqLz9LFVdhFFA+YbDQvb5pLaQ0HCtPkYS2gluFD4IdzCD
        ryIO6RkkrGi9jfillt1Au84+lIo4hhs=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-17--qmsZSzkMcWcu3MRxu67lQ-1; Mon, 02 Dec 2019 16:51:58 -0500
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 4AB74DB61;
        Mon,  2 Dec 2019 21:51:56 +0000 (UTC)
Received: from rh2.redhat.com (ovpn-126-161.rdu2.redhat.com [10.10.126.161])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 73E6A19C68;
        Mon,  2 Dec 2019 21:51:52 +0000 (UTC)
From:   Mike Christie <mchristi@redhat.com>
To:     sunke32@huawei.com, nbd@other.debian.org, axboe@kernel.dk,
        josef@toxicpanda.com, linux-block@vger.kernel.org
Cc:     Mike Christie <mchristi@redhat.com>, stable@vger.kernel.org
Subject: [PATCH] nbd: fix shutdown and recv work deadlock
Date:   Mon,  2 Dec 2019 15:51:50 -0600
Message-Id: <20191202215150.10250-1-mchristi@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
X-MC-Unique: -qmsZSzkMcWcu3MRxu67lQ-1
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

where we can deadlock during device shutdown. The problem will occur if
userpsace has done a NBD_CLEAR_SOCK call, then does close() before the
recv_work work has done its nbd_config_put() call. If recv_work does the
last call then it will do destroy_workqueue which will then be stuck
waiting for the work we are running from.

This fixes the issue by having nbd_start_device_ioctl flush the work
queue on both the failure and success cases and has a refcount on the
nbd_device while it is flushing the work queue.

Cc: stable@vger.kernel.org
Signed-off-by: Mike Christie <mchristi@redhat.com>
---
 drivers/block/nbd.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/block/nbd.c b/drivers/block/nbd.c
index 57532465fb83..f8597d2fb365 100644
--- a/drivers/block/nbd.c
+++ b/drivers/block/nbd.c
@@ -1293,13 +1293,15 @@ static int nbd_start_device_ioctl(struct nbd_device=
 *nbd, struct block_device *b
=20
 =09if (max_part)
 =09=09bdev->bd_invalidated =3D 1;
+
+=09refcount_inc(&nbd->config_refs);
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
@@ -1307,6 +1309,7 @@ static int nbd_start_device_ioctl(struct nbd_device *=
nbd, struct block_device *b
 =09=09ret =3D 0;
 =09if (test_bit(NBD_RT_TIMEDOUT, &config->runtime_flags))
 =09=09ret =3D -ETIMEDOUT;
+=09nbd_config_put(nbd);
 =09return ret;
 }
=20
--=20
2.20.1

