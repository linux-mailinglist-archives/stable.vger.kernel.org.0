Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 45EBC2A3FBF
	for <lists+stable@lfdr.de>; Tue,  3 Nov 2020 10:13:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725993AbgKCJNO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Nov 2020 04:13:14 -0500
Received: from mail.kernel.org ([198.145.29.99]:34502 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725988AbgKCJNM (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Nov 2020 04:13:12 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5126120756;
        Tue,  3 Nov 2020 09:13:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604394789;
        bh=psey128zaq/rgAlvl5OzfiGJvtLq1oEzgqkPO6ISHoI=;
        h=Subject:To:From:Date:From;
        b=XvPmYYEBcuYMlBGXzdWnBJIAHSgAfcPwTBvHAFXBp2vHFhCnwYLxDy5NqAT9HYkcf
         l6yWjVeJN+ZQaHfbVE1Oqkkab1U99DbNWOcYKo8rohjFPH1On2rDejCX/t5Xx9ytcE
         xTcnXaMRq7GcEgKufpHq507vWA6898o/4KCahzco=
Subject: patch "mei: protect mei_cl_mtu from null dereference" added to char-misc-linus
To:     alexander.usyskin@intel.com, gregkh@linuxfoundation.org,
        stable@vger.kernel.org, tomas.winkler@intel.com
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 03 Nov 2020 10:14:03 +0100
Message-ID: <160439484313420@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    mei: protect mei_cl_mtu from null dereference

to my char-misc git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/char-misc.git
in the char-misc-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From bcbc0b2e275f0a797de11a10eff495b4571863fc Mon Sep 17 00:00:00 2001
From: Alexander Usyskin <alexander.usyskin@intel.com>
Date: Thu, 29 Oct 2020 11:54:42 +0200
Subject: mei: protect mei_cl_mtu from null dereference

A receive callback is queued while the client is still connected
but can still be called after the client was disconnected. Upon
disconnect cl->me_cl is set to NULL, hence we need to check
that ME client is not-NULL in mei_cl_mtu to avoid
null dereference.

Cc: <stable@vger.kernel.org>
Signed-off-by: Alexander Usyskin <alexander.usyskin@intel.com>
Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
Link: https://lore.kernel.org/r/20201029095444.957924-2-tomas.winkler@intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/misc/mei/client.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/misc/mei/client.h b/drivers/misc/mei/client.h
index 64143d4ec758..9e08a9843bba 100644
--- a/drivers/misc/mei/client.h
+++ b/drivers/misc/mei/client.h
@@ -182,11 +182,11 @@ static inline u8 mei_cl_me_id(const struct mei_cl *cl)
  *
  * @cl: host client
  *
- * Return: mtu
+ * Return: mtu or 0 if client is not connected
  */
 static inline size_t mei_cl_mtu(const struct mei_cl *cl)
 {
-	return cl->me_cl->props.max_msg_length;
+	return cl->me_cl ? cl->me_cl->props.max_msg_length : 0;
 }
 
 /**
-- 
2.29.2


