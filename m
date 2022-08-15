Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1DA32594F9F
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 06:31:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229682AbiHPEa5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Aug 2022 00:30:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44190 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229673AbiHPEaa (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 16 Aug 2022 00:30:30 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2AC2215CE28;
        Mon, 15 Aug 2022 13:18:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 913EDB81135;
        Mon, 15 Aug 2022 20:18:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE411C433C1;
        Mon, 15 Aug 2022 20:18:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660594693;
        bh=101aRdQRbjE4KjXETMaG5UNfHXPX9Z5bUYAjih/HHLg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=b9z0UAYfy4Cb09EFv+3llONMhsBx4VSbZmupIR5AapEFGkpEsaglZprojaEeDKqoo
         76Flb8q2ikI30wh7bYGk6RiuW3fEKHK8+8PUgn7DezAgkmO85QCR2vqGHUpYg+2D/P
         m4ItLlFMPAEHTBOkCLuNRdo1dZNsOv3GCiER404M=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Zhengping Jiang <jiangzp@google.com>,
        Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 0529/1157] Bluetooth: mgmt: Fix refresh cached connection info
Date:   Mon, 15 Aug 2022 19:58:05 +0200
Message-Id: <20220815180500.814458720@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180439.416659447@linuxfoundation.org>
References: <20220815180439.416659447@linuxfoundation.org>
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

From: Zhengping Jiang <jiangzp@google.com>

[ Upstream commit d7b2fdfb53ea09382941c0a4950dc9b00d51d1c7 ]

Set the connection data before calling get_conn_info_sync, so it can be
verified the connection is still connected, before refreshing cached
values.

Fixes: 47db6b42991e6 ("Bluetooth: hci_sync: Convert MGMT_OP_GET_CONN_INFO")
Signed-off-by: Zhengping Jiang <jiangzp@google.com>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bluetooth/mgmt.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/net/bluetooth/mgmt.c b/net/bluetooth/mgmt.c
index 2f91a8c2b678..cbdf0e2bc5ae 100644
--- a/net/bluetooth/mgmt.c
+++ b/net/bluetooth/mgmt.c
@@ -6820,11 +6820,14 @@ static int get_conn_info(struct sock *sk, struct hci_dev *hdev, void *data,
 
 		cmd = mgmt_pending_new(sk, MGMT_OP_GET_CONN_INFO, hdev, data,
 				       len);
-		if (!cmd)
+		if (!cmd) {
 			err = -ENOMEM;
-		else
+		} else {
+			hci_conn_hold(conn);
+			cmd->user_data = hci_conn_get(conn);
 			err = hci_cmd_sync_queue(hdev, get_conn_info_sync,
 						 cmd, get_conn_info_complete);
+		}
 
 		if (err < 0) {
 			mgmt_cmd_complete(sk, hdev->id, MGMT_OP_GET_CONN_INFO,
@@ -6836,9 +6839,6 @@ static int get_conn_info(struct sock *sk, struct hci_dev *hdev, void *data,
 			goto unlock;
 		}
 
-		hci_conn_hold(conn);
-		cmd->user_data = hci_conn_get(conn);
-
 		conn->conn_info_timestamp = jiffies;
 	} else {
 		/* Cache is valid, just reply with values cached in hci_conn */
-- 
2.35.1



