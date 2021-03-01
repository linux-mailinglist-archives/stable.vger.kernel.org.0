Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6F1A6328FE8
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 21:01:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242646AbhCAT67 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 14:58:59 -0500
Received: from mail.kernel.org ([198.145.29.99]:55192 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241877AbhCATra (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 14:47:30 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 50AC56515B;
        Mon,  1 Mar 2021 17:06:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614618378;
        bh=qYHcelP+1byxYx+bmqXO0RlOMU6hMNfB1M9ZtayTxuY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ttew9c5LlBI6BXEKg1meoeu3zNwxhHlW0yqkly6L2lvSS/OZB6z7F6ra5w6YPM1HV
         52Ya55FYJzYIBHJf13gCBrjfp5KrP4vwZM1L1h5v2+buVJOJqvoHmpMxTsWjkwIbgj
         oMxnNfjg7Qt3JGpWujURymnrbDVnQ1vopn6urYBo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dinghao Liu <dinghao.liu@zju.edu.cn>,
        Marcel Holtmann <marcel@holtmann.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 036/663] Bluetooth: hci_qca: Fix memleak in qca_controller_memdump
Date:   Mon,  1 Mar 2021 17:04:44 +0100
Message-Id: <20210301161143.582291749@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161141.760350206@linuxfoundation.org>
References: <20210301161141.760350206@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dinghao Liu <dinghao.liu@zju.edu.cn>

[ Upstream commit 71f8e707557b9bc25dc90a59a752528d4e7c1cbf ]

When __le32_to_cpu() fails, qca_memdump should be freed
just like when vmalloc() fails.

Fixes: d841502c79e3f ("Bluetooth: hci_qca: Collect controller memory dump during SSR")
Signed-off-by: Dinghao Liu <dinghao.liu@zju.edu.cn>
Signed-off-by: Marcel Holtmann <marcel@holtmann.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/bluetooth/hci_qca.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/bluetooth/hci_qca.c b/drivers/bluetooth/hci_qca.c
index 244b8feba5232..5c26c7d941731 100644
--- a/drivers/bluetooth/hci_qca.c
+++ b/drivers/bluetooth/hci_qca.c
@@ -1020,7 +1020,9 @@ static void qca_controller_memdump(struct work_struct *work)
 			dump_size = __le32_to_cpu(dump->dump_size);
 			if (!(dump_size)) {
 				bt_dev_err(hu->hdev, "Rx invalid memdump size");
+				kfree(qca_memdump);
 				kfree_skb(skb);
+				qca->qca_memdump = NULL;
 				mutex_unlock(&qca->hci_memdump_lock);
 				return;
 			}
-- 
2.27.0



