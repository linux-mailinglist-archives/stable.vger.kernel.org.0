Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0F7E6226889
	for <lists+stable@lfdr.de>; Mon, 20 Jul 2020 18:23:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732804AbgGTQGZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Jul 2020 12:06:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:42704 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732620AbgGTQGZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Jul 2020 12:06:25 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EC86F2064B;
        Mon, 20 Jul 2020 16:06:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595261184;
        bh=UrBuyJDEcb2P1q4yldNPXBc8+4qK4/umagj9wFiJm7c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=r3dpSNIvA5gPYxrbdO9F+SB4JwTy8wS/yQmpswKdSAl/GnXIrCCjx4w9v7fPr41bn
         8uusf3O2EjG03O56nCm9rue6EMtLrn1TV5uXG7BOPGbbKsPLJxS4GCei2MU8QcrfCb
         omqQM2tlXLbocucZA/DMu0/jSX8O5D2BZFS0JS5g=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Alex Elder <elder@linaro.org>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.7 024/244] net: ipa: introduce ipa_cmd_tag_process()
Date:   Mon, 20 Jul 2020 17:34:55 +0200
Message-Id: <20200720152827.008366062@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200720152825.863040590@linuxfoundation.org>
References: <20200720152825.863040590@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alex Elder <elder@linaro.org>

[ Upstream commit 6cb63ea6a39eac9640d109f274a237b34350c183 ]

Create a new function ipa_cmd_tag_process() that simply allocates a
transaction, adds a tag process command to it to clear the hardware
pipeline, and commits the transaction.

Call it in from ipa_endpoint_suspend(), after suspending the modem
endpoints but before suspending the AP command TX and AP LAN RX
endpoints (which are used by the tag sequence).

Signed-off-by: Alex Elder <elder@linaro.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ipa/ipa_cmd.c      |   15 +++++++++++++++
 drivers/net/ipa/ipa_cmd.h      |    8 ++++++++
 drivers/net/ipa/ipa_endpoint.c |    2 ++
 3 files changed, 25 insertions(+)

--- a/drivers/net/ipa/ipa_cmd.c
+++ b/drivers/net/ipa/ipa_cmd.c
@@ -645,6 +645,21 @@ u32 ipa_cmd_tag_process_count(void)
 	return 4;
 }
 
+void ipa_cmd_tag_process(struct ipa *ipa)
+{
+	u32 count = ipa_cmd_tag_process_count();
+	struct gsi_trans *trans;
+
+	trans = ipa_cmd_trans_alloc(ipa, count);
+	if (trans) {
+		ipa_cmd_tag_process_add(trans);
+		gsi_trans_commit_wait(trans);
+	} else {
+		dev_err(&ipa->pdev->dev,
+			"error allocating %u entry tag transaction\n", count);
+	}
+}
+
 static struct ipa_cmd_info *
 ipa_cmd_info_alloc(struct ipa_endpoint *endpoint, u32 tre_count)
 {
--- a/drivers/net/ipa/ipa_cmd.h
+++ b/drivers/net/ipa/ipa_cmd.h
@@ -183,6 +183,14 @@ void ipa_cmd_tag_process_add(struct gsi_
 u32 ipa_cmd_tag_process_count(void);
 
 /**
+ * ipa_cmd_tag_process() - Perform a tag process
+ *
+ * @Return:	The number of elements to allocate in a transaction
+ *		to hold tag process commands
+ */
+void ipa_cmd_tag_process(struct ipa *ipa);
+
+/**
  * ipa_cmd_trans_alloc() - Allocate a transaction for the command TX endpoint
  * @ipa:	IPA pointer
  * @tre_count:	Number of elements in the transaction
--- a/drivers/net/ipa/ipa_endpoint.c
+++ b/drivers/net/ipa/ipa_endpoint.c
@@ -1485,6 +1485,8 @@ void ipa_endpoint_suspend(struct ipa *ip
 	if (ipa->modem_netdev)
 		ipa_modem_suspend(ipa->modem_netdev);
 
+	ipa_cmd_tag_process(ipa);
+
 	ipa_endpoint_suspend_one(ipa->name_map[IPA_ENDPOINT_AP_LAN_RX]);
 	ipa_endpoint_suspend_one(ipa->name_map[IPA_ENDPOINT_AP_COMMAND_TX]);
 }


