Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6F5BC4BE479
	for <lists+stable@lfdr.de>; Mon, 21 Feb 2022 18:59:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348322AbiBUJRv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Feb 2022 04:17:51 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:49122 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349019AbiBUJQe (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 21 Feb 2022 04:16:34 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 700C832EF6;
        Mon, 21 Feb 2022 01:07:07 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 08D8260FB6;
        Mon, 21 Feb 2022 09:07:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E3906C340EB;
        Mon, 21 Feb 2022 09:07:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1645434426;
        bh=0x6i4OlwnfiUrwgKFWTgJ7ebyVDAj1Ju/6rNnIfShrw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xm4L3q2qWb7/lvEKXzdmyz0m5lByNDPztlOBT8vIkgPco4PdXspGjYwn7VVHLJWRk
         kGQxfF4lPntXQtRq5yQCFcDHa+DHRrkTZwvGYiuoDRd4zcg3Tb6cRHMGrgBomxYTiK
         GwGWD2dWchLRGA4r0xAhHi48Ii3sQp121BdhSvpA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Florian Westphal <fw@strlen.de>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Sasha Levin <sashal@kernel.org>,
        Vivek Thrivikraman <vivek.thrivikraman@est.tech>
Subject: [PATCH 5.10 096/121] netfilter: conntrack: dont refresh sctp entries in closed state
Date:   Mon, 21 Feb 2022 09:49:48 +0100
Message-Id: <20220221084924.432730716@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220221084921.147454846@linuxfoundation.org>
References: <20220221084921.147454846@linuxfoundation.org>
User-Agent: quilt/0.66
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

From: Florian Westphal <fw@strlen.de>

[ Upstream commit 77b337196a9d87f3d6bb9b07c0436ecafbffda1e ]

Vivek Thrivikraman reported:
 An SCTP server application which is accessed continuously by client
 application.
 When the session disconnects the client retries to establish a connection.
 After restart of SCTP server application the session is not established
 because of stale conntrack entry with connection state CLOSED as below.

 (removing this entry manually established new connection):

 sctp 9 CLOSED src=10.141.189.233 [..]  [ASSURED]

Just skip timeout update of closed entries, we don't want them to
stay around forever.

Reported-and-tested-by: Vivek Thrivikraman <vivek.thrivikraman@est.tech>
Closes: https://bugzilla.netfilter.org/show_bug.cgi?id=1579
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nf_conntrack_proto_sctp.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/net/netfilter/nf_conntrack_proto_sctp.c b/net/netfilter/nf_conntrack_proto_sctp.c
index 810cca24b3990..7626f3e1c70a7 100644
--- a/net/netfilter/nf_conntrack_proto_sctp.c
+++ b/net/netfilter/nf_conntrack_proto_sctp.c
@@ -489,6 +489,15 @@ int nf_conntrack_sctp_packet(struct nf_conn *ct,
 			pr_debug("Setting vtag %x for dir %d\n",
 				 ih->init_tag, !dir);
 			ct->proto.sctp.vtag[!dir] = ih->init_tag;
+
+			/* don't renew timeout on init retransmit so
+			 * port reuse by client or NAT middlebox cannot
+			 * keep entry alive indefinitely (incl. nat info).
+			 */
+			if (new_state == SCTP_CONNTRACK_CLOSED &&
+			    old_state == SCTP_CONNTRACK_CLOSED &&
+			    nf_ct_is_confirmed(ct))
+				ignore = true;
 		}
 
 		ct->proto.sctp.state = new_state;
-- 
2.34.1



