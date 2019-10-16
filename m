Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EF79CD9FF3
	for <lists+stable@lfdr.de>; Thu, 17 Oct 2019 00:24:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388163AbfJPWGT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 16 Oct 2019 18:06:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:52298 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2438192AbfJPV6e (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 16 Oct 2019 17:58:34 -0400
Received: from localhost (unknown [192.55.54.58])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 33ED921928;
        Wed, 16 Oct 2019 21:58:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1571263114;
        bh=cgUZmNNAzyKO94lgcFtGH3+Q2ibbzA3dWEHh+4TK0iE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rw2gJcp8g145vlzePsbTVBVEcViVCQkASy4JehONPkveVGJnAU4ysyuFI4WaOwNHM
         qbgWlTHkeF+kMFQItTpZYOAE6ydJh5uVvUE4t/dLdeW1BI7/ilNtJjLNTey9MS6lYf
         dYFQPOz+L+D7HGc+X+lJ+rFc+U+OKbZvyWT88Ms4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>
Subject: [PATCH 5.3 038/112] usb: typec: ucsi: displayport: Fix for the mode entering routine
Date:   Wed, 16 Oct 2019 14:50:30 -0700
Message-Id: <20191016214854.090208871@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191016214844.038848564@linuxfoundation.org>
References: <20191016214844.038848564@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Heikki Krogerus <heikki.krogerus@linux.intel.com>

commit f2372b87c386871b16d7dbda680d98d4092ab708 upstream.

Making sure that ucsi_displayport_enter() function does not
return an error if the displayport alternate mode has
already been entered. It's normal that the firmware (or
controller) has already entered the alternate mode by the
time the operating system is notified about the device.

Fixes: af8622f6a585 ("usb: typec: ucsi: Support for DisplayPort alt mode")
Cc: stable@vger.kernel.org
Signed-off-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
Link: https://lore.kernel.org/r/20191004100219.71152-3-heikki.krogerus@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/typec/ucsi/displayport.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/usb/typec/ucsi/displayport.c
+++ b/drivers/usb/typec/ucsi/displayport.c
@@ -75,6 +75,8 @@ static int ucsi_displayport_enter(struct
 
 	if (cur != 0xff) {
 		mutex_unlock(&dp->con->lock);
+		if (dp->con->port_altmode[cur] == alt)
+			return 0;
 		return -EBUSY;
 	}
 


