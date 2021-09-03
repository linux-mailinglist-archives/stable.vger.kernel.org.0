Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 88DB14000F0
	for <lists+stable@lfdr.de>; Fri,  3 Sep 2021 16:03:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235443AbhICOEz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 Sep 2021 10:04:55 -0400
Received: from www.linuxtv.org ([130.149.80.248]:51860 "EHLO www.linuxtv.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235169AbhICOEy (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 3 Sep 2021 10:04:54 -0400
Received: from mchehab by www.linuxtv.org with local (Exim 4.92)
        (envelope-from <mchehab@linuxtv.org>)
        id 1mM9nE-00BliQ-8I; Fri, 03 Sep 2021 14:03:44 +0000
From:   Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Date:   Fri, 03 Sep 2021 14:02:58 +0000
Subject: [git:media_stage/master] media: firewire: firedtv-avc: fix a buffer overflow in avc_ca_pmt()
To:     linuxtv-commits@linuxtv.org
Cc:     Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        stable@vger.kernel.org
Mail-followup-to: linux-media@vger.kernel.org
Forward-to: linux-media@vger.kernel.org
Reply-to: linux-media@vger.kernel.org
Message-Id: <E1mM9nE-00BliQ-8I@www.linuxtv.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is an automatic generated email to let you know that the following patch were queued:

Subject: media: firewire: firedtv-avc: fix a buffer overflow in avc_ca_pmt()
Author:  Dan Carpenter <dan.carpenter@oracle.com>
Date:    Mon Jun 7 17:23:48 2021 +0200

The bounds checking in avc_ca_pmt() is not strict enough.  It should
be checking "read_pos + 4" because it's reading 5 bytes.  If the
"es_info_length" is non-zero then it reads a 6th byte so there needs to
be an additional check for that.

I also added checks for the "write_pos".  I don't think these are
required because "read_pos" and "write_pos" are tied together so
checking one ought to be enough.  But they make the code easier to
understand for me.  The check on write_pos is:

	if (write_pos + 4 >= sizeof(c->operand) - 4) {

The first "+ 4" is because we're writing 5 bytes and the last " - 4"
is to leave space for the CRC.

The other problem is that "length" can be invalid.  It comes from
"data_length" in fdtv_ca_pmt().

Cc: stable@vger.kernel.org
Reported-by: Luo Likang <luolikang@nsfocus.com>
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>

 drivers/media/firewire/firedtv-avc.c | 14 +++++++++++---
 drivers/media/firewire/firedtv-ci.c  |  2 ++
 2 files changed, 13 insertions(+), 3 deletions(-)

---

diff --git a/drivers/media/firewire/firedtv-avc.c b/drivers/media/firewire/firedtv-avc.c
index 2bf9467b917d..71991f8638e6 100644
--- a/drivers/media/firewire/firedtv-avc.c
+++ b/drivers/media/firewire/firedtv-avc.c
@@ -1165,7 +1165,11 @@ int avc_ca_pmt(struct firedtv *fdtv, char *msg, int length)
 		read_pos += program_info_length;
 		write_pos += program_info_length;
 	}
-	while (read_pos < length) {
+	while (read_pos + 4 < length) {
+		if (write_pos + 4 >= sizeof(c->operand) - 4) {
+			ret = -EINVAL;
+			goto out;
+		}
 		c->operand[write_pos++] = msg[read_pos++];
 		c->operand[write_pos++] = msg[read_pos++];
 		c->operand[write_pos++] = msg[read_pos++];
@@ -1177,13 +1181,17 @@ int avc_ca_pmt(struct firedtv *fdtv, char *msg, int length)
 		c->operand[write_pos++] = es_info_length >> 8;
 		c->operand[write_pos++] = es_info_length & 0xff;
 		if (es_info_length > 0) {
+			if (read_pos >= length) {
+				ret = -EINVAL;
+				goto out;
+			}
 			pmt_cmd_id = msg[read_pos++];
 			if (pmt_cmd_id != 1 && pmt_cmd_id != 4)
 				dev_err(fdtv->device, "invalid pmt_cmd_id %d at stream level\n",
 					pmt_cmd_id);
 
-			if (es_info_length > sizeof(c->operand) - 4 -
-					     write_pos) {
+			if (es_info_length > sizeof(c->operand) - 4 - write_pos ||
+			    es_info_length > length - read_pos) {
 				ret = -EINVAL;
 				goto out;
 			}
diff --git a/drivers/media/firewire/firedtv-ci.c b/drivers/media/firewire/firedtv-ci.c
index 9363d005e2b6..e0d57e09dab0 100644
--- a/drivers/media/firewire/firedtv-ci.c
+++ b/drivers/media/firewire/firedtv-ci.c
@@ -134,6 +134,8 @@ static int fdtv_ca_pmt(struct firedtv *fdtv, void *arg)
 	} else {
 		data_length = msg->msg[3];
 	}
+	if (data_length > sizeof(msg->msg) - data_pos)
+		return -EINVAL;
 
 	return avc_ca_pmt(fdtv, &msg->msg[data_pos], data_length);
 }
