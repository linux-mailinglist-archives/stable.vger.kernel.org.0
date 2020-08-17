Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AB861247036
	for <lists+stable@lfdr.de>; Mon, 17 Aug 2020 20:05:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389749AbgHQSFk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Aug 2020 14:05:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:59880 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388496AbgHQQJL (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 Aug 2020 12:09:11 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 31EC220729;
        Mon, 17 Aug 2020 16:09:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597680550;
        bh=otHSwM6N24Z+S7FOBdYU6wRadTih+IiDQQp4BxWggMw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=y1QmB/qXhFcP5fGR4DdMG8Jc+X8oIdKKy2Tlljs1Tzssxlgohm2PoETUqjiMBhtaM
         oWSoPAy22NqtlcB0JWa+vB+T+4kXVFw3gvfWJm4nRIs5uL/hKDyDNFxNOVF8n02E1Q
         wow/2wszAM2C0gOEPqcYDDvq0PdpetxviyU+fmKw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Julian Wiedmann <jwi@linux.ibm.com>,
        Alexandra Winter <wintera@linux.ibm.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 191/270] s390/qeth: dont process empty bridge port events
Date:   Mon, 17 Aug 2020 17:16:32 +0200
Message-Id: <20200817143805.305967574@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200817143755.807583758@linuxfoundation.org>
References: <20200817143755.807583758@linuxfoundation.org>
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
index 92bace3b28fd2..4ce28aa490cdb 100644
--- a/drivers/s390/net/qeth_l2_main.c
+++ b/drivers/s390/net/qeth_l2_main.c
@@ -1199,6 +1199,10 @@ static void qeth_bridge_state_change(struct qeth_card *card,
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



