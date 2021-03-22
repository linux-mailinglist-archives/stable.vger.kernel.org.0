Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1B1523443C0
	for <lists+stable@lfdr.de>; Mon, 22 Mar 2021 13:55:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230245AbhCVMxq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Mar 2021 08:53:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:47788 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231536AbhCVMvs (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 22 Mar 2021 08:51:48 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 83D8B619FF;
        Mon, 22 Mar 2021 12:46:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1616417185;
        bh=OILm6jBGESXvps1Cv1pDxw5hs8Llohqh1bqGZ1w2/vY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RRTvzUwfWQVECfsJk6bDmd+/nbSy21TtESv7wXHcbXFwRST4DsRr+4xxVWulq6Xeu
         tL0OZkrzXuU8WZo8ZdQ9pL+uLilVIDD1DGIieHtNMvLOep1avmkMIFfsRhSmY0o/n/
         1jVjOVONANDmGlS1FncMQb4n/WXstDlDlUIR9s48=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Macpaul Lin <macpaul.lin@mediatek.com>,
        Alan Stern <stern@rowland.harvard.edu>
Subject: [PATCH 4.4 08/14] USB: replace hardcode maximum usb string length by definition
Date:   Mon, 22 Mar 2021 13:29:02 +0100
Message-Id: <20210322121919.460579586@linuxfoundation.org>
X-Mailer: git-send-email 2.31.0
In-Reply-To: <20210322121919.202392464@linuxfoundation.org>
References: <20210322121919.202392464@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Macpaul Lin <macpaul.lin@mediatek.com>

commit 81c7462883b0cc0a4eeef0687f80ad5b5baee5f6 upstream.

Replace hardcoded maximum USB string length (126 bytes) by definition
"USB_MAX_STRING_LEN".

Signed-off-by: Macpaul Lin <macpaul.lin@mediatek.com>
Acked-by: Alan Stern <stern@rowland.harvard.edu>
Link: https://lore.kernel.org/r/1592471618-29428-1-git-send-email-macpaul.lin@mediatek.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/gadget/composite.c |    4 ++--
 drivers/usb/gadget/configfs.c  |    2 +-
 drivers/usb/gadget/usbstring.c |    4 ++--
 include/uapi/linux/usb/ch9.h   |    3 +++
 4 files changed, 8 insertions(+), 5 deletions(-)

--- a/drivers/usb/gadget/composite.c
+++ b/drivers/usb/gadget/composite.c
@@ -933,7 +933,7 @@ static void collect_langs(struct usb_gad
 	while (*sp) {
 		s = *sp;
 		language = cpu_to_le16(s->language);
-		for (tmp = buf; *tmp && tmp < &buf[126]; tmp++) {
+		for (tmp = buf; *tmp && tmp < &buf[USB_MAX_STRING_LEN]; tmp++) {
 			if (*tmp == language)
 				goto repeat;
 		}
@@ -1008,7 +1008,7 @@ static int get_string(struct usb_composi
 			collect_langs(sp, s->wData);
 		}
 
-		for (len = 0; len <= 126 && s->wData[len]; len++)
+		for (len = 0; len <= USB_MAX_STRING_LEN && s->wData[len]; len++)
 			continue;
 		if (!len)
 			return -EINVAL;
--- a/drivers/usb/gadget/configfs.c
+++ b/drivers/usb/gadget/configfs.c
@@ -117,7 +117,7 @@ static int usb_string_copy(const char *s
 	char *str;
 	char *copy = *s_copy;
 	ret = strlen(s);
-	if (ret > 126)
+	if (ret > USB_MAX_STRING_LEN)
 		return -EOVERFLOW;
 
 	str = kstrdup(s, GFP_KERNEL);
--- a/drivers/usb/gadget/usbstring.c
+++ b/drivers/usb/gadget/usbstring.c
@@ -59,9 +59,9 @@ usb_gadget_get_string (struct usb_gadget
 		return -EINVAL;
 
 	/* string descriptors have length, tag, then UTF16-LE text */
-	len = min ((size_t) 126, strlen (s->s));
+	len = min((size_t)USB_MAX_STRING_LEN, strlen(s->s));
 	len = utf8s_to_utf16s(s->s, len, UTF16_LITTLE_ENDIAN,
-			(wchar_t *) &buf[2], 126);
+			(wchar_t *) &buf[2], USB_MAX_STRING_LEN);
 	if (len < 0)
 		return -EINVAL;
 	buf [0] = (len + 1) * 2;
--- a/include/uapi/linux/usb/ch9.h
+++ b/include/uapi/linux/usb/ch9.h
@@ -333,6 +333,9 @@ struct usb_config_descriptor {
 
 /*-------------------------------------------------------------------------*/
 
+/* USB String descriptors can contain at most 126 characters. */
+#define USB_MAX_STRING_LEN	126
+
 /* USB_DT_STRING: String descriptor */
 struct usb_string_descriptor {
 	__u8  bLength;


