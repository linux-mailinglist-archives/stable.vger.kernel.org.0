Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1C07A451E77
	for <lists+stable@lfdr.de>; Tue, 16 Nov 2021 01:33:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355183AbhKPAgN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 19:36:13 -0500
Received: from mail.kernel.org ([198.145.29.99]:45220 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1344971AbhKOTZw (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 14:25:52 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6497F63401;
        Mon, 15 Nov 2021 19:07:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637003265;
        bh=JiS9z61ucItHFQBOirNVN+aBihVXJmCTgy8BPlPzw6o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=etXoZvquv5ZEtwpBqWSNkqIjqJ/rLTyJIK00OaiSzjag9cNyOyt2amk0X0IP2zDHy
         9Ue2eqLQ/VvZyTvBOzw0kKYJdNT2pYiE83/fwRzIAwvnTw7XbSKInKPdbsA7AE8is4
         zIurEUb7yIdYh8fIizz/7QZXlVBB4XCo23jssh6M=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Peter Ujfalusi <peter.ujfalusi@gmail.com>,
        Kishon Vijay Abraham I <kishon@ti.com>,
        Vinod Koul <vkoul@kernel.org>
Subject: [PATCH 5.15 871/917] dmaengine: ti: k3-udma: Set bchan to NULL if a channel request fail
Date:   Mon, 15 Nov 2021 18:06:06 +0100
Message-Id: <20211115165458.587955919@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165428.722074685@linuxfoundation.org>
References: <20211115165428.722074685@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kishon Vijay Abraham I <kishon@ti.com>

commit 5c6c6d60e4b489308ae4da8424c869f7cc53cd12 upstream.

bcdma_get_*() checks if bchan is already allocated by checking if it
has a NON NULL value. For the error cases, bchan will have error value
and bcdma_get_*() considers this as already allocated (PASS) since the
error values are NON NULL. This results in NULL pointer dereference
error while de-referencing bchan.

Reset the value of bchan to NULL if a channel request fails.

CC: stable@vger.kernel.org
Acked-by: Peter Ujfalusi <peter.ujfalusi@gmail.com>
Signed-off-by: Kishon Vijay Abraham I <kishon@ti.com>
Link: https://lore.kernel.org/r/20211031032411.27235-2-kishon@ti.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/dma/ti/k3-udma.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

--- a/drivers/dma/ti/k3-udma.c
+++ b/drivers/dma/ti/k3-udma.c
@@ -1348,6 +1348,7 @@ static int bcdma_get_bchan(struct udma_c
 {
 	struct udma_dev *ud = uc->ud;
 	enum udma_tp_level tpl;
+	int ret;
 
 	if (uc->bchan) {
 		dev_dbg(ud->dev, "chan%d: already have bchan%d allocated\n",
@@ -1365,8 +1366,11 @@ static int bcdma_get_bchan(struct udma_c
 		tpl = ud->bchan_tpl.levels - 1;
 
 	uc->bchan = __udma_reserve_bchan(ud, tpl, -1);
-	if (IS_ERR(uc->bchan))
-		return PTR_ERR(uc->bchan);
+	if (IS_ERR(uc->bchan)) {
+		ret = PTR_ERR(uc->bchan);
+		uc->bchan = NULL;
+		return ret;
+	}
 
 	uc->tchan = uc->bchan;
 


