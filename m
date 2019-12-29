Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4CCB512C9CD
	for <lists+stable@lfdr.de>; Sun, 29 Dec 2019 19:19:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728287AbfL2R0w (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 29 Dec 2019 12:26:52 -0500
Received: from mail.kernel.org ([198.145.29.99]:48398 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728290AbfL2R0u (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 29 Dec 2019 12:26:50 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A70B3208E4;
        Sun, 29 Dec 2019 17:26:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1577640409;
        bh=hMuYONIPat+I+chEyHUq+cw42nC2MRM3jeSxDsdr5L8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tcHY/HANiR4Jshoe9rvjd1F6YdfThNjYJ+/2oiws8lvQ2VDrRjFVkJUHAz0qiY0cv
         EIgr1VDD5hHBQZ372Zy54veeEW3a1xvQekuhgaNXu26u4N6ZGvMnZMYHRyNsEtaxSs
         /bV1JMoHtvxOeocc6oQ20Sy7c0iXNkS7KvO2J9PU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Erkka Talvitie <erkka.talvitie@vincit.fi>,
        Alan Stern <stern@rowland.harvard.edu>
Subject: [PATCH 4.14 146/161] USB: EHCI: Do not return -EPIPE when hub is disconnected
Date:   Sun, 29 Dec 2019 18:19:54 +0100
Message-Id: <20191229162445.526615823@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191229162355.500086350@linuxfoundation.org>
References: <20191229162355.500086350@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Erkka Talvitie <erkka.talvitie@vincit.fi>

commit 64cc3f12d1c7dd054a215bc1ff9cc2abcfe35832 upstream.

When disconnecting a USB hub that has some child device(s) connected to it
(such as a USB mouse), then the stack tries to clear halt and
reset device(s) which are _already_ physically disconnected.

The issue has been reproduced with:

CPU: IMX6D5EYM10AD or MCIMX6D5EYM10AE.
SW: U-Boot 2019.07 and kernel 4.19.40.

CPU: HP Proliant Microserver Gen8.
SW: Linux version 4.2.3-300.fc23.x86_64

In this situation there will be error bit for MMF active yet the
CERR equals EHCI_TUNE_CERR + halt. Existing implementation
interprets this as a stall [1] (chapter 8.4.5).

The possible conditions when the MMF will be active + halt
can be found from [2] (Table 4-13).

Fix for the issue is to check whether MMF is active and PID Code is
IN before checking for the stall. If these conditions are true then
it is not a stall.

What happens after the fix is that when disconnecting a hub with
attached device(s) the situation is not interpret as a stall.

[1] [https://www.usb.org/document-library/usb-20-specification, usb_20.pdf]
[2] [https://www.intel.com/content/dam/www/public/us/en/documents/
     technical-specifications/ehci-specification-for-usb.pdf]

Signed-off-by: Erkka Talvitie <erkka.talvitie@vincit.fi>
Reviewed-by: Alan Stern <stern@rowland.harvard.edu>
Cc: stable <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/ef70941d5f349767f19c0ed26b0dd9eed8ad81bb.1576050523.git.erkka.talvitie@vincit.fi
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/host/ehci-q.c |   13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

--- a/drivers/usb/host/ehci-q.c
+++ b/drivers/usb/host/ehci-q.c
@@ -40,6 +40,10 @@
 
 /*-------------------------------------------------------------------------*/
 
+/* PID Codes that are used here, from EHCI specification, Table 3-16. */
+#define PID_CODE_IN    1
+#define PID_CODE_SETUP 2
+
 /* fill a qtd, returning how much of the buffer we were able to queue up */
 
 static int
@@ -203,7 +207,7 @@ static int qtd_copy_status (
 	int	status = -EINPROGRESS;
 
 	/* count IN/OUT bytes, not SETUP (even short packets) */
-	if (likely (QTD_PID (token) != 2))
+	if (likely(QTD_PID(token) != PID_CODE_SETUP))
 		urb->actual_length += length - QTD_LENGTH (token);
 
 	/* don't modify error codes */
@@ -219,6 +223,13 @@ static int qtd_copy_status (
 		if (token & QTD_STS_BABBLE) {
 			/* FIXME "must" disable babbling device's port too */
 			status = -EOVERFLOW;
+		/*
+		 * When MMF is active and PID Code is IN, queue is halted.
+		 * EHCI Specification, Table 4-13.
+		 */
+		} else if ((token & QTD_STS_MMF) &&
+					(QTD_PID(token) == PID_CODE_IN)) {
+			status = -EPROTO;
 		/* CERR nonzero + halt --> stall */
 		} else if (QTD_CERR(token)) {
 			status = -EPIPE;


