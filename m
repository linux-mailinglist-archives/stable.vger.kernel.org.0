Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1A2DE439600
	for <lists+stable@lfdr.de>; Mon, 25 Oct 2021 14:18:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233118AbhJYMTq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 25 Oct 2021 08:19:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:56314 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233062AbhJYMTn (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 25 Oct 2021 08:19:43 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D04906105A;
        Mon, 25 Oct 2021 12:17:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1635164239;
        bh=bHMyDNovNe9zehRCGFFe8UpbUFbhhC6sMj7mtZpO1qM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BmikNBtqhvCcR27Eb+ZkZ44xZ80+i+VWyTFaoTWyGxoEie0daNYfX+kfriVCzXgYx
         Cdq46dBQ31u1kdWPpNJPvgF1w8xDq1M+5rT7XcIzIOj7FEBf0qzDJ+kjdd9clPS10e
         epLD6Eb97oyy9WEj1c/jjYLIgfmHJUBheItJsjk6+FOU7TFNT3tDACXDJ7L2zHr4h5
         +lyT7fA07dWTU9bPFLTx0e4lh67R2oklqd61TinbwQEjnHpP2p2JyDF/5VqrwCvZV/
         A1xuqx0ukvV2VXGUwTSocPKavCTJ/o4wnjDH8VGp+zHFsCN0ug7ofvU3M8KPfI8HCx
         0PaBkTR25Gv+A==
Received: from johan by xi.lan with local (Exim 4.94.2)
        (envelope-from <johan@kernel.org>)
        id 1meyuU-0001mM-MP; Mon, 25 Oct 2021 14:17:02 +0200
From:   Johan Hovold <johan@kernel.org>
To:     Sean Young <sean@mess.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Cc:     Mike Isely <isely@pobox.com>,
        Ezequiel Garcia <ezequiel@vanguardiasur.com.ar>,
        linux-media@vger.kernel.org, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, Johan Hovold <johan@kernel.org>,
        stable@vger.kernel.org
Subject: [PATCH 4/8] media: cpia2: fix control-message timeouts
Date:   Mon, 25 Oct 2021 14:16:37 +0200
Message-Id: <20211025121641.6759-5-johan@kernel.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20211025121641.6759-1-johan@kernel.org>
References: <20211025121641.6759-1-johan@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

USB control-message timeouts are specified in milliseconds and should
specifically not vary with CONFIG_HZ.

Fixes: ab33d5071de7 ("V4L/DVB (3376): Add cpia2 camera support")
Cc: stable@vger.kernel.org      # 2.6.17
Signed-off-by: Johan Hovold <johan@kernel.org>
---
 drivers/media/usb/cpia2/cpia2_usb.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/media/usb/cpia2/cpia2_usb.c b/drivers/media/usb/cpia2/cpia2_usb.c
index 76aac06f9fb8..cba03b286473 100644
--- a/drivers/media/usb/cpia2/cpia2_usb.c
+++ b/drivers/media/usb/cpia2/cpia2_usb.c
@@ -550,7 +550,7 @@ static int write_packet(struct usb_device *udev,
 			       0,	/* index */
 			       buf,	/* buffer */
 			       size,
-			       HZ);
+			       1000);
 
 	kfree(buf);
 	return ret;
@@ -582,7 +582,7 @@ static int read_packet(struct usb_device *udev,
 			       0,	/* index */
 			       buf,	/* buffer */
 			       size,
-			       HZ);
+			       1000);
 
 	if (ret >= 0)
 		memcpy(registers, buf, size);
-- 
2.32.0

