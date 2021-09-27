Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3C02C4199EF
	for <lists+stable@lfdr.de>; Mon, 27 Sep 2021 19:03:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235768AbhI0RFY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Sep 2021 13:05:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:44034 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235746AbhI0RFY (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 27 Sep 2021 13:05:24 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 964086101A;
        Mon, 27 Sep 2021 17:03:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632762226;
        bh=kyXHDwLZ4D72H0wXL5gVuj9akRR4SZlbm4N8dhuKz9Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uzM6/XTMEDE2NLhKnjUTguL55pdM0K0JhcoZDCN12Nc6b87xhVQXwSfwGyMp7dj57
         EQK8bxabg9IrbPks7XZtYzITPFuo44dYH7C8Z8O2r//EDYeGvE9zz20t132GBC8KYs
         jsRO3fF8I+KlIdkMUVUKQaZfjjGujANJ0H8wzIqA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jaejoong Kim <climbbb.kim@gmail.com>,
        Oliver Neukum <oneukum@suse.com>,
        Johan Hovold <johan@kernel.org>
Subject: [PATCH 5.4 10/68] USB: cdc-acm: fix minor-number release
Date:   Mon, 27 Sep 2021 19:02:06 +0200
Message-Id: <20210927170220.279752073@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210927170219.901812470@linuxfoundation.org>
References: <20210927170219.901812470@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Johan Hovold <johan@kernel.org>

commit 91fac0741d4817945c6ee0a17591421e7f5ecb86 upstream.

If the driver runs out of minor numbers it would release minor 0 and
allow another device to claim the minor while still in use.

Fortunately, registering the tty class device of the second device would
fail (with a stack dump) due to the sysfs name collision so no memory is
leaked.

Fixes: cae2bc768d17 ("usb: cdc-acm: Decrement tty port's refcount if probe() fail")
Cc: stable@vger.kernel.org      # 4.19
Cc: Jaejoong Kim <climbbb.kim@gmail.com>
Acked-by: Oliver Neukum <oneukum@suse.com>
Signed-off-by: Johan Hovold <johan@kernel.org>
Link: https://lore.kernel.org/r/20210907082318.7757-1-johan@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/class/cdc-acm.c |    7 +++++--
 drivers/usb/class/cdc-acm.h |    2 ++
 2 files changed, 7 insertions(+), 2 deletions(-)

--- a/drivers/usb/class/cdc-acm.c
+++ b/drivers/usb/class/cdc-acm.c
@@ -725,7 +725,8 @@ static void acm_port_destruct(struct tty
 {
 	struct acm *acm = container_of(port, struct acm, port);
 
-	acm_release_minor(acm);
+	if (acm->minor != ACM_MINOR_INVALID)
+		acm_release_minor(acm);
 	usb_put_intf(acm->control);
 	kfree(acm->country_codes);
 	kfree(acm);
@@ -1356,8 +1357,10 @@ made_compressed_probe:
 	usb_get_intf(acm->control); /* undone in destruct() */
 
 	minor = acm_alloc_minor(acm);
-	if (minor < 0)
+	if (minor < 0) {
+		acm->minor = ACM_MINOR_INVALID;
 		goto alloc_fail1;
+	}
 
 	acm->minor = minor;
 	acm->dev = usb_dev;
--- a/drivers/usb/class/cdc-acm.h
+++ b/drivers/usb/class/cdc-acm.h
@@ -22,6 +22,8 @@
 #define ACM_TTY_MAJOR		166
 #define ACM_TTY_MINORS		256
 
+#define ACM_MINOR_INVALID	ACM_TTY_MINORS
+
 /*
  * Requests.
  */


