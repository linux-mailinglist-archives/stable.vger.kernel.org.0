Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1685E2F1507
	for <lists+stable@lfdr.de>; Mon, 11 Jan 2021 14:34:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732119AbhAKNO3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Jan 2021 08:14:29 -0500
Received: from mail.kernel.org ([198.145.29.99]:32804 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732106AbhAKNO3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 11 Jan 2021 08:14:29 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id D0F2921973;
        Mon, 11 Jan 2021 13:14:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1610370853;
        bh=Dci+bdd4Gg8z4iKrGzns8bzNd8y3D3v+odKNyaCB8Co=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OzOL9Q5mak+tgGEIrvgX+Wt5nzug9CMRXawfNH3tTeELTyKVUjAJayeYwxsDt9N9g
         CV6wCrxb4+QcSfouLeoTUrJiclWo1jKoRA7HBnP4ONQWZgPtpJT/15DA7DrKCnkKsG
         ykEr1ZCyp8m0Ws0R8cyHKHNvW8eM3uLk/afT0xho=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Shannon Nelson <snelson@pensando.io>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.10 009/145] ionic: account for vlan tag len in rx buffer len
Date:   Mon, 11 Jan 2021 14:00:33 +0100
Message-Id: <20210111130048.962787702@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210111130048.499958175@linuxfoundation.org>
References: <20210111130048.499958175@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Shannon Nelson <snelson@pensando.io>

[ Upstream commit 83469893204281ecf65d572bddf02de29a19787c ]

Let the FW know we have enough receive buffer space for the
vlan tag if it isn't stripped.

Fixes: 0f3154e6bcb3 ("ionic: Add Tx and Rx handling")
Signed-off-by: Shannon Nelson <snelson@pensando.io>
Link: https://lore.kernel.org/r/20201218215001.64696-1-snelson@pensando.io
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/pensando/ionic/ionic_txrx.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/net/ethernet/pensando/ionic/ionic_txrx.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_txrx.c
@@ -337,7 +337,7 @@ void ionic_rx_fill(struct ionic_queue *q
 	unsigned int i, j;
 	unsigned int len;
 
-	len = netdev->mtu + ETH_HLEN;
+	len = netdev->mtu + ETH_HLEN + VLAN_HLEN;
 	nfrags = round_up(len, PAGE_SIZE) / PAGE_SIZE;
 
 	for (i = ionic_q_space_avail(q); i; i--) {


