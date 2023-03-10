Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 418E46B48FB
	for <lists+stable@lfdr.de>; Fri, 10 Mar 2023 16:08:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233810AbjCJPIe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Mar 2023 10:08:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32980 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233140AbjCJPH6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Mar 2023 10:07:58 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC3CE13689B
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 07:00:49 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B5AE761AC2
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 15:00:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB0F4C4339C;
        Fri, 10 Mar 2023 15:00:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678460417;
        bh=cCH7VQG9oHwEHtMIfZAQ+VE25nBoMuZ8zCtrHLV57SI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=aLEZlHTFw4ocBXxf8QaiQIQQGogvzcnhRLjya2k04XLOoTITGHdKtFzsSk7sS0QlM
         oVaRIzwRyph76MYHaSWrok0Mk2+8lTnyUdF0oT33i8GWjc0e5IbL6I9s/xbHJw/xs2
         /JB+uVMYQwUxvDK3s8TsSsnoUpQDaCrP3sZNYH6c=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Jun ASAKA <JunASAKA@zzy040330.moe>,
        Ping-Ke Shih <pkshih@realtek.com>,
        Kalle Valo <kvalo@kernel.org>
Subject: [PATCH 5.10 328/529] wifi: rtl8xxxu: fixing transmisison failure for rtl8192eu
Date:   Fri, 10 Mar 2023 14:37:51 +0100
Message-Id: <20230310133820.209567644@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230310133804.978589368@linuxfoundation.org>
References: <20230310133804.978589368@linuxfoundation.org>
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
@@ -1671,6 +1671,11 @@ static void rtl8192e_enable_rf(struct rt
 	val8 = rtl8xxxu_read8(priv, REG_PAD_CTRL1);
 	val8 &= ~BIT(0);
 	rtl8xxxu_write8(priv, REG_PAD_CTRL1, val8);
+
+	/*
+	 * Fix transmission failure of rtl8192e.
+	 */
+	rtl8xxxu_write8(priv, REG_TXPAUSE, 0x00);
 }
 
 struct rtl8xxxu_fileops rtl8192eu_fops = {


