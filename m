Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C1E28579A15
	for <lists+stable@lfdr.de>; Tue, 19 Jul 2022 14:10:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238568AbiGSMKd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Jul 2022 08:10:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51108 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238977AbiGSMJz (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 19 Jul 2022 08:09:55 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 315154B0F6;
        Tue, 19 Jul 2022 05:03:00 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 840E1615F4;
        Tue, 19 Jul 2022 12:02:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 77825C341C6;
        Tue, 19 Jul 2022 12:02:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1658232178;
        bh=+X7vwntOv5W94BZJ8s5XyCGg+kTvjqwFTcKxvAeT5DU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wVJPgeFicaghVT9PuVWj/gH5C/31bULCIEdxuZWUHidVNtX3zqy8tipFC+UMtROqB
         xLw+NEjtz3faOFPcg36LNLyMVtcHK3/33BrzN7pN8oIkR3MGt/hDD8U2WK65aNpe1b
         KVW6soycuARupfthXbn3qoFgkh6nGfPe525jIci8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Paolo Abeni <pabeni@redhat.com>,
        Andrea Mayer <andrea.mayer@uniroma2.it>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 40/71] seg6: fix skb checksum evaluation in SRH encapsulation/insertion
Date:   Tue, 19 Jul 2022 13:54:03 +0200
Message-Id: <20220719114556.158303217@linuxfoundation.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220719114552.477018590@linuxfoundation.org>
References: <20220719114552.477018590@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Andrea Mayer <andrea.mayer@uniroma2.it>

[ Upstream commit df8386d13ea280d55beee1b95f61a59234a3798b ]

Support for SRH encapsulation and insertion was introduced with
commit 6c8702c60b88 ("ipv6: sr: add support for SRH encapsulation and
injection with lwtunnels"), through the seg6_do_srh_encap() and
seg6_do_srh_inline() functions, respectively.
The former encapsulates the packet in an outer IPv6 header along with
the SRH, while the latter inserts the SRH between the IPv6 header and
the payload. Then, the headers are initialized/updated according to the
operating mode (i.e., encap/inline).
Finally, the skb checksum is calculated to reflect the changes applied
to the headers.

The IPv6 payload length ('payload_len') is not initialized
within seg6_do_srh_{inline,encap}() but is deferred in seg6_do_srh(), i.e.
the caller of seg6_do_srh_{inline,encap}().
However, this operation invalidates the skb checksum, since the
'payload_len' is updated only after the checksum is evaluated.

To solve this issue, the initialization of the IPv6 payload length is
moved from seg6_do_srh() directly into the seg6_do_srh_{inline,encap}()
functions and before the skb checksum update takes place.

Fixes: 6c8702c60b88 ("ipv6: sr: add support for SRH encapsulation and injection with lwtunnels")
Reported-by: Paolo Abeni <pabeni@redhat.com>
Link: https://lore.kernel.org/all/20220705190727.69d532417be7438b15404ee1@uniroma2.it
Signed-off-by: Andrea Mayer <andrea.mayer@uniroma2.it>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv6/seg6_iptunnel.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/net/ipv6/seg6_iptunnel.c b/net/ipv6/seg6_iptunnel.c
index 6954db1fd26e..b626e0b62a54 100644
--- a/net/ipv6/seg6_iptunnel.c
+++ b/net/ipv6/seg6_iptunnel.c
@@ -171,6 +171,8 @@ int seg6_do_srh_encap(struct sk_buff *skb, struct ipv6_sr_hdr *osrh, int proto)
 	}
 #endif
 
+	hdr->payload_len = htons(skb->len - sizeof(struct ipv6hdr));
+
 	skb_postpush_rcsum(skb, hdr, tot_len);
 
 	return 0;
@@ -223,6 +225,8 @@ int seg6_do_srh_inline(struct sk_buff *skb, struct ipv6_sr_hdr *osrh)
 	}
 #endif
 
+	hdr->payload_len = htons(skb->len - sizeof(struct ipv6hdr));
+
 	skb_postpush_rcsum(skb, hdr, sizeof(struct ipv6hdr) + hdrlen);
 
 	return 0;
@@ -284,7 +288,6 @@ static int seg6_do_srh(struct sk_buff *skb)
 		break;
 	}
 
-	ipv6_hdr(skb)->payload_len = htons(skb->len - sizeof(struct ipv6hdr));
 	skb_set_transport_header(skb, sizeof(struct ipv6hdr));
 
 	return 0;
-- 
2.35.1



