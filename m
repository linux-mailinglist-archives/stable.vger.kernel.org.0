Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 508EC6AEF80
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 19:24:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232453AbjCGSX6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 13:23:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46322 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232738AbjCGSXk (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 13:23:40 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C5AF798861
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 10:18:56 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8EB58B8184E
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 18:18:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD1C7C433D2;
        Tue,  7 Mar 2023 18:18:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678213134;
        bh=o9GCGmwgky6r46sSOipycLCBaLT4QRcMERkXOGxX7KU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iXCfLSQO6hFxVRcZrr9U+GWjV98JaKaT4tM655WtVBCUi18qQ0Ltud0pLPPJeFVUE
         5q+DpmeNtCgGGd7LOWyyHbV2xSrcBYWjxqonP9YaI1/tC9S/MbkhVcdaAePW0GKNFY
         4s81bhjn7XIBQLnKuQ3qBcB7j7kJTKdAFQif9ghE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Jeff Layton <jlayton@kernel.org>,
        Chuck Lever <chuck.lever@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 380/885] NFSD: copy the whole verifier in nfsd_copy_write_verifier
Date:   Tue,  7 Mar 2023 17:55:14 +0100
Message-Id: <20230307170018.842024129@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170001.594919529@linuxfoundation.org>
References: <20230307170001.594919529@linuxfoundation.org>
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
index 8b1afde192118..6b20f285f3ca6 100644
--- a/fs/nfsd/nfssvc.c
+++ b/fs/nfsd/nfssvc.c
@@ -357,7 +357,7 @@ void nfsd_copy_write_verifier(__be32 verf[2], struct nfsd_net *nn)
 
 	do {
 		read_seqbegin_or_lock(&nn->writeverf_lock, &seq);
-		memcpy(verf, nn->writeverf, sizeof(*verf));
+		memcpy(verf, nn->writeverf, sizeof(nn->writeverf));
 	} while (need_seqretry(&nn->writeverf_lock, seq));
 	done_seqretry(&nn->writeverf_lock, seq);
 }
-- 
2.39.2



