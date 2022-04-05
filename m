Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BBAB94F3044
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 14:27:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239361AbiDEKHV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 06:07:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43644 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344348AbiDEJTe (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 05:19:34 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 731DBE0D9;
        Tue,  5 Apr 2022 02:07:40 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 25062B81C19;
        Tue,  5 Apr 2022 09:07:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 674CFC385A0;
        Tue,  5 Apr 2022 09:07:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649149657;
        bh=UPyd4KE5RZhuBQ3r29MQ6fG0fXlHOPnapWsvTCOT5Uw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=r5BNr1UqGl7ljJG4spYyWwQM7Xm4oiHGBUeZfguwGOPoB/nhY04pvFXk5cgJg/Eeq
         /lAW+Di3XjWEDPmYemCsWxD2JrYJzRIss1hWg9QVnbVuLJc2OUCCV9Zjw8C6dNd8Ni
         uHgQ6Uu1aWNVI2FqD6QTQ43iiJQFoeFnHRmG509A=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dai Ngo <dai.ngo@oracle.com>,
        Chuck Lever <chuck.lever@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 0792/1017] NFSD: Fix nfsd_breaker_owns_lease() return values
Date:   Tue,  5 Apr 2022 09:28:25 +0200
Message-Id: <20220405070417.761952002@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070354.155796697@linuxfoundation.org>
References: <20220405070354.155796697@linuxfoundation.org>
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
index ac0ddde8beef..6075a328d756 100644
--- a/fs/nfsd/nfs4state.c
+++ b/fs/nfsd/nfs4state.c
@@ -4693,6 +4693,14 @@ nfsd_break_deleg_cb(struct file_lock *fl)
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
@@ -4700,11 +4708,11 @@ static bool nfsd_breaker_owns_lease(struct file_lock *fl)
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



