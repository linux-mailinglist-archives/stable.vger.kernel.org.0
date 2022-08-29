Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 951025A48BD
	for <lists+stable@lfdr.de>; Mon, 29 Aug 2022 13:15:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231278AbiH2LPE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Aug 2022 07:15:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43012 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231450AbiH2LNu (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Aug 2022 07:13:50 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 09535659D1;
        Mon, 29 Aug 2022 04:09:43 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7AB05B80F96;
        Mon, 29 Aug 2022 11:09:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C047BC433C1;
        Mon, 29 Aug 2022 11:09:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661771374;
        bh=t4Ral+eNtw1TmAL9Zj3bBoJmT5H+4wQP/GGzP5O2aOg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KWkYV8j82XefMjlyyiyiUdw0LNjelcEmMqvIG3fFmyRRYGiqzntQ6m7TP2y1NIquO
         ntUxxEmDEa/gRELFB1vQuZE9gyYa6TysmVluBPF1mdqRlq9ZJpi/mo0jDKzdMclKnP
         Y6JMsyKNYtcsh5cDjWUpsAK56X32FIm43h5BQjOM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hayes Wang <hayeswang@realtek.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 024/158] r8152: fix the units of some registers for RTL8156A
Date:   Mon, 29 Aug 2022 12:57:54 +0200
Message-Id: <20220829105809.807331767@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220829105808.828227973@linuxfoundation.org>
References: <20220829105808.828227973@linuxfoundation.org>
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

From: Hayes Wang <hayeswang@realtek.com>

[ Upstream commit 6dc4df12d741c0fe8f885778a43039e0619b9cd9 ]

The units of PLA_RX_FIFO_FULL and PLA_RX_FIFO_EMPTY are 16 bytes.

Fixes: 195aae321c82 ("r8152: support new chips")
Signed-off-by: Hayes Wang <hayeswang@realtek.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/usb/r8152.c | 17 ++---------------
 1 file changed, 2 insertions(+), 15 deletions(-)

diff --git a/drivers/net/usb/r8152.c b/drivers/net/usb/r8152.c
index 0f6efaabaa32b..46c7954d27629 100644
--- a/drivers/net/usb/r8152.c
+++ b/drivers/net/usb/r8152.c
@@ -6431,21 +6431,8 @@ static void r8156_fc_parameter(struct r8152 *tp)
 	u32 pause_on = tp->fc_pause_on ? tp->fc_pause_on : fc_pause_on_auto(tp);
 	u32 pause_off = tp->fc_pause_off ? tp->fc_pause_off : fc_pause_off_auto(tp);
 
-	switch (tp->version) {
-	case RTL_VER_10:
-	case RTL_VER_11:
-		ocp_write_word(tp, MCU_TYPE_PLA, PLA_RX_FIFO_FULL, pause_on / 8);
-		ocp_write_word(tp, MCU_TYPE_PLA, PLA_RX_FIFO_EMPTY, pause_off / 8);
-		break;
-	case RTL_VER_12:
-	case RTL_VER_13:
-	case RTL_VER_15:
-		ocp_write_word(tp, MCU_TYPE_PLA, PLA_RX_FIFO_FULL, pause_on / 16);
-		ocp_write_word(tp, MCU_TYPE_PLA, PLA_RX_FIFO_EMPTY, pause_off / 16);
-		break;
-	default:
-		break;
-	}
+	ocp_write_word(tp, MCU_TYPE_PLA, PLA_RX_FIFO_FULL, pause_on / 16);
+	ocp_write_word(tp, MCU_TYPE_PLA, PLA_RX_FIFO_EMPTY, pause_off / 16);
 }
 
 static void rtl8156_change_mtu(struct r8152 *tp)
-- 
2.35.1



