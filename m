Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CD7E349A90D
	for <lists+stable@lfdr.de>; Tue, 25 Jan 2022 05:18:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1321975AbiAYDUR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 22:20:17 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:47724 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244739AbiAXTuz (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 14:50:55 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id AD61660B89;
        Mon, 24 Jan 2022 19:50:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 913FDC340E5;
        Mon, 24 Jan 2022 19:50:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643053848;
        bh=m0OcBpcxmIF16T15F0g3LId9WJ1aV0DdmBGbFIrLcTo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OaE0icx0hWyDhWWo7DwsUxozoPxmPiax0t06ZKDGT1hDGlVFRzATL5crgxwTF9t7X
         abAy0V7KCL35/e8LPRK/wmaS8C0KnV2/5Lpae8LxQADq3Sgf8OzrebZwfBw6RHXH7T
         gBs36dgu87Zh1Fpvdt2Xy/hzgx4897Dm4ur5JYIY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Panicker Harish <quic_pharish@quicinc.com>,
        Marcel Holtmann <marcel@holtmann.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 196/563] Bluetooth: hci_qca: Stop IBS timer during BT OFF
Date:   Mon, 24 Jan 2022 19:39:21 +0100
Message-Id: <20220124184031.210103661@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184024.407936072@linuxfoundation.org>
References: <20220124184024.407936072@linuxfoundation.org>
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
index 4184faef9f169..4f8a32601c1b6 100644
--- a/drivers/bluetooth/hci_qca.c
+++ b/drivers/bluetooth/hci_qca.c
@@ -1844,6 +1844,9 @@ static int qca_power_off(struct hci_dev *hdev)
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



