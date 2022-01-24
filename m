Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 06521498B30
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 20:12:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345726AbiAXTMR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 14:12:17 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:36572 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345884AbiAXTGk (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 14:06:40 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 16EB0611DA;
        Mon, 24 Jan 2022 19:06:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD784C340E5;
        Mon, 24 Jan 2022 19:06:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643051197;
        bh=Sh+M3L0lB9KpZ1YUcJstaGMEojTqMlUaXuswNPJ9dYg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pBsBpRwJde5Gu4jGiFC6DzHgiPOPkFMlYspxUf2obor0F5oOL1PPCnDWuqI3iKMG3
         C854UMPjLfBRk9kz3QWMxXRXkgBf8U3ZFxui3tL6DGjvelIOjN1vCbOq6MDHWLwC49
         bavDU/9/7i2h203uzEJmhuFSmKrj1914cN0lJfg4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Wei Yongjun <weiyongjun1@huawei.com>,
        Marcel Holtmann <marcel@holtmann.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 086/186] Bluetooth: Fix debugfs entry leak in hci_register_dev()
Date:   Mon, 24 Jan 2022 19:42:41 +0100
Message-Id: <20220124183939.880661017@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124183937.101330125@linuxfoundation.org>
References: <20220124183937.101330125@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Wei Yongjun <weiyongjun1@huawei.com>

[ Upstream commit 5a4bb6a8e981d3d0d492aa38412ee80b21033177 ]

Fault injection test report debugfs entry leak as follows:

debugfs: Directory 'hci0' with parent 'bluetooth' already present!

When register_pm_notifier() failed in hci_register_dev(), the debugfs
create by debugfs_create_dir() do not removed in the error handing path.

Add the remove debugfs code to fix it.

Signed-off-by: Wei Yongjun <weiyongjun1@huawei.com>
Signed-off-by: Marcel Holtmann <marcel@holtmann.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bluetooth/hci_core.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/bluetooth/hci_core.c b/net/bluetooth/hci_core.c
index 1906adfd553ad..687b4d0e4c673 100644
--- a/net/bluetooth/hci_core.c
+++ b/net/bluetooth/hci_core.c
@@ -3183,6 +3183,7 @@ int hci_register_dev(struct hci_dev *hdev)
 	return id;
 
 err_wqueue:
+	debugfs_remove_recursive(hdev->debugfs);
 	destroy_workqueue(hdev->workqueue);
 	destroy_workqueue(hdev->req_workqueue);
 err:
-- 
2.34.1



