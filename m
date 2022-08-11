Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B8C6859027F
	for <lists+stable@lfdr.de>; Thu, 11 Aug 2022 18:11:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237410AbiHKQJn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 11 Aug 2022 12:09:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39700 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237414AbiHKQJC (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 11 Aug 2022 12:09:02 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 488FABC805;
        Thu, 11 Aug 2022 08:54:46 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id AC233B82123;
        Thu, 11 Aug 2022 15:54:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 15CDFC433D6;
        Thu, 11 Aug 2022 15:54:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1660233283;
        bh=hI06GOUZMLdm1Y0o4SIGE0cIr+HZts72NtCfAD1wbcI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cCWf+YQ1gEs1VHu0u4yXuIN3XnNOHzOCCEF6SDngcf4J3GR2CPa+LIs9O+hD2KCL2
         zNGBrDi+7KAS0A6YSIeeFXkki1f7Yzq8os6XfkPfRvHE56uDMHJbhvqRkfy5HIhI+V
         6u3eGZFNX6+4aZuJRTSUq4qTD5WAR7Nz8kAorl5TH0VH/ZnB1JVi18YoPuvCXHseOG
         wSA+poAjbQz0ChcUkOghwcsZvh4iRIM4H+3NxQa5YcEDoLid9JMIHq5iiPlr7oP61B
         AxY4gG3hUWkcGEMZxSs8rT9c+j6/cHBclOBurynPQ7NdUldFmHo4NiZ//J0w47qEFk
         ri6Vtvv7Do0Bg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Yuri D'Elia <wavexx@thregr.org>,
        Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
        Sasha Levin <sashal@kernel.org>, marcel@holtmann.org,
        johan.hedberg@gmail.com, luiz.dentz@gmail.com,
        linux-bluetooth@vger.kernel.org
Subject: [PATCH AUTOSEL 5.18 76/93] Bluetooth: btusb: Set HCI_QUIRK_BROKEN_ENHANCED_SETUP_SYNC_CONN for MTK
Date:   Thu, 11 Aug 2022 11:42:10 -0400
Message-Id: <20220811154237.1531313-76-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220811154237.1531313-1-sashal@kernel.org>
References: <20220811154237.1531313-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yuri D'Elia <wavexx@thregr.org>

[ Upstream commit e11523e97f474f8c7acc76fa912209900e2d3c69 ]

This sets HCI_QUIRK_BROKEN_ENHANCED_SETUP_SYNC_CONN for MTK controllers
since SCO appear to not work when using HCI_OP_ENHANCED_SETUP_SYNC_CONN.

Link: https://bugzilla.kernel.org/show_bug.cgi?id=215576
Signed-off-by: Yuri D'Elia <wavexx@thregr.org>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/bluetooth/btusb.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/bluetooth/btusb.c b/drivers/bluetooth/btusb.c
index e48c3ad069bb..b0af6c20b586 100644
--- a/drivers/bluetooth/btusb.c
+++ b/drivers/bluetooth/btusb.c
@@ -3782,6 +3782,7 @@ static int btusb_probe(struct usb_interface *intf,
 		hdev->manufacturer = 70;
 		hdev->cmd_timeout = btusb_mtk_cmd_timeout;
 		hdev->set_bdaddr = btmtk_set_bdaddr;
+		set_bit(HCI_QUIRK_BROKEN_ENHANCED_SETUP_SYNC_CONN, &hdev->quirks);
 		set_bit(HCI_QUIRK_NON_PERSISTENT_SETUP, &hdev->quirks);
 		data->recv_acl = btusb_recv_acl_mtk;
 	}
-- 
2.35.1

