Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B109A37876A
	for <lists+stable@lfdr.de>; Mon, 10 May 2021 13:38:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237542AbhEJLP2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 May 2021 07:15:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:46088 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236369AbhEJLH4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 May 2021 07:07:56 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 11FFE61984;
        Mon, 10 May 2021 11:00:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620644430;
        bh=IUf6afyY39bl4MsSqUuKJfLMuwdyqH6DmQSpaBdciAg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MuBqJe7zh0i/C6VnpJkeFi1TZDO1Hdci/v2PmVbDZ5I5dSOnhmSY/ul2HjhLSYeKd
         E1VxriEExrBxqNiTF99MlBcO2IWqJnPqnvvBVnVVevo8Ir8zJoP6H2ec9vKVuy+xkX
         YCQa+/c9p7Uxw9vikoMHxFOASos6S2+tM6f+3Jno=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ilya Dryomov <idryomov@gmail.com>,
        Jeff Layton <jlayton@kernel.org>
Subject: [PATCH 5.12 034/384] libceph: allow addrvecs with a single NONE/blank address
Date:   Mon, 10 May 2021 12:17:03 +0200
Message-Id: <20210510102015.996671204@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210510102014.849075526@linuxfoundation.org>
References: <20210510102014.849075526@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ilya Dryomov <idryomov@gmail.com>

commit 3f1c6f2122fc780560f09735b6d1dbf39b44eb0f upstream.

Normally, an unused OSD id/slot is represented by an empty addrvec.
However, it also appears to be possible to generate an osdmap where
an unused OSD id/slot has an addrvec with a single blank address of
type NONE.  Allow such addrvecs and make the end result be exactly
the same as for the empty addrvec case -- leave addr intact.

Cc: stable@vger.kernel.org # 5.11+
Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
Reviewed-by: Jeff Layton <jlayton@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ceph/decode.c |   20 ++++++++++++++------
 1 file changed, 14 insertions(+), 6 deletions(-)

--- a/net/ceph/decode.c
+++ b/net/ceph/decode.c
@@ -4,6 +4,7 @@
 #include <linux/inet.h>
 
 #include <linux/ceph/decode.h>
+#include <linux/ceph/messenger.h>  /* for ceph_pr_addr() */
 
 static int
 ceph_decode_entity_addr_versioned(void **p, void *end,
@@ -110,6 +111,7 @@ int ceph_decode_entity_addrvec(void **p,
 	}
 
 	ceph_decode_32_safe(p, end, addr_cnt, e_inval);
+	dout("%s addr_cnt %d\n", __func__, addr_cnt);
 
 	found = false;
 	for (i = 0; i < addr_cnt; i++) {
@@ -117,6 +119,7 @@ int ceph_decode_entity_addrvec(void **p,
 		if (ret)
 			return ret;
 
+		dout("%s i %d addr %s\n", __func__, i, ceph_pr_addr(&tmp_addr));
 		if (tmp_addr.type == my_type) {
 			if (found) {
 				pr_err("another match of type %d in addrvec\n",
@@ -128,13 +131,18 @@ int ceph_decode_entity_addrvec(void **p,
 			found = true;
 		}
 	}
-	if (!found && addr_cnt != 0) {
-		pr_err("no match of type %d in addrvec\n",
-		       le32_to_cpu(my_type));
-		return -ENOENT;
-	}
 
-	return 0;
+	if (found)
+		return 0;
+
+	if (!addr_cnt)
+		return 0;  /* normal -- e.g. unused OSD id/slot */
+
+	if (addr_cnt == 1 && !memchr_inv(&tmp_addr, 0, sizeof(tmp_addr)))
+		return 0;  /* weird but effectively the same as !addr_cnt */
+
+	pr_err("no match of type %d in addrvec\n", le32_to_cpu(my_type));
+	return -ENOENT;
 
 e_inval:
 	return -EINVAL;


