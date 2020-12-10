Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 13C292D6506
	for <lists+stable@lfdr.de>; Thu, 10 Dec 2020 19:31:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390810AbgLJOe3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Dec 2020 09:34:29 -0500
Received: from mail.kernel.org ([198.145.29.99]:42400 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390809AbgLJOeX (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 10 Dec 2020 09:34:23 -0500
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Authentication-Results: mail.kernel.org; dkim=permerror (bad message/signature format)
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Shisong Qin <qinshisong1205@gmail.com>,
        Samuel Thibault <samuel.thibault@ens-lyon.org>
Subject: [PATCH 4.19 27/39] speakup: Reject setting the speakup line discipline outside of speakup
Date:   Thu, 10 Dec 2020 15:27:06 +0100
Message-Id: <20201210142603.605722932@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201210142602.272595094@linuxfoundation.org>
References: <20201210142602.272595094@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Samuel Thibault <samuel.thibault@ens-lyon.org>

commit f0992098cadb4c9c6a00703b66cafe604e178fea upstream.

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

---
 drivers/staging/speakup/spk_ttyio.c |   37 ++++++++++++++++++++++--------------
 1 file changed, 23 insertions(+), 14 deletions(-)

--- a/drivers/staging/speakup/spk_ttyio.c
+++ b/drivers/staging/speakup/spk_ttyio.c
@@ -47,27 +47,20 @@ static int spk_ttyio_ldisc_open(struct t
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
@@ -187,9 +180,25 @@ static int spk_ttyio_initialise_ldisc(st
 
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


