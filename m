Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1370626A706
	for <lists+stable@lfdr.de>; Tue, 15 Sep 2020 16:27:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726927AbgIOO1l (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 15 Sep 2020 10:27:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:38172 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726926AbgIOO0u (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 15 Sep 2020 10:26:50 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6DFF922473;
        Tue, 15 Sep 2020 14:19:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600179588;
        bh=wOb0MOvzDb/ZrwrJ3pg48ni2ycaY2oXkvvjZPPz+c+Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=X+TYrIatKRMw1wR5rZRCEQRkckMTdbaz2FPDeSaJJ1R2+dpQ0DPb5MqqyZX0F7OJ+
         spAai+gUwO21GHoR7PYrwXq5LRn5TQOuhIKK9tu0Sop0T/vmiVq8S4bQJS5iX69cHO
         RiJ9YSY0TBb4lN97ZlJNQJu+EjLJ/P+Kx06fZ+p4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dinghao Liu <dinghao.liu@zju.edu.cn>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 040/132] NFC: st95hf: Fix memleak in st95hf_in_send_cmd
Date:   Tue, 15 Sep 2020 16:12:22 +0200
Message-Id: <20200915140646.128661704@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200915140644.037604909@linuxfoundation.org>
References: <20200915140644.037604909@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dinghao Liu <dinghao.liu@zju.edu.cn>

[ Upstream commit f97c04c316d8fea16dca449fdfbe101fbdfee6a2 ]

When down_killable() fails, skb_resp should be freed
just like when st95hf_spi_send() fails.

Signed-off-by: Dinghao Liu <dinghao.liu@zju.edu.cn>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nfc/st95hf/core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/nfc/st95hf/core.c b/drivers/nfc/st95hf/core.c
index 9642971e89cea..4578547659839 100644
--- a/drivers/nfc/st95hf/core.c
+++ b/drivers/nfc/st95hf/core.c
@@ -966,7 +966,7 @@ static int st95hf_in_send_cmd(struct nfc_digital_dev *ddev,
 	rc = down_killable(&stcontext->exchange_lock);
 	if (rc) {
 		WARN(1, "Semaphore is not found up in st95hf_in_send_cmd\n");
-		return rc;
+		goto free_skb_resp;
 	}
 
 	rc = st95hf_spi_send(&stcontext->spicontext, skb->data,
-- 
2.25.1



