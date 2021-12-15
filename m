Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 12F6C475E44
	for <lists+stable@lfdr.de>; Wed, 15 Dec 2021 18:11:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245164AbhLORLj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Dec 2021 12:11:39 -0500
Received: from p-impout007aa.msg.pkvw.co.charter.net ([47.43.26.138]:38918
        "EHLO p-impout007.msg.pkvw.co.charter.net" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S232113AbhLORLj (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 Dec 2021 12:11:39 -0500
Received: from localhost.localdomain ([24.31.246.181])
        by cmsmtp with ESMTP
        id xXoWmVObHtfLpxXoXmICun; Wed, 15 Dec 2021 17:11:37 +0000
X-Authority-Analysis: v=2.4 cv=A+F/goaG c=1 sm=1 tr=0 ts=61ba21c9
 a=cAe/7qmlxnd6JlJqP68I9A==:117 a=cAe/7qmlxnd6JlJqP68I9A==:17 a=hSkVLCK3AAAA:8
 a=VwQbUJbxAAAA:8 a=yQdBAQUQAAAA:8 a=tY4FJJ6CfTjgVO9VqIUA:9
 a=cQPPKAXgyycSBL8etih5:22 a=AjGcO6oz07-iQ99wixmX:22 a=SzazLyfi1tnkUD6oumHU:22
From:   Larry Finger <Larry.Finger@lwfinger.net>
To:     kvalo@kernel.org
Cc:     linux-wireless@vger.kernel.org,
        Larry Finger <Larry.Finger@lwfinger.net>,
        syzbot+cce1ee31614c171f5595@syzkaller.appspotmail.com,
        stable@vger.kernel.org
Subject: [PATCH] rtlwifi: rtl8192cu: Fix WARNING when calling local_irq_restore() with interrupts enabled
Date:   Wed, 15 Dec 2021 11:11:05 -0600
Message-Id: <20211215171105.20623-1-Larry.Finger@lwfinger.net>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CMAE-Envelope: MS4xfLkNsLwfUnYG9J9RMJuoIpxGw5SYgcBLJWa15udU5lmKI6ID6vW6x+qxPAW9dpJjn0WPx5c2u+usecqpeiGtg/t2hJbiLv8+KDJCK4tgAzr0PFm0b6sO
 DAh/ycoJHdOxb/rEuWj0hVmBNy/dIQpmVYxQ+zU8gDFLdSo91D1pPg2FDbD0v8AlTF7zeFkPdPQV9m0KDO7L9Pz3diEi5O5tJUr9FU+P8KhC266TY/LrJ9G3
 RMofXy8Vbv0TetKlLs/6eJgql9lH9ekajs//iDgowzMsAJ3xwFefaZcxkLBqC6XDoCArxAjaxNUNyYKzbztVbNFJSBRwHqc2/9+xVzEGQS04vZsZYEsBd3FB
 oKNjHbzhrTPPi3RzLqVr2LAa3jdLuJrHmF21MXW2xcIehIpPWkM=
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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
---
 drivers/net/wireless/realtek/rtlwifi/rtl8192cu/hw.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8192cu/hw.c b/drivers/net/wireless/realtek/rtlwifi/rtl8192cu/hw.c
index 6312fddd9c00..eaba66113328 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8192cu/hw.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8192cu/hw.c
@@ -1000,6 +1000,7 @@ int rtl92cu_hw_init(struct ieee80211_hw *hw)
 	_initpabias(hw);
 	rtl92c_dm_init(hw);
 exit:
+	local_irq_disable();
 	local_irq_restore(flags);
 	return err;
 }
-- 
2.34.1

