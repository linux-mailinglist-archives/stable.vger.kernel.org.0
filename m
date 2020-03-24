Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A5A431910DD
	for <lists+stable@lfdr.de>; Tue, 24 Mar 2020 14:32:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728828AbgCXNT1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 Mar 2020 09:19:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:40120 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728390AbgCXNT0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 24 Mar 2020 09:19:26 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6E60D20775;
        Tue, 24 Mar 2020 13:19:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1585055965;
        bh=a6COAg6MB9DpFUpTiXgHAkOs72a2wm6U+5vWQkJUJm8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Vr0sYO17j0VgiG3jpkMYUoqxUUYavHuMbuA8g+zrldBRHo7GRoyKvnRGpzvYLoOlB
         6Xpbv9HrU9RJcDu/LFfk3Yv82gu7hP3Ep9IIEgEb89p+xtLQ54dHiXPGNqcv+fjp6a
         PjybkGVXCmQ7ZIseCnAVGRYxR4CdIfOzeU0gXZF4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>
Subject: [PATCH 5.4 044/102] usb: typec: ucsi: displayport: Fix a potential race during registration
Date:   Tue, 24 Mar 2020 14:10:36 +0100
Message-Id: <20200324130811.188208722@linuxfoundation.org>
X-Mailer: git-send-email 2.25.2
In-Reply-To: <20200324130806.544601211@linuxfoundation.org>
References: <20200324130806.544601211@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Heikki Krogerus <heikki.krogerus@linux.intel.com>

commit 081da1325d351ea8804cf74e65263ea120834f33 upstream.

Locking the connector in ucsi_register_displayport() to make
sure that nothing can access the displayport alternate mode
before the function has finished and the alternate mode is
actually ready.

Fixes: af8622f6a585 ("usb: typec: ucsi: Support for DisplayPort alt mode")
Cc: stable@vger.kernel.org
Signed-off-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
Link: https://lore.kernel.org/r/20200311130006.41288-3-heikki.krogerus@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/typec/ucsi/displayport.c |    9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

--- a/drivers/usb/typec/ucsi/displayport.c
+++ b/drivers/usb/typec/ucsi/displayport.c
@@ -290,6 +290,8 @@ struct typec_altmode *ucsi_register_disp
 	struct typec_altmode *alt;
 	struct ucsi_dp *dp;
 
+	mutex_lock(&con->lock);
+
 	/* We can't rely on the firmware with the capabilities. */
 	desc->vdo |= DP_CAP_DP_SIGNALING | DP_CAP_RECEPTACLE;
 
@@ -298,12 +300,15 @@ struct typec_altmode *ucsi_register_disp
 	desc->vdo |= all_assignments << 16;
 
 	alt = typec_port_register_altmode(con->port, desc);
-	if (IS_ERR(alt))
+	if (IS_ERR(alt)) {
+		mutex_unlock(&con->lock);
 		return alt;
+	}
 
 	dp = devm_kzalloc(&alt->dev, sizeof(*dp), GFP_KERNEL);
 	if (!dp) {
 		typec_unregister_altmode(alt);
+		mutex_unlock(&con->lock);
 		return ERR_PTR(-ENOMEM);
 	}
 
@@ -316,5 +321,7 @@ struct typec_altmode *ucsi_register_disp
 	alt->ops = &ucsi_displayport_ops;
 	typec_altmode_set_drvdata(alt, dp);
 
+	mutex_unlock(&con->lock);
+
 	return alt;
 }


