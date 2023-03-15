Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ACDEA6BB0FD
	for <lists+stable@lfdr.de>; Wed, 15 Mar 2023 13:23:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232385AbjCOMXv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Mar 2023 08:23:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45442 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232259AbjCOMXZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 Mar 2023 08:23:25 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A53D7EA20
        for <stable@vger.kernel.org>; Wed, 15 Mar 2023 05:22:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8C574B81DFE
        for <stable@vger.kernel.org>; Wed, 15 Mar 2023 12:22:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E3400C433EF;
        Wed, 15 Mar 2023 12:22:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678882922;
        bh=iOsGcY0bD7kpgKsxFZBAxtwYErOt6OZcbC/NHHT5ZQ4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2UEM+29jwD7O1y8XmPMQ9Gy+gh2ybayd9YjOckvgWKcbg4aGCcc30daRvtFXX3PVh
         e8vNTlCTL6KI8es+/2R6gk1FuNcT6qg6cS4G9lfM16QLizTm+2A5EWSAsVcD7aDxVQ
         zYB3e9reElB3ATBn67yXLWw73JLxfXdZyjxSy31A=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Benjamin Coddington <bcodding@redhat.com>,
        Jeff Layton <jlayton@kernel.org>,
        Chuck Lever <chuck.lever@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 053/104] SUNRPC: Fix a server shutdown leak
Date:   Wed, 15 Mar 2023 13:12:24 +0100
Message-Id: <20230315115734.204564277@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230315115731.942692602@linuxfoundation.org>
References: <20230315115731.942692602@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Benjamin Coddington <bcodding@redhat.com>

[ Upstream commit 9ca6705d9d609441d34f8b853e1e4a6369b3b171 ]

Fix a race where kthread_stop() may prevent the threadfn from ever getting
called.  If that happens the svc_rqst will not be cleaned up.

Fixes: ed6473ddc704 ("NFSv4: Fix callback server shutdown")
Signed-off-by: Benjamin Coddington <bcodding@redhat.com>
Reviewed-by: Jeff Layton <jlayton@kernel.org>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sunrpc/svc.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/net/sunrpc/svc.c b/net/sunrpc/svc.c
index d38788cd9433a..af657a482ad2d 100644
--- a/net/sunrpc/svc.c
+++ b/net/sunrpc/svc.c
@@ -800,6 +800,7 @@ EXPORT_SYMBOL_GPL(svc_set_num_threads);
 static int
 svc_stop_kthreads(struct svc_serv *serv, struct svc_pool *pool, int nrservs)
 {
+	struct svc_rqst	*rqstp;
 	struct task_struct *task;
 	unsigned int state = serv->sv_nrthreads-1;
 
@@ -808,7 +809,10 @@ svc_stop_kthreads(struct svc_serv *serv, struct svc_pool *pool, int nrservs)
 		task = choose_victim(serv, pool, &state);
 		if (task == NULL)
 			break;
-		kthread_stop(task);
+		rqstp = kthread_data(task);
+		/* Did we lose a race to svo_function threadfn? */
+		if (kthread_stop(task) == -EINTR)
+			svc_exit_thread(rqstp);
 		nrservs++;
 	} while (nrservs < 0);
 	return 0;
-- 
2.39.2



