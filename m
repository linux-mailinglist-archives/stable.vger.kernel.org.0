Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0365C59EA7D
	for <lists+stable@lfdr.de>; Tue, 23 Aug 2022 20:05:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233751AbiHWSDO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Aug 2022 14:03:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59340 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233797AbiHWSCk (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Aug 2022 14:02:40 -0400
Received: from sender-of-o50.zoho.in (sender-of-o50.zoho.in [103.117.158.50])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3DCB599273;
        Tue, 23 Aug 2022 09:08:43 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1661270904; cv=none; 
        d=zohomail.in; s=zohoarc; 
        b=JVbN+o5FIkISrOPZjQPBvu7OtJzN5G0kKXh7ZPoAz8eC9NXnhSBCwprJ6TF2X4asewUz/yenEjwIgIiPvLrA7h+gta3HpdyFjm/it43ikI5+9wNwfLVLviOJtDC/xGXV3bGjlXRUCujm9SpOVaq3drWXLZSvwhqoBBU0fy27ePc=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.in; s=zohoarc; 
        t=1661270904; h=Content-Type:Content-Transfer-Encoding:Cc:Date:From:MIME-Version:Message-ID:Subject:To; 
        bh=UjlKgz2xV4xjj14J2LSVuB5e7dOd3HlE+vr/w0QgVZY=; 
        b=WHiautuSleOVUZ1HN15b6q2eN4Ww7jAUeZeBaFmfgFha3QC3VZ6/scZ9Y+VW9vjc15EGDVqhfCgOuZYGfcUweOcwWB1Laku9NzJ16nPd7k1BqQTnK0vz3vfyxlfwNGFC2fUoieItEf4hb8xUopcSr2i23hzmLIx/hKUAF0ayeHM=
ARC-Authentication-Results: i=1; mx.zohomail.in;
        dkim=pass  header.i=siddh.me;
        spf=pass  smtp.mailfrom=code@siddh.me;
        dmarc=pass header.from=<code@siddh.me>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1661270904;
        s=zmail; d=siddh.me; i=code@siddh.me;
        h=From:From:To:To:Cc:Cc:Message-ID:Subject:Subject:Date:Date:MIME-Version:Content-Transfer-Encoding:Content-Type:Message-Id:Reply-To;
        bh=UjlKgz2xV4xjj14J2LSVuB5e7dOd3HlE+vr/w0QgVZY=;
        b=eDrovX6Mi9EX6AYter3SwakhVr0/cg9vJe4zqQeZYHzPotfHPdliEIV8aT8Se/om
        GZaiYUGXu4AGTvESCJVUbDwa7nMZ8K0o3KIYLKZH2E7DHzPqBwzC3mWJLwKRd+HzdZE
        66aJYjlRmyaZHmfJ5MDJQfYAxHlUy5MvydthSLG0=
Received: from localhost.localdomain (103.249.234.81 [103.249.234.81]) by mx.zoho.in
        with SMTPS id 166127090391618.64430756700915; Tue, 23 Aug 2022 21:38:23 +0530 (IST)
From:   Siddh Raman Pant <code@siddh.me>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Matthew Wilcox <willy@infradead.org>,
        Christoph Hellwig <hch@infradead.org>,
        linux-block <linux-block@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-kernel-mentees 
        <linux-kernel-mentees@lists.linuxfoundation.org>,
        syzbot+a8e049cd3abd342936b6@syzkaller.appspotmail.com,
        stable@vger.kernel.org
Message-ID: <20220823160810.181275-1-code@siddh.me>
Subject: [PATCH v2] loop: Check for overflow while configuring loop
Date:   Tue, 23 Aug 2022 21:38:10 +0530
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-ZohoMailClient: External
Content-Type: text/plain; charset=utf8
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_RED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The userspace can configure a loop using an ioctl call, wherein
a configuration of type loop_config is passed (see lo_ioctl()'s
case on line 1550 of drivers/block/loop.c). This proceeds to call
loop_configure() which in turn calls loop_set_status_from_info()
(see line 1050 of loop.c), passing &config->info which is of type
loop_info64*. This function then sets the appropriate values, like
the offset.

loop_device has lo_offset of type loff_t (see line 52 of loop.c),
which is typdef-chained to long long, whereas loop_info64 has
lo_offset of type __u64 (see line 56 of include/uapi/linux/loop.h).

The function directly copies offset from info to the device as
follows (See line 980 of loop.c):
=09lo->lo_offset =3D info->lo_offset;

This results in an overflow, which triggers a warning in iomap_iter()
due to a call to iomap_iter_done() which has:
=09WARN_ON_ONCE(iter->iomap.offset > iter->pos);

Thus, check for negative value during loop_set_status_from_info().

Bug report: https://syzkaller.appspot.com/bug?id=3Dc620fe14aac810396d3c3edc=
9ad73848bf69a29e
Reported-and-tested-by: syzbot+a8e049cd3abd342936b6@syzkaller.appspotmail.c=
om
Cc: stable@vger.kernel.org
Reviewed-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Siddh Raman Pant <code@siddh.me>
---
Changes since v1:
- Do not break userspace API, so check loop_device for overflow.
- Use EOVERFLOW instead of EINVAL.

 drivers/block/loop.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/block/loop.c b/drivers/block/loop.c
index e3c0ba93c1a3..ad92192c7d61 100644
--- a/drivers/block/loop.c
+++ b/drivers/block/loop.c
@@ -979,6 +979,11 @@ loop_set_status_from_info(struct loop_device *lo,
=20
 =09lo->lo_offset =3D info->lo_offset;
 =09lo->lo_sizelimit =3D info->lo_sizelimit;
+
+=09/* loff_t vars have been assigned __u64 */
+=09if (lo->lo_offset < 0 || lo->lo_sizelimit < 0)
+=09=09return -EOVERFLOW;
+
 =09memcpy(lo->lo_file_name, info->lo_file_name, LO_NAME_SIZE);
 =09lo->lo_file_name[LO_NAME_SIZE-1] =3D 0;
 =09lo->lo_flags =3D info->lo_flags;
--=20
2.35.1


