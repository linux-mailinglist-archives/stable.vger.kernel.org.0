Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 497ED4C75DF
	for <lists+stable@lfdr.de>; Mon, 28 Feb 2022 18:56:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239346AbiB1R4u (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Feb 2022 12:56:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46998 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239865AbiB1Rxg (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 28 Feb 2022 12:53:36 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF189AD11B;
        Mon, 28 Feb 2022 09:41:04 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 14398B815BB;
        Mon, 28 Feb 2022 17:40:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 72D59C340F0;
        Mon, 28 Feb 2022 17:40:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1646070047;
        bh=p8i4Tq1JhKBA4elh4tr7Rvc8i93blPcxJzdKjp36pJI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LtfIv7F9qUJZ/jFdtx5uadwES/49wifU0JoEruU5dTSGXkOtMHjlemPBTHL7wXUZC
         MuPoivkNxrZ+TXcd7CwNJ03hfYWpyvL8cRqD55kfUhkyJCxZR7DvFB1bYmmri8FCNh
         iI1hwiQ7DBc2/y1RQxfavPuLwAgKwYqlHkAr6w/g=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, stable <stable@kernel.org>,
        Daehwan Jung <dh10.jung@samsung.com>
Subject: [PATCH 5.15 106/139] usb: gadget: rndis: add spinlock for rndis response list
Date:   Mon, 28 Feb 2022 18:24:40 +0100
Message-Id: <20220228172358.811023388@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220228172347.614588246@linuxfoundation.org>
References: <20220228172347.614588246@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Daehwan Jung <dh10.jung@samsung.com>

commit aaaba1c86d04dac8e49bf508b492f81506257da3 upstream.

There's no lock for rndis response list. It could cause list corruption
if there're two different list_add at the same time like below.
It's better to add in rndis_add_response / rndis_free_response
/ rndis_get_next_response to prevent any race condition on response list.

[  361.894299] [1:   irq/191-dwc3:16979] list_add corruption.
next->prev should be prev (ffffff80651764d0),
but was ffffff883dc36f80. (next=ffffff80651764d0).

[  361.904380] [1:   irq/191-dwc3:16979] Call trace:
[  361.904391] [1:   irq/191-dwc3:16979]  __list_add_valid+0x74/0x90
[  361.904401] [1:   irq/191-dwc3:16979]  rndis_msg_parser+0x168/0x8c0
[  361.904409] [1:   irq/191-dwc3:16979]  rndis_command_complete+0x24/0x84
[  361.904417] [1:   irq/191-dwc3:16979]  usb_gadget_giveback_request+0x20/0xe4
[  361.904426] [1:   irq/191-dwc3:16979]  dwc3_gadget_giveback+0x44/0x60
[  361.904434] [1:   irq/191-dwc3:16979]  dwc3_ep0_complete_data+0x1e8/0x3a0
[  361.904442] [1:   irq/191-dwc3:16979]  dwc3_ep0_interrupt+0x29c/0x3dc
[  361.904450] [1:   irq/191-dwc3:16979]  dwc3_process_event_entry+0x78/0x6cc
[  361.904457] [1:   irq/191-dwc3:16979]  dwc3_process_event_buf+0xa0/0x1ec
[  361.904465] [1:   irq/191-dwc3:16979]  dwc3_thread_interrupt+0x34/0x5c

Fixes: f6281af9d62e ("usb: gadget: rndis: use list_for_each_entry_safe")
Cc: stable <stable@kernel.org>
Signed-off-by: Daehwan Jung <dh10.jung@samsung.com>
Link: https://lore.kernel.org/r/1645507768-77687-1-git-send-email-dh10.jung@samsung.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/gadget/function/rndis.c |    8 ++++++++
 drivers/usb/gadget/function/rndis.h |    1 +
 2 files changed, 9 insertions(+)

--- a/drivers/usb/gadget/function/rndis.c
+++ b/drivers/usb/gadget/function/rndis.c
@@ -922,6 +922,7 @@ struct rndis_params *rndis_register(void
 	params->resp_avail = resp_avail;
 	params->v = v;
 	INIT_LIST_HEAD(&params->resp_queue);
+	spin_lock_init(&params->resp_lock);
 	pr_debug("%s: configNr = %d\n", __func__, i);
 
 	return params;
@@ -1015,12 +1016,14 @@ void rndis_free_response(struct rndis_pa
 {
 	rndis_resp_t *r, *n;
 
+	spin_lock(&params->resp_lock);
 	list_for_each_entry_safe(r, n, &params->resp_queue, list) {
 		if (r->buf == buf) {
 			list_del(&r->list);
 			kfree(r);
 		}
 	}
+	spin_unlock(&params->resp_lock);
 }
 EXPORT_SYMBOL_GPL(rndis_free_response);
 
@@ -1030,14 +1033,17 @@ u8 *rndis_get_next_response(struct rndis
 
 	if (!length) return NULL;
 
+	spin_lock(&params->resp_lock);
 	list_for_each_entry_safe(r, n, &params->resp_queue, list) {
 		if (!r->send) {
 			r->send = 1;
 			*length = r->length;
+			spin_unlock(&params->resp_lock);
 			return r->buf;
 		}
 	}
 
+	spin_unlock(&params->resp_lock);
 	return NULL;
 }
 EXPORT_SYMBOL_GPL(rndis_get_next_response);
@@ -1054,7 +1060,9 @@ static rndis_resp_t *rndis_add_response(
 	r->length = length;
 	r->send = 0;
 
+	spin_lock(&params->resp_lock);
 	list_add_tail(&r->list, &params->resp_queue);
+	spin_unlock(&params->resp_lock);
 	return r;
 }
 
--- a/drivers/usb/gadget/function/rndis.h
+++ b/drivers/usb/gadget/function/rndis.h
@@ -174,6 +174,7 @@ typedef struct rndis_params {
 	void			(*resp_avail)(void *v);
 	void			*v;
 	struct list_head	resp_queue;
+	spinlock_t		resp_lock;
 } rndis_params;
 
 /* RNDIS Message parser and other useless functions */


