Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 372A36810C0
	for <lists+stable@lfdr.de>; Mon, 30 Jan 2023 15:06:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237083AbjA3OGX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 30 Jan 2023 09:06:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48838 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237081AbjA3OGW (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 30 Jan 2023 09:06:22 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E45FC1F5E6
        for <stable@vger.kernel.org>; Mon, 30 Jan 2023 06:06:20 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 80381B81147
        for <stable@vger.kernel.org>; Mon, 30 Jan 2023 14:06:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D4152C433EF;
        Mon, 30 Jan 2023 14:06:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1675087578;
        bh=v84peDmP8zZ7T0DmHVDZf8FLD5XUNOd62oI7QusZVw8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=X/hJOV4m7F506eI0Dst+gmAS8aA6SNV6ASS0XkosJLDfvDzpvoWFtie1CZvMcwCfi
         IOwVezlhsHJRDkOcaf4jo8gGu4Eznyd7I2UGdV67bgrgaRwLkgB386znZ5et8KeWqD
         H+g5iZV/uj44OcTQd+TxnXJNQfFhu62VQ5JqLNfY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 254/313] netlink: prevent potential spectre v1 gadgets
Date:   Mon, 30 Jan 2023 14:51:29 +0100
Message-Id: <20230130134348.548152904@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230130134336.532886729@linuxfoundation.org>
References: <20230130134336.532886729@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit f0950402e8c76e7dcb08563f1b4e8000fbc62455 ]

Most netlink attributes are parsed and validated from
__nla_validate_parse() or validate_nla()

    u16 type = nla_type(nla);

    if (type == 0 || type > maxtype) {
        /* error or continue */
    }

@type is then used as an array index and can be used
as a Spectre v1 gadget.

array_index_nospec() can be used to prevent leaking
content of kernel memory to malicious users.

This should take care of vast majority of netlink uses,
but an audit is needed to take care of others where
validation is not yet centralized in core netlink functions.

Fixes: bfa83a9e03cf ("[NETLINK]: Type-safe netlink messages/attributes interface")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Link: https://lore.kernel.org/r/20230119110150.2678537-1-edumazet@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 lib/nlattr.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/lib/nlattr.c b/lib/nlattr.c
index b67a53e29b8f..dffd60e4065f 100644
--- a/lib/nlattr.c
+++ b/lib/nlattr.c
@@ -10,6 +10,7 @@
 #include <linux/kernel.h>
 #include <linux/errno.h>
 #include <linux/jiffies.h>
+#include <linux/nospec.h>
 #include <linux/skbuff.h>
 #include <linux/string.h>
 #include <linux/types.h>
@@ -381,6 +382,7 @@ static int validate_nla(const struct nlattr *nla, int maxtype,
 	if (type <= 0 || type > maxtype)
 		return 0;
 
+	type = array_index_nospec(type, maxtype + 1);
 	pt = &policy[type];
 
 	BUG_ON(pt->type > NLA_TYPE_MAX);
@@ -596,6 +598,7 @@ static int __nla_validate_parse(const struct nlattr *head, int len, int maxtype,
 			}
 			continue;
 		}
+		type = array_index_nospec(type, maxtype + 1);
 		if (policy) {
 			int err = validate_nla(nla, maxtype, policy,
 					       validate, extack, depth);
-- 
2.39.0



