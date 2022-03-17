Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E7C3B4DC6B7
	for <lists+stable@lfdr.de>; Thu, 17 Mar 2022 13:54:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230256AbiCQMzn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 17 Mar 2022 08:55:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39892 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234466AbiCQMxO (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 17 Mar 2022 08:53:14 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E3E21D12F1;
        Thu, 17 Mar 2022 05:51:08 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 99AF2B81E5C;
        Thu, 17 Mar 2022 12:51:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E5709C340E9;
        Thu, 17 Mar 2022 12:51:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1647521465;
        bh=6tcnReq4dlKG8UQNN1H5WqTssEeBvARoDbZQTqK+57o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rdXpn4qvUyTPq//TO03egpWjoNYwtyb00fbkw+UL8n0qavIwjNGcTPxoMEmzRpUy9
         Mnb/it9COg3TXEjyUKe9+JE3NxWfPAgpTCB2xSSTPfo3stt6zGR6/rhvYjVSyFoxlp
         brGYUNBP+tjXQXGMWynhj978BrwXYZAdQG+DpupM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
        Marcel Holtmann <marcel@holtmann.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 14/25] Bluetooth: hci_core: Fix leaking sent_cmd skb
Date:   Thu, 17 Mar 2022 13:46:01 +0100
Message-Id: <20220317124526.716389346@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220317124526.308079100@linuxfoundation.org>
References: <20220317124526.308079100@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>

[ Upstream commit dd3b1dc3dd050f1f47cd13e300732852414270f8 ]

sent_cmd memory is not freed before freeing hci_dev causing it to leak
it contents.

Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Marcel Holtmann <marcel@holtmann.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bluetooth/hci_core.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/bluetooth/hci_core.c b/net/bluetooth/hci_core.c
index 53f1b08017aa..c67390367cc2 100644
--- a/net/bluetooth/hci_core.c
+++ b/net/bluetooth/hci_core.c
@@ -4083,6 +4083,7 @@ void hci_release_dev(struct hci_dev *hdev)
 	hci_dev_unlock(hdev);
 
 	ida_simple_remove(&hci_index_ida, hdev->id);
+	kfree_skb(hdev->sent_cmd);
 	kfree(hdev);
 }
 EXPORT_SYMBOL(hci_release_dev);
-- 
2.34.1



