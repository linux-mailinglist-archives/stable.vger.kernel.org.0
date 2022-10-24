Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 436DD60A97B
	for <lists+stable@lfdr.de>; Mon, 24 Oct 2022 15:21:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231959AbiJXNVJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Oct 2022 09:21:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42688 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236439AbiJXNU2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Oct 2022 09:20:28 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 98B1B29CB0;
        Mon, 24 Oct 2022 05:29:01 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B73EFB8119E;
        Mon, 24 Oct 2022 12:04:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 16FC9C433D6;
        Mon, 24 Oct 2022 12:04:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666613090;
        bh=/K/z/rK+8z3Z74OMUw1WBkuyfmRSNZoUhy4sU47g0Yk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=X+aJkKuPnV3DOjrJbOY+ndxIzR5G5RTqAuyUaTASLNm27IrtXPlpruNzqiBEq03Qx
         XEk7WWM2MYuza49VqnrbM8Cf5MdUDcHoyKvKw7yz8Rqya/Taoz+QI8iRTBbGXZ/HVV
         UDI6SeOyj5AYlvYxF4W37f1+0qTZSi371gGZ0npw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot <syzbot+5ea725c25d06fb9114c4@syzkaller.appspotmail.com>,
        Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
        Alexander Aring <aahringo@redhat.com>,
        Stefan Schmidt <stefan@datenfreihafen.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 223/229] net/ieee802154: dont warn zero-sized raw_sendmsg()
Date:   Mon, 24 Oct 2022 13:32:22 +0200
Message-Id: <20221024113006.476744345@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221024112959.085534368@linuxfoundation.org>
References: <20221024112959.085534368@linuxfoundation.org>
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

From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>

[ Upstream commit b12e924a2f5b960373459c8f8a514f887adf5cac ]

syzbot is hitting skb_assert_len() warning at __dev_queue_xmit() [1],
for PF_IEEE802154 socket's zero-sized raw_sendmsg() request is hitting
__dev_queue_xmit() with skb->len == 0.

Since PF_IEEE802154 socket's zero-sized raw_sendmsg() request was
able to return 0, don't call __dev_queue_xmit() if packet length is 0.

  ----------
  #include <sys/socket.h>
  #include <netinet/in.h>

  int main(int argc, char *argv[])
  {
    struct sockaddr_in addr = { .sin_family = AF_INET, .sin_addr.s_addr = htonl(INADDR_LOOPBACK) };
    struct iovec iov = { };
    struct msghdr hdr = { .msg_name = &addr, .msg_namelen = sizeof(addr), .msg_iov = &iov, .msg_iovlen = 1 };
    sendmsg(socket(PF_IEEE802154, SOCK_RAW, 0), &hdr, 0);
    return 0;
  }
  ----------

Note that this might be a sign that commit fd1894224407c484 ("bpf: Don't
redirect packets with invalid pkt_len") should be reverted, for
skb->len == 0 was acceptable for at least PF_IEEE802154 socket.

Link: https://syzkaller.appspot.com/bug?extid=5ea725c25d06fb9114c4 [1]
Reported-by: syzbot <syzbot+5ea725c25d06fb9114c4@syzkaller.appspotmail.com>
Fixes: fd1894224407c484 ("bpf: Don't redirect packets with invalid pkt_len")
Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Signed-off-by: Alexander Aring <aahringo@redhat.com>
Link: https://lore.kernel.org/r/20221005014750.3685555-2-aahringo@redhat.com
Signed-off-by: Stefan Schmidt <stefan@datenfreihafen.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ieee802154/socket.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/net/ieee802154/socket.c
+++ b/net/ieee802154/socket.c
@@ -285,6 +285,10 @@ static int raw_sendmsg(struct sock *sk,
 		err = -EMSGSIZE;
 		goto out_dev;
 	}
+	if (!size) {
+		err = 0;
+		goto out_dev;
+	}
 
 	hlen = LL_RESERVED_SPACE(dev);
 	tlen = dev->needed_tailroom;


