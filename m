Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C13BF4838F5
	for <lists+stable@lfdr.de>; Tue,  4 Jan 2022 00:04:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230435AbiACXE3 convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Mon, 3 Jan 2022 18:04:29 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:27538 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229700AbiACXE3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Jan 2022 18:04:29 -0500
Received: from pps.filterd (m0109332.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 203JU1qB024728
        for <stable@vger.kernel.org>; Mon, 3 Jan 2022 15:04:28 -0800
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3dc7bu0r9e-5
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <stable@vger.kernel.org>; Mon, 03 Jan 2022 15:04:28 -0800
Received: from twshared7460.02.ash7.facebook.com (2620:10d:c085:208::f) by
 mail.thefacebook.com (2620:10d:c085:21d::5) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Mon, 3 Jan 2022 15:04:24 -0800
Received: by devbig006.ftw2.facebook.com (Postfix, from userid 4523)
        id B2B76270828AC; Mon,  3 Jan 2022 15:04:19 -0800 (PST)
From:   Song Liu <song@kernel.org>
To:     <linux-raid@vger.kernel.org>
CC:     <linux-kernel@vger.kernel.org>, Song Liu <song@kernel.org>,
        <stable@vger.kernel.org>, Guoqing Jiang <guoqing.jiang@linux.dev>,
        Jens Axboe <axboe@kernel.dk>,
        Norbert Warmuth <nwarmuth@t-online.de>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH] md/raid1: fix missing bitmap update w/o WriteMostly devices
Date:   Mon, 3 Jan 2022 15:04:01 -0800
Message-ID: <20220103230401.180704-1-song@kernel.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: zDVSKs_Z0d9-NylX74GhwywnCu52z_cz
X-Proofpoint-GUID: zDVSKs_Z0d9-NylX74GhwywnCu52z_cz
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-01-03_09,2022-01-01_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=fb_outbound_notspam policy=fb_outbound score=0 mlxscore=0 bulkscore=0
 lowpriorityscore=0 spamscore=0 mlxlogscore=964 clxscore=1011 adultscore=0
 impostorscore=0 priorityscore=1501 suspectscore=0 malwarescore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2201030156
X-FB-Internal: deliver
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

commit [1] causes missing bitmap updates when there isn't any WriteMostly
devices.

Detailed steps to reproduce by Norbert (which somehow didn't make to lore):

   # setup md10 (raid1) with two drives (1 GByte sparse files)
   dd if=/dev/zero of=disk1 bs=1024k seek=1024 count=0
   dd if=/dev/zero of=disk2 bs=1024k seek=1024 count=0

   losetup /dev/loop11 disk1
   losetup /dev/loop12 disk2

   mdadm --create /dev/md10 --level=1 --raid-devices=2 /dev/loop11 /dev/loop12

   # add bitmap (aka write-intent log)
   mdadm /dev/md10 --grow --bitmap=internal

   echo check > /sys/block/md10/md/sync_action

   root:# cat /sys/block/md10/md/mismatch_cnt
   0
   root:#

   # remove member drive disk2 (loop12)
   mdadm /dev/md10 -f loop12 ; mdadm /dev/md10 -r loop12

   # modify degraded md device
   dd if=/dev/urandom of=/dev/md10 bs=512 count=1

   # no blocks recorded as out of sync on the remaining member disk1/loop11
   root:# mdadm -X /dev/loop11 | grep Bitmap
             Bitmap : 16 bits (chunks), 0 dirty (0.0%)
   root:#

   # re-add disk2, nothing synced because of empty bitmap
   mdadm /dev/md10 --re-add /dev/loop12

   # check integrity again
   echo check > /sys/block/md10/md/sync_action

   # disk1 and disk2 are no longer in sync, reads return differend data
   root:# cat /sys/block/md10/md/mismatch_cnt
   128
   root:#

   # clean up
   mdadm -S /dev/md10
   losetup -d /dev/loop11
   losetup -d /dev/loop12
   rm disk1 disk2

Fix this by moving the WriteMostly check to the if condition for
alloc_behind_master_bio().

[1] commit fd3b6975e9c1 ("md/raid1: only allocate write behind bio for WriteMostly device")
Fixes: fd3b6975e9c1 ("md/raid1: only allocate write behind bio for WriteMostly device")
Cc: stable@vger.kernel.org # v5.12+
Cc: Guoqing Jiang <guoqing.jiang@linux.dev>
Cc: Jens Axboe <axboe@kernel.dk>
Reported-by: Norbert Warmuth <nwarmuth@t-online.de>
Suggested-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Song Liu <song@kernel.org>
---
 drivers/md/raid1.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
index 7dc8026cf6ee..85505424f7a4 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -1496,12 +1496,13 @@ static void raid1_write_request(struct mddev *mddev, struct bio *bio,
 		if (!r1_bio->bios[i])
 			continue;
 
-		if (first_clone && test_bit(WriteMostly, &rdev->flags)) {
+		if (first_clone) {
 			/* do behind I/O ?
 			 * Not if there are too many, or cannot
 			 * allocate memory, or a reader on WriteMostly
 			 * is waiting for behind writes to flush */
 			if (bitmap &&
+			    test_bit(WriteMostly, &rdev->flags) &&
 			    (atomic_read(&bitmap->behind_writes)
 			     < mddev->bitmap_info.max_write_behind) &&
 			    !waitqueue_active(&bitmap->behind_wait)) {
-- 
2.30.2

