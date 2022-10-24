Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B2A9960AE54
	for <lists+stable@lfdr.de>; Mon, 24 Oct 2022 16:57:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232033AbiJXO5q (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Oct 2022 10:57:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52452 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232322AbiJXO53 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Oct 2022 10:57:29 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 12A9122510;
        Mon, 24 Oct 2022 06:34:46 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4AC5361290;
        Mon, 24 Oct 2022 12:56:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A305C433C1;
        Mon, 24 Oct 2022 12:56:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666616172;
        bh=yy1LzY/k4eWn7O3Bo53AqA6dt4/zM2XYo6Qw9qUfJl4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=R7L7v5xXrG+hJCrqaoSnxwwKU/Tbra8RAdLjZuJjDOmxj3NjW6UtpydzKcWcw3OT8
         R8f0YtzIOk0YMPpDA5ZFaaaI7imHx0KS09AUAL/+nRDIaQwJJXkk7VbNbM7jOSlxXF
         IdoKYcAKqhHZO23pWwrRcTQlLYX036BlwAkzukqU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Robin Guo <guoweibin@inspur.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 497/530] usb: musb: Fix musb_gadget.c rxstate overflow bug
Date:   Mon, 24 Oct 2022 13:34:01 +0200
Message-Id: <20221024113107.540667985@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221024113044.976326639@linuxfoundation.org>
References: <20221024113044.976326639@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
index 51274b87f46c..dc67fff8e941 100644
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



