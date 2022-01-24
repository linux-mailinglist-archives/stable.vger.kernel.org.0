Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 60A68498A0E
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 20:01:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236847AbiAXTBT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 14:01:19 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:55618 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343518AbiAXS5t (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 13:57:49 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 09CC5B8121C;
        Mon, 24 Jan 2022 18:57:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2DF25C340E5;
        Mon, 24 Jan 2022 18:57:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643050666;
        bh=8HhqhLYUtzscszQjAX1dCUydahnbhPvnAe7pYo2zT+Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zYd5Bvls/YEUFsQUt3AK+YZrMqvsifYgAWqP3YEYKCLIIZBjl4Xt7C61vzSbRDL/M
         oLKHITcHGOKlILK4sbbiO6O1BEnAFq0ysFNhfpczQLBMmfBHlco6mQU0PvSoMhjX/g
         cKc7gFFq2NROdJo5N++c8yGJ8FRG2NksbP72HjHI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Wei Yongjun <weiyongjun1@huawei.com>,
        Marcel Holtmann <marcel@holtmann.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 073/157] Bluetooth: Fix debugfs entry leak in hci_register_dev()
Date:   Mon, 24 Jan 2022 19:42:43 +0100
Message-Id: <20220124183935.107317641@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124183932.787526760@linuxfoundation.org>
References: <20220124183932.787526760@linuxfoundation.org>
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
index b43f31203a430..40e6e5feb1e06 100644
--- a/net/bluetooth/hci_core.c
+++ b/net/bluetooth/hci_core.c
@@ -3148,6 +3148,7 @@ int hci_register_dev(struct hci_dev *hdev)
 	return id;
 
 err_wqueue:
+	debugfs_remove_recursive(hdev->debugfs);
 	destroy_workqueue(hdev->workqueue);
 	destroy_workqueue(hdev->req_workqueue);
 err:
-- 
2.34.1



