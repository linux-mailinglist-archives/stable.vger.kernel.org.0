Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6B74F49A4CB
	for <lists+stable@lfdr.de>; Tue, 25 Jan 2022 03:10:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2369624AbiAYACQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 19:02:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52984 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1835371AbiAXX2X (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 18:28:23 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C7DAC06137E;
        Mon, 24 Jan 2022 13:33:37 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id BED07B811FB;
        Mon, 24 Jan 2022 21:33:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D6D9FC340E5;
        Mon, 24 Jan 2022 21:33:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643060014;
        bh=AgnJz7sWVdzNBLyQVmv2Q5ZZKhnnlYEXfPsBXRUnz6E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Rbw1MWlsMXlk/y8GTGwP4rgg1C1L+oAvGUp8WaX+XgUFo+wVmkh5KvGMRYlI1oyoH
         fSq4BdgFlDXBLMhELZCqAFjaiKXg217AGQu6mLf4vjALECjK97tOm8QLQ5pLkfSwzt
         fLMuWc83FqYF7zW7ig2Fl8L4M7M2F0r1oKkooJiY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, rtm@csail.mit.edu,
        "J. Bruce Fields" <bfields@redhat.com>,
        Chuck Lever <chuck.lever@oracle.com>,
        Olga Kornievskaia <kolga@netapp.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 0811/1039] nfsd: fix crash on COPY_NOTIFY with special stateid
Date:   Mon, 24 Jan 2022 19:43:20 +0100
Message-Id: <20220124184152.573221726@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184125.121143506@linuxfoundation.org>
References: <20220124184125.121143506@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
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
index 1956d377d1a60..b94b3bb2b8a6e 100644
--- a/fs/nfsd/nfs4state.c
+++ b/fs/nfsd/nfs4state.c
@@ -6040,7 +6040,11 @@ nfs4_preprocess_stateid_op(struct svc_rqst *rqstp,
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



