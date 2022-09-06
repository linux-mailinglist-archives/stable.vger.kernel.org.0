Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 99B2B5AEC36
	for <lists+stable@lfdr.de>; Tue,  6 Sep 2022 16:28:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240841AbiIFOAt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 6 Sep 2022 10:00:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43882 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240983AbiIFN7Q (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 6 Sep 2022 09:59:16 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF4A983062;
        Tue,  6 Sep 2022 06:43:01 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7CCEE614C9;
        Tue,  6 Sep 2022 13:42:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7F618C433D6;
        Tue,  6 Sep 2022 13:42:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1662471767;
        bh=RgwTp/+6L4fw8BFVer85uyI+oumLirHMGkUf5M0yMcw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rV06rkS9NwJmo3/T5N2N2roBhyQB9bg8TXxP75iXGpLe3mINt6B/pJ5LlyQUd3gTe
         vI8J9h4jqRSQLMAqjxFJ+aeI+q21pv6mJMak6XA7Pr8+yKh/+yjltOIUiRAY0F9j2G
         n2IHPp06PdgzZcOmEzdHD0ajpTMDkNxr+C1/XgQc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 030/155] Bluetooth: hci_sync: Fix suspend performance regression
Date:   Tue,  6 Sep 2022 15:29:38 +0200
Message-Id: <20220906132830.696125381@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220906132829.417117002@linuxfoundation.org>
References: <20220906132829.417117002@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>

[ Upstream commit 1fd02d56dae35b08e4cba8e6bd2c2e7ccff68ecc ]

This attempts to fix suspend performance when there is no connections by
not updating the event mask.

Fixes: ef61b6ea1544 ("Bluetooth: Always set event mask on suspend")
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bluetooth/hci_sync.c | 24 ++++++++++++++----------
 1 file changed, 14 insertions(+), 10 deletions(-)

diff --git a/net/bluetooth/hci_sync.c b/net/bluetooth/hci_sync.c
index b5e7d4b8ab24a..2012f23158839 100644
--- a/net/bluetooth/hci_sync.c
+++ b/net/bluetooth/hci_sync.c
@@ -4967,17 +4967,21 @@ int hci_suspend_sync(struct hci_dev *hdev)
 	/* Prevent disconnects from causing scanning to be re-enabled */
 	hci_pause_scan_sync(hdev);
 
-	/* Soft disconnect everything (power off) */
-	err = hci_disconnect_all_sync(hdev, HCI_ERROR_REMOTE_POWER_OFF);
-	if (err) {
-		/* Set state to BT_RUNNING so resume doesn't notify */
-		hdev->suspend_state = BT_RUNNING;
-		hci_resume_sync(hdev);
-		return err;
-	}
+	if (hci_conn_count(hdev)) {
+		/* Soft disconnect everything (power off) */
+		err = hci_disconnect_all_sync(hdev, HCI_ERROR_REMOTE_POWER_OFF);
+		if (err) {
+			/* Set state to BT_RUNNING so resume doesn't notify */
+			hdev->suspend_state = BT_RUNNING;
+			hci_resume_sync(hdev);
+			return err;
+		}
 
-	/* Update event mask so only the allowed event can wakeup the host */
-	hci_set_event_mask_sync(hdev);
+		/* Update event mask so only the allowed event can wakeup the
+		 * host.
+		 */
+		hci_set_event_mask_sync(hdev);
+	}
 
 	/* Only configure accept list if disconnect succeeded and wake
 	 * isn't being prevented.
-- 
2.35.1



