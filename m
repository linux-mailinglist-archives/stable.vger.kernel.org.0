Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C11AE4CF6E4
	for <lists+stable@lfdr.de>; Mon,  7 Mar 2022 10:43:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238314AbiCGJnJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Mar 2022 04:43:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41818 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240938AbiCGJlm (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Mar 2022 04:41:42 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 884CD5B893;
        Mon,  7 Mar 2022 01:38:43 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1D0BA6116E;
        Mon,  7 Mar 2022 09:38:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2CE02C340F3;
        Mon,  7 Mar 2022 09:38:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1646645922;
        bh=3/kkwC3GonZthDwBJEBTO1peZX/rHod02QG4EBjZFYw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vDpYAQgN+JdKvL8Qj9uBcFcTZE9Hee+S4DwnbKbA6FrFrP6EINk8YOH+7eCLlq9Gn
         y2HNruxXnBFW+g1M5764jKM15Ex41FmnC/8GZupFrVDsWS5S7XqXdwySGRWETf2J7+
         HDd9wnH2Lr/RmMmHEbZZVhAQCox7+k8na8jkF+lc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, rtm@csail.mit.edu,
        "J. Bruce Fields" <bfields@redhat.com>,
        Chuck Lever <chuck.lever@oracle.com>,
        Olga Kornievskaia <kolga@netapp.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 077/262] nfsd: fix crash on COPY_NOTIFY with special stateid
Date:   Mon,  7 Mar 2022 10:17:01 +0100
Message-Id: <20220307091704.665272036@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220307091702.378509770@linuxfoundation.org>
References: <20220307091702.378509770@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: J. Bruce Fields <bfields@redhat.com>

[ Upstream commit 074b07d94e0bb6ddce5690a9b7e2373088e8b33a ]

RTM says "If the special ONE stateid is passed to
nfs4_preprocess_stateid_op(), it returns status=0 but does not set
*cstid. nfsd4_copy_notify() depends on stid being set if status=0, and
thus can crash if the client sends the right COPY_NOTIFY RPC."

RFC 7862 says "The cna_src_stateid MUST refer to either open or locking
states provided earlier by the server.  If it is invalid, then the
operation MUST fail."

The RFC doesn't specify an error, and the choice doesn't matter much as
this is clearly illegal client behavior, but bad_stateid seems
reasonable.

Simplest is just to guarantee that nfs4_preprocess_stateid_op, called
with non-NULL cstid, errors out if it can't return a stateid.

Reported-by: rtm@csail.mit.edu
Fixes: 624322f1adc5 ("NFSD add COPY_NOTIFY operation")
Signed-off-by: J. Bruce Fields <bfields@redhat.com>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Reviewed-by: Olga Kornievskaia <kolga@netapp.com>
Tested-by: Olga Kornievskaia <kolga@netapp.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfsd/nfs4state.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/fs/nfsd/nfs4state.c b/fs/nfsd/nfs4state.c
index 97090ddcfc94d..db4a47a280dc5 100644
--- a/fs/nfsd/nfs4state.c
+++ b/fs/nfsd/nfs4state.c
@@ -6042,7 +6042,11 @@ nfs4_preprocess_stateid_op(struct svc_rqst *rqstp,
 		*nfp = NULL;
 
 	if (ZERO_STATEID(stateid) || ONE_STATEID(stateid)) {
-		status = check_special_stateids(net, fhp, stateid, flags);
+		if (cstid)
+			status = nfserr_bad_stateid;
+		else
+			status = check_special_stateids(net, fhp, stateid,
+									flags);
 		goto done;
 	}
 
-- 
2.34.1



