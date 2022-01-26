Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9215549CB56
	for <lists+stable@lfdr.de>; Wed, 26 Jan 2022 14:51:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241631AbiAZNvI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 26 Jan 2022 08:51:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49586 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234796AbiAZNvI (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 26 Jan 2022 08:51:08 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B110EC06161C
        for <stable@vger.kernel.org>; Wed, 26 Jan 2022 05:51:07 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 715A5B81E16
        for <stable@vger.kernel.org>; Wed, 26 Jan 2022 13:51:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9C4EFC340E3;
        Wed, 26 Jan 2022 13:51:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643205065;
        bh=77TB8A8iM7yx+hp2kKKFCnsMIXJUN4kpr/1Milo39Kk=;
        h=Subject:To:From:Date:From;
        b=r8CCnVEXalxfAyV1/V/hlzbm46RH/D4QAcvBj/a0Qd4rRj1v3xPH7/9Ryr0tEqPSi
         Keaf9++mVTyBygRvBevgAcu9w8R+fKRChWMx/Zy/16sX2fk5p9UhONEcJ71uKoEven
         VvqHIjendXZh01BcWGR8AKcr5ys37PmGscVXszFQ=
Subject: patch "tty: rpmsg: Fix race condition releasing tty port" added to tty-linus
To:     arnaud.pouliquen@foss.st.com, gregkh@linuxfoundation.org,
        stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Wed, 26 Jan 2022 14:51:02 +0100
Message-ID: <164320506219429@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    tty: rpmsg: Fix race condition releasing tty port

to my tty git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/tty.git
in the tty-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From db7f19c0aa0abcb751ff0ed694a071363f702b1d Mon Sep 17 00:00:00 2001
From: Arnaud Pouliquen <arnaud.pouliquen@foss.st.com>
Date: Tue, 4 Jan 2022 17:35:45 +0100
Subject: tty: rpmsg: Fix race condition releasing tty port

The tty_port struct is part of the rpmsg_tty_port structure.
The issue is that the rpmsg_tty_port structure is freed on
rpmsg_tty_remove while it is still referenced in the tty_struct.
Its release is not predictable due to workqueues.

For instance following ftrace shows that rpmsg_tty_close is called after
rpmsg_tty_release_cport:

     nr_test.sh-389     [000] .....   212.093752: rpmsg_tty_remove <-rpmsg_dev_
remove
             cat-1191    [001] .....   212.095697: tty_release <-__fput
      nr_test.sh-389     [000] .....   212.099166: rpmsg_tty_release_cport <-rpm
sg_tty_remove
             cat-1191    [001] .....   212.115352: rpmsg_tty_close <-tty_release
             cat-1191    [001] .....   212.115371: release_tty <-tty_release_str

As consequence, the port must be free only when user has released the TTY
interface.

This path :
- Introduce the .destruct port tty ops function to release the allocated
  rpmsg_tty_port structure.
- Introduce the .hangup tty ops function to call tty_port_hangup.
- Manages the tty port refcounting to trig the .destruct port ops,
- Introduces the rpmsg_tty_cleanup function to ensure that the TTY is
  removed before decreasing the port refcount.

Fixes: 7c0408d80579 ("tty: add rpmsg driver")
Cc: stable <stable@vger.kernel.org>
Signed-off-by: Arnaud Pouliquen <arnaud.pouliquen@foss.st.com>
Link: https://lore.kernel.org/r/20220104163545.34710-1-arnaud.pouliquen@foss.st.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/tty/rpmsg_tty.c | 40 ++++++++++++++++++++++++++--------------
 1 file changed, 26 insertions(+), 14 deletions(-)

diff --git a/drivers/tty/rpmsg_tty.c b/drivers/tty/rpmsg_tty.c
index dae2a4e44f38..29db413bbc03 100644
--- a/drivers/tty/rpmsg_tty.c
+++ b/drivers/tty/rpmsg_tty.c
@@ -50,10 +50,17 @@ static int rpmsg_tty_cb(struct rpmsg_device *rpdev, void *data, int len, void *p
 static int rpmsg_tty_install(struct tty_driver *driver, struct tty_struct *tty)
 {
 	struct rpmsg_tty_port *cport = idr_find(&tty_idr, tty->index);
+	struct tty_port *port;
 
 	tty->driver_data = cport;
 
-	return tty_port_install(&cport->port, driver, tty);
+	port = tty_port_get(&cport->port);
+	return tty_port_install(port, driver, tty);
+}
+
+static void rpmsg_tty_cleanup(struct tty_struct *tty)
+{
+	tty_port_put(tty->port);
 }
 
 static int rpmsg_tty_open(struct tty_struct *tty, struct file *filp)
@@ -106,12 +113,19 @@ static unsigned int rpmsg_tty_write_room(struct tty_struct *tty)
 	return size;
 }
 
+static void rpmsg_tty_hangup(struct tty_struct *tty)
+{
+	tty_port_hangup(tty->port);
+}
+
 static const struct tty_operations rpmsg_tty_ops = {
 	.install	= rpmsg_tty_install,
 	.open		= rpmsg_tty_open,
 	.close		= rpmsg_tty_close,
 	.write		= rpmsg_tty_write,
 	.write_room	= rpmsg_tty_write_room,
+	.hangup		= rpmsg_tty_hangup,
+	.cleanup	= rpmsg_tty_cleanup,
 };
 
 static struct rpmsg_tty_port *rpmsg_tty_alloc_cport(void)
@@ -137,8 +151,10 @@ static struct rpmsg_tty_port *rpmsg_tty_alloc_cport(void)
 	return cport;
 }
 
-static void rpmsg_tty_release_cport(struct rpmsg_tty_port *cport)
+static void rpmsg_tty_destruct_port(struct tty_port *port)
 {
+	struct rpmsg_tty_port *cport = container_of(port, struct rpmsg_tty_port, port);
+
 	mutex_lock(&idr_lock);
 	idr_remove(&tty_idr, cport->id);
 	mutex_unlock(&idr_lock);
@@ -146,7 +162,10 @@ static void rpmsg_tty_release_cport(struct rpmsg_tty_port *cport)
 	kfree(cport);
 }
 
-static const struct tty_port_operations rpmsg_tty_port_ops = { };
+static const struct tty_port_operations rpmsg_tty_port_ops = {
+	.destruct = rpmsg_tty_destruct_port,
+};
+
 
 static int rpmsg_tty_probe(struct rpmsg_device *rpdev)
 {
@@ -166,7 +185,8 @@ static int rpmsg_tty_probe(struct rpmsg_device *rpdev)
 					   cport->id, dev);
 	if (IS_ERR(tty_dev)) {
 		ret = dev_err_probe(dev, PTR_ERR(tty_dev), "Failed to register tty port\n");
-		goto err_destroy;
+		tty_port_put(&cport->port);
+		return ret;
 	}
 
 	cport->rpdev = rpdev;
@@ -177,12 +197,6 @@ static int rpmsg_tty_probe(struct rpmsg_device *rpdev)
 		rpdev->src, rpdev->dst, cport->id);
 
 	return 0;
-
-err_destroy:
-	tty_port_destroy(&cport->port);
-	rpmsg_tty_release_cport(cport);
-
-	return ret;
 }
 
 static void rpmsg_tty_remove(struct rpmsg_device *rpdev)
@@ -192,13 +206,11 @@ static void rpmsg_tty_remove(struct rpmsg_device *rpdev)
 	dev_dbg(&rpdev->dev, "Removing rpmsg tty device %d\n", cport->id);
 
 	/* User hang up to release the tty */
-	if (tty_port_initialized(&cport->port))
-		tty_port_tty_hangup(&cport->port, false);
+	tty_port_tty_hangup(&cport->port, false);
 
 	tty_unregister_device(rpmsg_tty_driver, cport->id);
 
-	tty_port_destroy(&cport->port);
-	rpmsg_tty_release_cport(cport);
+	tty_port_put(&cport->port);
 }
 
 static struct rpmsg_device_id rpmsg_driver_tty_id_table[] = {
-- 
2.35.0


