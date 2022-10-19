Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5CD4D603F45
	for <lists+stable@lfdr.de>; Wed, 19 Oct 2022 11:31:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229697AbiJSJbD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Oct 2022 05:31:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48916 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233410AbiJSJ2N (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Oct 2022 05:28:13 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 85205E8AA4;
        Wed, 19 Oct 2022 02:12:27 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 63DA761890;
        Wed, 19 Oct 2022 09:11:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 79029C433D6;
        Wed, 19 Oct 2022 09:11:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666170673;
        bh=nqnzV76i/7+Dexr0VLbVB6a6AGYIYb3csiWZnBgbDck=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=E6EL5pi7bX2FjNV9kQuTzCqH/8kfaXQgi0LRaj6D7woTdt6dIpBASa7Ww2FBLZfJ4
         HJK+yxFKhZsSDD8yN8O/wBXmoAnsGJvrQvnJ5IYbqqp/7LYo2NLbkNeSYsbQYgUw0T
         tBkUEwQIwUKXr9lMZtL9cXUengOgJtlMO/BcBg2g=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 710/862] Bluetooth: hci_event: Make sure ISO events dont affect non-ISO connections
Date:   Wed, 19 Oct 2022 10:33:17 +0200
Message-Id: <20221019083321.320060597@linuxfoundation.org>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20221019083249.951566199@linuxfoundation.org>
References: <20221019083249.951566199@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>

[ Upstream commit ed680f925aea76ac666f34d9923cb40558f4e97b ]

ISO events (CIS/BIS) shall only be relevant for connection with link
type of ISO_LINK, otherwise the controller is probably buggy or it is
the result of fuzzer tools such as syzkaller.

Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bluetooth/hci_event.c | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/net/bluetooth/hci_event.c b/net/bluetooth/hci_event.c
index d6f0e6ca0e7e..ab79a978deb5 100644
--- a/net/bluetooth/hci_event.c
+++ b/net/bluetooth/hci_event.c
@@ -6778,6 +6778,13 @@ static void hci_le_cis_estabilished_evt(struct hci_dev *hdev, void *data,
 		goto unlock;
 	}
 
+	if (conn->type != ISO_LINK) {
+		bt_dev_err(hdev,
+			   "Invalid connection link type handle 0x%4.4x",
+			   handle);
+		goto unlock;
+	}
+
 	if (conn->role == HCI_ROLE_SLAVE) {
 		__le32 interval;
 
@@ -6898,6 +6905,13 @@ static void hci_le_create_big_complete_evt(struct hci_dev *hdev, void *data,
 	if (!conn)
 		goto unlock;
 
+	if (conn->type != ISO_LINK) {
+		bt_dev_err(hdev,
+			   "Invalid connection link type handle 0x%2.2x",
+			   ev->handle);
+		goto unlock;
+	}
+
 	if (ev->num_bis)
 		conn->handle = __le16_to_cpu(ev->bis_handle[0]);
 
-- 
2.35.1



