Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9664D4B716C
	for <lists+stable@lfdr.de>; Tue, 15 Feb 2022 17:40:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240643AbiBOPfF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 15 Feb 2022 10:35:05 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:46196 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240528AbiBOPeE (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 15 Feb 2022 10:34:04 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 03A90125582;
        Tue, 15 Feb 2022 07:30:34 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9B042B81AF2;
        Tue, 15 Feb 2022 15:30:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A75D3C340ED;
        Tue, 15 Feb 2022 15:30:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1644939032;
        bh=nyj2we/GVux9ke5H4pfoxuTBNZ11sfeVyubRhdGHMT8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=t8VHRaj8rQXRhWdlXRMoMmhctFItbjEa4BaJcPPlhPka//mHlNliUQYKrPPTHnQXX
         ZDeLUkEIaAblaG2L3UiQJIpou4ul3+I5292b4WMo/LWdAJPMV4W3Q/0KVBEOnIxvHc
         TofTMcl/ixTTjzQV07wbmnuu1Rp3PQ2Z6c3yCf7CDhnR/A5/PV3WTMMLccrtY2aZTp
         5czJqbOEftO2WGzlV1Hyug56fgqulvS5ri+BKGkKMHICwIHlNug+gx6EkVaBhfTEQm
         oidQFxL2fD7j7tbhgvY6q6M7sk+kAJBVU0YvQmWd3kfKBrwgMq87c6fYIGU9cpnIeM
         udzREuZjYUA/Q==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Chuck Lever <chuck.lever@oracle.com>,
        Sasha Levin <sashal@kernel.org>, linux-nfs@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 20/23] NFSD: Fix offset type in I/O trace points
Date:   Tue, 15 Feb 2022 10:29:54 -0500
Message-Id: <20220215152957.581303-20-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220215152957.581303-1-sashal@kernel.org>
References: <20220215152957.581303-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chuck Lever <chuck.lever@oracle.com>

[ Upstream commit 6a4d333d540041d244b2fca29b8417bfde20af81 ]

NFSv3 and NFSv4 use u64 offset values on the wire. Record these values
verbatim without the implicit type case to loff_t.

Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfsd/trace.h | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/fs/nfsd/trace.h b/fs/nfsd/trace.h
index c8ca73d69ad04..a952f4a9b2a68 100644
--- a/fs/nfsd/trace.h
+++ b/fs/nfsd/trace.h
@@ -175,14 +175,14 @@ TRACE_EVENT(nfsd_export_update,
 DECLARE_EVENT_CLASS(nfsd_io_class,
 	TP_PROTO(struct svc_rqst *rqstp,
 		 struct svc_fh	*fhp,
-		 loff_t		offset,
-		 unsigned long	len),
+		 u64		offset,
+		 u32		len),
 	TP_ARGS(rqstp, fhp, offset, len),
 	TP_STRUCT__entry(
 		__field(u32, xid)
 		__field(u32, fh_hash)
-		__field(loff_t, offset)
-		__field(unsigned long, len)
+		__field(u64, offset)
+		__field(u32, len)
 	),
 	TP_fast_assign(
 		__entry->xid = be32_to_cpu(rqstp->rq_xid);
@@ -190,7 +190,7 @@ DECLARE_EVENT_CLASS(nfsd_io_class,
 		__entry->offset = offset;
 		__entry->len = len;
 	),
-	TP_printk("xid=0x%08x fh_hash=0x%08x offset=%lld len=%lu",
+	TP_printk("xid=0x%08x fh_hash=0x%08x offset=%llu len=%u",
 		  __entry->xid, __entry->fh_hash,
 		  __entry->offset, __entry->len)
 )
@@ -199,8 +199,8 @@ DECLARE_EVENT_CLASS(nfsd_io_class,
 DEFINE_EVENT(nfsd_io_class, nfsd_##name,	\
 	TP_PROTO(struct svc_rqst *rqstp,	\
 		 struct svc_fh	*fhp,		\
-		 loff_t		offset,		\
-		 unsigned long	len),		\
+		 u64		offset,		\
+		 u32		len),		\
 	TP_ARGS(rqstp, fhp, offset, len))
 
 DEFINE_NFSD_IO_EVENT(read_start);
-- 
2.34.1

