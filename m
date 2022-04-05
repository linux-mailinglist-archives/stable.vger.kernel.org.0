Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2538C4F430C
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 23:54:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1382442AbiDEMPM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 08:15:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34780 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242985AbiDEKfX (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 06:35:23 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F42B522D3;
        Tue,  5 Apr 2022 03:21:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1C70761676;
        Tue,  5 Apr 2022 10:21:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 29665C385A0;
        Tue,  5 Apr 2022 10:21:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649154079;
        bh=nCcQDCqkA9cH4A6fJiPyNXrg6fpHBNG8Ok6IbQz4LvM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wDfGtZObKUw//voa6FjqZ2UCeVMgii+ZPd7d763L7rSSAuQl3zHS4su7d3KE6BDNR
         nKiS5qH4KAnxeV630Sc5p+o3n8phfMLbdNw3SNjfNWB9xHiC0jGEWz/fXkod36AlVX
         RFwCv7KqF0tDLtnvGJQKVsW7RrpYxNVPEkakN7tQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Alexey Khoroshilov <khoroshilov@ispras.ru>,
        Trond Myklebust <trond.myklebust@hammerspace.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 413/599] NFS: remove unneeded check in decode_devicenotify_args()
Date:   Tue,  5 Apr 2022 09:31:47 +0200
Message-Id: <20220405070311.122819483@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070258.802373272@linuxfoundation.org>
References: <20220405070258.802373272@linuxfoundation.org>
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

From: Alexey Khoroshilov <khoroshilov@ispras.ru>

[ Upstream commit cb8fac6d2727f79f211e745b16c9abbf4d8be652 ]

[You don't often get email from khoroshilov@ispras.ru. Learn why this is important at http://aka.ms/LearnAboutSenderIdentification.]

Overflow check in not needed anymore after we switch to kmalloc_array().

Signed-off-by: Alexey Khoroshilov <khoroshilov@ispras.ru>
Fixes: a4f743a6bb20 ("NFSv4.1: Convert open-coded array allocation calls to kmalloc_array()")
Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfs/callback_xdr.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/fs/nfs/callback_xdr.c b/fs/nfs/callback_xdr.c
index 1725079a0527..ca8a4aa351dc 100644
--- a/fs/nfs/callback_xdr.c
+++ b/fs/nfs/callback_xdr.c
@@ -272,10 +272,6 @@ __be32 decode_devicenotify_args(struct svc_rqst *rqstp,
 	n = ntohl(*p++);
 	if (n == 0)
 		goto out;
-	if (n > ULONG_MAX / sizeof(*args->devs)) {
-		status = htonl(NFS4ERR_BADXDR);
-		goto out;
-	}
 
 	args->devs = kmalloc_array(n, sizeof(*args->devs), GFP_KERNEL);
 	if (!args->devs) {
-- 
2.34.1



