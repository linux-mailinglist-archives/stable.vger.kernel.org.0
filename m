Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B973F4F29F8
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 12:51:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236523AbiDEI17 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 04:27:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45418 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239560AbiDEIUO (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 04:20:14 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F2C52601;
        Tue,  5 Apr 2022 01:16:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C011260B0A;
        Tue,  5 Apr 2022 08:16:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C95CDC385A1;
        Tue,  5 Apr 2022 08:16:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649146575;
        bh=OlZgfNfWqUL2kkWzmZuqYmPzg9dSfeyZHARzCMt+jF4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gIUJjZPD/3ImHcvScAY0DPcDwwqDM+PNvBr+m6eNujOmxak3NdhtNgh5Y6ULUPPeP
         zFC2SMj9CEc14YzoPFqaRu7rXppeOI3BONZ0+d/DXAYsjS1nIN8kgqF6ZvHwI/FAqX
         dek76Fxg1hi934kSbkpZCvjiHRe3RA8bgg0wIjlY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Olga Kornievskaia <kolga@netapp.com>,
        Trond Myklebust <trond.myklebust@hammerspace.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 0796/1126] NFSv4.1: dont retry BIND_CONN_TO_SESSION on session error
Date:   Tue,  5 Apr 2022 09:25:43 +0200
Message-Id: <20220405070430.936067121@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070407.513532867@linuxfoundation.org>
References: <20220405070407.513532867@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Olga Kornievskaia <kolga@netapp.com>

[ Upstream commit 1d15d121cc2ad4d016a7dc1493132a9696f91fc5 ]

There is no reason to retry the operation if a session error had
occurred in such case result structure isn't filled out.

Fixes: dff58530c4ca ("NFSv4.1: fix handling of backchannel binding in BIND_CONN_TO_SESSION")
Signed-off-by: Olga Kornievskaia <kolga@netapp.com>
Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfs/nfs4proc.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/nfs/nfs4proc.c b/fs/nfs/nfs4proc.c
index 0e0db6c27619..c36fa0d0d438 100644
--- a/fs/nfs/nfs4proc.c
+++ b/fs/nfs/nfs4proc.c
@@ -8333,6 +8333,7 @@ nfs4_bind_one_conn_to_session_done(struct rpc_task *task, void *calldata)
 	case -NFS4ERR_DEADSESSION:
 		nfs4_schedule_session_recovery(clp->cl_session,
 				task->tk_status);
+		return;
 	}
 	if (args->dir == NFS4_CDFC4_FORE_OR_BOTH &&
 			res->dir != NFS4_CDFS4_BOTH) {
-- 
2.34.1



