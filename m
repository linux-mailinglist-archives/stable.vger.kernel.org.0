Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E5C836A3835
	for <lists+stable@lfdr.de>; Mon, 27 Feb 2023 03:16:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231204AbjB0CQ0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 26 Feb 2023 21:16:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41998 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231366AbjB0CO4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 26 Feb 2023 21:14:56 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8ACE71DBBB;
        Sun, 26 Feb 2023 18:12:21 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E39E860DCA;
        Mon, 27 Feb 2023 02:10:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B9F33C4339E;
        Mon, 27 Feb 2023 02:10:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1677463834;
        bh=w7nW1mn3Q4teusHdP0rzbD8SYR307ctOuhTJgpe/Rho=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZSdhtPqaDvUI7WOqLTyT+7hswuw0UOqRM6fDYRJi7cf/qskGKem7qtxnomTDN4FBC
         9e5/65qtthUyUzgKsTRlJpnHh9VzroB7AU6Nvqsy28Vzgm7e2mkOVA7o/vNVF/869k
         x6gf3rQCuR9SLnIGT8AERWO2lzMbaI8Ey8t6EhSUQGIAGBNZSjNtTifqtVr3GS1vdZ
         +pscOG2nfHk3PaNPvPBSrZoAHO4jHIUPmCNx8Q31Xww7hV38p367ujVXypaHVf6Gil
         utpiyhnynI+SKfOv4ZTovZ0kj6TKr1AVSd6OH67zDb1wZlCb6ooBPKAqZYp1GazYVq
         n7z3+53YuPwSg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jeff Layton <jlayton@kernel.org>,
        Chuck Lever <chuck.lever@oracle.com>,
        Sasha Levin <sashal@kernel.org>, linux-nfs@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 19/19] nfsd: zero out pointers after putting nfsd_files on COPY setup error
Date:   Sun, 26 Feb 2023 21:09:54 -0500
Message-Id: <20230227020957.1052252-19-sashal@kernel.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230227020957.1052252-1-sashal@kernel.org>
References: <20230227020957.1052252-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jeff Layton <jlayton@kernel.org>

[ Upstream commit 1f0001d43d0c0ac2a19a34a914f6595ad97cbc1d ]

At first, I thought this might be a source of nfsd_file overputs, but
the current callers seem to avoid an extra put when nfsd4_verify_copy
returns an error.

Still, it's "bad form" to leave the pointers filled out when we don't
have a reference to them anymore, and that might lead to bugs later.
Zero them out as a defensive coding measure.

Signed-off-by: Jeff Layton <jlayton@kernel.org>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfsd/nfs4proc.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/nfsd/nfs4proc.c b/fs/nfsd/nfs4proc.c
index 735ee8a798705..f82cfe843b99b 100644
--- a/fs/nfsd/nfs4proc.c
+++ b/fs/nfsd/nfs4proc.c
@@ -1075,8 +1075,10 @@ nfsd4_verify_copy(struct svc_rqst *rqstp, struct nfsd4_compound_state *cstate,
 	return status;
 out_put_dst:
 	nfsd_file_put(*dst);
+	*dst = NULL;
 out_put_src:
 	nfsd_file_put(*src);
+	*src = NULL;
 	goto out;
 }
 
-- 
2.39.0

