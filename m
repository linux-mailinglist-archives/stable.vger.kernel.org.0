Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C66E9664912
	for <lists+stable@lfdr.de>; Tue, 10 Jan 2023 19:17:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239048AbjAJSRq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Jan 2023 13:17:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58232 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235257AbjAJSQo (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 Jan 2023 13:16:44 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 91212B4B
        for <stable@vger.kernel.org>; Tue, 10 Jan 2023 10:15:11 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2BE916182C
        for <stable@vger.kernel.org>; Tue, 10 Jan 2023 18:15:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB9D3C433D2;
        Tue, 10 Jan 2023 18:15:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673374510;
        bh=zMwIWUk/gD+LATD29bYw+MZtmJp5rmq/VeGYNyeJZhA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sLoelzVF9QnuP/vqxicl9/LEbT0gXbxAsUcGi/ltqNoBTNVK6nwlODULHmM5yr6Yc
         GLR/mP4JW2dq3Zvlmv3m2xmaUNL6HfnPV8tZeHz6uir0nE4eenCQOJ2f5NRteYqYOW
         uzMfa0xAql5wOAQsCxI1zreiJkoTlmGQ9HAbiT30=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Jeff Layton <jlayton@kernel.org>,
        Chuck Lever <chuck.lever@oracle.com>,
        Sasha Levin <sashal@kernel.org>,
        Wang Yugui <wangyugui@e16-tech.com>
Subject: [PATCH 6.1 028/159] nfsd: shut down the NFSv4 state objects before the filecache
Date:   Tue, 10 Jan 2023 19:02:56 +0100
Message-Id: <20230110180019.207423642@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230110180018.288460217@linuxfoundation.org>
References: <20230110180018.288460217@linuxfoundation.org>
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

From: Jeff Layton <jlayton@kernel.org>

[ Upstream commit 789e1e10f214c00ca18fc6610824c5b9876ba5f2 ]

Currently, we shut down the filecache before trying to clean up the
stateids that depend on it. This leads to the kernel trying to free an
nfsd_file twice, and a refcount overput on the nf_mark.

Change the shutdown procedure to tear down all of the stateids prior
to shutting down the filecache.

Reported-and-tested-by: Wang Yugui <wangyugui@e16-tech.com>
Signed-off-by: Jeff Layton <jlayton@kernel.org>
Fixes: 5e113224c17e ("nfsd: nfsd_file cache entries should be per net namespace")
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfsd/nfssvc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/nfsd/nfssvc.c b/fs/nfsd/nfssvc.c
index bfbd9f672f59..8b1afde19211 100644
--- a/fs/nfsd/nfssvc.c
+++ b/fs/nfsd/nfssvc.c
@@ -447,8 +447,8 @@ static void nfsd_shutdown_net(struct net *net)
 {
 	struct nfsd_net *nn = net_generic(net, nfsd_net_id);
 
-	nfsd_file_cache_shutdown_net(net);
 	nfs4_state_shutdown_net(net);
+	nfsd_file_cache_shutdown_net(net);
 	if (nn->lockd_up) {
 		lockd_down(net);
 		nn->lockd_up = false;
-- 
2.35.1



