Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3EF54492A9A
	for <lists+stable@lfdr.de>; Tue, 18 Jan 2022 17:11:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347493AbiARQLp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Jan 2022 11:11:45 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:41108 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347017AbiARQKG (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 18 Jan 2022 11:10:06 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DDA5D612C2;
        Tue, 18 Jan 2022 16:10:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F77BC00446;
        Tue, 18 Jan 2022 16:10:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1642522205;
        bh=kQOy95IhZSZw5cFxZAIB00jh2ltD6YlMb16JXwiYEjQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rAuY11BY0XuO8+/jud2Gryd42rtl7vscyjgycBHybV+otTSZeDMIg9B+JVtB/p8iH
         NDDjLizdcvWGeaNnOUb0sJnPUFaoadKva77t4s+TLu07lF48LExWRDcCHCQE8ACTLr
         1mE0Rdef33burVYY8VH+R2XyvlXRk1OGqvsNPnQ8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+cce1ee31614c171f5595@syzkaller.appspotmail.com,
        Larry Finger <Larry.Finger@lwfinger.net>,
        Kalle Valo <kvalo@kernel.org>
Subject: [PATCH 5.15 15/28] rtlwifi: rtl8192cu: Fix WARNING when calling local_irq_restore() with interrupts enabled
Date:   Tue, 18 Jan 2022 17:06:01 +0100
Message-Id: <20220118160452.388722708@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220118160451.879092022@linuxfoundation.org>
References: <20220118160451.879092022@linuxfoundation.org>
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
@@ -1000,6 +1000,7 @@ int rtl92cu_hw_init(struct ieee80211_hw
 	_initpabias(hw);
 	rtl92c_dm_init(hw);
 exit:
+	local_irq_disable();
 	local_irq_restore(flags);
 	return err;
 }


