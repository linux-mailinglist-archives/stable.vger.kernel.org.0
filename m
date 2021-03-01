Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5FA4A328C8F
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 19:55:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237669AbhCASxn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 13:53:43 -0500
Received: from mail.kernel.org ([198.145.29.99]:55412 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240468AbhCASrs (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 13:47:48 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 830196519D;
        Mon,  1 Mar 2021 17:11:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614618699;
        bh=t7KkS03sTGMZVsOQ1FE5kHPOnpkHk74FZ2X7vPDKYjs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jJn7IPb41cZ/f/pOwAmM/avCTXMFq4lFt1PJuw2NiZW7vOPqHpeQyiVXPxmV/pJ4V
         YRMkqEhw/8kCFOtxO8VprPTyxpW3Q88oSALNs8OgQAYcXL/xvBMus7WpKCWHRRKblx
         U87uF46Gf6JAZRSb5m0hHRjp6b5UgMI23+fnxUVA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Joshua Thompson <funaho@jurai.org>,
        Stan Johnson <userm57@yahoo.com>,
        Finn Thain <fthain@telegraphics.com.au>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 184/663] macintosh/adb-iop: Use big-endian autopoll mask
Date:   Mon,  1 Mar 2021 17:07:12 +0100
Message-Id: <20210301161150.881619583@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161141.760350206@linuxfoundation.org>
References: <20210301161141.760350206@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Finn Thain <fthain@telegraphics.com.au>

[ Upstream commit c396dd2ec5bbd1cb80eafe32a72ab6bd6b17cb5a ]

As usual, the available documentation is inadequate and leaves endianness
unspecified for message data. However, testing shows that this patch does
improve correctness. The mistake should have been detected earlier but it
was obscured by other bugs. In testing, this patch reinstated pre-v5.9
behaviour. The old driver bugs remain and ADB input devices may stop
working. But that appears to be unrelated.

Cc: Joshua Thompson <funaho@jurai.org>
Fixes: c66da95a39ec ("macintosh/adb-iop: Implement SRQ autopolling")
Tested-by: Stan Johnson <userm57@yahoo.com>
Signed-off-by: Finn Thain <fthain@telegraphics.com.au>
Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
Link: https://lore.kernel.org/r/20210125074524.3027452-1-geert@linux-m68k.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/macintosh/adb-iop.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/macintosh/adb-iop.c b/drivers/macintosh/adb-iop.c
index 0ee3272491501..2633bc254935c 100644
--- a/drivers/macintosh/adb-iop.c
+++ b/drivers/macintosh/adb-iop.c
@@ -19,6 +19,7 @@
 #include <asm/macints.h>
 #include <asm/mac_iop.h>
 #include <asm/adb_iop.h>
+#include <asm/unaligned.h>
 
 #include <linux/adb.h>
 
@@ -249,7 +250,7 @@ static void adb_iop_set_ap_complete(struct iop_msg *msg)
 {
 	struct adb_iopmsg *amsg = (struct adb_iopmsg *)msg->message;
 
-	autopoll_devs = (amsg->data[1] << 8) | amsg->data[0];
+	autopoll_devs = get_unaligned_be16(amsg->data);
 	if (autopoll_devs & (1 << autopoll_addr))
 		return;
 	autopoll_addr = autopoll_devs ? (ffs(autopoll_devs) - 1) : 0;
@@ -266,8 +267,7 @@ static int adb_iop_autopoll(int devs)
 	amsg.flags = ADB_IOP_SET_AUTOPOLL | (mask ? ADB_IOP_AUTOPOLL : 0);
 	amsg.count = 2;
 	amsg.cmd = 0;
-	amsg.data[0] = mask & 0xFF;
-	amsg.data[1] = (mask >> 8) & 0xFF;
+	put_unaligned_be16(mask, amsg.data);
 
 	iop_send_message(ADB_IOP, ADB_CHAN, NULL, sizeof(amsg), (__u8 *)&amsg,
 			 adb_iop_set_ap_complete);
-- 
2.27.0



