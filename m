Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A0BEF60B29D
	for <lists+stable@lfdr.de>; Mon, 24 Oct 2022 18:50:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233291AbiJXQuY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Oct 2022 12:50:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57932 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233733AbiJXQrq (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Oct 2022 12:47:46 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 70FCD459AF;
        Mon, 24 Oct 2022 08:31:54 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D828BB81A21;
        Mon, 24 Oct 2022 12:55:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 38600C433C1;
        Mon, 24 Oct 2022 12:55:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666616156;
        bh=ChQlq57TdiF2+yMwowcsaIstRF9GQEl2m9FYZMOmQ4U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=T6HAYarY48OgnMitWp2vjSnBhDqBRTAnBLyngSp/UBdHh59XnKTbDzXNTtMJJquys
         FCo+4VibpCOsavMI2QLgXLQaqrU5Q1f7cOqrjAXHjOHJIky+Jmwnx0YFvBccnt49DT
         4eJvBvWdwK9ZTLNLzZip+/b6k6Ja8tW6hwyd9Uqc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot <syzbot+5ea725c25d06fb9114c4@syzkaller.appspotmail.com>,
        Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
        Alexander Aring <aahringo@redhat.com>,
        Stefan Schmidt <stefan@datenfreihafen.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 522/530] net/ieee802154: dont warn zero-sized raw_sendmsg()
Date:   Mon, 24 Oct 2022 13:34:26 +0200
Message-Id: <20221024113108.616973009@linuxfoundation.org>
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
 net/ieee802154/socket.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/net/ieee802154/socket.c b/net/ieee802154/socket.c
index fd5862f9e26a..d0aaa0346cb1 100644
--- a/net/ieee802154/socket.c
+++ b/net/ieee802154/socket.c
@@ -272,6 +272,10 @@ static int raw_sendmsg(struct sock *sk, struct msghdr *msg, size_t size)
 		err = -EMSGSIZE;
 		goto out_dev;
 	}
+	if (!size) {
+		err = 0;
+		goto out_dev;
+	}
 
 	hlen = LL_RESERVED_SPACE(dev);
 	tlen = dev->needed_tailroom;
-- 
2.35.1



