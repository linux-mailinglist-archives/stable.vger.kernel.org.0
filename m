Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 07ABA498A1E
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 20:02:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344158AbiAXTBe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 14:01:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44638 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344678AbiAXS6z (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 13:58:55 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE6C0C0612B2;
        Mon, 24 Jan 2022 10:56:12 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 933E1B81227;
        Mon, 24 Jan 2022 18:56:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B5E31C340E5;
        Mon, 24 Jan 2022 18:56:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643050571;
        bh=szx3KHnAGqYPCIQSnKc2YO2cne5YMw4r5dPOGfee4w8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gDA3qoz1BCSoPeI7kQzY9xiO/MZKav2tbhtPnwK4mVJy0jld8g8oVWFZi8OkSKqMI
         EkcPNyxjNd3H8oD2CNPmFhSGEI0pfXBlxRbTJFZ/Dbfj2BcvQLcUMjd/RAfNS/e08z
         CfySvCJdHsUEQrJVHQYkz/t8Y9AUu27STFUrQq4M=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+cce1ee31614c171f5595@syzkaller.appspotmail.com,
        Larry Finger <Larry.Finger@lwfinger.net>,
        Kalle Valo <kvalo@kernel.org>
Subject: [PATCH 4.9 012/157] rtlwifi: rtl8192cu: Fix WARNING when calling local_irq_restore() with interrupts enabled
Date:   Mon, 24 Jan 2022 19:41:42 +0100
Message-Id: <20220124183933.183700115@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124183932.787526760@linuxfoundation.org>
References: <20220124183932.787526760@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Larry Finger <Larry.Finger@lwfinger.net>

commit 8b144dedb928e4e2f433a328d58f44c3c098d63e upstream.

Syzbot reports the following WARNING:

[200~raw_local_irq_restore() called with IRQs enabled
WARNING: CPU: 1 PID: 1206 at kernel/locking/irqflag-debug.c:10
   warn_bogus_irq_restore+0x1d/0x20 kernel/locking/irqflag-debug.c:10

Hardware initialization for the rtl8188cu can run for as long as 350 ms,
and the routine may be called with interrupts disabled. To avoid locking
the machine for this long, the current routine saves the interrupt flags
and enables local interrupts. The problem is that it restores the flags
at the end without disabling local interrupts first.

This patch fixes commit a53268be0cb9 ("rtlwifi: rtl8192cu: Fix too long
disable of IRQs").

Reported-by: syzbot+cce1ee31614c171f5595@syzkaller.appspotmail.com
Cc: stable@vger.kernel.org
Fixes: a53268be0cb9 ("rtlwifi: rtl8192cu: Fix too long disable of IRQs")
Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
Signed-off-by: Kalle Valo <kvalo@kernel.org>
Link: https://lore.kernel.org/r/20211215171105.20623-1-Larry.Finger@lwfinger.net
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/wireless/realtek/rtlwifi/rtl8192cu/hw.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/net/wireless/realtek/rtlwifi/rtl8192cu/hw.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8192cu/hw.c
@@ -1037,6 +1037,7 @@ int rtl92cu_hw_init(struct ieee80211_hw
 	_InitPABias(hw);
 	rtl92c_dm_init(hw);
 exit:
+	local_irq_disable();
 	local_irq_restore(flags);
 	return err;
 }


