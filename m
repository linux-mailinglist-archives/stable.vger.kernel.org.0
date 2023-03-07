Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5C3946AEBE7
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 18:50:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232158AbjCGRuK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 12:50:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36616 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232171AbjCGRti (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 12:49:38 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BDC0D95E26
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 09:44:34 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 300CD614B2
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 17:44:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 48EC1C433EF;
        Tue,  7 Mar 2023 17:44:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678211073;
        bh=IQ1HWFuDxg05wll5CLU4qQfhlvUITYkheP1RQldeGSk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UZW1JhRS6QGL2gjB0vZ3HSwR39ybxPXBijNo6Nz979/8BbpwQ/g9GLuvD3AXcI71D
         BQK3Rk1z5/JAkhpvJNVWzllKVtB6D3mr7Hhb+Fva6Y1D9tdR34eRuDE5x7gr18gGhP
         L/3vYQEeftvJlL4Ij86QTw/zWflkKx0uiVRloMFI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Jun ASAKA <JunASAKA@zzy040330.moe>,
        Ping-Ke Shih <pkshih@realtek.com>,
        Kalle Valo <kvalo@kernel.org>
Subject: [PATCH 6.2 0744/1001] wifi: rtl8xxxu: fixing transmisison failure for rtl8192eu
Date:   Tue,  7 Mar 2023 17:58:36 +0100
Message-Id: <20230307170054.015803199@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170022.094103862@linuxfoundation.org>
References: <20230307170022.094103862@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jun ASAKA <JunASAKA@zzy040330.moe>

commit c6015bf3ff1ffb3caa27eb913797438a0fc634a0 upstream.

Fixing transmission failure which results in
"authentication with ... timed out". This can be
fixed by disable the REG_TXPAUSE.

Signed-off-by: Jun ASAKA <JunASAKA@zzy040330.moe>
Reviewed-by: Ping-Ke Shih <pkshih@realtek.com>
Signed-off-by: Kalle Valo <kvalo@kernel.org>
Link: https://lore.kernel.org/r/20221217030659.12577-1-JunASAKA@zzy040330.moe
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_8192e.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_8192e.c
+++ b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_8192e.c
@@ -1744,6 +1744,11 @@ static void rtl8192e_enable_rf(struct rt
 	val8 = rtl8xxxu_read8(priv, REG_PAD_CTRL1);
 	val8 &= ~BIT(0);
 	rtl8xxxu_write8(priv, REG_PAD_CTRL1, val8);
+
+	/*
+	 * Fix transmission failure of rtl8192e.
+	 */
+	rtl8xxxu_write8(priv, REG_TXPAUSE, 0x00);
 }
 
 static s8 rtl8192e_cck_rssi(struct rtl8xxxu_priv *priv, u8 cck_agc_rpt)


