Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 32F002A5379
	for <lists+stable@lfdr.de>; Tue,  3 Nov 2020 22:01:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733078AbgKCVBS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Nov 2020 16:01:18 -0500
Received: from mail.kernel.org ([198.145.29.99]:37674 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730024AbgKCVBQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Nov 2020 16:01:16 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 032F82053B;
        Tue,  3 Nov 2020 21:01:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604437275;
        bh=l0lvXZCW3pe6QBzIIU3kISXcYBdU9aclTmrieYLvZkk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=t3FXlfky+Nr8WQpxeFsI89OXqTgImKZPw2LTn/z+ev1iun9g6YhqVrwCHETgT5m0E
         VrQBMhakZo5gdUU7Ij13du5FaDmoA2KLfZBB5FkK7D+H6QzPmJ9TcbpEpRpCNtMfHm
         A6/WSA24jKGn1KsrVAtxWhVxBx+BgV6s+rfQJVmo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Helge Deller <deller@gmx.de>
Subject: [PATCH 5.4 203/214] hil/parisc: Disable HIL driver when it gets stuck
Date:   Tue,  3 Nov 2020 21:37:31 +0100
Message-Id: <20201103203309.653534453@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201103203249.448706377@linuxfoundation.org>
References: <20201103203249.448706377@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Helge Deller <deller@gmx.de>

commit 879bc2d27904354b98ca295b6168718e045c4aa2 upstream.

When starting a HP machine with HIL driver but without an HIL keyboard
or HIL mouse attached, it may happen that data written to the HIL loop
gets stuck (e.g. because the transaction queue is full).  Usually one
will then have to reboot the machine because all you see is and endless
output of:
 Transaction add failed: transaction already queued?

In the higher layers hp_sdc_enqueue_transaction() is called to queued up
a HIL packet. This function returns an error code, and this patch adds
the necessary checks for this return code and disables the HIL driver if
further packets can't be sent.

Tested on a HP 730 and a HP 715/64 machine.

Signed-off-by: Helge Deller <deller@gmx.de>
Cc: <stable@vger.kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/input/serio/hil_mlc.c    |   21 ++++++++++++++++++---
 drivers/input/serio/hp_sdc_mlc.c |    8 ++++----
 include/linux/hil_mlc.h          |    2 +-
 3 files changed, 23 insertions(+), 8 deletions(-)

--- a/drivers/input/serio/hil_mlc.c
+++ b/drivers/input/serio/hil_mlc.c
@@ -74,7 +74,7 @@ EXPORT_SYMBOL(hil_mlc_unregister);
 static LIST_HEAD(hil_mlcs);
 static DEFINE_RWLOCK(hil_mlcs_lock);
 static struct timer_list	hil_mlcs_kicker;
-static int			hil_mlcs_probe;
+static int			hil_mlcs_probe, hil_mlc_stop;
 
 static void hil_mlcs_process(unsigned long unused);
 static DECLARE_TASKLET_DISABLED(hil_mlcs_tasklet, hil_mlcs_process, 0);
@@ -702,9 +702,13 @@ static int hilse_donode(hil_mlc *mlc)
 		if (!mlc->ostarted) {
 			mlc->ostarted = 1;
 			mlc->opacket = pack;
-			mlc->out(mlc);
+			rc = mlc->out(mlc);
 			nextidx = HILSEN_DOZE;
 			write_unlock_irqrestore(&mlc->lock, flags);
+			if (rc) {
+				hil_mlc_stop = 1;
+				return 1;
+			}
 			break;
 		}
 		mlc->ostarted = 0;
@@ -715,8 +719,13 @@ static int hilse_donode(hil_mlc *mlc)
 
 	case HILSE_CTS:
 		write_lock_irqsave(&mlc->lock, flags);
-		nextidx = mlc->cts(mlc) ? node->bad : node->good;
+		rc = mlc->cts(mlc);
+		nextidx = rc ? node->bad : node->good;
 		write_unlock_irqrestore(&mlc->lock, flags);
+		if (rc) {
+			hil_mlc_stop = 1;
+			return 1;
+		}
 		break;
 
 	default:
@@ -780,6 +789,12 @@ static void hil_mlcs_process(unsigned lo
 
 static void hil_mlcs_timer(struct timer_list *unused)
 {
+	if (hil_mlc_stop) {
+		/* could not send packet - stop immediately. */
+		pr_warn(PREFIX "HIL seems stuck - Disabling HIL MLC.\n");
+		return;
+	}
+
 	hil_mlcs_probe = 1;
 	tasklet_schedule(&hil_mlcs_tasklet);
 	/* Re-insert the periodic task. */
--- a/drivers/input/serio/hp_sdc_mlc.c
+++ b/drivers/input/serio/hp_sdc_mlc.c
@@ -210,7 +210,7 @@ static int hp_sdc_mlc_cts(hil_mlc *mlc)
 	priv->tseq[2] = 1;
 	priv->tseq[3] = 0;
 	priv->tseq[4] = 0;
-	__hp_sdc_enqueue_transaction(&priv->trans);
+	return __hp_sdc_enqueue_transaction(&priv->trans);
  busy:
 	return 1;
  done:
@@ -219,7 +219,7 @@ static int hp_sdc_mlc_cts(hil_mlc *mlc)
 	return 0;
 }
 
-static void hp_sdc_mlc_out(hil_mlc *mlc)
+static int hp_sdc_mlc_out(hil_mlc *mlc)
 {
 	struct hp_sdc_mlc_priv_s *priv;
 
@@ -234,7 +234,7 @@ static void hp_sdc_mlc_out(hil_mlc *mlc)
  do_data:
 	if (priv->emtestmode) {
 		up(&mlc->osem);
-		return;
+		return 0;
 	}
 	/* Shouldn't be sending commands when loop may be busy */
 	BUG_ON(down_trylock(&mlc->csem));
@@ -296,7 +296,7 @@ static void hp_sdc_mlc_out(hil_mlc *mlc)
 		BUG_ON(down_trylock(&mlc->csem));
 	}
  enqueue:
-	hp_sdc_enqueue_transaction(&priv->trans);
+	return hp_sdc_enqueue_transaction(&priv->trans);
 }
 
 static int __init hp_sdc_mlc_init(void)
--- a/include/linux/hil_mlc.h
+++ b/include/linux/hil_mlc.h
@@ -103,7 +103,7 @@ struct hilse_node {
 
 /* Methods for back-end drivers, e.g. hp_sdc_mlc */
 typedef int	(hil_mlc_cts) (hil_mlc *mlc);
-typedef void	(hil_mlc_out) (hil_mlc *mlc);
+typedef int	(hil_mlc_out) (hil_mlc *mlc);
 typedef int	(hil_mlc_in)  (hil_mlc *mlc, suseconds_t timeout);
 
 struct hil_mlc_devinfo {


