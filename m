Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D2EFD5B757A
	for <lists+stable@lfdr.de>; Tue, 13 Sep 2022 17:45:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234342AbiIMPp3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 13 Sep 2022 11:45:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38394 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231886AbiIMPpH (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 13 Sep 2022 11:45:07 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 146D65F7F6;
        Tue, 13 Sep 2022 07:48:46 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8CEBF614D1;
        Tue, 13 Sep 2022 14:25:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8DE03C433C1;
        Tue, 13 Sep 2022 14:25:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1663079109;
        bh=XkQbDJaMEkaRdkohvyKxOTHcsS3Jp20F3IRQadi3+84=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=a8OpAXWXCTLYCZL/LrbnHxDKrdyNjyDPsMio7ggFGrsbxSNElRsCedjniTS9qk15u
         oaydv2ROX/uN0CsqDzWIhLUJBPa79H2+QaBperm5EWcQxIc2DbAPyo7vcXrNcV5HLM
         8lvQfnsCyOadc/Hf/19Kf9RR3DFHV0+t59/xPN7s=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lucas Leong <wmliang.tw@gmail.com>,
        David Lebrun <dlebrun@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 62/79] ipv6: sr: fix out-of-bounds read when setting HMAC data.
Date:   Tue, 13 Sep 2022 16:05:07 +0200
Message-Id: <20220913140353.206087559@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220913140350.291927556@linuxfoundation.org>
References: <20220913140350.291927556@linuxfoundation.org>
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

From: David Lebrun <dlebrun@google.com>

[ Upstream commit 84a53580c5d2138c7361c7c3eea5b31827e63b35 ]

The SRv6 layer allows defining HMAC data that can later be used to sign IPv6
Segment Routing Headers. This configuration is realised via netlink through
four attributes: SEG6_ATTR_HMACKEYID, SEG6_ATTR_SECRET, SEG6_ATTR_SECRETLEN and
SEG6_ATTR_ALGID. Because the SECRETLEN attribute is decoupled from the actual
length of the SECRET attribute, it is possible to provide invalid combinations
(e.g., secret = "", secretlen = 64). This case is not checked in the code and
with an appropriately crafted netlink message, an out-of-bounds read of up
to 64 bytes (max secret length) can occur past the skb end pointer and into
skb_shared_info:

Breakpoint 1, seg6_genl_sethmac (skb=<optimized out>, info=<optimized out>) at net/ipv6/seg6.c:208
208		memcpy(hinfo->secret, secret, slen);
(gdb) bt
 #0  seg6_genl_sethmac (skb=<optimized out>, info=<optimized out>) at net/ipv6/seg6.c:208
 #1  0xffffffff81e012e9 in genl_family_rcv_msg_doit (skb=skb@entry=0xffff88800b1f9f00, nlh=nlh@entry=0xffff88800b1b7600,
    extack=extack@entry=0xffffc90000ba7af0, ops=ops@entry=0xffffc90000ba7a80, hdrlen=4, net=0xffffffff84237580 <init_net>, family=<optimized out>,
    family=<optimized out>) at net/netlink/genetlink.c:731
 #2  0xffffffff81e01435 in genl_family_rcv_msg (extack=0xffffc90000ba7af0, nlh=0xffff88800b1b7600, skb=0xffff88800b1f9f00,
    family=0xffffffff82fef6c0 <seg6_genl_family>) at net/netlink/genetlink.c:775
 #3  genl_rcv_msg (skb=0xffff88800b1f9f00, nlh=0xffff88800b1b7600, extack=0xffffc90000ba7af0) at net/netlink/genetlink.c:792
 #4  0xffffffff81dfffc3 in netlink_rcv_skb (skb=skb@entry=0xffff88800b1f9f00, cb=cb@entry=0xffffffff81e01350 <genl_rcv_msg>)
    at net/netlink/af_netlink.c:2501
 #5  0xffffffff81e00919 in genl_rcv (skb=0xffff88800b1f9f00) at net/netlink/genetlink.c:803
 #6  0xffffffff81dff6ae in netlink_unicast_kernel (ssk=0xffff888010eec800, skb=0xffff88800b1f9f00, sk=0xffff888004aed000)
    at net/netlink/af_netlink.c:1319
 #7  netlink_unicast (ssk=ssk@entry=0xffff888010eec800, skb=skb@entry=0xffff88800b1f9f00, portid=portid@entry=0, nonblock=<optimized out>)
    at net/netlink/af_netlink.c:1345
 #8  0xffffffff81dff9a4 in netlink_sendmsg (sock=<optimized out>, msg=0xffffc90000ba7e48, len=<optimized out>) at net/netlink/af_netlink.c:1921
...
(gdb) p/x ((struct sk_buff *)0xffff88800b1f9f00)->head + ((struct sk_buff *)0xffff88800b1f9f00)->end
$1 = 0xffff88800b1b76c0
(gdb) p/x secret
$2 = 0xffff88800b1b76c0
(gdb) p slen
$3 = 64 '@'

The OOB data can then be read back from userspace by dumping HMAC state. This
commit fixes this by ensuring SECRETLEN cannot exceed the actual length of
SECRET.

Reported-by: Lucas Leong <wmliang.tw@gmail.com>
Tested: verified that EINVAL is correctly returned when secretlen > len(secret)
Fixes: 4f4853dc1c9c1 ("ipv6: sr: implement API to control SR HMAC structure")
Signed-off-by: David Lebrun <dlebrun@google.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv6/seg6.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/net/ipv6/seg6.c b/net/ipv6/seg6.c
index d2f8138e5a73a..2278c0234c497 100644
--- a/net/ipv6/seg6.c
+++ b/net/ipv6/seg6.c
@@ -135,6 +135,11 @@ static int seg6_genl_sethmac(struct sk_buff *skb, struct genl_info *info)
 		goto out_unlock;
 	}
 
+	if (slen > nla_len(info->attrs[SEG6_ATTR_SECRET])) {
+		err = -EINVAL;
+		goto out_unlock;
+	}
+
 	if (hinfo) {
 		err = seg6_hmac_info_del(net, hmackeyid);
 		if (err)
-- 
2.35.1



