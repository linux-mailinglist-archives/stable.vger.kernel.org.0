Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 735CF6A3934
	for <lists+stable@lfdr.de>; Mon, 27 Feb 2023 04:07:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229978AbjB0DHR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 26 Feb 2023 22:07:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43432 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229478AbjB0DHQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 26 Feb 2023 22:07:16 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 01090EB72;
        Sun, 26 Feb 2023 19:07:15 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BB33A60DBC;
        Mon, 27 Feb 2023 02:08:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 93318C433D2;
        Mon, 27 Feb 2023 02:08:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1677463724;
        bh=k7DMZ1EarN2GB9bXhGwL0g6EIiULaOf7Ws4bn/6I3dw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=R74vKW0Tu4Gkt5HA72JTdH2Dngjsrl3zk7tLqhx5mTBeEqOD0z935iijlw/KlKp2B
         WLPy839OSfPQJSUbIuHwZ/mR6orssMtEG3aNlNguLeat661GlekMYMhqhl7cQUnJzg
         dsfsxv5mXzfvwR5a4DyQvwDYNl4xHcIhZD8BzeBFtQSwJhCAcJofoBynm5Wy/V0jHh
         8rXTmEfxCgeY4SkjrFxPLRz+GQpOludCR855voQc49ElXC0MhgheDNoRM5vUk2Zdip
         sMmNPydWfCx24e3WG6aOYB3J6fbtCS9hiLUunKcLQAjcTGcTi0M0U4hwgZTLTO+K6j
         xVfZrwTGzPkaQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jeff Layton <jlayton@kernel.org>,
        Chuck Lever <chuck.lever@oracle.com>,
        Sasha Levin <sashal@kernel.org>, linux-nfs@vger.kernel.org
Subject: [PATCH AUTOSEL 6.1 55/58] nfsd: zero out pointers after putting nfsd_files on COPY setup error
Date:   Sun, 26 Feb 2023 21:04:53 -0500
Message-Id: <20230227020457.1048737-55-sashal@kernel.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230227020457.1048737-1-sashal@kernel.org>
References: <20230227020457.1048737-1-sashal@kernel.org>
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
index ba04ce9b9fa51..13603cb017346 100644
--- a/fs/nfsd/nfs4proc.c
+++ b/fs/nfsd/nfs4proc.c
@@ -1227,8 +1227,10 @@ nfsd4_verify_copy(struct svc_rqst *rqstp, struct nfsd4_compound_state *cstate,
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

