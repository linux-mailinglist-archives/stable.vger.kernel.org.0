Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A4382657E87
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 16:54:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234147AbiL1Pyj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 10:54:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42170 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233669AbiL1Pyi (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 10:54:38 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A6E417402
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 07:54:37 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9A5846155B
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 15:54:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA154C433F0;
        Wed, 28 Dec 2022 15:54:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672242876;
        bh=aF97xiE5iL92iQ0pCzCkNrT+n8iD18aRRKryiT7Om4E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LsDqaP5gclDPuD4YQSxdQ4UrILOSH9pyUdVatuR26onDEO/VQ5+8zqb906WMqX/wY
         USxf4VQTNIqBdysB/Xx/vGcOTCnXwJxeCRCj4cdCDFiesWyt6A2GcYlaEJA3MGnSWZ
         BYo3+BG0l8nbVyffLdxqWjCdb2j4b7NzWS4/HsHs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Trond Myklebust <trond.myklebust@hammerspace.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0426/1146] NFSv4: Fix a credential leak in _nfs4_discover_trunking()
Date:   Wed, 28 Dec 2022 15:32:45 +0100
Message-Id: <20221228144341.753160095@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144330.180012208@linuxfoundation.org>
References: <20221228144330.180012208@linuxfoundation.org>
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
index 98a867092039..bd89c7f06952 100644
--- a/fs/nfs/nfs4proc.c
+++ b/fs/nfs/nfs4proc.c
@@ -4018,7 +4018,7 @@ static int _nfs4_discover_trunking(struct nfs_server *server,
 
 	page = alloc_page(GFP_KERNEL);
 	if (!page)
-		return -ENOMEM;
+		goto out_put_cred;
 	locations = kmalloc(sizeof(struct nfs4_fs_locations), GFP_KERNEL);
 	if (!locations)
 		goto out_free;
@@ -4040,6 +4040,8 @@ static int _nfs4_discover_trunking(struct nfs_server *server,
 	kfree(locations);
 out_free:
 	__free_page(page);
+out_put_cred:
+	put_cred(cred);
 	return status;
 }
 
-- 
2.35.1



