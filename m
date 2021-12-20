Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2DBD047ACCB
	for <lists+stable@lfdr.de>; Mon, 20 Dec 2021 15:47:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235450AbhLTOqz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Dec 2021 09:46:55 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:38002 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236750AbhLTOpD (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Dec 2021 09:45:03 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C244D611A5;
        Mon, 20 Dec 2021 14:45:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A8639C36AE7;
        Mon, 20 Dec 2021 14:45:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1640011502;
        bh=gprVOI9OuW2MH+OG+qU9dKnKLZI0kwKVVaXv4sO1mW8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CVdXUaqJr1f9L5FZcsQoeFqyLUny9eVmf+qvvp9LgAYh/PuLkN2MYyYsdcqOqj1qQ
         mjc8ZEuEEXw6DEt5dCRDvML3FhVUe81SaCXRkeVZboOtyCyHshDn9jONCwt9FHFlNV
         kek8RDjMBn5jpXJqVCyjoHUndhnwr7LgJXHWW1/U=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Felipe Balbi <balbi@kernel.org>,
        Szymon Heidrich <szymon.heidrich@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 44/71] USB: gadget: bRequestType is a bitfield, not a enum
Date:   Mon, 20 Dec 2021 15:34:33 +0100
Message-Id: <20211220143027.164331639@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211220143025.683747691@linuxfoundation.org>
References: <20211220143025.683747691@linuxfoundation.org>
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
index d2980e30f3417..c5acf5c39fb18 100644
--- a/drivers/usb/gadget/composite.c
+++ b/drivers/usb/gadget/composite.c
@@ -1649,14 +1649,14 @@ composite_setup(struct usb_gadget *gadget, const struct usb_ctrlrequest *ctrl)
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
index f0aff79f544c3..5f1e15172403e 100644
--- a/drivers/usb/gadget/legacy/inode.c
+++ b/drivers/usb/gadget/legacy/inode.c
@@ -1336,14 +1336,14 @@ gadgetfs_setup (struct usb_gadget *gadget, const struct usb_ctrlrequest *ctrl)
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



