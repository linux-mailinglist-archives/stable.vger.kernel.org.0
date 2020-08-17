Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3C18324758A
	for <lists+stable@lfdr.de>; Mon, 17 Aug 2020 21:25:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730426AbgHQTZA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Aug 2020 15:25:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:39058 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730425AbgHQPeU (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 Aug 2020 11:34:20 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 65B4420882;
        Mon, 17 Aug 2020 15:34:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597678459;
        bh=oqclE7P4Uix6mzOgO7GXp5zg1fACZ9N2FYFeR1/rkDQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZhMzeQEfBBIf7nBc+jlfoUXScjIE2spZ1VQ3aFUtmLHAZgIy0PZQbwCBrTTw7FI5T
         Vq7HgyO8G9uD+Hmw/2OUat6rcWOxSHOoIL04IbU0f6uSbKZJhCsXalzJxLlN9HbcKZ
         bPy9mWX6C/8lpJLxht/brFFv6xRvcuRVe3vAxQ2M=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Julian Wiedmann <jwi@linux.ibm.com>,
        Alexandra Winter <wintera@linux.ibm.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.8 341/464] s390/qeth: dont process empty bridge port events
Date:   Mon, 17 Aug 2020 17:14:54 +0200
Message-Id: <20200817143850.108854688@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200817143833.737102804@linuxfoundation.org>
References: <20200817143833.737102804@linuxfoundation.org>
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
index 2d3bca3c0141f..b4e06aeb6dc1c 100644
--- a/drivers/s390/net/qeth_l2_main.c
+++ b/drivers/s390/net/qeth_l2_main.c
@@ -1142,6 +1142,10 @@ static void qeth_bridge_state_change(struct qeth_card *card,
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



