Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9B4046A3728
	for <lists+stable@lfdr.de>; Mon, 27 Feb 2023 03:07:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230146AbjB0CHU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 26 Feb 2023 21:07:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60264 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230142AbjB0CGz (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 26 Feb 2023 21:06:55 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E12CF1ADD2;
        Sun, 26 Feb 2023 18:06:20 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5DB43B80CB6;
        Mon, 27 Feb 2023 02:04:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6FAEDC433D2;
        Mon, 27 Feb 2023 02:04:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1677463492;
        bh=dfKGWSmbnd+zux7C1Hm7ZDrx6wMPTpl01xcPSzAzH4Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WEIUhg678XmAPn2ga+fYBOj5RcmbwkMot5C9WSJ5raG1k30LSgmEsz5daNbynkW+G
         ALVYCR7yQkpZK+pAajVQqG37+L9YXh9ttCIuapNu7BDCdIY0x8PD2dEPs2P6rMXyPb
         1zcEgPGjmtKSEjkh5dKJ0yNOaRUigETG8ZAxzJ9KgndOtAMLZuhmH8tUtNS3EysWCn
         1dKTirUpr50I1AntiHhrY7+K2zGSQUANcVX+Oc8uMA+2a3ZkzQp5n80eejdgDQ4Rqk
         uZH27LORJ96okLZzOdGKKMc70varOhrn0aalMHJHciEeHfGvx6SaqhR9gBodO0wV7p
         bIP3JWCpND+lg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jeff Layton <jlayton@kernel.org>,
        Chuck Lever <chuck.lever@oracle.com>,
        Sasha Levin <sashal@kernel.org>, linux-nfs@vger.kernel.org
Subject: [PATCH AUTOSEL 6.2 57/60] nfsd: zero out pointers after putting nfsd_files on COPY setup error
Date:   Sun, 26 Feb 2023 21:00:42 -0500
Message-Id: <20230227020045.1045105-57-sashal@kernel.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230227020045.1045105-1-sashal@kernel.org>
References: <20230227020045.1045105-1-sashal@kernel.org>
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
index f189ba7995f5a..451403758ea17 100644
--- a/fs/nfsd/nfs4proc.c
+++ b/fs/nfsd/nfs4proc.c
@@ -1214,8 +1214,10 @@ nfsd4_verify_copy(struct svc_rqst *rqstp, struct nfsd4_compound_state *cstate,
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

