Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E212E3EB289
	for <lists+stable@lfdr.de>; Fri, 13 Aug 2021 10:22:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231582AbhHMIXO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 13 Aug 2021 04:23:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:52816 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229605AbhHMIXN (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 13 Aug 2021 04:23:13 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id CBD786109E;
        Fri, 13 Aug 2021 08:22:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1628842967;
        bh=0V21C9/p+PP4D/k+FuLbH8XuCviDuZZLusYvSRnMSqc=;
        h=Subject:To:From:Date:From;
        b=y87EL6FymKWMmbX5uT4dUNEcgcuFVLlx8IZPuKjiGnMqhrv/vNreKoSL+JYwURiGT
         wkoDKCdhSQ1U+0tYW6X6Md8JUw2eGm3+uCWwfm18ZwGO7I7BZv1t4NcZpOrPAB3wPU
         MEreatlNz7hDrtiLo7mGxx7/8tzceDAMnerUWJfU=
Subject: patch "slimbus: messaging: start transaction ids from 1 instead of zero" added to char-misc-linus
To:     srinivas.kandagatla@linaro.org, gregkh@linuxfoundation.org,
        stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Fri, 13 Aug 2021 10:22:44 +0200
Message-ID: <1628842964135249@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    slimbus: messaging: start transaction ids from 1 instead of zero

to my char-misc git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/char-misc.git
in the char-misc-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From 9659281ce78de0f15a4aa124da8f7450b1399c09 Mon Sep 17 00:00:00 2001
From: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Date: Mon, 9 Aug 2021 09:24:25 +0100
Subject: slimbus: messaging: start transaction ids from 1 instead of zero

As tid is unsigned its hard to figure out if the tid is valid or
invalid. So Start the transaction ids from 1 instead of zero
so that we could differentiate between a valid tid and invalid tids

This is useful in cases where controller would add a tid for controller
specific transfers.

Fixes: d3062a210930 ("slimbus: messaging: add slim_alloc/free_txn_tid()")
Cc: <stable@vger.kernel.org>
Signed-off-by: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Link: https://lore.kernel.org/r/20210809082428.11236-2-srinivas.kandagatla@linaro.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/slimbus/messaging.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/slimbus/messaging.c b/drivers/slimbus/messaging.c
index f2b5d347d227..6097ddc43a35 100644
--- a/drivers/slimbus/messaging.c
+++ b/drivers/slimbus/messaging.c
@@ -66,7 +66,7 @@ int slim_alloc_txn_tid(struct slim_controller *ctrl, struct slim_msg_txn *txn)
 	int ret = 0;
 
 	spin_lock_irqsave(&ctrl->txn_lock, flags);
-	ret = idr_alloc_cyclic(&ctrl->tid_idr, txn, 0,
+	ret = idr_alloc_cyclic(&ctrl->tid_idr, txn, 1,
 				SLIM_MAX_TIDS, GFP_ATOMIC);
 	if (ret < 0) {
 		spin_unlock_irqrestore(&ctrl->txn_lock, flags);
-- 
2.32.0


