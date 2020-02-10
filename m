Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D4A6C158028
	for <lists+stable@lfdr.de>; Mon, 10 Feb 2020 17:51:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727558AbgBJQv1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Feb 2020 11:51:27 -0500
Received: from mail.kernel.org ([198.145.29.99]:42308 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727499AbgBJQv1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 Feb 2020 11:51:27 -0500
Received: from localhost (unknown [104.132.1.111])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3B6C920661;
        Mon, 10 Feb 2020 16:51:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581353487;
        bh=3bx4vKMugMTzGtCPOMAKlu9xu4XVOOInnzDgwSz1Nu8=;
        h=Subject:To:From:Date:From;
        b=gJFRfbRAL+K188ZwgOnIZbmKeINXJ2euaYInAGK59/skRoVVnjbzqij08F+r6Do4W
         bB6OhtMOZhb34oSil/nQh1YjwTNkpIEiHddq+ToQn/ldwl95pdrZSmFyE+IRvAy5YJ
         HXzNViDnVgUahJSiBu1UcPgKn81Wg9SpU6O1NEIg=
Subject: patch "staging: vt6656: fix sign of rx_dbm to bb_pre_ed_rssi." added to staging-linus
To:     tvboxspy@gmail.com, gregkh@linuxfoundation.org,
        stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 10 Feb 2020 08:51:26 -0800
Message-ID: <15813534869045@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    staging: vt6656: fix sign of rx_dbm to bb_pre_ed_rssi.

to my staging git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/staging.git
in the staging-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From 93134df520f23f4e9998c425b8987edca7016817 Mon Sep 17 00:00:00 2001
From: Malcolm Priestley <tvboxspy@gmail.com>
Date: Tue, 4 Feb 2020 19:34:02 +0000
Subject: staging: vt6656: fix sign of rx_dbm to bb_pre_ed_rssi.

bb_pre_ed_rssi is an u8 rx_dm always returns negative signed
values add minus operator to always yield positive.

fixes issue where rx sensitivity is always set to maximum because
the unsigned numbers were always greater then 100.

Fixes: 63b9907f58f1 ("staging: vt6656: mac80211 conversion: create rx function.")
Cc: stable <stable@vger.kernel.org>
Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
Link: https://lore.kernel.org/r/aceac98c-6e69-3ce1-dfec-2bf27b980221@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/vt6656/dpc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/vt6656/dpc.c b/drivers/staging/vt6656/dpc.c
index 821aae8ca402..a0b60e7d1086 100644
--- a/drivers/staging/vt6656/dpc.c
+++ b/drivers/staging/vt6656/dpc.c
@@ -98,7 +98,7 @@ int vnt_rx_data(struct vnt_private *priv, struct vnt_rcb *ptr_rcb,
 
 	vnt_rf_rssi_to_dbm(priv, tail->rssi, &rx_dbm);
 
-	priv->bb_pre_ed_rssi = (u8)rx_dbm + 1;
+	priv->bb_pre_ed_rssi = (u8)-rx_dbm + 1;
 	priv->current_rssi = priv->bb_pre_ed_rssi;
 
 	skb_pull(skb, sizeof(*head));
-- 
2.25.0


