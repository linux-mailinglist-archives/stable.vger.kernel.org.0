Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D1DCE261C38
	for <lists+stable@lfdr.de>; Tue,  8 Sep 2020 21:16:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731947AbgIHTQZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Sep 2020 15:16:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:53450 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730963AbgIHQEj (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 8 Sep 2020 12:04:39 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AA59E2467C;
        Tue,  8 Sep 2020 15:39:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599579570;
        bh=wkAzy+/lV7e2qMtMdBz3rknYjw51l58UVEVCpQvBVJY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1jLgQH/3hm5vAancixbCF0MBeOT3nRWpM29jtUFitA+y+w691qZF4+u/dbkUUO3TH
         pG3ijwnNvWkF1ELr93WTmQjZZH1g1XWejli3xv2G+M2sTRtRqsE/cl7XiQiMg3qpsm
         9DuAuZ9dlAa61It8oAj4S3p/7IraLnXzAk8xFz7A=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Max Chou <max.chou@realtek.com>,
        Marcel Holtmann <marcel@holtmann.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.8 132/186] Bluetooth: Return NOTIFY_DONE for hci_suspend_notifier
Date:   Tue,  8 Sep 2020 17:24:34 +0200
Message-Id: <20200908152248.042281584@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200908152241.646390211@linuxfoundation.org>
References: <20200908152241.646390211@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Max Chou <max.chou@realtek.com>

[ Upstream commit 24b065727ceba53cc5bec0e725672417154df24f ]

The original return is NOTIFY_STOP, but notifier_call_chain would stop
the future call for register_pm_notifier even registered on other Kernel
modules with the same priority which value is zero.

Signed-off-by: Max Chou <max.chou@realtek.com>
Signed-off-by: Marcel Holtmann <marcel@holtmann.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bluetooth/hci_core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/bluetooth/hci_core.c b/net/bluetooth/hci_core.c
index 41fba93d857a6..fc28dc201b936 100644
--- a/net/bluetooth/hci_core.c
+++ b/net/bluetooth/hci_core.c
@@ -3370,7 +3370,7 @@ static int hci_suspend_notifier(struct notifier_block *nb, unsigned long action,
 		bt_dev_err(hdev, "Suspend notifier action (%lu) failed: %d",
 			   action, ret);
 
-	return NOTIFY_STOP;
+	return NOTIFY_DONE;
 }
 
 /* Alloc HCI device */
-- 
2.25.1



