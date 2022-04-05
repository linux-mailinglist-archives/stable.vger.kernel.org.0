Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A8ECB4F3C40
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 17:25:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244278AbiDEMGl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 08:06:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32860 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358262AbiDEK2L (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 06:28:11 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E5419DFA0;
        Tue,  5 Apr 2022 03:17:40 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A160AB81C8A;
        Tue,  5 Apr 2022 10:17:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC0D5C385A1;
        Tue,  5 Apr 2022 10:17:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649153858;
        bh=Pe5172lF1JtWSUI2NbHjGbtJdpNz2Bfb9/CBvizVf9c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0Tjgxv/fo5uZ9xjNQJJSUORUMK3T2CBcIINSvYT3F7qsIf6NpaX3jmK9htj8HAKpr
         BIEil1uQ3nFJlVY6iOYn38OKSfR0aYrIFZgGPPk03ld4OTbEI32zZn91k4K5QcPnQW
         CEWbV6QeA4AJHePT52KMFw9L13vhGZvACznu9Q5U=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Niels Dossche <dossche.niels@gmail.com>,
        Marcel Holtmann <marcel@holtmann.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 365/599] Bluetooth: call hci_le_conn_failed with hdev lock in hci_le_conn_failed
Date:   Tue,  5 Apr 2022 09:30:59 +0200
Message-Id: <20220405070309.692779975@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070258.802373272@linuxfoundation.org>
References: <20220405070258.802373272@linuxfoundation.org>
User-Agent: quilt/0.66
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

From: Niels Dossche <dossche.niels@gmail.com>

[ Upstream commit 9fa6b4cda3b414e990f008f45f9bcecbcb54d4d1 ]

hci_le_conn_failed function's documentation says that the caller must
hold hdev->lock. The only callsite that does not hold that lock is
hci_le_conn_failed. The other 3 callsites hold the hdev->lock very
locally. The solution is to hold the lock during the call to
hci_le_conn_failed.

Fixes: 3c857757ef6e ("Bluetooth: Add directed advertising support through connect()")
Signed-off-by: Niels Dossche <dossche.niels@gmail.com>
Signed-off-by: Marcel Holtmann <marcel@holtmann.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bluetooth/hci_conn.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/bluetooth/hci_conn.c b/net/bluetooth/hci_conn.c
index 1c5a0a60292d..ecd2ffcf2ba2 100644
--- a/net/bluetooth/hci_conn.c
+++ b/net/bluetooth/hci_conn.c
@@ -508,7 +508,9 @@ static void le_conn_timeout(struct work_struct *work)
 	if (conn->role == HCI_ROLE_SLAVE) {
 		/* Disable LE Advertising */
 		le_disable_advertising(hdev);
+		hci_dev_lock(hdev);
 		hci_le_conn_failed(conn, HCI_ERROR_ADVERTISING_TIMEOUT);
+		hci_dev_unlock(hdev);
 		return;
 	}
 
-- 
2.34.1



