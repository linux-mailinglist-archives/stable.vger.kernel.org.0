Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 97455593F41
	for <lists+stable@lfdr.de>; Mon, 15 Aug 2022 23:45:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241564AbiHOVTb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 17:19:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37562 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344479AbiHOVRa (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 17:17:30 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A5585725B;
        Mon, 15 Aug 2022 12:20:42 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BC1436009B;
        Mon, 15 Aug 2022 19:20:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B8DD6C433C1;
        Mon, 15 Aug 2022 19:20:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660591241;
        bh=W8tKKp3uQ7QzLlBkW/w8MCeuiMzfHsJzpzwh8y5v5xk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vfb3fZPYhRHw0YFxIHp6gjnEjTPZabG2TcaKZqwKzt7I8NGkAEW5LaoUbQ4ii5BvO
         JPsGlD9r82B9HpItyvbMdNjfoQVF1JwRBXSDO+cem2/M9IlnAqtHqrw19LHw9i7bt8
         xWImAGlb2Mtqpnkmv/JxJVY76zHZ+ZzIORfdJXhY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
        Zhengping Jiang <jiangzp@google.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 0499/1095] Bluetooth: hci_sync: Fix not updating privacy_mode
Date:   Mon, 15 Aug 2022 19:58:18 +0200
Message-Id: <20220815180450.170806979@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180429.240518113@linuxfoundation.org>
References: <20220815180429.240518113@linuxfoundation.org>
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

[ Upstream commit 0900b1c62f43e495d04ca4bebdf80b34f3c12432 ]

When programming a new entry into the resolving list it shall default
to network mode since the params may contain the mode programmed when
the device was last added to the resolving list.

Link: https://bugzilla.kernel.org/show_bug.cgi?id=209745
Fixes: 853b70b506a20 ("Bluetooth: hci_sync: Set Privacy Mode when updating the resolving list")
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Tested-by: Zhengping Jiang <jiangzp@google.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bluetooth/hci_sync.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/bluetooth/hci_sync.c b/net/bluetooth/hci_sync.c
index 99ef15167a81..6f901398132e 100644
--- a/net/bluetooth/hci_sync.c
+++ b/net/bluetooth/hci_sync.c
@@ -1612,6 +1612,9 @@ static int hci_le_add_resolve_list_sync(struct hci_dev *hdev,
 	bacpy(&cp.bdaddr, &params->addr);
 	memcpy(cp.peer_irk, irk->val, 16);
 
+	/* Default privacy mode is always Network */
+	params->privacy_mode = HCI_NETWORK_PRIVACY;
+
 done:
 	if (hci_dev_test_flag(hdev, HCI_PRIVACY))
 		memcpy(cp.local_irk, hdev->irk, 16);
-- 
2.35.1



