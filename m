Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A5F6638C67C
	for <lists+stable@lfdr.de>; Fri, 21 May 2021 14:28:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230342AbhEUM3n (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 21 May 2021 08:29:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:55492 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229457AbhEUM3m (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 21 May 2021 08:29:42 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 14A5D613B6;
        Fri, 21 May 2021 12:28:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621600099;
        bh=toLkrEBeyNSgFKceZFzWjyv05TssRy9/X3LJOkpggxc=;
        h=Subject:To:From:Date:From;
        b=x7+wrMKQbv8/Fw1E6ep94uC4iBPlNs5vDjl8WwrIe8kaSWcCmtqx+YX1/SSPV+oMD
         eDM3YMfJGOfPL1/WqrGmQ7R85a1byU8iW2FNeoSb5un+NO4dxsp85bCkthHqYwhFND
         9+zf14TCrNrPlhW7lvziwg/TN8Yav6bdvcUAeUKc=
Subject: patch "usb: typec: mux: Fix matching with typec_altmode_desc" added to usb-linus
To:     bjorn.andersson@linaro.org, gregkh@linuxfoundation.org,
        heikki.krogerus@linux.intel.com, stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Fri, 21 May 2021 14:28:17 +0200
Message-ID: <1621600097168217@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    usb: typec: mux: Fix matching with typec_altmode_desc

to my usb git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb.git
in the usb-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From acf5631c239dfc53489f739c4ad47f490c5181ff Mon Sep 17 00:00:00 2001
From: Bjorn Andersson <bjorn.andersson@linaro.org>
Date: Sat, 15 May 2021 20:47:30 -0700
Subject: usb: typec: mux: Fix matching with typec_altmode_desc

In typec_mux_match() "nval" is assigned the number of elements in the
"svid" fwnode property, then the variable is used to store the success
of the read and finally attempts to loop between 0 and "success" - i.e.
not at all - and the code returns indicating that no match was found.

Fix this by using a separate variable to track the success of the read,
to allow the loop to get a change to find a match.

Fixes: 96a6d031ca99 ("usb: typec: mux: Find the muxes by also matching against the device node")
Reviewed-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
Cc: stable <stable@vger.kernel.org>
Signed-off-by: Bjorn Andersson <bjorn.andersson@linaro.org>
Link: https://lore.kernel.org/r/20210516034730.621461-1-bjorn.andersson@linaro.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/typec/mux.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/usb/typec/mux.c b/drivers/usb/typec/mux.c
index 9da22ae3006c..8514bec7e1b8 100644
--- a/drivers/usb/typec/mux.c
+++ b/drivers/usb/typec/mux.c
@@ -191,6 +191,7 @@ static void *typec_mux_match(struct fwnode_handle *fwnode, const char *id,
 	bool match;
 	int nval;
 	u16 *val;
+	int ret;
 	int i;
 
 	/*
@@ -218,10 +219,10 @@ static void *typec_mux_match(struct fwnode_handle *fwnode, const char *id,
 	if (!val)
 		return ERR_PTR(-ENOMEM);
 
-	nval = fwnode_property_read_u16_array(fwnode, "svid", val, nval);
-	if (nval < 0) {
+	ret = fwnode_property_read_u16_array(fwnode, "svid", val, nval);
+	if (ret < 0) {
 		kfree(val);
-		return ERR_PTR(nval);
+		return ERR_PTR(ret);
 	}
 
 	for (i = 0; i < nval; i++) {
-- 
2.31.1


