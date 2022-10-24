Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2417460A36C
	for <lists+stable@lfdr.de>; Mon, 24 Oct 2022 13:55:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232141AbiJXLzg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Oct 2022 07:55:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40710 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232559AbiJXLzA (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Oct 2022 07:55:00 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7319379624;
        Mon, 24 Oct 2022 04:45:57 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 64876CE1333;
        Mon, 24 Oct 2022 11:44:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5604BC433D7;
        Mon, 24 Oct 2022 11:44:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666611854;
        bh=/DR/Pm6olMKD07sZdtTxvKVfY++LskMxUDTIWs68pxo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fnLcPRFUSrmCFitQQFknzjDRzEIhl+aJkUdMpOyu3uMkroY2q2/Z+EaoIzmaVM3Wf
         J3PWIPCBXUQ5/tanqTwiQNQodgucnB2qype7kdODHAFWCYACRbGUGaFCWlbNTJgMh4
         vYrb73fq8F3AF1xhjRe8SrRp607/U+7FWELLep6Y=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Andrew Gaul <gaul@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 136/159] r8152: Rate limit overflow messages
Date:   Mon, 24 Oct 2022 13:31:30 +0200
Message-Id: <20221024112954.430967872@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221024112949.358278806@linuxfoundation.org>
References: <20221024112949.358278806@linuxfoundation.org>
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

From: Andrew Gaul <gaul@gaul.org>

[ Upstream commit 93e2be344a7db169b7119de21ac1bf253b8c6907 ]

My system shows almost 10 million of these messages over a 24-hour
period which pollutes my logs.

Signed-off-by: Andrew Gaul <gaul@google.com>
Link: https://lore.kernel.org/r/20221002034128.2026653-1-gaul@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/usb/r8152.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/usb/r8152.c b/drivers/net/usb/r8152.c
index 96f6edcb0062..a354695a22a9 100644
--- a/drivers/net/usb/r8152.c
+++ b/drivers/net/usb/r8152.c
@@ -1282,7 +1282,9 @@ static void intr_callback(struct urb *urb)
 			   "Stop submitting intr, status %d\n", status);
 		return;
 	case -EOVERFLOW:
-		netif_info(tp, intr, tp->netdev, "intr status -EOVERFLOW\n");
+		if (net_ratelimit())
+			netif_info(tp, intr, tp->netdev,
+				   "intr status -EOVERFLOW\n");
 		goto resubmit;
 	/* -EPIPE:  should clear the halt */
 	default:
-- 
2.35.1



