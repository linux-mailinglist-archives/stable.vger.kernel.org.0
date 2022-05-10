Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 32CE5521893
	for <lists+stable@lfdr.de>; Tue, 10 May 2022 15:35:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242217AbiEJNjK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 May 2022 09:39:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48638 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243730AbiEJNgF (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 May 2022 09:36:05 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 989DE2609D0;
        Tue, 10 May 2022 06:25:04 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 5AE8CCE1EF3;
        Tue, 10 May 2022 13:25:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6DA9BC385A6;
        Tue, 10 May 2022 13:24:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1652189098;
        bh=AL52ttcBAs7NqVJFaNwvadAqz1DHpx4qIemg1e63Ats=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nTK7KQRhQrzcGEp4dq08c6GhlL8YT9Dg/baQPWDx34myAkuLb+iiDLUf88/6l+lkF
         0pWdruXktT2ouE1FZBAX95193JkKqBHCeg4uKDPRJ7n6w3tb4lcMewnjUcjZ/GQIIH
         Y6yANcURAbaj1rYo+rtp3Q6RFgDmViOHUs1QF/Bo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chengfeng Ye <cyeaa@connect.ust.hk>,
        Takashi Sakamoto <o-takashi@sakamocchi.jp>,
        Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.10 12/70] firewire: fix potential uaf in outbound_phy_packet_callback()
Date:   Tue, 10 May 2022 15:07:31 +0200
Message-Id: <20220510130733.228165921@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220510130732.861729621@linuxfoundation.org>
References: <20220510130732.861729621@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chengfeng Ye <cyeaa@connect.ust.hk>

commit b7c81f80246fac44077166f3e07103affe6db8ff upstream.

&e->event and e point to the same address, and &e->event could
be freed in queue_event. So there is a potential uaf issue if
we dereference e after calling queue_event(). Fix this by adding
a temporary variable to maintain e->client in advance, this can
avoid the potential uaf issue.

Cc: <stable@vger.kernel.org>
Signed-off-by: Chengfeng Ye <cyeaa@connect.ust.hk>
Signed-off-by: Takashi Sakamoto <o-takashi@sakamocchi.jp>
Link: https://lore.kernel.org/r/20220409041243.603210-2-o-takashi@sakamocchi.jp
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/firewire/core-cdev.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/firewire/core-cdev.c
+++ b/drivers/firewire/core-cdev.c
@@ -1480,6 +1480,7 @@ static void outbound_phy_packet_callback
 {
 	struct outbound_phy_packet_event *e =
 		container_of(packet, struct outbound_phy_packet_event, p);
+	struct client *e_client;
 
 	switch (status) {
 	/* expected: */
@@ -1496,9 +1497,10 @@ static void outbound_phy_packet_callback
 	}
 	e->phy_packet.data[0] = packet->timestamp;
 
+	e_client = e->client;
 	queue_event(e->client, &e->event, &e->phy_packet,
 		    sizeof(e->phy_packet) + e->phy_packet.length, NULL, 0);
-	client_put(e->client);
+	client_put(e_client);
 }
 
 static int ioctl_send_phy_packet(struct client *client, union ioctl_arg *arg)


