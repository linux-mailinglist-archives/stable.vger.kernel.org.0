Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DA80D4E86CC
	for <lists+stable@lfdr.de>; Sun, 27 Mar 2022 10:03:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233949AbiC0IEV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 27 Mar 2022 04:04:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51562 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229636AbiC0IEV (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 27 Mar 2022 04:04:21 -0400
Received: from mail-pf1-x430.google.com (mail-pf1-x430.google.com [IPv6:2607:f8b0:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A401D43AC7;
        Sun, 27 Mar 2022 01:02:39 -0700 (PDT)
Received: by mail-pf1-x430.google.com with SMTP id f3so8723085pfe.2;
        Sun, 27 Mar 2022 01:02:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id;
        bh=6WEcIiDLKxrIOj61KNbQv+CB44nK63wxSMiAxjt7pBc=;
        b=j20HQM2NdRCFaPujnXUn9LlRirzydADGi+yfn8XMf826iiWVvT8KRXsx/KsUnpTdQh
         e/oNsy+o00PBQWzDLRcPBmQ6h1X3TY3hgddH8q17c207+CiGOJZaXhBIq2QE4lreL1Vr
         FpAIpq2V2QJ1wRqsSgBeN8OHzPlJErp4W+tWe24ecsIs1/AqPtkXZ0QJR+1UGVmUkkcG
         m82t5HFIAZFkavuA6d4OZy+AKzi3JQ2qofj065KQYZzrmhM1miV0lKo3GEt+2/NDMoYZ
         OOBOaw5d0/uFHCsA/VXz/zPF61Csaaw+PnkFJakyCrgBdSDLPySujfQaD34MSDjZMsat
         igVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=6WEcIiDLKxrIOj61KNbQv+CB44nK63wxSMiAxjt7pBc=;
        b=Dc1Xo7bXMK8xAtRjbJA+USVFlfCqp+oEmMsIkNaz6UHaSxp4YTksyALG88WUSOrAWy
         SAzREpqaP4T6O13xdv+RPXfVRZ11Pi5tC7zpR39RKuMWJJ3mhUD9UDlo9d5SWWewrjWw
         Fy9CrMJtLq0C9mFOJUQWsN+xxMDpGqZNUCQ7aJMiR/sK1JFcS8HkUqtp7yB5AEVhqgS8
         RaHjl9zeF9b30t8hYW1hAIRGTD05B4yYt8I21UiVX9qw9mwx6ugqI6qvtmPVSqIMrCuv
         /uzdUXB0xdnZxRRksCa2EOudSg/lm4o37oSQUHFZqi7S9+p8voC+WZ1F1q0BD1uZrMto
         rdBA==
X-Gm-Message-State: AOAM530EB8xDbb/BSJwfkjNbWxHI8TomqJC9P1nm9KXzfY5tN1g6vFD/
        0KlxVs+crE6OvAxGR/G8pRo=
X-Google-Smtp-Source: ABdhPJwfIa9xLZ2dxrQyeVXx3/Z422jD2+YfbCP5OfD6iDlNgfxJHt54wRF97Ss+1jd2FYYrvG8lWw==
X-Received: by 2002:a63:fd01:0:b0:381:31b7:8bc5 with SMTP id d1-20020a63fd01000000b0038131b78bc5mr5928177pgh.206.1648368158572;
        Sun, 27 Mar 2022 01:02:38 -0700 (PDT)
Received: from localhost ([115.220.243.108])
        by smtp.gmail.com with ESMTPSA id i6-20020a633c46000000b003817d623f72sm9744595pgn.24.2022.03.27.01.02.37
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Sun, 27 Mar 2022 01:02:38 -0700 (PDT)
From:   Xiaomeng Tong <xiam0nd.tong@gmail.com>
To:     trond.myklebust@hammerspace.com, anna@kernel.org
Cc:     bhalevy@panasas.com, bharrosh@panasas.com,
        linux-nfs@vger.kernel.org, linux-kernel@vger.kernel.org,
        Xiaomeng Tong <xiam0nd.tong@gmail.com>, stable@vger.kernel.org
Subject: [PATCH] nfs: callback_proc: fix an incorrect NULL check on list iterator
Date:   Sun, 27 Mar 2022 16:02:30 +0800
Message-Id: <20220327080230.12134-1-xiam0nd.tong@gmail.com>
X-Mailer: git-send-email 2.17.1
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The bug is here:
	if (!server ||
	server->pnfs_curr_ld->id != dev->cbd_layout_type) {

The list iterator value 'server' will *always* be set and non-NULL
by list_for_each_entry_rcu, so it is incorrect to assume that the
iterator value will be NULL if the list is empty or no element is
found (In fact, it will be a bogus pointer to an invalid struct
object containing the HEAD, which is used for above check at next
outer loop). Otherwise it may bypass the check in theory (iif
server->pnfs_curr_ld->id == dev->cbd_layout_type, 'server' now is
a bogus pointer) and lead to invalid memory access passing the check.

To fix the bug, use a new variable 'iter' as the list iterator,
while use the original variable 'server' as a dedicated pointer to
point to the found element.

Cc: stable@vger.kernel.org
Fixes: 1be5683b03a76 ("pnfs: CB_NOTIFY_DEVICEID")
Signed-off-by: Xiaomeng Tong <xiam0nd.tong@gmail.com>
---
 fs/nfs/callback_proc.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/fs/nfs/callback_proc.c b/fs/nfs/callback_proc.c
index c343666d9a42..84779785dc8d 100644
--- a/fs/nfs/callback_proc.c
+++ b/fs/nfs/callback_proc.c
@@ -361,7 +361,7 @@ __be32 nfs4_callback_devicenotify(void *argp, void *resp,
 	uint32_t i;
 	__be32 res = 0;
 	struct nfs_client *clp = cps->clp;
-	struct nfs_server *server = NULL;
+	struct nfs_server *server = NULL, *iter;
 
 	if (!clp) {
 		res = cpu_to_be32(NFS4ERR_OP_NOT_IN_SESSION);
@@ -374,10 +374,11 @@ __be32 nfs4_callback_devicenotify(void *argp, void *resp,
 		if (!server ||
 		    server->pnfs_curr_ld->id != dev->cbd_layout_type) {
 			rcu_read_lock();
-			list_for_each_entry_rcu(server, &clp->cl_superblocks, client_link)
-				if (server->pnfs_curr_ld &&
-				    server->pnfs_curr_ld->id == dev->cbd_layout_type) {
+			list_for_each_entry_rcu(iter, &clp->cl_superblocks, client_link)
+				if (iter->pnfs_curr_ld &&
+				    iter->pnfs_curr_ld->id == dev->cbd_layout_type) {
 					rcu_read_unlock();
+					server = iter;
 					goto found;
 				}
 			rcu_read_unlock();
-- 
2.17.1

