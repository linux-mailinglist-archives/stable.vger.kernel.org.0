Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7CDC95E9FD1
	for <lists+stable@lfdr.de>; Mon, 26 Sep 2022 12:30:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235473AbiIZK3j (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Sep 2022 06:29:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52468 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235620AbiIZK2k (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 26 Sep 2022 06:28:40 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 465864E600;
        Mon, 26 Sep 2022 03:18:53 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 97148B8092F;
        Mon, 26 Sep 2022 10:18:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E8912C433B5;
        Mon, 26 Sep 2022 10:18:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1664187531;
        bh=3CAaS5EwBCW3W9RTHzr/UqlF5QrWtFo6WelZq7ipWko=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cKYnIOS1K6wg3TReNm9GFP1ILzy0o340Txtfk2welSKi8Vv7wYYIEZwsWH/Wwy33K
         Y1dAhKY3txYtQ8Q2Joi+/wbvDPdv5d+tku4f18+Lp/VBhHKrnoapPDoxe3yV3I3aMo
         QP6Zb5kE/LLNWJupww45SgnXhp1S5OVgHxPC9Tvc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, David Leadbeater <dgl@dgl.cx>,
        Florian Westphal <fw@strlen.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 37/58] netfilter: nf_conntrack_irc: Tighten matching on DCC message
Date:   Mon, 26 Sep 2022 12:11:56 +0200
Message-Id: <20220926100742.830158315@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220926100741.430882406@linuxfoundation.org>
References: <20220926100741.430882406@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: David Leadbeater <dgl@dgl.cx>

[ Upstream commit e8d5dfd1d8747b56077d02664a8838c71ced948e ]

CTCP messages should only be at the start of an IRC message, not
anywhere within it.

While the helper only decodes packes in the ORIGINAL direction, its
possible to make a client send a CTCP message back by empedding one into
a PING request.  As-is, thats enough to make the helper believe that it
saw a CTCP message.

Fixes: 869f37d8e48f ("[NETFILTER]: nf_conntrack/nf_nat: add IRC helper port")
Signed-off-by: David Leadbeater <dgl@dgl.cx>
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nf_conntrack_irc.c | 34 ++++++++++++++++++++++++++------
 1 file changed, 28 insertions(+), 6 deletions(-)

diff --git a/net/netfilter/nf_conntrack_irc.c b/net/netfilter/nf_conntrack_irc.c
index b7436935b57d..23ead02c6aa5 100644
--- a/net/netfilter/nf_conntrack_irc.c
+++ b/net/netfilter/nf_conntrack_irc.c
@@ -150,15 +150,37 @@ static int help(struct sk_buff *skb, unsigned int protoff,
 	data = ib_ptr;
 	data_limit = ib_ptr + skb->len - dataoff;
 
-	/* strlen("\1DCC SENT t AAAAAAAA P\1\n")=24
-	 * 5+MINMATCHLEN+strlen("t AAAAAAAA P\1\n")=14 */
-	while (data < data_limit - (19 + MINMATCHLEN)) {
-		if (memcmp(data, "\1DCC ", 5)) {
+	/* Skip any whitespace */
+	while (data < data_limit - 10) {
+		if (*data == ' ' || *data == '\r' || *data == '\n')
+			data++;
+		else
+			break;
+	}
+
+	/* strlen("PRIVMSG x ")=10 */
+	if (data < data_limit - 10) {
+		if (strncasecmp("PRIVMSG ", data, 8))
+			goto out;
+		data += 8;
+	}
+
+	/* strlen(" :\1DCC SENT t AAAAAAAA P\1\n")=26
+	 * 7+MINMATCHLEN+strlen("t AAAAAAAA P\1\n")=26
+	 */
+	while (data < data_limit - (21 + MINMATCHLEN)) {
+		/* Find first " :", the start of message */
+		if (memcmp(data, " :", 2)) {
 			data++;
 			continue;
 		}
+		data += 2;
+
+		/* then check that place only for the DCC command */
+		if (memcmp(data, "\1DCC ", 5))
+			goto out;
 		data += 5;
-		/* we have at least (19+MINMATCHLEN)-5 bytes valid data left */
+		/* we have at least (21+MINMATCHLEN)-(2+5) bytes valid data left */
 
 		iph = ip_hdr(skb);
 		pr_debug("DCC found in master %pI4:%u %pI4:%u\n",
@@ -174,7 +196,7 @@ static int help(struct sk_buff *skb, unsigned int protoff,
 			pr_debug("DCC %s detected\n", dccprotos[i]);
 
 			/* we have at least
-			 * (19+MINMATCHLEN)-5-dccprotos[i].matchlen bytes valid
+			 * (21+MINMATCHLEN)-7-dccprotos[i].matchlen bytes valid
 			 * data left (== 14/13 bytes) */
 			if (parse_dcc(data, data_limit, &dcc_ip,
 				       &dcc_port, &addr_beg_p, &addr_end_p)) {
-- 
2.35.1



