Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7748159E39E
	for <lists+stable@lfdr.de>; Tue, 23 Aug 2022 14:44:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241796AbiHWMZT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Aug 2022 08:25:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39882 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241452AbiHWMXp (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Aug 2022 08:23:45 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F2DC699B63;
        Tue, 23 Aug 2022 02:43:50 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 9C5F5CE1B67;
        Tue, 23 Aug 2022 09:43:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AFF94C433C1;
        Tue, 23 Aug 2022 09:43:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661247799;
        bh=3SgRBEcKdUq1jSyw/M+5HbWwcg4l3qiIjgF+3iRVqLQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Z/fC7Z5KjD8EIax71z8IkV9BVdLh2vnuFO0Bi/+NfdN5rDBVs3bRWHJs31IafyJU/
         Dv0UU5uUeOQZ8oSFe/n1FqCPtn8pUp7UgeViGfhbnFB18B4QKzK/7mx2BFlCa5b1O3
         TLc3Ysib8pEZJGxHKAsecneeaYaJdMGn5di3JfKY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        Paul Moore <paul@paul-moore.com>,
        Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 5.10 151/158] netfilter: nftables: fix a warning message in nf_tables_commit_audit_collect()
Date:   Tue, 23 Aug 2022 10:28:03 +0200
Message-Id: <20220823080051.904861510@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220823080046.056825146@linuxfoundation.org>
References: <20220823080046.056825146@linuxfoundation.org>
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

From: Dan Carpenter <dan.carpenter@oracle.com>

commit dadf33c9f6b5f694e842d224a4d071f59ac665ee upstream.

The first argument of a WARN_ONCE() is a condition.  This WARN_ONCE()
will only print the table name, and is potentially problematic if the
table name has a %s in it.

Fixes: c520292f29b8 ("audit: log nftables configuration change events once per table")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Reviewed-by: Paul Moore <paul@paul-moore.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/netfilter/nf_tables_api.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -7828,7 +7828,7 @@ static void nf_tables_commit_audit_colle
 		if (adp->table == table)
 			goto found;
 	}
-	WARN_ONCE("table=%s not expected in commit list", table->name);
+	WARN_ONCE(1, "table=%s not expected in commit list", table->name);
 	return;
 found:
 	adp->entries++;


