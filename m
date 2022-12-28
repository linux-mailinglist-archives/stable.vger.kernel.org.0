Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 36634657DDD
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 16:47:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233614AbiL1Prm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 10:47:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35072 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234087AbiL1PrX (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 10:47:23 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D7F8816594
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 07:47:22 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8A13BB8172E
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 15:47:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE129C433F0;
        Wed, 28 Dec 2022 15:47:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672242440;
        bh=6rLIY0V7F5b9HMN8VVnzlwTngztFCkHSMkiGH4bizuU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KGCI0Zu74RcrjjPrtxJx98UFeuERf7QOevDDPqC9qQHC4Fw5G3K1DsMEJYn2lfh60
         kJuaAxK3ATSvNHG4/z68uzS9B4G70h+qjOVTr6McUbpwhkdFAXIB0XlvZcPveqqtBi
         X3cETv1rir0m78IPNAoojtMjlfziCwUltTb9MWu8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Trond Myklebust <trond.myklebust@hammerspace.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 0410/1073] NFSv4: Fix a credential leak in _nfs4_discover_trunking()
Date:   Wed, 28 Dec 2022 15:33:18 +0100
Message-Id: <20221228144339.156876777@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144328.162723588@linuxfoundation.org>
References: <20221228144328.162723588@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Trond Myklebust <trond.myklebust@hammerspace.com>

[ Upstream commit e83458fce080dc23c25353a1af90bfecf79c7369 ]

Fixes: 4f40a5b55446 ("NFSv4: Add an fattr allocation to _nfs4_discover_trunking()")
Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfs/nfs4proc.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/fs/nfs/nfs4proc.c b/fs/nfs/nfs4proc.c
index 0500da4dab57..f85559bbb422 100644
--- a/fs/nfs/nfs4proc.c
+++ b/fs/nfs/nfs4proc.c
@@ -4017,7 +4017,7 @@ static int _nfs4_discover_trunking(struct nfs_server *server,
 
 	page = alloc_page(GFP_KERNEL);
 	if (!page)
-		return -ENOMEM;
+		goto out_put_cred;
 	locations = kmalloc(sizeof(struct nfs4_fs_locations), GFP_KERNEL);
 	if (!locations)
 		goto out_free;
@@ -4039,6 +4039,8 @@ static int _nfs4_discover_trunking(struct nfs_server *server,
 	kfree(locations);
 out_free:
 	__free_page(page);
+out_put_cred:
+	put_cred(cred);
 	return status;
 }
 
-- 
2.35.1



