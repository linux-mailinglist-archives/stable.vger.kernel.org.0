Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5CECB12C850
	for <lists+stable@lfdr.de>; Sun, 29 Dec 2019 19:16:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732082AbfL2Rx2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 29 Dec 2019 12:53:28 -0500
Received: from mail.kernel.org ([198.145.29.99]:40492 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732463AbfL2Rx1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 29 Dec 2019 12:53:27 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B68FF206DB;
        Sun, 29 Dec 2019 17:53:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1577642007;
        bh=75ksc0Fs5EbTGUWnXhGRT4NgnHpaPY6EdU+RtEKlmWE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Vbq4XKhwlGIXHv603r+sgEcUK63uFcXk54lkXELcBMQIMzqYr9Wgn/XROB2bpGp48
         sIv5mWAL5gWpcplgizZ7LmdgtWXw86bJy1aioSVp1vw6UNtAmRd+brM0So7O3QWFyf
         B6Ym4T3pjNDuEDyb+Wz0joBu/v83/hZU+s4EZvpA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 303/434] qtnfmac: fix using skb after free
Date:   Sun, 29 Dec 2019 18:25:56 +0100
Message-Id: <20191229172722.079860912@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191229172702.393141737@linuxfoundation.org>
References: <20191229172702.393141737@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>

[ Upstream commit 4a33f21cef84b1b933958c99ed5dac1726214b35 ]

KASAN reported use-after-free error:

[  995.220767] BUG: KASAN: use-after-free in qtnf_cmd_send_with_reply+0x169/0x3e0 [qtnfmac]
[  995.221098] Read of size 2 at addr ffff888213d1ded0 by task kworker/1:1/71

The issue in qtnf_cmd_send_with_reply impacts all the commands that do
not need response other then return code. For such commands, consume_skb
is used for response skb and right after that return code in response
skb is accessed.

Signed-off-by: Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/quantenna/qtnfmac/commands.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/quantenna/qtnfmac/commands.c b/drivers/net/wireless/quantenna/qtnfmac/commands.c
index dc0c7244b60e..c0c32805fb8d 100644
--- a/drivers/net/wireless/quantenna/qtnfmac/commands.c
+++ b/drivers/net/wireless/quantenna/qtnfmac/commands.c
@@ -83,6 +83,7 @@ static int qtnf_cmd_send_with_reply(struct qtnf_bus *bus,
 	struct qlink_cmd *cmd;
 	struct qlink_resp *resp = NULL;
 	struct sk_buff *resp_skb = NULL;
+	int resp_res = 0;
 	u16 cmd_id;
 	u8 mac_id;
 	u8 vif_id;
@@ -113,6 +114,7 @@ static int qtnf_cmd_send_with_reply(struct qtnf_bus *bus,
 	}
 
 	resp = (struct qlink_resp *)resp_skb->data;
+	resp_res = le16_to_cpu(resp->result);
 	ret = qtnf_cmd_check_reply_header(resp, cmd_id, mac_id, vif_id,
 					  const_resp_size);
 	if (ret)
@@ -128,8 +130,8 @@ out:
 	else
 		consume_skb(resp_skb);
 
-	if (!ret && resp)
-		return qtnf_cmd_resp_result_decode(le16_to_cpu(resp->result));
+	if (!ret)
+		return qtnf_cmd_resp_result_decode(resp_res);
 
 	pr_warn("VIF%u.%u: cmd 0x%.4X failed: %d\n",
 		mac_id, vif_id, cmd_id, ret);
-- 
2.20.1



