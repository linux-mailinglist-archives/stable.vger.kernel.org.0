Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DEF794B472C
	for <lists+stable@lfdr.de>; Mon, 14 Feb 2022 10:53:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244998AbiBNJrK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Feb 2022 04:47:10 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:43864 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245462AbiBNJp5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Feb 2022 04:45:57 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B8C96A3A4;
        Mon, 14 Feb 2022 01:39:03 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id AC23361185;
        Mon, 14 Feb 2022 09:39:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6CF49C340E9;
        Mon, 14 Feb 2022 09:39:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1644831542;
        bh=uxBtlMvpAEk7Qv6agBQmc3iJ1oSIfEUqJj1aLSZvzl4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bECGG5/qDbJKM4eyuMNEG+yQtpYN1CT9Lq0PVzxH2VKavqH2Aav85shsEXs77T/z5
         FkOi8kplrFZ2HTx5kWDQgCSjqhgy1kPhcO6jjG20T3yRHvzcaeuqeBv3Jzpp0SkpPb
         GnRLIalCFuj6SjMvlKjhdzKaJSHY31TeSaSAMVwo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Xiaoke Wang <xkernel.wang@foxmail.com>,
        Anna Schumaker <Anna.Schumaker@Netapp.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 016/116] nfs: nfs4clinet: check the return value of kstrdup()
Date:   Mon, 14 Feb 2022 10:25:15 +0100
Message-Id: <20220214092459.244200121@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220214092458.668376521@linuxfoundation.org>
References: <20220214092458.668376521@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Xiaoke Wang <xkernel.wang@foxmail.com>

[ Upstream commit fbd2057e5329d3502a27491190237b6be52a1cb6 ]

kstrdup() returns NULL when some internal memory errors happen, it is
better to check the return value of it so to catch the memory error in
time.

Signed-off-by: Xiaoke Wang <xkernel.wang@foxmail.com>
Signed-off-by: Anna Schumaker <Anna.Schumaker@Netapp.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfs/nfs4client.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/fs/nfs/nfs4client.c b/fs/nfs/nfs4client.c
index 6d74f2e2de461..0e6437b08a3a5 100644
--- a/fs/nfs/nfs4client.c
+++ b/fs/nfs/nfs4client.c
@@ -1330,8 +1330,11 @@ int nfs4_update_server(struct nfs_server *server, const char *hostname,
 	}
 	nfs_put_client(clp);
 
-	if (server->nfs_client->cl_hostname == NULL)
+	if (server->nfs_client->cl_hostname == NULL) {
 		server->nfs_client->cl_hostname = kstrdup(hostname, GFP_KERNEL);
+		if (server->nfs_client->cl_hostname == NULL)
+			return -ENOMEM;
+	}
 	nfs_server_insert_lists(server);
 
 	return nfs_probe_destination(server);
-- 
2.34.1



