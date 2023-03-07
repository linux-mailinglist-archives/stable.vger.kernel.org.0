Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 32D676AE841
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 18:14:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229870AbjCGROb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 12:14:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55828 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230190AbjCGROG (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 12:14:06 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C7D7F3B678
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 09:08:56 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 64C9261506
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 17:08:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6943AC433EF;
        Tue,  7 Mar 2023 17:08:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678208935;
        bh=Mjdf752hvvrpcsvLewRZ6J4YOE+VYzE7LGfUN4ZhSgo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WuKEO+CxiXHn6eVtskTvRVP+GGTogkemcoA1F1iXDXrqh3QUY7y5YS/N4+kt0wANI
         CBiXwCmdenABZk0wzX8vAlHmhItYzI7ku6CXdB9hZS04zwS+F3j8z3VXlyGR96DveR
         mBTRWToVoL1GV89jqazbdEEpQkSmMKndFt8pBWTY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Yang Yingliang <yangyingliang@huawei.com>,
        David Teigland <teigland@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 0027/1001] fs: dlm: fix return value check in dlm_memory_init()
Date:   Tue,  7 Mar 2023 17:46:39 +0100
Message-Id: <20230307170023.321852273@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170022.094103862@linuxfoundation.org>
References: <20230307170022.094103862@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yang Yingliang <yangyingliang@huawei.com>

[ Upstream commit 8113aa91360a013ebe00763bb0823b5a41b11c4d ]

It should check 'cb_cache', after calling kmem_cache_create("dlm_cb").

Fixes: 61bed0baa4db ("fs: dlm: use a non-static queue for callbacks")
Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
Signed-off-by: David Teigland <teigland@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/dlm/memory.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/dlm/memory.c b/fs/dlm/memory.c
index eb7a08641fcf5..cdbaa452fc05a 100644
--- a/fs/dlm/memory.c
+++ b/fs/dlm/memory.c
@@ -51,7 +51,7 @@ int __init dlm_memory_init(void)
 	cb_cache = kmem_cache_create("dlm_cb", sizeof(struct dlm_callback),
 				     __alignof__(struct dlm_callback), 0,
 				     NULL);
-	if (!rsb_cache)
+	if (!cb_cache)
 		goto cb;
 
 	return 0;
-- 
2.39.2



