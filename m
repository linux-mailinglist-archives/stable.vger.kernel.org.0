Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 53EEA5AB3C1
	for <lists+stable@lfdr.de>; Fri,  2 Sep 2022 16:36:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235677AbiIBOgP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 2 Sep 2022 10:36:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53010 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235685AbiIBOfi (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 2 Sep 2022 10:35:38 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C8963168A32;
        Fri,  2 Sep 2022 06:56:34 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1B12B62178;
        Fri,  2 Sep 2022 12:38:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 152A3C433D6;
        Fri,  2 Sep 2022 12:37:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1662122280;
        bh=S1ziajJp7xs/vpXYFoVk59BE8C1BfxDdOtGKt2qmjSE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oaqKIHDoHHkLZVKZiJs822v4OBOv+dxuu0O09aPtDKaKuZtAQgOZIiC4CTqsUBXnm
         I9Ua6/gLAcs36iQybOa4nqLWlX3VTzVuInEO5ymE9wVeEFH+AF/hTTvVFk7QWDm2Ei
         j7lJQasaUo6uHnq7tnNFjXiXTUCSpq2DsvWOPr9Y=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+5ea725c25d06fb9114c4@syzkaller.appspotmail.com,
        Zhengchao Shao <shaozhengchao@huawei.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.19 70/72] net/af_packet: check len when min_header_len equals to 0
Date:   Fri,  2 Sep 2022 14:19:46 +0200
Message-Id: <20220902121407.097023450@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220902121404.772492078@linuxfoundation.org>
References: <20220902121404.772492078@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Zhengchao Shao <shaozhengchao@huawei.com>

commit dc633700f00f726e027846a318c5ffeb8deaaeda upstream.

User can use AF_PACKET socket to send packets with the length of 0.
When min_header_len equals to 0, packet_snd will call __dev_queue_xmit
to send packets, and sock->type can be any type.

Reported-by: syzbot+5ea725c25d06fb9114c4@syzkaller.appspotmail.com
Fixes: fd1894224407 ("bpf: Don't redirect packets with invalid pkt_len")
Signed-off-by: Zhengchao Shao <shaozhengchao@huawei.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/packet/af_packet.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/net/packet/af_packet.c
+++ b/net/packet/af_packet.c
@@ -3037,8 +3037,8 @@ static int packet_snd(struct socket *soc
 	if (err)
 		goto out_free;
 
-	if (sock->type == SOCK_RAW &&
-	    !dev_validate_header(dev, skb->data, len)) {
+	if ((sock->type == SOCK_RAW &&
+	     !dev_validate_header(dev, skb->data, len)) || !skb->len) {
 		err = -EINVAL;
 		goto out_free;
 	}


