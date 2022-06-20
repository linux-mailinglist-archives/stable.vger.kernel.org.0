Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7DC7D551E5B
	for <lists+stable@lfdr.de>; Mon, 20 Jun 2022 16:27:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242260AbiFTOBu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Jun 2022 10:01:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45322 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352414AbiFTN41 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Jun 2022 09:56:27 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A40E23630D;
        Mon, 20 Jun 2022 06:22:25 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id EC043B811CE;
        Mon, 20 Jun 2022 13:07:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 50534C36AF2;
        Mon, 20 Jun 2022 13:07:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655730424;
        bh=NDNu/SpoG9dwbs1BYRNDlaOd1ny40enNsWHWjHOmNkc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=f9XxyEk6ncTqa7ku05fKaIdiJNvVwQiTJGOup2x1hoe6KltMaR8ptJRP+a3nEhXoW
         U5VaTQOF9W14aWNv6GxYZge8ZOwV377BfeeIvh8Z6Ve7Lw6DW2S+wE6DY3Ra941u/g
         h1Vz7W0P9zOlBhKNSkHtmT/LuPa3tnniNpRxcAZM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Scott Mayhew <smayhew@redhat.com>,
        Anna Schumaker <Anna.Schumaker@Netapp.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 049/106] sunrpc: set cl_max_connect when cloning an rpc_clnt
Date:   Mon, 20 Jun 2022 14:51:08 +0200
Message-Id: <20220620124725.839476193@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220620124724.380838401@linuxfoundation.org>
References: <20220620124724.380838401@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Scott Mayhew <smayhew@redhat.com>

[ Upstream commit 304791255a2dc1c9be7e7c8a6cbdb31b6847b0e5 ]

If the initial attempt at trunking detection using the krb5i auth flavor
fails with -EACCES, -NFS4ERR_CLID_INUSE, or -NFS4ERR_WRONGSEC, then the
NFS client tries again using auth_sys, cloning the rpc_clnt in the
process.  If this second attempt at trunking detection succeeds, then
the resulting nfs_client->cl_rpcclient winds up having cl_max_connect=0
and subsequent attempts to add additional transport connections to the
rpc_clnt will fail with a message similar to the following being logged:

[502044.312640] SUNRPC: reached max allowed number (0) did not add
transport to server: 192.168.122.3

Signed-off-by: Scott Mayhew <smayhew@redhat.com>
Fixes: dc48e0abee24 ("SUNRPC enforce creation of no more than max_connect xprts")
Signed-off-by: Anna Schumaker <Anna.Schumaker@Netapp.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sunrpc/clnt.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/sunrpc/clnt.c b/net/sunrpc/clnt.c
index 0a0818e55879..6a035e9339d2 100644
--- a/net/sunrpc/clnt.c
+++ b/net/sunrpc/clnt.c
@@ -651,6 +651,7 @@ static struct rpc_clnt *__rpc_clone_client(struct rpc_create_args *args,
 	new->cl_discrtry = clnt->cl_discrtry;
 	new->cl_chatty = clnt->cl_chatty;
 	new->cl_principal = clnt->cl_principal;
+	new->cl_max_connect = clnt->cl_max_connect;
 	return new;
 
 out_err:
-- 
2.35.1



