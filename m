Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6FEC62E76E3
	for <lists+stable@lfdr.de>; Wed, 30 Dec 2020 08:43:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725814AbgL3Hlv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 30 Dec 2020 02:41:51 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:52158 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726337AbgL3Hlv (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 30 Dec 2020 02:41:51 -0500
Received: from pps.filterd (m0044010.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 0BU7ewjt020072
        for <stable@vger.kernel.org>; Tue, 29 Dec 2020 23:41:10 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding :
 content-type; s=facebook; bh=b8OgOCHph3GYWcoIeb3dNgwSY+JbvBn0A6TbTZD06qI=;
 b=GQhHLHqaBKzn0UVMWZCB2+3dERCvVV5uPFgHoowpmtvhz+VhpQPtyJoD6xpaiGnHNsf/
 2wl5Qy2gxkaCigzO4kqfODm66w3V9NN8USyZ3MnJxkDJ3IL5Vw6LC6NvL2K61tvBg3/D
 oAz8teplNaM1RY+Yb9WqkgI9CwP+yoFfq3s= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 35pp3vtjdn-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <stable@vger.kernel.org>; Tue, 29 Dec 2020 23:41:10 -0800
Received: from intmgw002.03.ash8.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:83::4) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Tue, 29 Dec 2020 23:41:05 -0800
Received: by devbig006.ftw2.facebook.com (Postfix, from userid 4523)
        id 18D9262E567F; Tue, 29 Dec 2020 23:41:03 -0800 (PST)
From:   Song Liu <songliubraving@fb.com>
To:     <stable@vger.kernel.org>
CC:     <gregkh@linuxfoundation.org>, Kevin Vigor <kvigor@gmail.com>,
        Song Liu <songliubraving@fb.com>
Subject: [PATCH] md/raid10: initialize r10_bio->read_slot before use.
Date:   Tue, 29 Dec 2020 23:40:39 -0800
Message-ID: <20201230074039.1732760-1-songliubraving@fb.com>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2020-12-30_04:2020-12-28,2020-12-30 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 malwarescore=0
 spamscore=0 priorityscore=1501 clxscore=1011 impostorscore=0
 suspectscore=0 mlxscore=0 bulkscore=0 phishscore=0 mlxlogscore=724
 lowpriorityscore=0 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2009150000 definitions=main-2012300045
X-FB-Internal: deliver
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kevin Vigor <kvigor@gmail.com>

In __make_request() a new r10bio is allocated and passed to
raid10_read_request(). The read_slot member of the bio is not
initialized, and the raid10_read_request() uses it to index an
array. This leads to occasional panics.

Fix by initializing the field to invalid value and checking for
valid value in raid10_read_request().

Cc: stable@vger.kernel.org # v4.14+
Signed-off-by: Kevin Vigor <kvigor@gmail.com>
Signed-off-by: Song Liu <songliubraving@fb.com>
(cherry picked from commit 93decc563637c4288380912eac0eb42fb246cc04)
---
 drivers/md/raid10.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
index d08d77b9674ff..419ecdd914f4c 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -1120,7 +1120,7 @@ static void raid10_read_request(struct mddev *mddev=
, struct bio *bio,
 	struct md_rdev *err_rdev =3D NULL;
 	gfp_t gfp =3D GFP_NOIO;
=20
-	if (r10_bio->devs[slot].rdev) {
+	if (slot >=3D 0 && r10_bio->devs[slot].rdev) {
 		/*
 		 * This is an error retry, but we cannot
 		 * safely dereference the rdev in the r10_bio,
@@ -1513,6 +1513,7 @@ static void __make_request(struct mddev *mddev, str=
uct bio *bio, int sectors)
 	r10_bio->mddev =3D mddev;
 	r10_bio->sector =3D bio->bi_iter.bi_sector;
 	r10_bio->state =3D 0;
+	r10_bio->read_slot =3D -1;
 	memset(r10_bio->devs, 0, sizeof(r10_bio->devs[0]) * conf->copies);
=20
 	if (bio_data_dir(bio) =3D=3D READ)
--=20
2.24.1

