Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3A72454145D
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 22:18:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355475AbiFGURZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 16:17:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37648 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358987AbiFGUOq (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 16:14:46 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 95258170673;
        Tue,  7 Jun 2022 11:28:22 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DD720612EC;
        Tue,  7 Jun 2022 18:28:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E4A38C385A2;
        Tue,  7 Jun 2022 18:28:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654626501;
        bh=fBS2BidZn5RqdMjmAq72Xd9LzbXKHWPaJR3JL95dGIc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UNyCHjXLE5v2PBKf04/SiZzBGtKDyoLXJgBVUTO3ZFCPNVnVwF0078mKjy269sacV
         KrEUDLaiHxTYcO7d0/6FvVAC54leR/KeCXSaFKuJDT9qbpB5KC5/T9oXtjWphgfqIN
         wZ6KqESqMmlnGXycu0Z+39jVEn+vlL165E7TDp7w=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Niels Dossche <dossche.niels@gmail.com>,
        Marcel Holtmann <marcel@holtmann.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 384/772] Bluetooth: use hdev lock in activate_scan for hci_is_adv_monitoring
Date:   Tue,  7 Jun 2022 18:59:36 +0200
Message-Id: <20220607165000.331262660@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607164948.980838585@linuxfoundation.org>
References: <20220607164948.980838585@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Niels Dossche <dossche.niels@gmail.com>

[ Upstream commit 50a3633ae5e98cf1b80ef5b73c9e341aee9ad896 ]

hci_is_adv_monitoring's function documentation states that it must be
called under the hdev lock. Paths that leads to an unlocked call are:
discov_update => start_discovery => interleaved_discov => active_scan
and: discov_update => start_discovery => active_scan

The solution is to take the lock in active_scan during the duration of
the call to hci_is_adv_monitoring.

Fixes: c32d624640fd ("Bluetooth: disable filter dup when scan for adv monitor")
Signed-off-by: Niels Dossche <dossche.niels@gmail.com>
Signed-off-by: Marcel Holtmann <marcel@holtmann.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bluetooth/hci_request.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/bluetooth/hci_request.c b/net/bluetooth/hci_request.c
index 42c8047a9897..f4afe482e300 100644
--- a/net/bluetooth/hci_request.c
+++ b/net/bluetooth/hci_request.c
@@ -2260,6 +2260,7 @@ static int active_scan(struct hci_request *req, unsigned long opt)
 	if (err < 0)
 		own_addr_type = ADDR_LE_DEV_PUBLIC;
 
+	hci_dev_lock(hdev);
 	if (hci_is_adv_monitoring(hdev)) {
 		/* Duplicate filter should be disabled when some advertisement
 		 * monitor is activated, otherwise AdvMon can only receive one
@@ -2276,6 +2277,7 @@ static int active_scan(struct hci_request *req, unsigned long opt)
 		 */
 		filter_dup = LE_SCAN_FILTER_DUP_DISABLE;
 	}
+	hci_dev_unlock(hdev);
 
 	hci_req_start_scan(req, LE_SCAN_ACTIVE, interval,
 			   hdev->le_scan_window_discovery, own_addr_type,
-- 
2.35.1



