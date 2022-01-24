Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 763BD499AC7
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 22:57:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1378729AbiAXVqX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 16:46:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55820 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1456654AbiAXVjo (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 16:39:44 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B27DC0419C4;
        Mon, 24 Jan 2022 12:26:12 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 01D42B811F9;
        Mon, 24 Jan 2022 20:26:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 003D2C340E5;
        Mon, 24 Jan 2022 20:26:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643055969;
        bh=VGIkT8JLELxZFrOomgUDtxo9zPRY+QxiAo2uv+JBIW8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nffYg3gI5D9OTfbkOQpR+veEEyeIvzVRy3i//W0X9L9s598J3SAxEvUqEuvmuPOzj
         sr/viwpFz1eO/+z3W799nNSJ1xwUpsF8w7NLLXh6qd43C4l2xDXPpzlQpsESJNAYiJ
         zSCsS58gEN0EAQyVZ0XZGENM7krtExeOfyAiQlW4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Panicker Harish <quic_pharish@quicinc.com>,
        Marcel Holtmann <marcel@holtmann.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 293/846] Bluetooth: hci_qca: Stop IBS timer during BT OFF
Date:   Mon, 24 Jan 2022 19:36:50 +0100
Message-Id: <20220124184111.033095201@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184100.867127425@linuxfoundation.org>
References: <20220124184100.867127425@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Panicker Harish <quic_pharish@quicinc.com>

[ Upstream commit df1e5c51492fd93ffc293acdcc6f00698d19fedc ]

The IBS timers are not stopped properly once BT OFF is triggered.
we could see IBS commands being sent along with version command,
so stopped IBS timers while Bluetooth is off.

Fixes: 3e4be65eb82c ("Bluetooth: hci_qca: Add poweroff support during hci down for wcn3990")
Signed-off-by: Panicker Harish <quic_pharish@quicinc.com>
Signed-off-by: Marcel Holtmann <marcel@holtmann.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/bluetooth/hci_qca.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/bluetooth/hci_qca.c b/drivers/bluetooth/hci_qca.c
index 53deea2eb7b4d..3c26fc8463923 100644
--- a/drivers/bluetooth/hci_qca.c
+++ b/drivers/bluetooth/hci_qca.c
@@ -1927,6 +1927,9 @@ static int qca_power_off(struct hci_dev *hdev)
 	hu->hdev->hw_error = NULL;
 	hu->hdev->cmd_timeout = NULL;
 
+	del_timer_sync(&qca->wake_retrans_timer);
+	del_timer_sync(&qca->tx_idle_timer);
+
 	/* Stop sending shutdown command if soc crashes. */
 	if (soc_type != QCA_ROME
 		&& qca->memdump_state == QCA_MEMDUMP_IDLE) {
-- 
2.34.1



