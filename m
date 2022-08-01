Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2CB935869E8
	for <lists+stable@lfdr.de>; Mon,  1 Aug 2022 14:09:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233725AbiHAMJD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Aug 2022 08:09:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43066 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233620AbiHAMIS (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 1 Aug 2022 08:08:18 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E20945F6B;
        Mon,  1 Aug 2022 04:55:53 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0DE06B80E8F;
        Mon,  1 Aug 2022 11:55:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 64268C433D6;
        Mon,  1 Aug 2022 11:55:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1659354950;
        bh=6HuTgiNfY4n1mFptF3vAN268xiOhkWFB+72RZlZBRQY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PCPxHu2G2uSnx4Sb+gOdXWam3/dwy0bhfDrooFpJBvY/lm/juibM8iY9V7RAoDCAY
         G7r+SUggjJY7v0eMdne7x1AbHELHp48bIhswvs+rSI2bV8UXyA/n+Bei39KGfvyRz/
         n3p8VubS7GwHVVzf2OEeJT/etn/BxOwtt10z1S4g=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Abhishek Pandit-Subedi <abhishekpandit@chromium.org>,
        Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Subject: [PATCH 5.18 01/88] Bluetooth: Always set event mask on suspend
Date:   Mon,  1 Aug 2022 13:46:15 +0200
Message-Id: <20220801114138.109716229@linuxfoundation.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220801114138.041018499@linuxfoundation.org>
References: <20220801114138.041018499@linuxfoundation.org>
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Abhishek Pandit-Subedi <abhishekpandit@chromium.org>

commit ef61b6ea154464fefd8a6712d7a3b43b445c3d4a upstream.

When suspending, always set the event mask once disconnects are
successful. Otherwise, if wakeup is disallowed, the event mask is not
set before suspend continues and can result in an early wakeup.

Fixes: 182ee45da083 ("Bluetooth: hci_sync: Rework hci_suspend_notifier")
Cc: stable@vger.kernel.org
Signed-off-by: Abhishek Pandit-Subedi <abhishekpandit@chromium.org>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/bluetooth/hci_sync.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/net/bluetooth/hci_sync.c
+++ b/net/bluetooth/hci_sync.c
@@ -4942,6 +4942,9 @@ int hci_suspend_sync(struct hci_dev *hde
 		return err;
 	}
 
+	/* Update event mask so only the allowed event can wakeup the host */
+	hci_set_event_mask_sync(hdev);
+
 	/* Only configure accept list if disconnect succeeded and wake
 	 * isn't being prevented.
 	 */
@@ -4953,9 +4956,6 @@ int hci_suspend_sync(struct hci_dev *hde
 	/* Unpause to take care of updating scanning params */
 	hdev->scanning_paused = false;
 
-	/* Update event mask so only the allowed event can wakeup the host */
-	hci_set_event_mask_sync(hdev);
-
 	/* Enable event filter for paired devices */
 	hci_update_event_filter_sync(hdev);
 


