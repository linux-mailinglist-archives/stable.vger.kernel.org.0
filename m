Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F285B4C73D1
	for <lists+stable@lfdr.de>; Mon, 28 Feb 2022 18:39:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238418AbiB1Riw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Feb 2022 12:38:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33676 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233239AbiB1RiY (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 28 Feb 2022 12:38:24 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 805A285669;
        Mon, 28 Feb 2022 09:33:47 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 63C62B815B4;
        Mon, 28 Feb 2022 17:33:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B7BB2C340E7;
        Mon, 28 Feb 2022 17:33:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1646069625;
        bh=9UeXGo99m0LxgDlUp16RQJ3NOi3KlH6cTMp6KlLsTGw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=L1fGNzSeSMaoTRaNByosBmWCM39Y98GxrKl0NSnDHqlQDnCCFhHhf0d2SHjOLlBGN
         XWsTNv++qSFSFI53fNJm26lMZHmjapH6zrUzqH3W2aZYqudxhMk7jSJL33WP3Hy56f
         vmOYVQVzACGWPUFqhRHPX2pzkyx8dIN5VCScJAZQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Paul Blakey <paulb@nvidia.com>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.10 34/80] net/sched: act_ct: Fix flow table lookup after ct clear or switching zones
Date:   Mon, 28 Feb 2022 18:24:15 +0100
Message-Id: <20220228172315.596722738@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220228172311.789892158@linuxfoundation.org>
References: <20220228172311.789892158@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Paul Blakey <paulb@nvidia.com>

commit 2f131de361f6d0eaff17db26efdb844c178432f8 upstream.

Flow table lookup is skipped if packet either went through ct clear
action (which set the IP_CT_UNTRACKED flag on the packet), or while
switching zones and there is already a connection associated with
the packet. This will result in no SW offload of the connection,
and the and connection not being removed from flow table with
TCP teardown (fin/rst packet).

To fix the above, remove these unneccary checks in flow
table lookup.

Fixes: 46475bb20f4b ("net/sched: act_ct: Software offload of established flows")
Signed-off-by: Paul Blakey <paulb@nvidia.com>
Acked-by: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/sched/act_ct.c |    5 -----
 1 file changed, 5 deletions(-)

--- a/net/sched/act_ct.c
+++ b/net/sched/act_ct.c
@@ -514,11 +514,6 @@ static bool tcf_ct_flow_table_lookup(str
 	struct nf_conn *ct;
 	u8 dir;
 
-	/* Previously seen or loopback */
-	ct = nf_ct_get(skb, &ctinfo);
-	if ((ct && !nf_ct_is_template(ct)) || ctinfo == IP_CT_UNTRACKED)
-		return false;
-
 	switch (family) {
 	case NFPROTO_IPV4:
 		if (!tcf_ct_flow_table_fill_tuple_ipv4(skb, &tuple, &tcph))


