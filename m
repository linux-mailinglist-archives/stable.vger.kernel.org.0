Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 599F737FACA
	for <lists+stable@lfdr.de>; Thu, 13 May 2021 17:34:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234917AbhEMPf2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 May 2021 11:35:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:41856 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234914AbhEMPf1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 13 May 2021 11:35:27 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0AB1F611AC;
        Thu, 13 May 2021 15:34:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620920057;
        bh=dprlPpvP2pJ8ThzgIEg/H7TP5DEPsAWz5LSO24DEIXc=;
        h=Subject:To:From:Date:From;
        b=qsS9w3zOSXEqYf60t72XiNnrgroZWBBzxst4KtlooavmnFjUljjbqWAf+6skq7Qdk
         1rAnJEQHYp5YEOEyHiRk7HlqKHDfmHWW86/T+a1wtQW31w8XooBcFoS3mFRa8vwfGm
         OHRGYw/TG/onHcUHAvXdAC8mr7CcwVYJ2NlsR4eM=
Subject: patch "Revert "qlcnic: Avoid potential NULL pointer dereference"" added to char-misc-linus
To:     gregkh@linuxfoundation.org, davem@davemloft.net, pakki001@umn.edu,
        stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Thu, 13 May 2021 17:34:12 +0200
Message-ID: <1620920052325@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    Revert "qlcnic: Avoid potential NULL pointer dereference"

to my char-misc git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/char-misc.git
in the char-misc-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From b95b57dfe7a142bf2446548eb7f49340fd73e78b Mon Sep 17 00:00:00 2001
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Date: Mon, 3 May 2021 13:56:51 +0200
Subject: Revert "qlcnic: Avoid potential NULL pointer dereference"

This reverts commit 5bf7295fe34a5251b1d241b9736af4697b590670.

Because of recent interactions with developers from @umn.edu, all
commits from them have been recently re-reviewed to ensure if they were
correct or not.

Upon review, this commit was found to be incorrect for the reasons
below, so it must be reverted.  It will be fixed up "correctly" in a
later kernel change.

This commit does not properly detect if an error happens because the
logic after this loop will not detect that there was a failed
allocation.

Cc: Aditya Pakki <pakki001@umn.edu>
Cc: David S. Miller <davem@davemloft.net>
Fixes: 5bf7295fe34a ("qlcnic: Avoid potential NULL pointer dereference")
Cc: stable <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20210503115736.2104747-25-gregkh@linuxfoundation.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/qlogic/qlcnic/qlcnic_ethtool.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/net/ethernet/qlogic/qlcnic/qlcnic_ethtool.c b/drivers/net/ethernet/qlogic/qlcnic/qlcnic_ethtool.c
index d8a3ecaed3fc..985cf8cb2ec0 100644
--- a/drivers/net/ethernet/qlogic/qlcnic/qlcnic_ethtool.c
+++ b/drivers/net/ethernet/qlogic/qlcnic/qlcnic_ethtool.c
@@ -1047,8 +1047,6 @@ int qlcnic_do_lb_test(struct qlcnic_adapter *adapter, u8 mode)
 
 	for (i = 0; i < QLCNIC_NUM_ILB_PKT; i++) {
 		skb = netdev_alloc_skb(adapter->netdev, QLCNIC_ILB_PKT_SIZE);
-		if (!skb)
-			break;
 		qlcnic_create_loopback_buff(skb->data, adapter->mac_addr);
 		skb_put(skb, QLCNIC_ILB_PKT_SIZE);
 		adapter->ahw->diag_cnt = 0;
-- 
2.31.1


