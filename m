Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 25A371F45A0
	for <lists+stable@lfdr.de>; Tue,  9 Jun 2020 20:18:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732631AbgFISSc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 9 Jun 2020 14:18:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:37322 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730807AbgFIRuM (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 9 Jun 2020 13:50:12 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3D0C22081A;
        Tue,  9 Jun 2020 17:50:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591725012;
        bh=Qji0P9ZYJP6rjevkptNRCSR27VQwxRHmmnnhzSFH4Xs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hNySvtecEUw2gbZ2AkseH6njtf2xaa/MRciuj4++u6nzSlqZ29vcpHRQh7TorQhLB
         TqxVisPoybCBsx3ySMRA166n4Q+4C6YMo6jcVOl1EdGIwBC/Bdz0xaHv+n/lcfofnJ
         Cuzb3ARtuSyXRJZS3J/v786LXMJ0WPS+iVmNDu+I=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dinghao Liu <dinghao.liu@zju.edu.cn>,
        Bin Liu <b-liu@ti.com>
Subject: [PATCH 4.14 34/46] usb: musb: Fix runtime PM imbalance on error
Date:   Tue,  9 Jun 2020 19:44:50 +0200
Message-Id: <20200609174029.578394791@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200609174022.938987501@linuxfoundation.org>
References: <20200609174022.938987501@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dinghao Liu <dinghao.liu@zju.edu.cn>

commit e4befc121df03dc8ed2ac1031c98f9538e244bae upstream.

When copy_from_user() returns an error code, there
is a runtime PM usage counter imbalance.

Fix this by moving copy_from_user() to the beginning
of this function.

Fixes: 7b6c1b4c0e1e ("usb: musb: fix runtime PM in debugfs")

Signed-off-by: Dinghao Liu <dinghao.liu@zju.edu.cn>
Cc: stable@vger.kernel.org
Signed-off-by: Bin Liu <b-liu@ti.com>
Link: https://lore.kernel.org/r/20200525025049.3400-7-b-liu@ti.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/musb/musb_debugfs.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

--- a/drivers/usb/musb/musb_debugfs.c
+++ b/drivers/usb/musb/musb_debugfs.c
@@ -206,6 +206,11 @@ static ssize_t musb_test_mode_write(stru
 	u8			test;
 	char			buf[24];
 
+	memset(buf, 0x00, sizeof(buf));
+
+	if (copy_from_user(buf, ubuf, min_t(size_t, sizeof(buf) - 1, count)))
+		return -EFAULT;
+
 	pm_runtime_get_sync(musb->controller);
 	test = musb_readb(musb->mregs, MUSB_TESTMODE);
 	if (test) {
@@ -214,11 +219,6 @@ static ssize_t musb_test_mode_write(stru
 		goto ret;
 	}
 
-	memset(buf, 0x00, sizeof(buf));
-
-	if (copy_from_user(buf, ubuf, min_t(size_t, sizeof(buf) - 1, count)))
-		return -EFAULT;
-
 	if (strstarts(buf, "force host full-speed"))
 		test = MUSB_TEST_FORCE_HOST | MUSB_TEST_FORCE_FS;
 


