Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E69E113FFBC
	for <lists+stable@lfdr.de>; Fri, 17 Jan 2020 00:45:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729279AbgAPXou (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Jan 2020 18:44:50 -0500
Received: from mail.kernel.org ([198.145.29.99]:52388 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730219AbgAPXXq (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Jan 2020 18:23:46 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1E4022072B;
        Thu, 16 Jan 2020 23:23:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579217025;
        bh=RaIv+XEgZLtzNRzIDMIJ555wufoJzqan9BfDFdy6l1g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PX6StUS3MkG5IZYaT9MfneqxY8HejQJU2//nizVij3OOWixVvxjrY32Ny6YDlGlRn
         +MqC1gqZFf0z2xcBCCiajyHV14C47z2V8/hw8kQ+2zFMGrn1aQShCvH4EfLpH4dUpn
         3w6lJTnjIb1qQ5QIau+qK4DGtnmhrDUmT7u2zTJc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Amitkumar Karwar <amitkarwar@gmail.com>,
        Siva Rebbagondla <siva8118@gmail.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Denis Efremov <efremov@linux.com>
Subject: [PATCH 5.4 117/203] rsi: fix potential null dereference in rsi_probe()
Date:   Fri, 17 Jan 2020 00:17:14 +0100
Message-Id: <20200116231755.604943633@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200116231745.218684830@linuxfoundation.org>
References: <20200116231745.218684830@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Denis Efremov <efremov@linux.com>

commit f170d44bc4ec2feae5f6206980e7ae7fbf0432a0 upstream.

The id pointer can be NULL in rsi_probe(). It is checked everywhere except
for the else branch in the idProduct condition. The patch adds NULL check
before the id dereference in the rsi_dbg() call.

Fixes: 54fdb318c111 ("rsi: add new device model for 9116")
Cc: Amitkumar Karwar <amitkarwar@gmail.com>
Cc: Siva Rebbagondla <siva8118@gmail.com>
Cc: Kalle Valo <kvalo@codeaurora.org>
Signed-off-by: Denis Efremov <efremov@linux.com>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/wireless/rsi/rsi_91x_usb.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/net/wireless/rsi/rsi_91x_usb.c
+++ b/drivers/net/wireless/rsi/rsi_91x_usb.c
@@ -793,7 +793,7 @@ static int rsi_probe(struct usb_interfac
 		adapter->device_model = RSI_DEV_9116;
 	} else {
 		rsi_dbg(ERR_ZONE, "%s: Unsupported RSI device id 0x%x\n",
-			__func__, id->idProduct);
+			__func__, id ? id->idProduct : 0x0);
 		goto err1;
 	}
 


