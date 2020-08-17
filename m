Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B01C8246B62
	for <lists+stable@lfdr.de>; Mon, 17 Aug 2020 17:54:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387659AbgHQPyE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Aug 2020 11:54:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:41214 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387962AbgHQPyA (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 Aug 2020 11:54:00 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EC6CD20657;
        Mon, 17 Aug 2020 15:53:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597679639;
        bh=DuzbMVccMmFXiK3z7xwVDQGFI9B44hy2RoYTVa9JN5M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qWrQhtlV0Mpe+BdH+744a4z0BgVbS6tUKj/fyESpKUQXIZb20bqMpERqlBiDp04Md
         9N1N/5ZmNarjBO4weZ7XOghmbKBtzew/kcpD4YEV6wMY4Klg5OtVPOGrLevMGzYU1i
         8r4QCyLdyOlbh9V1YEzlVxUc2KJMX7alcyxXdsF0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Julian Wiedmann <jwi@linux.ibm.com>,
        Alexandra Winter <wintera@linux.ibm.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.7 282/393] s390/qeth: dont process empty bridge port events
Date:   Mon, 17 Aug 2020 17:15:32 +0200
Message-Id: <20200817143833.298954905@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200817143819.579311991@linuxfoundation.org>
References: <20200817143819.579311991@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Julian Wiedmann <jwi@linux.ibm.com>

[ Upstream commit 02472e28b9a45471c6d8729ff2c7422baa9be46a ]

Discard events that don't contain any entries. This shouldn't happen,
but subsequent code relies on being able to use entry 0. So better
be safe than accessing garbage.

Fixes: b4d72c08b358 ("qeth: bridgeport support - basic control")
Signed-off-by: Julian Wiedmann <jwi@linux.ibm.com>
Reviewed-by: Alexandra Winter <wintera@linux.ibm.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/s390/net/qeth_l2_main.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/s390/net/qeth_l2_main.c b/drivers/s390/net/qeth_l2_main.c
index 0bd5b09e7a223..37740cc7a44aa 100644
--- a/drivers/s390/net/qeth_l2_main.c
+++ b/drivers/s390/net/qeth_l2_main.c
@@ -1071,6 +1071,10 @@ static void qeth_bridge_state_change(struct qeth_card *card,
 	int extrasize;
 
 	QETH_CARD_TEXT(card, 2, "brstchng");
+	if (qports->num_entries == 0) {
+		QETH_CARD_TEXT(card, 2, "BPempty");
+		return;
+	}
 	if (qports->entry_length != sizeof(struct qeth_sbp_port_entry)) {
 		QETH_CARD_TEXT_(card, 2, "BPsz%04x", qports->entry_length);
 		return;
-- 
2.25.1



