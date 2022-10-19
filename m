Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DF499603DC0
	for <lists+stable@lfdr.de>; Wed, 19 Oct 2022 11:06:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232452AbiJSJGS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Oct 2022 05:06:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35874 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232786AbiJSJFH (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Oct 2022 05:05:07 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B16C9DFAF;
        Wed, 19 Oct 2022 01:59:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D234861838;
        Wed, 19 Oct 2022 08:48:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DAFA1C433D6;
        Wed, 19 Oct 2022 08:48:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666169289;
        bh=cEznBf9bvTB/4ENmafZ5o4nl4xs2vm5vB0HoS9fBxMM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lXrtZHnKwr05CjGJekuTytWwLLBIATLhTBvtn/mrJsRVhDQJuxyV96j2ygn1f/eIf
         12m7mil4796h4ZBCe3tjG+Ac3FWYmmwqZqiheMcNFVgbs7PUcM20gNUEVpBwyTIYQf
         IPfdTTJNYYI24rQMBeYASDMLtDdKiU93gCXxV2G8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        Jeff Layton <jlayton@kernel.org>,
        Chuck Lever <chuck.lever@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 221/862] nfsd: Fix a memory leak in an error handling path
Date:   Wed, 19 Oct 2022 10:25:08 +0200
Message-Id: <20221019083259.801867037@linuxfoundation.org>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20221019083249.951566199@linuxfoundation.org>
References: <20221019083249.951566199@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>

[ Upstream commit fd1ef88049de09bc70d60b549992524cfc0e66ff ]

If this memdup_user() call fails, the memory allocated in a previous call
a few lines above should be freed. Otherwise it leaks.

Fixes: 6ee95d1c8991 ("nfsd: add support for upcall version 2")
Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Reviewed-by: Jeff Layton <jlayton@kernel.org>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfsd/nfs4recover.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/fs/nfsd/nfs4recover.c b/fs/nfsd/nfs4recover.c
index c634483d85d2..8f24485e0f04 100644
--- a/fs/nfsd/nfs4recover.c
+++ b/fs/nfsd/nfs4recover.c
@@ -815,8 +815,10 @@ __cld_pipe_inprogress_downcall(const struct cld_msg_v2 __user *cmsg,
 				princhash.data = memdup_user(
 						&ci->cc_princhash.cp_data,
 						princhashlen);
-				if (IS_ERR_OR_NULL(princhash.data))
+				if (IS_ERR_OR_NULL(princhash.data)) {
+					kfree(name.data);
 					return -EFAULT;
+				}
 				princhash.len = princhashlen;
 			} else
 				princhash.len = 0;
-- 
2.35.1



