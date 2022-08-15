Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4DD575947D3
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 02:04:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355282AbiHOXzx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 19:55:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53218 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356137AbiHOXxt (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 19:53:49 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F287C15D8B4;
        Mon, 15 Aug 2022 13:18:29 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A8709B81180;
        Mon, 15 Aug 2022 20:18:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F2205C433D6;
        Mon, 15 Aug 2022 20:18:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660594699;
        bh=gf2Bk2iD4BPXWUsUwXH2JRtnr/UQ0t8TXQ7XkoxKOZ8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zELVUNh5wKQeHnAM70+JF7J7kdvhNHlOgwb/Q3XvQSBOUZIx42prms9ZnvMro8Fu9
         MFph+SmkQivEbEPT7yEHGZHx1xPV5rgF4dYdICeCQKAwKUf1i0aBSQmGtK8bcsH1zF
         lakuLPe87ANv05+iJgtWgBTEPgcale9HPOdJ84PM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
        Zhengping Jiang <jiangzp@google.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 0531/1157] Bluetooth: hci_sync: Fix not updating privacy_mode
Date:   Mon, 15 Aug 2022 19:58:07 +0200
Message-Id: <20220815180500.889796697@linuxfoundation.org>
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
index 1641db8722e0..b5e7d4b8ab24 100644
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



