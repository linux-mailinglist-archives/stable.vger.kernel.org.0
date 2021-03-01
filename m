Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4D3B1328BFC
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 19:45:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240553AbhCASnd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 13:43:33 -0500
Received: from mail.kernel.org ([198.145.29.99]:49798 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240397AbhCASix (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 13:38:53 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id B682F6513E;
        Mon,  1 Mar 2021 17:04:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614618260;
        bh=ol4GagMuc4mN3qfoXuJEQyU4d5LRzXaTCQJgQOfhGME=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SckV4nCEVrI/kyOcn6V7uSuiHqBl4TcqFt2zuXR8N3oaVFzQvqyJQ2fPAeT4iZgDk
         qDtUFOQAMwlCQNK7pdI7pP+hWKta4sKu7NhPNtMXlOGjUUVIKMm3vAQXf88uJ/iDvA
         gixDGVvSvoOSgFa9JNZHWc4TATvYMM2VZY7vKCgY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        Marcel Holtmann <marcel@holtmann.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 022/663] Bluetooth: btqcomsmd: Fix a resource leak in error handling paths in the probe function
Date:   Mon,  1 Mar 2021 17:04:30 +0100
Message-Id: <20210301161142.889565403@linuxfoundation.org>
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

From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>

[ Upstream commit 9a39a927be01d89e53f04304ab99a8761e08910d ]

Some resource should be released in the error handling path of the probe
function, as already done in the remove function.

The remove function was fixed in commit 5052de8deff5 ("soc: qcom: smd:
Transition client drivers from smd to rpmsg")

Fixes: 1511cc750c3d ("Bluetooth: Introduce Qualcomm WCNSS SMD based HCI driver")
Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Signed-off-by: Marcel Holtmann <marcel@holtmann.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/bluetooth/btqcomsmd.c | 27 +++++++++++++++++++--------
 1 file changed, 19 insertions(+), 8 deletions(-)

diff --git a/drivers/bluetooth/btqcomsmd.c b/drivers/bluetooth/btqcomsmd.c
index 98d53764871f5..2acb719e596f5 100644
--- a/drivers/bluetooth/btqcomsmd.c
+++ b/drivers/bluetooth/btqcomsmd.c
@@ -142,12 +142,16 @@ static int btqcomsmd_probe(struct platform_device *pdev)
 
 	btq->cmd_channel = qcom_wcnss_open_channel(wcnss, "APPS_RIVA_BT_CMD",
 						   btqcomsmd_cmd_callback, btq);
-	if (IS_ERR(btq->cmd_channel))
-		return PTR_ERR(btq->cmd_channel);
+	if (IS_ERR(btq->cmd_channel)) {
+		ret = PTR_ERR(btq->cmd_channel);
+		goto destroy_acl_channel;
+	}
 
 	hdev = hci_alloc_dev();
-	if (!hdev)
-		return -ENOMEM;
+	if (!hdev) {
+		ret = -ENOMEM;
+		goto destroy_cmd_channel;
+	}
 
 	hci_set_drvdata(hdev, btq);
 	btq->hdev = hdev;
@@ -161,14 +165,21 @@ static int btqcomsmd_probe(struct platform_device *pdev)
 	hdev->set_bdaddr = qca_set_bdaddr_rome;
 
 	ret = hci_register_dev(hdev);
-	if (ret < 0) {
-		hci_free_dev(hdev);
-		return ret;
-	}
+	if (ret < 0)
+		goto hci_free_dev;
 
 	platform_set_drvdata(pdev, btq);
 
 	return 0;
+
+hci_free_dev:
+	hci_free_dev(hdev);
+destroy_cmd_channel:
+	rpmsg_destroy_ept(btq->cmd_channel);
+destroy_acl_channel:
+	rpmsg_destroy_ept(btq->acl_channel);
+
+	return ret;
 }
 
 static int btqcomsmd_remove(struct platform_device *pdev)
-- 
2.27.0



