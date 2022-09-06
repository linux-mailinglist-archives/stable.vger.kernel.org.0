Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E01EF5AEBB0
	for <lists+stable@lfdr.de>; Tue,  6 Sep 2022 16:27:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240522AbiIFOAd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 6 Sep 2022 10:00:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57288 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240885AbiIFN7C (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 6 Sep 2022 09:59:02 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AAE5D80F77;
        Tue,  6 Sep 2022 06:42:51 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 55D006153B;
        Tue,  6 Sep 2022 13:42:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 65559C433D6;
        Tue,  6 Sep 2022 13:42:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1662471770;
        bh=443dFfJZz3E9xjACW/Tq456OiJbX29QowqloZsHGVA4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EuD3O3DsqS2BOUSknSWlBSRw/mqmfpAd4TkzzSOtCWDBW/DmgcKytugmQy5Xilo90
         O8L1Q9FPTfoAbwv8OxiQzFPDMdlZrLCYDZxRYzTbcZCw8sEt0XNPc+O7PZBBqAqVaw
         /mAyOtp2MsaBE+YkOcnRHd8gKPqKw1jJo0SiwB9Y=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Archie Pusaka <apusaka@chromium.org>,
        Sonny Sasaka <sonnysasaka@chromium.org>,
        Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 031/155] Bluetooth: hci_event: Fix checking conn for le_conn_complete_evt
Date:   Tue,  6 Sep 2022 15:29:39 +0200
Message-Id: <20220906132830.736065571@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220906132829.417117002@linuxfoundation.org>
References: <20220906132829.417117002@linuxfoundation.org>
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

From: Archie Pusaka <apusaka@chromium.org>

[ Upstream commit f48735a9aaf8258f39918e13adf464ccd7dce33b ]

To prevent multiple conn complete events, we shouldn't look up the
conn with hci_lookup_le_connect, since it requires the state to be
BT_CONNECT. By the time the duplicate event is processed, the state
might have changed, so we end up processing the new event anyway.

Change the lookup function to hci_conn_hash_lookup_ba.

Fixes: d5ebaa7c5f6f6 ("Bluetooth: hci_event: Ignore multiple conn complete events")
Signed-off-by: Archie Pusaka <apusaka@chromium.org>
Reviewed-by: Sonny Sasaka <sonnysasaka@chromium.org>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bluetooth/hci_event.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/bluetooth/hci_event.c b/net/bluetooth/hci_event.c
index 67c61f5240596..2c320a8fe70d7 100644
--- a/net/bluetooth/hci_event.c
+++ b/net/bluetooth/hci_event.c
@@ -5568,7 +5568,7 @@ static void le_conn_complete_evt(struct hci_dev *hdev, u8 status,
 	 */
 	hci_dev_clear_flag(hdev, HCI_LE_ADV);
 
-	conn = hci_lookup_le_connect(hdev);
+	conn = hci_conn_hash_lookup_ba(hdev, LE_LINK, bdaddr);
 	if (!conn) {
 		/* In case of error status and there is no connection pending
 		 * just unlock as there is nothing to cleanup.
-- 
2.35.1



