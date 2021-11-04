Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2BFC94454E6
	for <lists+stable@lfdr.de>; Thu,  4 Nov 2021 15:15:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231860AbhKDOSf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 4 Nov 2021 10:18:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:46732 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231872AbhKDOR4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 4 Nov 2021 10:17:56 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1DA8C61247;
        Thu,  4 Nov 2021 14:15:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1636035318;
        bh=9eoeH7pnTJB8v1PA67KVXdtRUWEJcFxuMbcpgedG0ZY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ox53GP1ur4z/bBOVifmmbe/Wg0hzr/ktTQxUz8PKJ0t28U4wCfg9MJux/kacj2XiO
         Iqs3GhZXV2LE514RLl9q6E1kRfQaZw0sY3+UUNNONAOA/ga6N4XHbCYBQnyehW50nJ
         W3DyUyLOGK2Z8KqMniz5vmExWJhnXaeIzchzhQvI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Luo Likang <luolikang@nsfocus.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Subject: [PATCH 5.10 08/16] media: firewire: firedtv-avc: fix a buffer overflow in avc_ca_pmt()
Date:   Thu,  4 Nov 2021 15:12:47 +0100
Message-Id: <20211104141159.866624691@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211104141159.561284732@linuxfoundation.org>
References: <20211104141159.561284732@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dan Carpenter <dan.carpenter@oracle.com>

commit 35d2969ea3c7d32aee78066b1f3cf61a0d935a4e upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/firewire/firedtv-avc.c |   14 +++++++++++---
 drivers/media/firewire/firedtv-ci.c  |    2 ++
 2 files changed, 13 insertions(+), 3 deletions(-)

--- a/drivers/media/firewire/firedtv-avc.c
+++ b/drivers/media/firewire/firedtv-avc.c
@@ -1165,7 +1165,11 @@ int avc_ca_pmt(struct firedtv *fdtv, cha
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
@@ -1177,13 +1181,17 @@ int avc_ca_pmt(struct firedtv *fdtv, cha
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
--- a/drivers/media/firewire/firedtv-ci.c
+++ b/drivers/media/firewire/firedtv-ci.c
@@ -134,6 +134,8 @@ static int fdtv_ca_pmt(struct firedtv *f
 	} else {
 		data_length = msg->msg[3];
 	}
+	if (data_length > sizeof(msg->msg) - data_pos)
+		return -EINVAL;
 
 	return avc_ca_pmt(fdtv, &msg->msg[data_pos], data_length);
 }


