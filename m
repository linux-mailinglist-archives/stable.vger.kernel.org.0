Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 823BB4F38B2
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 16:36:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358407AbiDEL1R (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 07:27:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54212 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349538AbiDEJuL (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 05:50:11 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD01322A;
        Tue,  5 Apr 2022 02:48:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 496AE61576;
        Tue,  5 Apr 2022 09:48:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 54143C385A2;
        Tue,  5 Apr 2022 09:48:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649152092;
        bh=+sWvTD6FOqqcuHADt21hlAnfUn1I2GaAJOelYaalGws=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RaUVvSEwkYPmreZf3XXPAPZO4/yqHb2ljme4LOUtZgbpxpkXhugWbpLPWsX/A3Ttp
         JLoVSr/ycQJndR3GNQSR96e8ucCDRD84yq5fMHMSZetSWZLcXMjcz0jvPt1VYN8vgV
         vdtFnTVhlDIJH7CHacU7+G/QB6t0YZWjZ+bwnfEg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Olga Kornievskaia <kolga@netapp.com>,
        Trond Myklebust <trond.myklebust@hammerspace.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 651/913] NFSv4.1: dont retry BIND_CONN_TO_SESSION on session error
Date:   Tue,  5 Apr 2022 09:28:33 +0200
Message-Id: <20220405070359.352735849@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070339.801210740@linuxfoundation.org>
References: <20220405070339.801210740@linuxfoundation.org>
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
index 53be03681f69..dababa6cf3f4 100644
--- a/fs/nfs/nfs4proc.c
+++ b/fs/nfs/nfs4proc.c
@@ -8341,6 +8341,7 @@ nfs4_bind_one_conn_to_session_done(struct rpc_task *task, void *calldata)
 	case -NFS4ERR_DEADSESSION:
 		nfs4_schedule_session_recovery(clp->cl_session,
 				task->tk_status);
+		return;
 	}
 	if (args->dir == NFS4_CDFC4_FORE_OR_BOTH &&
 			res->dir != NFS4_CDFS4_BOTH) {
-- 
2.34.1



