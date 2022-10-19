Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 771C1604618
	for <lists+stable@lfdr.de>; Wed, 19 Oct 2022 14:58:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231382AbiJSM6W (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Oct 2022 08:58:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35360 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231417AbiJSM6L (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Oct 2022 08:58:11 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD48F2408F;
        Wed, 19 Oct 2022 05:41:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 57213CE2167;
        Wed, 19 Oct 2022 09:15:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D9EEC433D7;
        Wed, 19 Oct 2022 09:15:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666170943;
        bh=2fdLn/QEe5cJvzhuHn+H7MqMQb9Zx1z0xrlir9w8xYE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uOJjkhEX59WzL8hd+xffoA+Se9tUJOE5uHto+l8krl/umeOCjamRgHAFbunhR/wQx
         hQOWWhpJzXZGFK3cRUztp704LwHjcg0e0nQYkXFelMNqc/XPSljR/1KdeadRskIzr+
         k4psaQzFUMk0oNl0jntJMFZIr9yZfDLNIV52uqb8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Robin Guo <guoweibin@inspur.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 818/862] usb: musb: Fix musb_gadget.c rxstate overflow bug
Date:   Wed, 19 Oct 2022 10:35:05 +0200
Message-Id: <20221019083326.051998588@linuxfoundation.org>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20221019083249.951566199@linuxfoundation.org>
References: <20221019083249.951566199@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Robin Guo <guoweibin@inspur.com>

[ Upstream commit eea4c860c3b366369eff0489d94ee4f0571d467d ]

The usb function device call musb_gadget_queue() adds the passed
request to musb_ep::req_list,If the (request->length > musb_ep->packet_sz)
and (is_buffer_mapped(req) return false),the rxstate() will copy all data
in fifo to request->buf which may cause request->buf out of bounds.

Fix it by add the length check :
fifocnt = min_t(unsigned, request->length - request->actual, fifocnt);

Signed-off-by: Robin Guo <guoweibin@inspur.com>
Link: https://lore.kernel.org/r/20220906102119.1b071d07a8391ff115e6d1ef@inspur.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/musb/musb_gadget.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/usb/musb/musb_gadget.c b/drivers/usb/musb/musb_gadget.c
index daada4b66a92..6704a62a1665 100644
--- a/drivers/usb/musb/musb_gadget.c
+++ b/drivers/usb/musb/musb_gadget.c
@@ -760,6 +760,9 @@ static void rxstate(struct musb *musb, struct musb_request *req)
 			musb_writew(epio, MUSB_RXCSR, csr);
 
 buffer_aint_mapped:
+			fifo_count = min_t(unsigned int,
+					request->length - request->actual,
+					(unsigned int)fifo_count);
 			musb_read_fifo(musb_ep->hw_ep, fifo_count, (u8 *)
 					(request->buf + request->actual));
 			request->actual += fifo_count;
-- 
2.35.1



