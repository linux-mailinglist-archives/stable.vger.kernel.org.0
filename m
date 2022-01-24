Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6971B498DA1
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 20:34:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347135AbiAXTeG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 14:34:06 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:59380 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346571AbiAXTcB (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 14:32:01 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 34AC66121F;
        Mon, 24 Jan 2022 19:32:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 17FBFC340E5;
        Mon, 24 Jan 2022 19:31:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643052719;
        bh=1qafoHmQHzEeYvZZ5mPQtfK7V5ZbfodQBUKQCPnWoO0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Z1vDJuXvfXWFIXdmxt2V+JEvXAggnDSeS3cMJ3gFfIpgDLkqo7Bv3QCpBP+DZR5x0
         AWGTAl1A689kn2uXywkQUASiFyI/rCKMx4uTouLnhhIG7BlfxYepJY+hlEhzjPanuZ
         NOiXepZFPBLw5oprbYyype/M0XsaiFRGdklQNN5o=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Wei Yongjun <weiyongjun1@huawei.com>,
        Marcel Holtmann <marcel@holtmann.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 152/320] Bluetooth: Fix debugfs entry leak in hci_register_dev()
Date:   Mon, 24 Jan 2022 19:42:16 +0100
Message-Id: <20220124183958.807958146@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124183953.750177707@linuxfoundation.org>
References: <20220124183953.750177707@linuxfoundation.org>
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
index c50e3e8afbd34..2edaa601df13a 100644
--- a/net/bluetooth/hci_core.c
+++ b/net/bluetooth/hci_core.c
@@ -3387,6 +3387,7 @@ int hci_register_dev(struct hci_dev *hdev)
 	return id;
 
 err_wqueue:
+	debugfs_remove_recursive(hdev->debugfs);
 	destroy_workqueue(hdev->workqueue);
 	destroy_workqueue(hdev->req_workqueue);
 err:
-- 
2.34.1



