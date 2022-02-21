Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 11ED64BDE63
	for <lists+stable@lfdr.de>; Mon, 21 Feb 2022 18:47:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242830AbiBUJtt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Feb 2022 04:49:49 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:43540 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352983AbiBUJsF (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 21 Feb 2022 04:48:05 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EFE0210AF;
        Mon, 21 Feb 2022 01:22:12 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8DCE4608C4;
        Mon, 21 Feb 2022 09:22:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6EF59C340E9;
        Mon, 21 Feb 2022 09:22:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1645435332;
        bh=2EEr04gVgGbLsytWBTlmHhQnd4tyf8xiRRSDPKxgK2U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fnQ3I+aLn65PCCJEEnHoRCqHfuaVN5yES7yOFfc5vMDP/cq2lwb/tmEm4ezpLSxFh
         CbrNX5y4U6f4N3y52PaqCRgOZSRWlXWmqG9JcRQuAE0IZnVg6mBgSLfQinm+Y7eLcA
         9uWEft/T4WDMJaKn3lahFk1Brnd95OxVRGRg2mqo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jon Maloy <jmaloy@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.16 127/227] tipc: fix wrong publisher node address in link publications
Date:   Mon, 21 Feb 2022 09:49:06 +0100
Message-Id: <20220221084939.075238258@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220221084934.836145070@linuxfoundation.org>
References: <20220221084934.836145070@linuxfoundation.org>
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

From: Jon Maloy <jmaloy@redhat.com>

commit 032062f363b4bf02b1d547f329aa5d97b6a17410 upstream.

When a link comes up we add its presence to the name table to make it
possible for users to subscribe for link up/down events. However, after
a previous call signature change the binding is wrongly published with
the peer node as publishing node, instead of the own node as it should
be. This has the effect that the command 'tipc name table show' will
list the link binding (service type 2) with node scope and a peer node
as originator, something that obviously is impossible.

We correct this bug here.

Fixes: 50a3499ab853 ("tipc: simplify signature of tipc_namtbl_publish()")
Signed-off-by: Jon Maloy <jmaloy@redhat.com>
Link: https://lore.kernel.org/r/20220214013852.2803940-1-jmaloy@redhat.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/tipc/node.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/tipc/node.c
+++ b/net/tipc/node.c
@@ -413,7 +413,7 @@ static void tipc_node_write_unlock(struc
 	tipc_uaddr(&ua, TIPC_SERVICE_RANGE, TIPC_NODE_SCOPE,
 		   TIPC_LINK_STATE, n->addr, n->addr);
 	sk.ref = n->link_id;
-	sk.node = n->addr;
+	sk.node = tipc_own_addr(net);
 	bearer_id = n->link_id & 0xffff;
 	publ_list = &n->publ_list;
 


