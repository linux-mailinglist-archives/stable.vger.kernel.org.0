Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3E1AB5218EE
	for <lists+stable@lfdr.de>; Tue, 10 May 2022 15:39:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243740AbiEJNlB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 May 2022 09:41:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54786 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245232AbiEJNik (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 May 2022 09:38:40 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 002561A811B;
        Tue, 10 May 2022 06:28:57 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 39989B81D24;
        Tue, 10 May 2022 13:28:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A0A68C2BBE4;
        Tue, 10 May 2022 13:28:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1652189335;
        bh=AL52ttcBAs7NqVJFaNwvadAqz1DHpx4qIemg1e63Ats=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xjjjSwkKIsgMke79+nrZakQttHl4yrYPApik8S+tNyziSBVZUto/y2CR6AXjMagWL
         yCIf+urMFQH5itkogCb6jxiwp9HgRiBm3ueUG2R6L1M4gidG+zyrhx6rjO6UuD4nr3
         l8xkQfwUhDSpjImr5aViEa1kzv3oxCtfXf+R4iHU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chengfeng Ye <cyeaa@connect.ust.hk>,
        Takashi Sakamoto <o-takashi@sakamocchi.jp>,
        Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.15 018/135] firewire: fix potential uaf in outbound_phy_packet_callback()
Date:   Tue, 10 May 2022 15:06:40 +0200
Message-Id: <20220510130740.921261705@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220510130740.392653815@linuxfoundation.org>
References: <20220510130740.392653815@linuxfoundation.org>
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


