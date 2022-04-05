Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C3C2C4F3809
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 16:27:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1359863AbiDELVK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 07:21:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39466 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349307AbiDEJtg (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 05:49:36 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB9AFB99;
        Tue,  5 Apr 2022 02:43:52 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5AC6061368;
        Tue,  5 Apr 2022 09:43:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 61CF4C385A2;
        Tue,  5 Apr 2022 09:43:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649151831;
        bh=uQoHJ3NW9CnApT7MV8GyRFwYt2MTapU0cySGZldJvYo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ax4sgprKOyNRtQSJ2FMKXrkV0l09CPyv9OShtF78PdE1sxz8azt/3oGl+n17o7iYS
         1dGsdEdJ7D7PEN2OjiYZS08znanJabm+JAE4IgX9NDbzGQUX2tVqA+UK+m1jZYem3+
         6rya1Nj1+7KqrbbHgPUr5/Hj1hrC2KLHzyIccLwU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Niels Dossche <dossche.niels@gmail.com>,
        Marcel Holtmann <marcel@holtmann.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 557/913] Bluetooth: call hci_le_conn_failed with hdev lock in hci_le_conn_failed
Date:   Tue,  5 Apr 2022 09:26:59 +0200
Message-Id: <20220405070356.542777819@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070339.801210740@linuxfoundation.org>
References: <20220405070339.801210740@linuxfoundation.org>
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
index 2b5059a56cda..7a7e92be1652 100644
--- a/net/bluetooth/hci_conn.c
+++ b/net/bluetooth/hci_conn.c
@@ -541,7 +541,9 @@ static void le_conn_timeout(struct work_struct *work)
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



