Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9E4A9548A4D
	for <lists+stable@lfdr.de>; Mon, 13 Jun 2022 18:07:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235844AbiFMKT0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Jun 2022 06:19:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57926 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242729AbiFMKSd (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Jun 2022 06:18:33 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7249220BD5;
        Mon, 13 Jun 2022 03:16:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id BC0ACCE1109;
        Mon, 13 Jun 2022 10:16:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B08CAC34114;
        Mon, 13 Jun 2022 10:16:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655115377;
        bh=lXOwunPvjLmnJDHlPHNJ8y9/+BMNkm1eEegXiSOoUHk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GMJ4Z6qqM6lKq0OKqrXN2heb9CVZgiboWdf+cq/gbn1ZuZ72eWfPVu4Gp41TWeZH+
         QmJdwaaTpE7DG/WlTUxXy0iu73PvJMXdh1bEYz8kw0/EkRSxcZhcrAhUPEuJQ34Ihf
         Gv7ExYneSj5OA5/6c/s9dnmj3J1u2v87dcO6j1pc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Xiaomeng Tong <xiam0nd.tong@gmail.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 052/167] media: uvcvideo: Fix missing check to determine if element is found in list
Date:   Mon, 13 Jun 2022 12:08:46 +0200
Message-Id: <20220613094853.179297413@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220613094840.720778945@linuxfoundation.org>
References: <20220613094840.720778945@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Xiaomeng Tong <xiam0nd.tong@gmail.com>

[ Upstream commit 261f33388c29f6f3c12a724e6d89172b7f6d5996 ]

The list iterator will point to a bogus position containing HEAD if
the list is empty or the element is not found in list. This case
should be checked before any use of the iterator, otherwise it will
lead to a invalid memory access. The missing check here is before
"pin = iterm->id;", just add check here to fix the security bug.

In addition, the list iterator value will *always* be set and non-NULL
by list_for_each_entry(), so it is incorrect to assume that the iterator
value will be NULL if the element is not found in list, considering
the (mis)use here: "if (iterm == NULL".

Use a new value 'it' as the list iterator, while use the old value
'iterm' as a dedicated pointer to point to the found element, which
1. can fix this bug, due to 'iterm' is NULL only if it's not found.
2. do not need to change all the uses of 'iterm' after the loop.
3. can also limit the scope of the list iterator 'it' *only inside*
   the traversal loop by simply declaring 'it' inside the loop in the
   future, as usage of the iterator outside of the list_for_each_entry
   is considered harmful. https://lkml.org/lkml/2022/2/17/1032

Fixes: d5e90b7a6cd1c ("[media] uvcvideo: Move to video_ioctl2")
Signed-off-by: Xiaomeng Tong <xiam0nd.tong@gmail.com>
Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/usb/uvc/uvc_v4l2.c | 20 +++++++++++---------
 1 file changed, 11 insertions(+), 9 deletions(-)

diff --git a/drivers/media/usb/uvc/uvc_v4l2.c b/drivers/media/usb/uvc/uvc_v4l2.c
index 2b1e06e825f0..53d81ef9a4be 100644
--- a/drivers/media/usb/uvc/uvc_v4l2.c
+++ b/drivers/media/usb/uvc/uvc_v4l2.c
@@ -846,29 +846,31 @@ static int uvc_ioctl_enum_input(struct file *file, void *fh,
 	struct uvc_video_chain *chain = handle->chain;
 	const struct uvc_entity *selector = chain->selector;
 	struct uvc_entity *iterm = NULL;
+	struct uvc_entity *it;
 	u32 index = input->index;
-	int pin = 0;
 
 	if (selector == NULL ||
 	    (chain->dev->quirks & UVC_QUIRK_IGNORE_SELECTOR_UNIT)) {
 		if (index != 0)
 			return -EINVAL;
-		list_for_each_entry(iterm, &chain->entities, chain) {
-			if (UVC_ENTITY_IS_ITERM(iterm))
+		list_for_each_entry(it, &chain->entities, chain) {
+			if (UVC_ENTITY_IS_ITERM(it)) {
+				iterm = it;
 				break;
+			}
 		}
-		pin = iterm->id;
 	} else if (index < selector->bNrInPins) {
-		pin = selector->baSourceID[index];
-		list_for_each_entry(iterm, &chain->entities, chain) {
-			if (!UVC_ENTITY_IS_ITERM(iterm))
+		list_for_each_entry(it, &chain->entities, chain) {
+			if (!UVC_ENTITY_IS_ITERM(it))
 				continue;
-			if (iterm->id == pin)
+			if (it->id == selector->baSourceID[index]) {
+				iterm = it;
 				break;
+			}
 		}
 	}
 
-	if (iterm == NULL || iterm->id != pin)
+	if (iterm == NULL)
 		return -EINVAL;
 
 	memset(input, 0, sizeof(*input));
-- 
2.35.1



