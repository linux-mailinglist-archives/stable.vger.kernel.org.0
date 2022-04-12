Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1FE634FD173
	for <lists+stable@lfdr.de>; Tue, 12 Apr 2022 08:57:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351613AbiDLG6h (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Apr 2022 02:58:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48686 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351988AbiDLGyu (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 12 Apr 2022 02:54:50 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 438A13137F;
        Mon, 11 Apr 2022 23:44:47 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9B91A60EF9;
        Tue, 12 Apr 2022 06:44:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A9D57C385A1;
        Tue, 12 Apr 2022 06:44:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649745886;
        bh=qaSj/7LegKEakoTuH7bRNXzfMCErFLQzfr9njREQeCE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xVQTpHAer47rYmGZyp/7Gd4aZ7rCpHuHxhL0odzdgubIOVaOwQDoaYCQDQjso9ncp
         PBJCHc8XZvc+ZILzYpnY5HoTn7sIb2u07hv17x76Gj6Ip8JLWj2xnBm2Mk0jHLzv63
         AICpnC28n5hWo4MwPe/erP0z4VEwW7r4zQreugok=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
        Marcel Holtmann <marcel@holtmann.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 082/277] Bluetooth: Fix not checking for valid hdev on bt_dev_{info,warn,err,dbg}
Date:   Tue, 12 Apr 2022 08:28:05 +0200
Message-Id: <20220412062944.422009023@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220412062942.022903016@linuxfoundation.org>
References: <20220412062942.022903016@linuxfoundation.org>
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

From: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>

[ Upstream commit 9b392e0e0b6d026da5a62bb79a08f32e27af858e ]

This fixes attemting to print hdev->name directly which causes them to
print an error:

kernel: read_version:367: (efault): sock 000000006a3008f2

Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Marcel Holtmann <marcel@holtmann.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/bluetooth/bluetooth.h | 14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

diff --git a/include/net/bluetooth/bluetooth.h b/include/net/bluetooth/bluetooth.h
index 9125effbf448..3fecc4a411a1 100644
--- a/include/net/bluetooth/bluetooth.h
+++ b/include/net/bluetooth/bluetooth.h
@@ -180,19 +180,21 @@ void bt_err_ratelimited(const char *fmt, ...);
 #define BT_DBG(fmt, ...)	pr_debug(fmt "\n", ##__VA_ARGS__)
 #endif
 
+#define bt_dev_name(hdev) ((hdev) ? (hdev)->name : "null")
+
 #define bt_dev_info(hdev, fmt, ...)				\
-	BT_INFO("%s: " fmt, (hdev)->name, ##__VA_ARGS__)
+	BT_INFO("%s: " fmt, bt_dev_name(hdev), ##__VA_ARGS__)
 #define bt_dev_warn(hdev, fmt, ...)				\
-	BT_WARN("%s: " fmt, (hdev)->name, ##__VA_ARGS__)
+	BT_WARN("%s: " fmt, bt_dev_name(hdev), ##__VA_ARGS__)
 #define bt_dev_err(hdev, fmt, ...)				\
-	BT_ERR("%s: " fmt, (hdev)->name, ##__VA_ARGS__)
+	BT_ERR("%s: " fmt, bt_dev_name(hdev), ##__VA_ARGS__)
 #define bt_dev_dbg(hdev, fmt, ...)				\
-	BT_DBG("%s: " fmt, (hdev)->name, ##__VA_ARGS__)
+	BT_DBG("%s: " fmt, bt_dev_name(hdev), ##__VA_ARGS__)
 
 #define bt_dev_warn_ratelimited(hdev, fmt, ...)			\
-	bt_warn_ratelimited("%s: " fmt, (hdev)->name, ##__VA_ARGS__)
+	bt_warn_ratelimited("%s: " fmt, bt_dev_name(hdev), ##__VA_ARGS__)
 #define bt_dev_err_ratelimited(hdev, fmt, ...)			\
-	bt_err_ratelimited("%s: " fmt, (hdev)->name, ##__VA_ARGS__)
+	bt_err_ratelimited("%s: " fmt, bt_dev_name(hdev), ##__VA_ARGS__)
 
 /* Connection and socket states */
 enum {
-- 
2.35.1



