Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F03056A3832
	for <lists+stable@lfdr.de>; Mon, 27 Feb 2023 03:16:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231191AbjB0CQZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 26 Feb 2023 21:16:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51326 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231551AbjB0CP2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 26 Feb 2023 21:15:28 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E3581C7E9;
        Sun, 26 Feb 2023 18:12:46 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5AA9260DD8;
        Mon, 27 Feb 2023 02:11:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3CF99C433A0;
        Mon, 27 Feb 2023 02:11:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1677463866;
        bh=6gIHOypxKZibup03V51EiHHet3X76JcP4ygTV831JD4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pl6lT0iShlc/I8LnLEFGMnKK3B+Xn3trhK4ERq7pDN9SpEW9XOPWLGTIjOljHKrqn
         YS+hSSFA0IcVgRJ2ApKrL7lHvVbbaUxeKw7D5gHVnpuNWN2OX6jWMNT5mWP8tHdZlb
         PnA5qB/d0sJyX/2YmkjVO8iqZ196g77X+Gtkk9Kyr3yyMqIYP59CmYVcj/r91YTgdY
         EBpHI7itDGTu7W88syJYcKeHUUQ0Yu8s2+U5D74NNgOmhNSUfvoavokn290PyxRvaZ
         +U6VafqT8ctpQ1dyvHrjIErNdAEKSTQ2vdsUWPxm0xZy98SydAT/sB7XiOwKILz0uO
         6CTSIutWotT+g==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jeff Layton <jlayton@kernel.org>,
        Chuck Lever <chuck.lever@oracle.com>,
        Sasha Levin <sashal@kernel.org>, linux-nfs@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 15/15] nfsd: zero out pointers after putting nfsd_files on COPY setup error
Date:   Sun, 26 Feb 2023 21:10:34 -0500
Message-Id: <20230227021038.1052958-15-sashal@kernel.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230227021038.1052958-1-sashal@kernel.org>
References: <20230227021038.1052958-1-sashal@kernel.org>
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
index 452ed633a2c76..bd7846758947b 100644
--- a/fs/nfsd/nfs4proc.c
+++ b/fs/nfsd/nfs4proc.c
@@ -1059,8 +1059,10 @@ nfsd4_verify_copy(struct svc_rqst *rqstp, struct nfsd4_compound_state *cstate,
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

