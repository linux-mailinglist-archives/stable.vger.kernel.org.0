Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 558BA60B435
	for <lists+stable@lfdr.de>; Mon, 24 Oct 2022 19:32:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233465AbiJXRcW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Oct 2022 13:32:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57402 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232079AbiJXRbs (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Oct 2022 13:31:48 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C81C46210;
        Mon, 24 Oct 2022 09:07:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4C100B819D8;
        Mon, 24 Oct 2022 12:49:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B9CCC433D6;
        Mon, 24 Oct 2022 12:49:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666615772;
        bh=znIfOAw2qnyy3/KsoXWVQh5iihyrexv06scq5zFQkEo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=g3eItu6//oWGNrtQUyzAoSx1HuCYLzv5NTtrNziy7EoYq9s304W+pIDYYfb4MltZQ
         ANb5Q69G9IcKfzdZJHoPf4qXH8Olivzw+GlCGJsHN1p2sVJ9LzAwBeKQoh5QH87Twn
         kSw3LUOsrJY8ZMq34dEZicFVQDG4T576iP07/z34=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Conor Dooley <conor.dooley@microchip.com>,
        Jassi Brar <jaswinder.singh@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 360/530] mailbox: mpfs: account for mbox offsets while sending
Date:   Mon, 24 Oct 2022 13:31:44 +0200
Message-Id: <20221024113101.344704539@linuxfoundation.org>
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

From: Conor Dooley <conor.dooley@microchip.com>

[ Upstream commit 0d1aadfe10ba17ebdeb96abb9638eb0f623f9b55 ]

The mailbox offset is not only used for receiving messages, but it is
also used by messages sent to the system controller by Linux that have a
payload, such as the "digital signature service". It is also overloaded
by certain other services (reprogramming of the FPGA fabric, see Link:)
to have a meaning other than the offset the system controller should
read from.
When the driver was written, no such services of the latter type were
in use & those of the former used an offset of zero so this has gone
un-noticed.

Link: https://www.microsemi.com/document-portal/doc_download/1245815-polarfire-fpga-and-polarfire-soc-fpga-system-services-user-guide # Section 5.2
Fixes: 83d7b1560810 ("mbox: add polarfire soc system controller mailbox")
Signed-off-by: Conor Dooley <conor.dooley@microchip.com>
Signed-off-by: Jassi Brar <jaswinder.singh@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mailbox/mailbox-mpfs.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/mailbox/mailbox-mpfs.c b/drivers/mailbox/mailbox-mpfs.c
index e432a8f0d148..cfacb3f320a6 100644
--- a/drivers/mailbox/mailbox-mpfs.c
+++ b/drivers/mailbox/mailbox-mpfs.c
@@ -100,21 +100,20 @@ static int mpfs_mbox_send_data(struct mbox_chan *chan, void *data)
 
 		for (index = 0; index < (msg->cmd_data_size / 4); index++)
 			writel_relaxed(word_buf[index],
-				       mbox->mbox_base + index * 0x4);
+				       mbox->mbox_base + msg->mbox_offset + index * 0x4);
 		if (extra_bits) {
 			u8 i;
 			u8 byte_off = ALIGN_DOWN(msg->cmd_data_size, 4);
 			u8 *byte_buf = msg->cmd_data + byte_off;
 
-			val = readl_relaxed(mbox->mbox_base + index * 0x4);
+			val = readl_relaxed(mbox->mbox_base + msg->mbox_offset + index * 0x4);
 
 			for (i = 0u; i < extra_bits; i++) {
 				val &= ~(0xffu << (i * 8u));
 				val |= (byte_buf[i] << (i * 8u));
 			}
 
-			writel_relaxed(val,
-				       mbox->mbox_base + index * 0x4);
+			writel_relaxed(val, mbox->mbox_base + msg->mbox_offset + index * 0x4);
 		}
 	}
 
-- 
2.35.1



