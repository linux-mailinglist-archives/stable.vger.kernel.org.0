Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7D8B16812E8
	for <lists+stable@lfdr.de>; Mon, 30 Jan 2023 15:26:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237464AbjA3O0T (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 30 Jan 2023 09:26:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40912 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237475AbjA3O0A (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 30 Jan 2023 09:26:00 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 94CE23E0A3
        for <stable@vger.kernel.org>; Mon, 30 Jan 2023 06:24:39 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E648860CEE
        for <stable@vger.kernel.org>; Mon, 30 Jan 2023 14:24:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 00B4BC433EF;
        Mon, 30 Jan 2023 14:24:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1675088677;
        bh=PR1gWmSHAFwpbhHiDyIL5JMhnvhge1SesM8sDVUEz1w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=n8mtluRcLT0iJk3o7bg1lB7ryLQwbqA/Bdy6o9MA68K5M3lOugKwj0ActLrO4Bb4X
         8PRFNhZJrTAPSQBc3UCZ4fe+IG32lkAQQ5xMxcqCjDkdhDvaGUEL3+RVz8GfgWxGr5
         DpOowlxjxXewecnA8fDGAvauGXfa0A01yP1iKSoQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Archie Pusaka <apusaka@chromium.org>,
        Abhishek Pandit-Subedi <abhishekpandit@google.com>,
        Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
        Fedor Pchelkin <pchelkin@ispras.ru>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 099/143] Bluetooth: hci_sync: cancel cmd_timer if hci_open failed
Date:   Mon, 30 Jan 2023 14:52:36 +0100
Message-Id: <20230130134310.938021661@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230130134306.862721518@linuxfoundation.org>
References: <20230130134306.862721518@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Archie Pusaka <apusaka@chromium.org>

commit 97dfaf073f5881c624856ef293be307b6166115c upstream.

If a command is already sent, we take care of freeing it, but we
also need to cancel the timeout as well.

Signed-off-by: Archie Pusaka <apusaka@chromium.org>
Reviewed-by: Abhishek Pandit-Subedi <abhishekpandit@google.com>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Fedor Pchelkin <pchelkin@ispras.ru>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bluetooth/hci_core.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/bluetooth/hci_core.c b/net/bluetooth/hci_core.c
index 2af1477a05ca..08c473aa0113 100644
--- a/net/bluetooth/hci_core.c
+++ b/net/bluetooth/hci_core.c
@@ -1623,6 +1623,7 @@ static int hci_dev_do_open(struct hci_dev *hdev)
 			hdev->flush(hdev);
 
 		if (hdev->sent_cmd) {
+			cancel_delayed_work_sync(&hdev->cmd_timer);
 			kfree_skb(hdev->sent_cmd);
 			hdev->sent_cmd = NULL;
 		}
-- 
2.39.0



