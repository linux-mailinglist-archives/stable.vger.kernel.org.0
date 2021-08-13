Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7AEC73EB28B
	for <lists+stable@lfdr.de>; Fri, 13 Aug 2021 10:23:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233038AbhHMIXY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 13 Aug 2021 04:23:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:52912 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229605AbhHMIXY (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 13 Aug 2021 04:23:24 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 71338610A5;
        Fri, 13 Aug 2021 08:22:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1628842978;
        bh=x3LT1KfnuyN1eJWitocN7656a+lDv9KVOYDivBO+jGI=;
        h=Subject:To:From:Date:From;
        b=Rw3eJ828T4sSFRAWpBTHx7aBuIPapy8OsdN10fh7vPBgqpOT/l9nLA7l0rKnzu36j
         ysCtu9dWc5SEPi5aqNJot80tpZBybquWyzQ65EemNn6r4MRBjRYuFjp4IS5oKOW5zo
         wnWsKs135TdfYtOBr5I7Qlw9YwQQtfv4MUAfe+DE=
Subject: patch "slimbus: messaging: check for valid transaction id" added to char-misc-linus
To:     srinivas.kandagatla@linaro.org, gregkh@linuxfoundation.org,
        stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Fri, 13 Aug 2021 10:22:45 +0200
Message-ID: <1628842965173145@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    slimbus: messaging: check for valid transaction id

to my char-misc git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/char-misc.git
in the char-misc-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From a263c1ff6abe0e66712f40d595bbddc7a35907f8 Mon Sep 17 00:00:00 2001
From: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Date: Mon, 9 Aug 2021 09:24:26 +0100
Subject: slimbus: messaging: check for valid transaction id

In some usecases transaction ids are dynamically allocated inside
the controller driver after sending the messages which have generic
acknowledge responses. So check for this before refcounting pm_runtime.

Without this we would end up imbalancing runtime pm count by
doing pm_runtime_put() in both slim_do_transfer() and slim_msg_response()
for a single  pm_runtime_get() in slim_do_transfer()

Fixes: d3062a210930 ("slimbus: messaging: add slim_alloc/free_txn_tid()")
Cc: <stable@vger.kernel.org>
Signed-off-by: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Link: https://lore.kernel.org/r/20210809082428.11236-3-srinivas.kandagatla@linaro.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/slimbus/messaging.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/slimbus/messaging.c b/drivers/slimbus/messaging.c
index 6097ddc43a35..e5ae26227bdb 100644
--- a/drivers/slimbus/messaging.c
+++ b/drivers/slimbus/messaging.c
@@ -131,7 +131,8 @@ int slim_do_transfer(struct slim_controller *ctrl, struct slim_msg_txn *txn)
 			goto slim_xfer_err;
 		}
 	}
-
+	/* Initialize tid to invalid value */
+	txn->tid = 0;
 	need_tid = slim_tid_txn(txn->mt, txn->mc);
 
 	if (need_tid) {
@@ -163,7 +164,7 @@ int slim_do_transfer(struct slim_controller *ctrl, struct slim_msg_txn *txn)
 			txn->mt, txn->mc, txn->la, ret);
 
 slim_xfer_err:
-	if (!clk_pause_msg && (!need_tid  || ret == -ETIMEDOUT)) {
+	if (!clk_pause_msg && (txn->tid == 0  || ret == -ETIMEDOUT)) {
 		/*
 		 * remove runtime-pm vote if this was TX only, or
 		 * if there was error during this transaction
-- 
2.32.0


