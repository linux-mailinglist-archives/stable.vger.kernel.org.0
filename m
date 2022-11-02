Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 68AE16157A4
	for <lists+stable@lfdr.de>; Wed,  2 Nov 2022 03:35:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230115AbiKBCf5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Nov 2022 22:35:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54686 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230116AbiKBCf4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 1 Nov 2022 22:35:56 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 21BC3767A
        for <stable@vger.kernel.org>; Tue,  1 Nov 2022 19:35:56 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 95C9B617A9
        for <stable@vger.kernel.org>; Wed,  2 Nov 2022 02:35:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3BE3DC433D6;
        Wed,  2 Nov 2022 02:35:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1667356555;
        bh=ORrQPYr7TA0uMJXlY0fZyf06nS9jXOpPaYnH/wUyvZ0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=b59YDsfyIvVWVIRBvC1r5+MkhBcGFWabruD5A9UpH2RyeboqLzoj07SwMFkTwmrr7
         oOY9xwF+pGx/YHBMp69AeWGXv/U1vaXw+nxouZyJto0g9h3Lf1Y+xEoUW0Pj5t58CH
         sTCFkWi+0XRBVI61rTVh1j8SxNIU2pM2QOY5aAuE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Yang Yingliang <yangyingliang@huawei.com>,
        Oleksij Rempel <o.rempel@pengutronix.de>,
        Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH 6.0 002/240] can: j1939: transport: j1939_session_skb_drop_old(): spin_unlock_irqrestore() before kfree_skb()
Date:   Wed,  2 Nov 2022 03:29:37 +0100
Message-Id: <20221102022111.463605318@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221102022111.398283374@linuxfoundation.org>
References: <20221102022111.398283374@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yang Yingliang <yangyingliang@huawei.com>

commit c3c06c61890da80494bb196f75d89b791adda87f upstream.

It is not allowed to call kfree_skb() from hardware interrupt context
or with interrupts being disabled. The skb is unlinked from the queue,
so it can be freed after spin_unlock_irqrestore().

Fixes: 9d71dd0c7009 ("can: add support of SAE J1939 protocol")
Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
Acked-by: Oleksij Rempel <o.rempel@pengutronix.de>
Link: https://lore.kernel.org/all/20221027091237.2290111-1-yangyingliang@huawei.com
Cc: stable@vger.kernel.org
[mkl: adjust subject]
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/can/j1939/transport.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/net/can/j1939/transport.c
+++ b/net/can/j1939/transport.c
@@ -342,10 +342,12 @@ static void j1939_session_skb_drop_old(s
 		__skb_unlink(do_skb, &session->skb_queue);
 		/* drop ref taken in j1939_session_skb_queue() */
 		skb_unref(do_skb);
+		spin_unlock_irqrestore(&session->skb_queue.lock, flags);
 
 		kfree_skb(do_skb);
+	} else {
+		spin_unlock_irqrestore(&session->skb_queue.lock, flags);
 	}
-	spin_unlock_irqrestore(&session->skb_queue.lock, flags);
 }
 
 void j1939_session_skb_queue(struct j1939_session *session,


