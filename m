Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4F1BF14E22B
	for <lists+stable@lfdr.de>; Thu, 30 Jan 2020 19:50:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730991AbgA3Sql (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 Jan 2020 13:46:41 -0500
Received: from mail.kernel.org ([198.145.29.99]:56858 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731235AbgA3Sql (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 30 Jan 2020 13:46:41 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 68FEC205F4;
        Thu, 30 Jan 2020 18:46:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1580410000;
        bh=ruD9v7iz3Y5cNeFCZjb02nuwwTlDJHiAKmIYc+H0aCQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dGYEuCZMoKL+HUBEF2N1ppxd4e3AB6oUFB/h1stJJkBfh9g73rB4sW3hZguZpASFw
         hPARRJhMHu+viPmcIsWaSM8AM4pZR1z90N+EW6MDiGKmksOI+4EEld6rJeNwOj8a6B
         REthfRw3xNZKtlZPvqhpB/6bjH/0Ej6RW51BfCOs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Prameela Rani Garnepudi <prameela.j04cs@gmail.com>,
        Johan Hovold <johan@kernel.org>,
        Kalle Valo <kvalo@codeaurora.org>
Subject: [PATCH 5.4 102/110] rsi: fix memory leak on failed URB submission
Date:   Thu, 30 Jan 2020 19:39:18 +0100
Message-Id: <20200130183625.718011784@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200130183613.810054545@linuxfoundation.org>
References: <20200130183613.810054545@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Johan Hovold <johan@kernel.org>

commit 47768297481184932844ab01a86752ba31a38861 upstream.

Make sure to free the skb on failed receive-URB submission (e.g. on
disconnect or currently also due to a missing endpoint).

Fixes: a1854fae1414 ("rsi: improve RX packet handling in USB interface")
Cc: stable <stable@vger.kernel.org>     # 4.17
Cc: Prameela Rani Garnepudi <prameela.j04cs@gmail.com>
Signed-off-by: Johan Hovold <johan@kernel.org>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/wireless/rsi/rsi_91x_usb.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/net/wireless/rsi/rsi_91x_usb.c
+++ b/drivers/net/wireless/rsi/rsi_91x_usb.c
@@ -338,8 +338,10 @@ static int rsi_rx_urb_submit(struct rsi_
 			  rx_cb);
 
 	status = usb_submit_urb(urb, GFP_KERNEL);
-	if (status)
+	if (status) {
 		rsi_dbg(ERR_ZONE, "%s: Failed in urb submission\n", __func__);
+		dev_kfree_skb(skb);
+	}
 
 	return status;
 }


