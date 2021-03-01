Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CADAA328EAC
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 20:37:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242072AbhCATfF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 14:35:05 -0500
Received: from mail.kernel.org ([198.145.29.99]:48602 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241866AbhCAT3b (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 14:29:31 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id CEA1964FAF;
        Mon,  1 Mar 2021 17:36:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614620205;
        bh=tCDPmrqyz8Ic824+AQZDAj529bEcuGdPZbFdlTfHn/I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qOcqkEnQwubVhblQ43ghMdUf/kb0HdxRFB9ovNNvDPxAqO1aQL/xH49Yrxlq2DHIX
         1OyifQY/p17q1Y5w2ekJOCCSgtKFpb1jhGD1A2uv2DAfdD1KV1quwM/byXls/B/8Wb
         Zw5/n0E4R1+tRgy0D32XAqDRxD4lRR/jxtSrQaDI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dinghao Liu <dinghao.liu@zju.edu.cn>,
        Marcel Holtmann <marcel@holtmann.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 038/775] Bluetooth: hci_qca: Fix memleak in qca_controller_memdump
Date:   Mon,  1 Mar 2021 17:03:26 +0100
Message-Id: <20210301161203.599738195@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161201.679371205@linuxfoundation.org>
References: <20210301161201.679371205@linuxfoundation.org>
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
index 4a963682c7021..5dbcb7c42b805 100644
--- a/drivers/bluetooth/hci_qca.c
+++ b/drivers/bluetooth/hci_qca.c
@@ -1024,7 +1024,9 @@ static void qca_controller_memdump(struct work_struct *work)
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



