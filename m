Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 78FF259AD97
	for <lists+stable@lfdr.de>; Sat, 20 Aug 2022 13:42:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344838AbiHTLlt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 20 Aug 2022 07:41:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59018 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241192AbiHTLls (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 20 Aug 2022 07:41:48 -0400
Received: from sender-of-o50.zoho.in (sender-of-o50.zoho.in [103.117.158.50])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC8909BB77;
        Sat, 20 Aug 2022 04:41:46 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1660995689; cv=none; 
        d=zohomail.in; s=zohoarc; 
        b=bzuIDQA+sR7ZiWE9DXMgKg0fHNUajlNkGygoTkXW2MW91KjrK5GL9eOKirNwxsPs/bJnNxQhnrknPFPij2k245WT0qW3D9ehEf52EbnOgIYV5FcRmt0UP5siCMl70q70faYcZAIhWPVIxmBHPr5TFhT/a2VU0hP4X9HwO8DZyjU=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.in; s=zohoarc; 
        t=1660995689; h=Content-Type:Content-Transfer-Encoding:Cc:Date:From:MIME-Version:Message-ID:Subject:To; 
        bh=OwlirewM9MHK3jNUDVvfjUe6e2E0DI0dbUmH8k2UzYQ=; 
        b=GenioD5MecWkzSLRl/rhBypTtzqh1kkoLFw6k0FFqzkxpS8oGBx2LQASZNBlwQiz/k/4V4pgo3lArz+X2njw4pConEvuJE/v7KG8BpzgJNyeYx7OKReBvZjRVN85YedcxivMXxYTRPt4qmBYAqWdgMypT1LoMkK5opXE1HDkF0s=
ARC-Authentication-Results: i=1; mx.zohomail.in;
        dkim=pass  header.i=siddh.me;
        spf=pass  smtp.mailfrom=code@siddh.me;
        dmarc=pass header.from=<code@siddh.me>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1660995689;
        s=zmail; d=siddh.me; i=code@siddh.me;
        h=From:From:To:To:Cc:Cc:Message-ID:Subject:Subject:Date:Date:MIME-Version:Content-Transfer-Encoding:Content-Type:Message-Id:Reply-To;
        bh=OwlirewM9MHK3jNUDVvfjUe6e2E0DI0dbUmH8k2UzYQ=;
        b=fbzEaX1s4LxtB1mccW6+EkXK8lpWzjKTQ6YE28zZS4Z1v0I+Fjkwh9aFFNlfRXMo
        oLl/vzp3vCh/x/gPreCbabPT6O+WmH2NSifKmHL3//s7PlDfHdeTVUoHkhGW4duTx4w
        3wcFsrXaZborYmXeobgoRkGXwvLhjr5Xo4i6GcaE=
Received: from localhost.localdomain (43.250.157.244 [43.250.157.244]) by mx.zoho.in
        with SMTPS id 1660995687489847.0225686061804; Sat, 20 Aug 2022 17:11:27 +0530 (IST)
From:   Siddh Raman Pant <code@siddh.me>
To:     Jens Axboe <axboe@kernel.dk>, Carlos Llamas <cmllamas@google.com>
Cc:     linux-block <linux-block@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-kernel-mentees 
        <linux-kernel-mentees@lists.linuxfoundation.org>,
        syzbot+a8e049cd3abd342936b6@syzkaller.appspotmail.com,
        stable@vger.kernel.org
Message-ID: <20220820114105.8792-1-code@siddh.me>
Subject: [PATCH] loop: Correct UAPI definitions to match with driver
Date:   Sat, 20 Aug 2022 17:11:05 +0530
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

Syzkaller has reported a warning in iomap_iter(), which got
triggered due to a call to iomap_iter_done() which has:
=09WARN_ON_ONCE(iter->iomap.offset > iter->pos);

The warning was triggered because `pos` was being negative.
I was having offset =3D 0, pos =3D -2950420705881096192.

This ridiculously negative value smells of an overflow, and sure
it is.

The userspace can configure a loop using an ioctl call, wherein
a configuration of type loop_config is passed (see lo_ioctl()'s
case on line 1550 of drivers/block/loop.c). This proceeds to call
loop_configure() which in turn calls loop_set_status_from_info()
(see line 1050 of loop.c), passing &config->info which is of type
loop_info64*. This function then sets the appropriate values, like
the offset.

The problem here is loop_device has lo_offset of type loff_t
(see line 52 of loop.c), which is typdef-chained to long long,
whereas loop_info64 has lo_offset of type __u64 (see line 56 of
include/uapi/linux/loop.h).

The function directly copies offset from info to the device as
follows (See line 980 of loop.c):
=09lo->lo_offset =3D info->lo_offset;

This results in the encountered overflow (in my case, the RHS
was 15496323367828455424).

Thus, convert the type definitions in loop_info64 to their
signed counterparts in order to match definitions in loop_device,
and check for negative value during loop_set_status_from_info().

Bug report: https://syzkaller.appspot.com/bug?id=3Dc620fe14aac810396d3c3edc=
9ad73848bf69a29e
Reported-and-tested-by: syzbot+a8e049cd3abd342936b6@syzkaller.appspotmail.c=
om
Cc: stable@vger.kernel.org
Signed-off-by: Siddh Raman Pant <code@siddh.me>
---
Unless I am missing any other uses or quirks of UAPI loop_info64,
I think this won't introduce regression, since if something is
working, it will continue to work. If something does break, then
it was relying on overflows, which is anyways an incorrect way
to go about.

Also, it seems even the 32-bit compatibility structure uses the
signed types (compat_loop_info uses compat_int_t which is s32),
so this patch should be fine.

 drivers/block/loop.c      |  3 +++
 include/uapi/linux/loop.h | 12 ++++++------
 2 files changed, 9 insertions(+), 6 deletions(-)

diff --git a/drivers/block/loop.c b/drivers/block/loop.c
index e3c0ba93c1a3..4ca20ce3158d 100644
--- a/drivers/block/loop.c
+++ b/drivers/block/loop.c
@@ -977,6 +977,9 @@ loop_set_status_from_info(struct loop_device *lo,
 =09=09return -EINVAL;
 =09}
=20
+=09if (info->lo_offset < 0 || info->lo_sizelimit < 0)
+=09=09return -EINVAL;
+
 =09lo->lo_offset =3D info->lo_offset;
 =09lo->lo_sizelimit =3D info->lo_sizelimit;
 =09memcpy(lo->lo_file_name, info->lo_file_name, LO_NAME_SIZE);
diff --git a/include/uapi/linux/loop.h b/include/uapi/linux/loop.h
index 6f63527dd2ed..973565f38f9d 100644
--- a/include/uapi/linux/loop.h
+++ b/include/uapi/linux/loop.h
@@ -53,12 +53,12 @@ struct loop_info64 {
 =09__u64=09=09   lo_device;=09=09=09/* ioctl r/o */
 =09__u64=09=09   lo_inode;=09=09=09/* ioctl r/o */
 =09__u64=09=09   lo_rdevice;=09=09=09/* ioctl r/o */
-=09__u64=09=09   lo_offset;
-=09__u64=09=09   lo_sizelimit;/* bytes, 0 =3D=3D max available */
-=09__u32=09=09   lo_number;=09=09=09/* ioctl r/o */
-=09__u32=09=09   lo_encrypt_type;=09=09/* obsolete, ignored */
-=09__u32=09=09   lo_encrypt_key_size;=09=09/* ioctl w/o */
-=09__u32=09=09   lo_flags;
+=09__s64=09=09   lo_offset;
+=09__s64=09=09   lo_sizelimit;/* bytes, 0 =3D=3D max available */
+=09__s32=09=09   lo_number;=09=09=09/* ioctl r/o */
+=09__s32=09=09   lo_encrypt_type;=09=09/* obsolete, ignored */
+=09__s32=09=09   lo_encrypt_key_size;=09=09/* ioctl w/o */
+=09__s32=09=09   lo_flags;
 =09__u8=09=09   lo_file_name[LO_NAME_SIZE];
 =09__u8=09=09   lo_crypt_name[LO_NAME_SIZE];
 =09__u8=09=09   lo_encrypt_key[LO_KEY_SIZE]; /* ioctl w/o */
--=20
2.35.1


