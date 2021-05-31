Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E9135395EAA
	for <lists+stable@lfdr.de>; Mon, 31 May 2021 16:00:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232818AbhEaOBe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 May 2021 10:01:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:60130 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233103AbhEaN73 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 31 May 2021 09:59:29 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 001F76193D;
        Mon, 31 May 2021 13:36:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1622468168;
        bh=7QYHg/G0vqSBhvu7nR1ZgYEMhMPQcwZuTaOunGLXAVU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=f6ij2rW5KS8ozC+z9dWp5q/nsaqjl2tz/p9Rc8QOF90z6epMO6bTw4nH/hAiw4nE6
         z9xAkY5tVynsSviuDlCqeMGXWti+XSahLTH+NtIXylQ3g22ZOxDRNmuv2bkQ9by8ff
         7g1ylb4Pv3HN9VLhQaa/f8NhSUw+NfptJE+BISgU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Aditya Pakki <pakki001@umn.edu>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 141/252] Revert "net: caif: replace BUG_ON with recovery code"
Date:   Mon, 31 May 2021 15:13:26 +0200
Message-Id: <20210531130702.805609121@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210531130657.971257589@linuxfoundation.org>
References: <20210531130657.971257589@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

[ Upstream commit 4df07045fcfd684379a394d0f2aa0cc4067bda2a ]

This reverts commit c5dea815834c7d2e9fc633785455bc428b7a1956.

Because of recent interactions with developers from @umn.edu, all
commits from them have been recently re-reviewed to ensure if they were
correct or not.

Upon review, this commit was found to be incorrect for the reasons
below, so it must be reverted.  It will be fixed up "correctly" in a
later kernel change.

The original change here was pointless as dev can never be NULL in this
function so the claim in the changelog that this "fixes" anything is
incorrect (also the developer forgot about panic_on_warn).  A follow-up
change will resolve this issue properly.

Cc: Aditya Pakki <pakki001@umn.edu>
Cc: David S. Miller <davem@davemloft.net>
Link: https://lore.kernel.org/r/20210503115736.2104747-19-gregkh@linuxfoundation.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/caif/caif_serial.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/net/caif/caif_serial.c b/drivers/net/caif/caif_serial.c
index bcc14c5875bf..4cc0d91d9c87 100644
--- a/drivers/net/caif/caif_serial.c
+++ b/drivers/net/caif/caif_serial.c
@@ -270,9 +270,7 @@ static netdev_tx_t caif_xmit(struct sk_buff *skb, struct net_device *dev)
 {
 	struct ser_device *ser;
 
-	if (WARN_ON(!dev))
-		return -EINVAL;
-
+	BUG_ON(dev == NULL);
 	ser = netdev_priv(dev);
 
 	/* Send flow off once, on high water mark */
-- 
2.30.2



