Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D490F3BAD84
	for <lists+stable@lfdr.de>; Sun,  4 Jul 2021 16:55:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229557AbhGDO6K (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 4 Jul 2021 10:58:10 -0400
Received: from mout.gmx.net ([212.227.17.21]:38079 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229547AbhGDO6J (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 4 Jul 2021 10:58:09 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1625410532;
        bh=sOGXehM1tLZ6085q2bAyEipEHuIDLW99g0jEdsG2oko=;
        h=X-UI-Sender-Class:From:To:Cc:Subject:Date;
        b=KByv1+fLFfkFlb/oT6T5CHrnN+tCaib55Oip7pjBiS394gK9fxKEblAvsaNAo6XrS
         VR7IDbpBTjTEYs49QSRVGmYmKMFMFVHcWRjbe7/6PkAS6kAKMk1gQGW+AG6p5wzQ9D
         K+OTa5UX39he49OKgdXXmkWFukwporJYORJItJkY=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from localhost.localdomain ([83.52.228.41]) by mail.gmx.net
 (mrgmx104 [212.227.17.174]) with ESMTPSA (Nemesis) id
 1MA7GM-1lu1ub38bi-00Bg2d; Sun, 04 Jul 2021 16:55:31 +0200
From:   John Wood <john.wood@gmx.com>
To:     Marcel Holtmann <marcel@holtmann.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        Luiz Augusto von Dentz <luiz.dentz@gmail.com>
Cc:     John Wood <john.wood@gmx.com>, stable@vger.kernel.org,
        linux-bluetooth@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] bluetooth/virtio_bt: Fix dereference null return value
Date:   Sun,  4 Jul 2021 16:55:04 +0200
Message-Id: <20210704145504.24756-1-john.wood@gmx.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:+Bb+LJ6hEp5FkU0Ty6vgHXhvNSVHjKFxNZ32v7cj48ZledK+47z
 ho59QPdZI4SqrO/qg8OiC4qCNeY6xQcGffORnIcTsaoXcwvNcIFTFJiDDZUOSV1Vkcan5x4
 gZ69pgPe/cTDcozlflyNgNz5VKbI4xcGAUJ0ffD/yzsXMKHcZN6ryVTRVUpBTZWW3+ThsTc
 tCEqv9VwwU/iArj71yrFg==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:jfEjBhVmTbc=:XXFC+AsCMXRZqok/1arJ8E
 DH6R4NbF35KNeTSY7cjwA8USqJ2bltknRJzJKT95OKrqqq1EY67GjK3+LUlXw4wKVsx7g1UhK
 VBGldQvs9vkEVftIvAO1MSXbIjyFU8+bqfA5t1uMnGqqiAubK/f2UyFb6Dnkmys1nQXT/81S5
 uXb1TdPmyitBN22LhQjDMFD7WwuF7h0Ev1qCpqV7hxS03K4MvgD1ldJA/PvjhbQkK781xMezt
 fF4IGlUt2MKSYlejSwnf9GDnMNVhsXk2n6F+g5ZBVyBJYm6ojQ11QhWNi80/yRGhmTcHyu7gR
 3tTN7QkJK0IbvpFFeVBmzeSznkSSCcgnsdeuhDiIrtQP/ZXJR0PgmcD8AbSOqcHte0i0/NxHT
 YiW5nGpyJr0uEc9W3kdxs+QemKeCncWj9F70AkL657VBYZcvAlaMlAKwybsxE1a1qLg/fz1L1
 O0Wl8QzdwCLFa56AA8mSAzdIxdSoImWO3Za6QjPnPIL3Qv0zbZi9njQ8T3JNCiQ9tSbboFeWD
 jvx6D+MOZYvmlx2C0Y6CXk+wU+9WmaQAtDKfckkf4BBYz4cZM5Lkdx4ExE0I8KpLJBKYeHOlR
 Rc9OCbTXyE2Fcxh1zvyKWeOzS3RGerwXQ0l3kTEvE0TzeVMavc4Ipb2gIFo6q8xd8gDCJp9OQ
 77sHhrO1iaIx9K6bKfLoedJK7bsUvgQSiu8ZUZkRpAeIC57lFU0tCIr0GM98utB6r1maPAvBh
 j+DHJQzDKMZ+91gnFNQ/Xal64XGeDxpOTQLC4oRA/wOos8jOVNgE6NGi21AedC+seiAhzA7SQ
 HnN9f1OCtldrzghREwmBf4ngGbYfDnoimYsgPWKbgBWOQp+KVMLJhP4ffBeQ+aQBlnusHB5dR
 bMsjP16UtqKz7K4hI17A0QRIA8xvtjB2H1SoynKJhoo3UW1vt+IN9TdoTADwJ9eyP+qTdk9i+
 In/G0g4cGr3qrKA6Qyuz5crNaM0Ao3aJ+v7DeqMZ0kletTkFftEzSqBg1jVEN4OUlajikucD4
 TRN1u4jwtuHEWyR670Sl6YfJUIG5OUQF93tECcYR4VG/uskgD4aamh4elvVNmq1C3n4EDsEeN
 fLA9ZX7+2YwTibzavE12RmRQgBcldDtQzC/
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The alloc_skb function returns NULL on error. So, test this case and
avoid a NULL dereference (skb->data).

Addresses-Coverity-ID: 1484718 ("Dereference null return value")
Fixes: afd2daa26c7ab ("Bluetooth: Add support for virtio transport driver"=
)
Signed-off-by: John Wood <john.wood@gmx.com>
=2D--
 drivers/bluetooth/virtio_bt.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/bluetooth/virtio_bt.c b/drivers/bluetooth/virtio_bt.c
index c804db7e90f8..5f82574236c0 100644
=2D-- a/drivers/bluetooth/virtio_bt.c
+++ b/drivers/bluetooth/virtio_bt.c
@@ -34,6 +34,8 @@ static int virtbt_add_inbuf(struct virtio_bluetooth *vbt=
)
 	int err;

 	skb =3D alloc_skb(1000, GFP_KERNEL);
+	if (!skb)
+		return -ENOMEM;
 	sg_init_one(sg, skb->data, 1000);

 	err =3D virtqueue_add_inbuf(vq, sg, 1, skb, GFP_KERNEL);
=2D-
2.25.1

