Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DF40B5EA456
	for <lists+stable@lfdr.de>; Mon, 26 Sep 2022 13:45:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238142AbiIZLph (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Sep 2022 07:45:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36744 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238401AbiIZLnW (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 26 Sep 2022 07:43:22 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF7D872873;
        Mon, 26 Sep 2022 03:46:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 683D0B802C5;
        Mon, 26 Sep 2022 10:45:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE0D0C433C1;
        Mon, 26 Sep 2022 10:45:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1664189147;
        bh=dPxiUNwktI/6LHpnNjBpRpD+Vb/t8nqMClxe9ag4g2I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wiaZNj9yUx8QgNEBCsLBCwITzEGS0Wivu3ma6V1nv3ItEsPX1LVwB/o3+7GUpELzy
         HphIs9K+ltIo5/b5lvskOA3ZC/Gq3qNaWrbfxOwmMEpnl9hNIG6yg8iINVYHIMfLPM
         zWMn1cEbF0Ghx6/sCc09ooNObRnjSNoWO95A3uvU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, David Leadbeater <dgl@dgl.cx>,
        Florian Westphal <fw@strlen.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 088/207] netfilter: nf_conntrack_irc: Tighten matching on DCC message
Date:   Mon, 26 Sep 2022 12:11:17 +0200
Message-Id: <20220926100810.523597344@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220926100806.522017616@linuxfoundation.org>
References: <20220926100806.522017616@linuxfoundation.org>
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
index 992decbcaa5c..5703846bea3b 100644
--- a/net/netfilter/nf_conntrack_irc.c
+++ b/net/netfilter/nf_conntrack_irc.c
@@ -157,15 +157,37 @@ static int help(struct sk_buff *skb, unsigned int protoff,
 	data = ib_ptr;
 	data_limit = ib_ptr + datalen;
 
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
@@ -181,7 +203,7 @@ static int help(struct sk_buff *skb, unsigned int protoff,
 			pr_debug("DCC %s detected\n", dccprotos[i]);
 
 			/* we have at least
-			 * (19+MINMATCHLEN)-5-dccprotos[i].matchlen bytes valid
+			 * (21+MINMATCHLEN)-7-dccprotos[i].matchlen bytes valid
 			 * data left (== 14/13 bytes) */
 			if (parse_dcc(data, data_limit, &dcc_ip,
 				       &dcc_port, &addr_beg_p, &addr_end_p)) {
-- 
2.35.1



