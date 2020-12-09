Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 43D682D40B4
	for <lists+stable@lfdr.de>; Wed,  9 Dec 2020 12:09:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730248AbgLILIW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 9 Dec 2020 06:08:22 -0500
Received: from hera.aquilenet.fr ([185.233.100.1]:44162 "EHLO
        hera.aquilenet.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729887AbgLILIW (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 9 Dec 2020 06:08:22 -0500
Received: from localhost (localhost [127.0.0.1])
        by hera.aquilenet.fr (Postfix) with ESMTP id 2E0C814B6
        for <stable@vger.kernel.org>; Wed,  9 Dec 2020 12:07:41 +0100 (CET)
X-Virus-Scanned: Debian amavisd-new at aquilenet.fr
Received: from hera.aquilenet.fr ([127.0.0.1])
        by localhost (hera.aquilenet.fr [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id ZWxhkZ6SPYIS for <stable@vger.kernel.org>;
        Wed,  9 Dec 2020 12:07:40 +0100 (CET)
Received: from function.youpi.perso.aquilenet.fr (unknown [IPv6:2a01:cb19:956:1b00:9eb6:d0ff:fe88:c3c7])
        by hera.aquilenet.fr (Postfix) with ESMTPSA id 5CAD214B0
        for <stable@vger.kernel.org>; Wed,  9 Dec 2020 12:07:40 +0100 (CET)
Received: from samy by function.youpi.perso.aquilenet.fr with local (Exim 4.94)
        (envelope-from <samuel.thibault@ens-lyon.org>)
        id 1kmxJr-0064wA-Re
        for stable@vger.kernel.org; Wed, 09 Dec 2020 12:07:39 +0100
Date:   Wed, 9 Dec 2020 12:07:39 +0100
From:   Samuel Thibault <samuel.thibault@ens-lyon.org>
To:     stable@vger.kernel.org
Subject: [PATCH for 4.19] speakup: Reject setting the speakup line discipline
 outside of speakup
Message-ID: <20201209110739.oqod456w7ktq3fgn@function>
Mail-Followup-To: Samuel Thibault <samuel.thibault@ens-lyon.org>,
        stable@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: NeoMutt/20170609 (1.8.3)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[backport of 5.10 commit f0992098cadb4c9c6a00703b66cafe604e178fea]

Speakup exposing a line discipline allows userland to try to use it,
while it is deemed to be useless, and thus uselessly exposes potential
bugs. One of them is simply that in such a case if the line sends data,
spk_ttyio_receive_buf2 is called and crashes since spk_ttyio_synth
is NULL.

This change restricts the use of the speakup line discipline to
speakup drivers, thus avoiding such kind of issues altogether.

Cc: stable@vger.kernel.org
Reported-by: Shisong Qin <qinshisong1205@gmail.com>
Signed-off-by: Samuel Thibault <samuel.thibault@ens-lyon.org>
Tested-by: Shisong Qin <qinshisong1205@gmail.com>
Link: https://lore.kernel.org/r/20201129193523.hm3f6n5xrn6fiyyc@function
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

diff --git a/drivers/staging/speakup/spk_ttyio.c b/drivers/staging/speakup/spk_ttyio.c
index 669392f31d4e..6284aff434a1 100644
--- a/drivers/staging/speakup/spk_ttyio.c
+++ b/drivers/staging/speakup/spk_ttyio.c
@@ -47,27 +47,20 @@ static int spk_ttyio_ldisc_open(struct tty_struct *tty)
 {
 	struct spk_ldisc_data *ldisc_data;
 
+	if (tty != speakup_tty)
+		/* Somebody tried to use this line discipline outside speakup */
+		return -ENODEV;
+
 	if (tty->ops->write == NULL)
 		return -EOPNOTSUPP;
 
-	mutex_lock(&speakup_tty_mutex);
-	if (speakup_tty) {
-		mutex_unlock(&speakup_tty_mutex);
-		return -EBUSY;
-	}
-	speakup_tty = tty;
-
 	ldisc_data = kmalloc(sizeof(struct spk_ldisc_data), GFP_KERNEL);
-	if (!ldisc_data) {
-		speakup_tty = NULL;
-		mutex_unlock(&speakup_tty_mutex);
+	if (!ldisc_data)
 		return -ENOMEM;
-	}
 
 	sema_init(&ldisc_data->sem, 0);
 	ldisc_data->buf_free = true;
-	speakup_tty->disc_data = ldisc_data;
-	mutex_unlock(&speakup_tty_mutex);
+	tty->disc_data = ldisc_data;
 
 	return 0;
 }
@@ -191,9 +184,25 @@ static int spk_ttyio_initialise_ldisc(struct spk_synth *synth)
 
 	tty_unlock(tty);
 
+	mutex_lock(&speakup_tty_mutex);
+	speakup_tty = tty;
 	ret = tty_set_ldisc(tty, N_SPEAKUP);
 	if (ret)
-		pr_err("speakup: Failed to set N_SPEAKUP on tty\n");
+		speakup_tty = NULL;
+	mutex_unlock(&speakup_tty_mutex);
+
+	if (!ret)
+		/* Success */
+		return 0;
+
+	pr_err("speakup: Failed to set N_SPEAKUP on tty\n");
+
+	tty_lock(tty);
+	if (tty->ops->close)
+		tty->ops->close(tty, NULL);
+	tty_unlock(tty);
+
+	tty_kclose(tty);
 
 	return ret;
 }



