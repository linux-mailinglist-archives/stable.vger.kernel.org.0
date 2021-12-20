Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5415947AE2B
	for <lists+stable@lfdr.de>; Mon, 20 Dec 2021 15:59:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238388AbhLTO6p (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Dec 2021 09:58:45 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:47098 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237879AbhLTO4b (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Dec 2021 09:56:31 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 80F6061141;
        Mon, 20 Dec 2021 14:56:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6817AC36AE8;
        Mon, 20 Dec 2021 14:56:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1640012190;
        bh=ebvzysUXfX6apRUpLcvFZDHKBsDtxx7URS5Tl+NlOpk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KPdYVSQxjhQZyKR1RTEeXoF7ExoNueFnelwt3xJJMZy+8Te3tDomzNISi/xe5Ss9G
         kyk+fY7w96kxRDmD0i6OsslSlDXX4+kCdpcm+vT2lIOhOpNk512Em6xXPM3dKHV00d
         O02mhYV8Fz5jbz11L/OOg3p/xSY3pktIxcYvZyWA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Felipe Balbi <balbi@kernel.org>,
        Szymon Heidrich <szymon.heidrich@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 113/177] USB: gadget: bRequestType is a bitfield, not a enum
Date:   Mon, 20 Dec 2021 15:34:23 +0100
Message-Id: <20211220143043.879994746@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211220143040.058287525@linuxfoundation.org>
References: <20211220143040.058287525@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

[ Upstream commit f08adf5add9a071160c68bb2a61d697f39ab0758 ]

Szymon rightly pointed out that the previous check for the endpoint
direction in bRequestType was not looking at only the bit involved, but
rather the whole value.  Normally this is ok, but for some request
types, bits other than bit 8 could be set and the check for the endpoint
length could not stall correctly.

Fix that up by only checking the single bit.

Fixes: 153a2d7e3350 ("USB: gadget: detect too-big endpoint 0 requests")
Cc: Felipe Balbi <balbi@kernel.org>
Reported-by: Szymon Heidrich <szymon.heidrich@gmail.com>
Link: https://lore.kernel.org/r/20211214184621.385828-1-gregkh@linuxfoundation.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/gadget/composite.c    | 6 +++---
 drivers/usb/gadget/legacy/dbgp.c  | 6 +++---
 drivers/usb/gadget/legacy/inode.c | 6 +++---
 3 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/drivers/usb/gadget/composite.c b/drivers/usb/gadget/composite.c
index 284eea9f6e4d8..3789c329183ca 100644
--- a/drivers/usb/gadget/composite.c
+++ b/drivers/usb/gadget/composite.c
@@ -1680,14 +1680,14 @@ composite_setup(struct usb_gadget *gadget, const struct usb_ctrlrequest *ctrl)
 	u8				endp;
 
 	if (w_length > USB_COMP_EP0_BUFSIZ) {
-		if (ctrl->bRequestType == USB_DIR_OUT) {
-			goto done;
-		} else {
+		if (ctrl->bRequestType & USB_DIR_IN) {
 			/* Cast away the const, we are going to overwrite on purpose. */
 			__le16 *temp = (__le16 *)&ctrl->wLength;
 
 			*temp = cpu_to_le16(USB_COMP_EP0_BUFSIZ);
 			w_length = USB_COMP_EP0_BUFSIZ;
+		} else {
+			goto done;
 		}
 	}
 
diff --git a/drivers/usb/gadget/legacy/dbgp.c b/drivers/usb/gadget/legacy/dbgp.c
index 355bc7dab9d5f..6bcbad3825802 100644
--- a/drivers/usb/gadget/legacy/dbgp.c
+++ b/drivers/usb/gadget/legacy/dbgp.c
@@ -346,14 +346,14 @@ static int dbgp_setup(struct usb_gadget *gadget,
 	u16 len = 0;
 
 	if (length > DBGP_REQ_LEN) {
-		if (ctrl->bRequestType == USB_DIR_OUT) {
-			return err;
-		} else {
+		if (ctrl->bRequestType & USB_DIR_IN) {
 			/* Cast away the const, we are going to overwrite on purpose. */
 			__le16 *temp = (__le16 *)&ctrl->wLength;
 
 			*temp = cpu_to_le16(DBGP_REQ_LEN);
 			length = DBGP_REQ_LEN;
+		} else {
+			return err;
 		}
 	}
 
diff --git a/drivers/usb/gadget/legacy/inode.c b/drivers/usb/gadget/legacy/inode.c
index 0a4041552ed19..1b223cba4c2c9 100644
--- a/drivers/usb/gadget/legacy/inode.c
+++ b/drivers/usb/gadget/legacy/inode.c
@@ -1337,14 +1337,14 @@ gadgetfs_setup (struct usb_gadget *gadget, const struct usb_ctrlrequest *ctrl)
 	u16				w_length = le16_to_cpu(ctrl->wLength);
 
 	if (w_length > RBUF_SIZE) {
-		if (ctrl->bRequestType == USB_DIR_OUT) {
-			return value;
-		} else {
+		if (ctrl->bRequestType & USB_DIR_IN) {
 			/* Cast away the const, we are going to overwrite on purpose. */
 			__le16 *temp = (__le16 *)&ctrl->wLength;
 
 			*temp = cpu_to_le16(RBUF_SIZE);
 			w_length = RBUF_SIZE;
+		} else {
+			return value;
 		}
 	}
 
-- 
2.34.1



