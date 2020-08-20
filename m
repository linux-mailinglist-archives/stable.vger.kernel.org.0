Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2586D24B461
	for <lists+stable@lfdr.de>; Thu, 20 Aug 2020 12:04:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730492AbgHTKEe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Aug 2020 06:04:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:53084 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730293AbgHTKCR (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 Aug 2020 06:02:17 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C7D7420855;
        Thu, 20 Aug 2020 10:02:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597917737;
        bh=0BuGBNYRRfCZkWroIdzu90x55iYIIgyR6zQdAe8liMk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DbIuRohNVW5fj22kNc2Bg5APHCu2CN4lliUR/bSjmf7FPjRj3F2BTpzuFP4/XKoPd
         4noYOnJ2GoRNew16gaQYZNFQEK7T4Trp0IBYGNK90q60UcqyKfxexXynKUnu8ureFn
         Hch+K8JmKAYUJ20IKy5HwjAloD6uOUR+EHWeqL4M=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Julian Wiedmann <jwi@linux.ibm.com>,
        Alexandra Winter <wintera@linux.ibm.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 140/212] s390/qeth: dont process empty bridge port events
Date:   Thu, 20 Aug 2020 11:21:53 +0200
Message-Id: <20200820091609.417418761@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200820091602.251285210@linuxfoundation.org>
References: <20200820091602.251285210@linuxfoundation.org>
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
index 51152681aba6e..c878c87966163 100644
--- a/drivers/s390/net/qeth_l2_main.c
+++ b/drivers/s390/net/qeth_l2_main.c
@@ -1675,6 +1675,10 @@ static void qeth_bridge_state_change(struct qeth_card *card,
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



