Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 794705A4A7E
	for <lists+stable@lfdr.de>; Mon, 29 Aug 2022 13:40:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232955AbiH2LkY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Aug 2022 07:40:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54534 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233390AbiH2Ljh (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Aug 2022 07:39:37 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 93C1175FC0;
        Mon, 29 Aug 2022 04:23:48 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 70D3B61208;
        Mon, 29 Aug 2022 11:09:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 77209C433D6;
        Mon, 29 Aug 2022 11:09:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661771382;
        bh=j3Po5+OEIMkh2Was4XBOQ7SRWX2NMA+dtrHbpJOl88M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=p1qyVPpel9w56Zi77xnk1ZGbQDpDEsVLxVXKpyP1WatXG7QIRTNv70e/cBwTs/8yS
         Mo9J6FxLPRnXoKNum5RxsUFzEfk0R7knqZPBVejtNLyQNM0p2QOH4WAwq39URM1no+
         q5SQTdmELKAtvYUaujIBD4sRVKxdicMoSztJLMmU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Mark Blakeney <mark.blakeney@bullet-systems.net>,
        Hayes Wang <hayeswang@realtek.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 025/158] r8152: fix the RX FIFO settings when suspending
Date:   Mon, 29 Aug 2022 12:57:55 +0200
Message-Id: <20220829105809.837683218@linuxfoundation.org>
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

[ Upstream commit b75d612014447e04abdf0e37ffb8f2fd8b0b49d6 ]

The RX FIFO would be changed when suspending, so the related settings
have to be modified, too. Otherwise, the flow control would work
abnormally.

BugLink: https://bugzilla.kernel.org/show_bug.cgi?id=216333
Reported-by: Mark Blakeney <mark.blakeney@bullet-systems.net>
Fixes: cdf0b86b250f ("r8152: fix a WOL issue")
Signed-off-by: Hayes Wang <hayeswang@realtek.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/usb/r8152.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/drivers/net/usb/r8152.c b/drivers/net/usb/r8152.c
index 46c7954d27629..d142ac8fcf6e2 100644
--- a/drivers/net/usb/r8152.c
+++ b/drivers/net/usb/r8152.c
@@ -5906,6 +5906,11 @@ static void r8153_enter_oob(struct r8152 *tp)
 	ocp_data &= ~NOW_IS_OOB;
 	ocp_write_byte(tp, MCU_TYPE_PLA, PLA_OOB_CTRL, ocp_data);
 
+	/* RX FIFO settings for OOB */
+	ocp_write_dword(tp, MCU_TYPE_PLA, PLA_RXFIFO_CTRL0, RXFIFO_THR1_OOB);
+	ocp_write_word(tp, MCU_TYPE_PLA, PLA_RXFIFO_CTRL1, RXFIFO_THR2_OOB);
+	ocp_write_word(tp, MCU_TYPE_PLA, PLA_RXFIFO_CTRL2, RXFIFO_THR3_OOB);
+
 	rtl_disable(tp);
 	rtl_reset_bmu(tp);
 
@@ -6544,6 +6549,11 @@ static void rtl8156_down(struct r8152 *tp)
 	ocp_data &= ~NOW_IS_OOB;
 	ocp_write_byte(tp, MCU_TYPE_PLA, PLA_OOB_CTRL, ocp_data);
 
+	/* RX FIFO settings for OOB */
+	ocp_write_word(tp, MCU_TYPE_PLA, PLA_RXFIFO_FULL, 64 / 16);
+	ocp_write_word(tp, MCU_TYPE_PLA, PLA_RX_FIFO_FULL, 1024 / 16);
+	ocp_write_word(tp, MCU_TYPE_PLA, PLA_RX_FIFO_EMPTY, 4096 / 16);
+
 	rtl_disable(tp);
 	rtl_reset_bmu(tp);
 
-- 
2.35.1



