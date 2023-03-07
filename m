Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B1FE06AEAA9
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 18:36:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231820AbjCGRf7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 12:35:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42554 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231633AbjCGRf1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 12:35:27 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 75BB69E50B
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 09:31:35 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1178C61517
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 17:31:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 086C1C433D2;
        Tue,  7 Mar 2023 17:31:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678210294;
        bh=t+sx0BVTR0Go1P6U7jNoGbVyXib9607yhBQNUQ0/FmY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BkCo4VigxQTwkqx2jTyvuJcux144OZibc6StvrYXHSahtmUEvKNZWzk3H+VhrRgss
         IEZrtKFbHI03kYakre2OMdTnVH878MkhKpdadIEx2kZha1FGwZd7id/gGNQmhaqFJ/
         mSTUya1+D9MM9YU99vtenq+am/DtX4LWyD3y3eb8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Jeff Layton <jlayton@kernel.org>,
        Chuck Lever <chuck.lever@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 0456/1001] NFSD: copy the whole verifier in nfsd_copy_write_verifier
Date:   Tue,  7 Mar 2023 17:53:48 +0100
Message-Id: <20230307170041.152004336@linuxfoundation.org>
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

From: Chuck Lever <chuck.lever@oracle.com>

[ Upstream commit 90d2175572470ba7f55da8447c72ddd4942923c4 ]

Currently, we're only memcpy'ing the first __be32. Ensure we copy into
both words.

Fixes: 91d2e9b56cf5 ("NFSD: Clean up the nfsd_net::nfssvc_boot field")
Reported-by: Jeff Layton <jlayton@kernel.org>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfsd/nfssvc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/nfsd/nfssvc.c b/fs/nfsd/nfssvc.c
index 325d3d3f12110..a0ecec54d3d7d 100644
--- a/fs/nfsd/nfssvc.c
+++ b/fs/nfsd/nfssvc.c
@@ -363,7 +363,7 @@ void nfsd_copy_write_verifier(__be32 verf[2], struct nfsd_net *nn)
 
 	do {
 		read_seqbegin_or_lock(&nn->writeverf_lock, &seq);
-		memcpy(verf, nn->writeverf, sizeof(*verf));
+		memcpy(verf, nn->writeverf, sizeof(nn->writeverf));
 	} while (need_seqretry(&nn->writeverf_lock, seq));
 	done_seqretry(&nn->writeverf_lock, seq);
 }
-- 
2.39.2



