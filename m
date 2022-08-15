Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 31E0059454C
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 01:00:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348104AbiHOW3u (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 18:29:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41162 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351217AbiHOW1x (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 18:27:53 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C2956EF2B;
        Mon, 15 Aug 2022 12:47:40 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 18CD2B80EB2;
        Mon, 15 Aug 2022 19:47:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 64E90C433C1;
        Mon, 15 Aug 2022 19:47:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660592857;
        bh=CCLSED5/tp56WMWq4oqMqYuLEMQWH1GAfsi6KdxpNd8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=l+PoGxOeGD9/bhqhdNbMTt79U5wcBp7aCk59Z4himTyX2oEbbK8AcYpaPmA/7REw7
         AkIrl6lXxN5LGuXJ+CtljBl8A9jE2tt1kWjRAIpIZwMocdk503jze28X/UDbHw3LIo
         3K9AJwvV58V0CsGFqvngnrXTvWdYly1XvzQsFMM4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Daniel Starke <daniel.starke@siemens.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 0855/1095] tty: n_gsm: fix tty registration before control channel open
Date:   Mon, 15 Aug 2022 20:04:14 +0200
Message-Id: <20220815180504.693448772@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180429.240518113@linuxfoundation.org>
References: <20220815180429.240518113@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Daniel Starke <daniel.starke@siemens.com>

[ Upstream commit 01aecd917114577c423f07cec0d186ad007d76fc ]

The current implementation registers/deregisters the user ttys at mux
attach/detach. That means that the user devices are available before any
control channel is open. However, user channel initialization requires an
open control channel. Furthermore, the user is not informed if the mux
restarts due to configuration changes.
Put the registration/deregistration procedure into separate function to
improve readability.
Move registration to mux activation and deregistration to mux cleanup to
keep the user devices only open as long as a control channel exists. The
user will be informed via the device driver if the mux was reconfigured in
a way that required a mux re-activation.
This makes it necessary to add T2 initialization to gsmld_open() for the
ldisc open code path (not the reconfiguration code path) to avoid deletion
of an uninitialized T2 at mux cleanup.

Fixes: d50f6dcaf22a ("tty: n_gsm: expose gsmtty device nodes at ldisc open time")
Signed-off-by: Daniel Starke <daniel.starke@siemens.com>
Link: https://lore.kernel.org/r/20220701061652.39604-2-daniel.starke@siemens.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/tty/n_gsm.c | 117 ++++++++++++++++++++++++++++++--------------
 1 file changed, 79 insertions(+), 38 deletions(-)

diff --git a/drivers/tty/n_gsm.c b/drivers/tty/n_gsm.c
index e15b3b107b5e..e80713a9d204 100644
--- a/drivers/tty/n_gsm.c
+++ b/drivers/tty/n_gsm.c
@@ -235,6 +235,7 @@ struct gsm_mux {
 	struct gsm_dlci *dlci[NUM_DLCI];
 	int old_c_iflag;		/* termios c_iflag value before attach */
 	bool constipated;		/* Asked by remote to shut up */
+	bool has_devices;		/* Devices were registered */
 
 	spinlock_t tx_lock;
 	unsigned int tx_bytes;		/* TX data outstanding */
@@ -463,6 +464,68 @@ static void gsm_hex_dump_bytes(const char *fname, const u8 *data,
 	kfree(prefix);
 }
 
+/**
+ *	gsm_register_devices	-	register all tty devices for a given mux index
+ *
+ *	@driver: the tty driver that describes the tty devices
+ *	@index:  the mux number is used to calculate the minor numbers of the
+ *	         ttys for this mux and may differ from the position in the
+ *	         mux array.
+ */
+static int gsm_register_devices(struct tty_driver *driver, unsigned int index)
+{
+	struct device *dev;
+	int i;
+	unsigned int base;
+
+	if (!driver || index >= MAX_MUX)
+		return -EINVAL;
+
+	base = index * NUM_DLCI; /* first minor for this index */
+	for (i = 1; i < NUM_DLCI; i++) {
+		/* Don't register device 0 - this is the control channel
+		 * and not a usable tty interface
+		 */
+		dev = tty_register_device(gsm_tty_driver, base + i, NULL);
+		if (IS_ERR(dev)) {
+			if (debug & 8)
+				pr_info("%s failed to register device minor %u",
+					__func__, base + i);
+			for (i--; i >= 1; i--)
+				tty_unregister_device(gsm_tty_driver, base + i);
+			return PTR_ERR(dev);
+		}
+	}
+
+	return 0;
+}
+
+/**
+ *	gsm_unregister_devices	-	unregister all tty devices for a given mux index
+ *
+ *	@driver: the tty driver that describes the tty devices
+ *	@index:  the mux number is used to calculate the minor numbers of the
+ *	         ttys for this mux and may differ from the position in the
+ *	         mux array.
+ */
+static void gsm_unregister_devices(struct tty_driver *driver,
+				   unsigned int index)
+{
+	int i;
+	unsigned int base;
+
+	if (!driver || index >= MAX_MUX)
+		return;
+
+	base = index * NUM_DLCI; /* first minor for this index */
+	for (i = 1; i < NUM_DLCI; i++) {
+		/* Don't unregister device 0 - this is the control
+		 * channel and not a usable tty interface
+		 */
+		tty_unregister_device(gsm_tty_driver, base + i);
+	}
+}
+
 /**
  *	gsm_print_packet	-	display a frame for debug
  *	@hdr: header to print before decode
@@ -2208,6 +2271,10 @@ static void gsm_cleanup_mux(struct gsm_mux *gsm, bool disc)
 	del_timer_sync(&gsm->t2_timer);
 
 	/* Free up any link layer users and finally the control channel */
+	if (gsm->has_devices) {
+		gsm_unregister_devices(gsm_tty_driver, gsm->num);
+		gsm->has_devices = false;
+	}
 	for (i = NUM_DLCI - 1; i >= 0; i--)
 		if (gsm->dlci[i])
 			gsm_dlci_release(gsm->dlci[i]);
@@ -2231,6 +2298,7 @@ static void gsm_cleanup_mux(struct gsm_mux *gsm, bool disc)
 static int gsm_activate_mux(struct gsm_mux *gsm)
 {
 	struct gsm_dlci *dlci;
+	int ret;
 
 	timer_setup(&gsm->t2_timer, gsm_control_retransmit, 0);
 	init_waitqueue_head(&gsm->event);
@@ -2242,9 +2310,14 @@ static int gsm_activate_mux(struct gsm_mux *gsm)
 	else
 		gsm->receive = gsm1_receive;
 
+	ret = gsm_register_devices(gsm_tty_driver, gsm->num);
+	if (ret)
+		return ret;
+
 	dlci = gsm_dlci_alloc(gsm, 0);
 	if (dlci == NULL)
 		return -ENOMEM;
+	gsm->has_devices = true;
 	gsm->dead = false;		/* Tty opens are now permissible */
 	return 0;
 }
@@ -2504,39 +2577,14 @@ static int gsmld_output(struct gsm_mux *gsm, u8 *data, int len)
  *	will need moving to an ioctl path.
  */
 
-static int gsmld_attach_gsm(struct tty_struct *tty, struct gsm_mux *gsm)
+static void gsmld_attach_gsm(struct tty_struct *tty, struct gsm_mux *gsm)
 {
-	unsigned int base;
-	int ret, i;
-
 	gsm->tty = tty_kref_get(tty);
 	/* Turn off tty XON/XOFF handling to handle it explicitly. */
 	gsm->old_c_iflag = tty->termios.c_iflag;
 	tty->termios.c_iflag &= (IXON | IXOFF);
-	ret =  gsm_activate_mux(gsm);
-	if (ret != 0)
-		tty_kref_put(gsm->tty);
-	else {
-		/* Don't register device 0 - this is the control channel and not
-		   a usable tty interface */
-		base = mux_num_to_base(gsm); /* Base for this MUX */
-		for (i = 1; i < NUM_DLCI; i++) {
-			struct device *dev;
-
-			dev = tty_register_device(gsm_tty_driver,
-							base + i, NULL);
-			if (IS_ERR(dev)) {
-				for (i--; i >= 1; i--)
-					tty_unregister_device(gsm_tty_driver,
-								base + i);
-				return PTR_ERR(dev);
-			}
-		}
-	}
-	return ret;
 }
 
-
 /**
  *	gsmld_detach_gsm	-	stop doing 0710 mux
  *	@tty: tty attached to the mux
@@ -2547,12 +2595,7 @@ static int gsmld_attach_gsm(struct tty_struct *tty, struct gsm_mux *gsm)
 
 static void gsmld_detach_gsm(struct tty_struct *tty, struct gsm_mux *gsm)
 {
-	unsigned int base = mux_num_to_base(gsm); /* Base for this MUX */
-	int i;
-
 	WARN_ON(tty != gsm->tty);
-	for (i = 1; i < NUM_DLCI; i++)
-		tty_unregister_device(gsm_tty_driver, base + i);
 	/* Restore tty XON/XOFF handling. */
 	gsm->tty->termios.c_iflag = gsm->old_c_iflag;
 	tty_kref_put(gsm->tty);
@@ -2644,7 +2687,6 @@ static void gsmld_close(struct tty_struct *tty)
 static int gsmld_open(struct tty_struct *tty)
 {
 	struct gsm_mux *gsm;
-	int ret;
 
 	if (tty->ops->write == NULL)
 		return -EINVAL;
@@ -2660,12 +2702,11 @@ static int gsmld_open(struct tty_struct *tty)
 	/* Attach the initial passive connection */
 	gsm->encoding = 1;
 
-	ret = gsmld_attach_gsm(tty, gsm);
-	if (ret != 0) {
-		gsm_cleanup_mux(gsm, false);
-		mux_put(gsm);
-	}
-	return ret;
+	gsmld_attach_gsm(tty, gsm);
+
+	timer_setup(&gsm->t2_timer, gsm_control_retransmit, 0);
+
+	return 0;
 }
 
 /**
-- 
2.35.1



