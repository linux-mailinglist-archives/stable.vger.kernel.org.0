Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 87FC34F4188
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 23:33:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1382599AbiDEMQG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 08:16:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34642 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243535AbiDEKgv (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 06:36:51 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 91E0B54FBD;
        Tue,  5 Apr 2022 03:22:32 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 19FF161676;
        Tue,  5 Apr 2022 10:22:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 27B72C385A1;
        Tue,  5 Apr 2022 10:22:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649154151;
        bh=RFxO9xF6t5YjxDSa/9vY21MmN/AHRRJpq/CrMwSlBaQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=F0/aXJ/y6C/lpuo965CIyFm4gz67isaFkVyglX5CyWitL8DW39OCKbr2QVmV0Vr2c
         UoUrXfA/bwSbbhQaqpls4QATxzgHQka/yDzoJniEOuLmUNwVUc/asol+7n9yI6BjKQ
         y9Agnf5xSeGyKAL7FJerfeucOTYjNic18omXD6fc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dai Ngo <dai.ngo@oracle.com>,
        Chuck Lever <chuck.lever@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 475/599] NFSD: Fix nfsd_breaker_owns_lease() return values
Date:   Tue,  5 Apr 2022 09:32:49 +0200
Message-Id: <20220405070312.960666134@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070258.802373272@linuxfoundation.org>
References: <20220405070258.802373272@linuxfoundation.org>
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

From: Chuck Lever <chuck.lever@oracle.com>

[ Upstream commit 50719bf3442dd6cd05159e9c98d020b3919ce978 ]

These have been incorrect since the function was introduced.

A proper kerneldoc comment is added since this function, though
static, is part of an external interface.

Reported-by: Dai Ngo <dai.ngo@oracle.com>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfsd/nfs4state.c | 12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff --git a/fs/nfsd/nfs4state.c b/fs/nfsd/nfs4state.c
index d01d7929753e..84dd68091f42 100644
--- a/fs/nfsd/nfs4state.c
+++ b/fs/nfsd/nfs4state.c
@@ -4607,6 +4607,14 @@ nfsd_break_deleg_cb(struct file_lock *fl)
 	return ret;
 }
 
+/**
+ * nfsd_breaker_owns_lease - Check if lease conflict was resolved
+ * @fl: Lock state to check
+ *
+ * Return values:
+ *   %true: Lease conflict was resolved
+ *   %false: Lease conflict was not resolved.
+ */
 static bool nfsd_breaker_owns_lease(struct file_lock *fl)
 {
 	struct nfs4_delegation *dl = fl->fl_owner;
@@ -4614,11 +4622,11 @@ static bool nfsd_breaker_owns_lease(struct file_lock *fl)
 	struct nfs4_client *clp;
 
 	if (!i_am_nfsd())
-		return NULL;
+		return false;
 	rqst = kthread_data(current);
 	/* Note rq_prog == NFS_ACL_PROGRAM is also possible: */
 	if (rqst->rq_prog != NFS_PROGRAM || rqst->rq_vers < 4)
-		return NULL;
+		return false;
 	clp = *(rqst->rq_lease_breaker);
 	return dl->dl_stid.sc_client == clp;
 }
-- 
2.34.1



