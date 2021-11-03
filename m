Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B4624443F97
	for <lists+stable@lfdr.de>; Wed,  3 Nov 2021 10:48:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231557AbhKCJvF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 3 Nov 2021 05:51:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:59844 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231302AbhKCJvE (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 3 Nov 2021 05:51:04 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3D65C60720;
        Wed,  3 Nov 2021 09:48:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1635932908;
        bh=vj0fOlxd6BkTbCl5ADlH9lZ09KlzLVI6KGZmfr7kZ3E=;
        h=Subject:To:Cc:From:Date:From;
        b=XfM0LV5DPd19+w/viog2f11IweArY+rMkTgz8H+hBub1BG1CAQAGm2i4f5JDUHMVr
         Kh24Qgng4Lj+Yk3D0hJd9SSnZcwvgW+nnboW2Ng4CIpdzXEpi3F/QzQss3iC5IsXCE
         rYf6Hyu5Dm8hC23cwZ0kX5iUTBm3+MdgdSJNDnSQ=
Subject: FAILED: patch "[PATCH] media: firewire: firedtv-avc: fix a buffer overflow in" failed to apply to 4.4-stable tree
To:     dan.carpenter@oracle.com, hverkuil-cisco@xs4all.nl,
        luolikang@nsfocus.com, mchehab+huawei@kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Wed, 03 Nov 2021 10:48:22 +0100
Message-ID: <16359329022564@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.4-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 35d2969ea3c7d32aee78066b1f3cf61a0d935a4e Mon Sep 17 00:00:00 2001
From: Dan Carpenter <dan.carpenter@oracle.com>
Date: Mon, 7 Jun 2021 17:23:48 +0200
Subject: [PATCH] media: firewire: firedtv-avc: fix a buffer overflow in
 avc_ca_pmt()

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

