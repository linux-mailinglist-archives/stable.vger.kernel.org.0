Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3C9AC4C7327
	for <lists+stable@lfdr.de>; Mon, 28 Feb 2022 18:33:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236630AbiB1Rcn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Feb 2022 12:32:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45404 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237739AbiB1RcM (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 28 Feb 2022 12:32:12 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F37689CFF;
        Mon, 28 Feb 2022 09:29:08 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B82F6B815AB;
        Mon, 28 Feb 2022 17:29:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1AFBFC340E7;
        Mon, 28 Feb 2022 17:29:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1646069345;
        bh=gVFD3kpnaFfz5ca/wuIyX6gbfMiPN9ph5/aOY2bpIQY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=chDBqbYSE7mJ75wDlj+iKp7dXQndWKFk7HNMSMVClOiSvELInxw9FD187P+wJNoTu
         sf0wk6RU4ArKYe7jxvF+HaO2rNVIsgt5uIL5ZBaw3hEyWjELocvNrvj1FogFoNfj1n
         uzpSHpF44eFL5SYReivTcEVzk2/LWb63puu8vEtU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.19 09/34] tipc: Fix end of loop tests for list_for_each_entry()
Date:   Mon, 28 Feb 2022 18:24:15 +0100
Message-Id: <20220228172209.239877746@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220228172207.090703467@linuxfoundation.org>
References: <20220228172207.090703467@linuxfoundation.org>
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

From: Dan Carpenter <dan.carpenter@oracle.com>

commit a1f8fec4dac8bc7b172b2bdbd881e015261a6322 upstream.

These tests are supposed to check if the loop exited via a break or not.
However the tests are wrong because if we did not exit via a break then
"p" is not a valid pointer.  In that case, it's the equivalent of
"if (*(u32 *)sr == *last_key) {".  That's going to work most of the time,
but there is a potential for those to be equal.

Fixes: 1593123a6a49 ("tipc: add name table dump to new netlink api")
Fixes: 1a1a143daf84 ("tipc: add publication dump to new netlink api")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/tipc/name_table.c |    2 +-
 net/tipc/socket.c     |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

--- a/net/tipc/name_table.c
+++ b/net/tipc/name_table.c
@@ -812,7 +812,7 @@ static int __tipc_nl_add_nametable_publ(
 		list_for_each_entry(p, &sr->all_publ, all_publ)
 			if (p->key == *last_key)
 				break;
-		if (p->key != *last_key)
+		if (list_entry_is_head(p, &sr->all_publ, all_publ))
 			return -EPIPE;
 	} else {
 		p = list_first_entry(&sr->all_publ,
--- a/net/tipc/socket.c
+++ b/net/tipc/socket.c
@@ -3487,7 +3487,7 @@ static int __tipc_nl_list_sk_publ(struct
 			if (p->key == *last_publ)
 				break;
 		}
-		if (p->key != *last_publ) {
+		if (list_entry_is_head(p, &tsk->publications, binding_sock)) {
 			/* We never set seq or call nl_dump_check_consistent()
 			 * this means that setting prev_seq here will cause the
 			 * consistence check to fail in the netlink callback


