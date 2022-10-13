Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BD6E05FD16D
	for <lists+stable@lfdr.de>; Thu, 13 Oct 2022 02:36:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232072AbiJMAgY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 Oct 2022 20:36:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42544 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232572AbiJMAf1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 12 Oct 2022 20:35:27 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B403195AB;
        Wed, 12 Oct 2022 17:31:12 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3F87B616F3;
        Thu, 13 Oct 2022 00:27:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D59B7C43143;
        Thu, 13 Oct 2022 00:27:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1665620853;
        bh=f6PvnzB2NTuAawVlsGsqh/PREkZdKYRgw4IKCn33zoY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=aLNuOpkJiKrME/qpYCZiFSZvLbIWsfCtTN7uF+/QAhlHM3HHTtY1S1zc6JfMoYELi
         4Q8dBTczqy+3lEDWJgOe8BdHkcSoh5aoI/0R15yO8mJHde5x6E9qMt7CGqp+Ot7mmQ
         KsUannGbTQ9zZisjJLWjiudGo1okgBSuBCxYKJRE1V0JJitQEpGnzM7hVE5MPfzpkE
         GjCjxt8chKZ2FpYjNwiseoCE9jeUelNfArqHrk7pneSMmrfPgXM84qvRUZP/JUYaL2
         /Nuse54ThuZS9b3pP5vadwcBTdnpt4OX58gxzkdg80JAWB5Fn8CCsnXfisfCRRCga9
         ot3CXSTd5Phow==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Robin Guo <guoweibin@inspur.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>, b-liu@ti.com,
        linux-usb@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 09/13] usb: musb: Fix musb_gadget.c rxstate overflow bug
Date:   Wed, 12 Oct 2022 20:27:08 -0400
Message-Id: <20221013002716.1895839-9-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221013002716.1895839-1-sashal@kernel.org>
References: <20221013002716.1895839-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
index 319c5a1b4a6a..8fd68f45a8df 100644
--- a/drivers/usb/musb/musb_gadget.c
+++ b/drivers/usb/musb/musb_gadget.c
@@ -785,6 +785,9 @@ static void rxstate(struct musb *musb, struct musb_request *req)
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

