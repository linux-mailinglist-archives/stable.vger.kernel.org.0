Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5E0864B711F
	for <lists+stable@lfdr.de>; Tue, 15 Feb 2022 17:40:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240833AbiBOPh5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 15 Feb 2022 10:37:57 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:43346 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240745AbiBOPfa (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 15 Feb 2022 10:35:30 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A6177B82D8;
        Tue, 15 Feb 2022 07:31:19 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 44A80615CE;
        Tue, 15 Feb 2022 15:31:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 19D6BC340ED;
        Tue, 15 Feb 2022 15:31:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1644939078;
        bh=vi1pWizM0FJogMNRkq0gEXrW2C3iMGDw32et93d5HmA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sBlngUbEqhCnKm8WcOC8XPC1qlp7Wupt6m07+15O5ZPU6CUarZO2ELL/AuLKDsg0y
         l1FL0+ZVcYXnBVhDRDj9qwA1JO9iaQn2ueGcBBN78sqo2qOfu/WE72BwL8F134JJpX
         RUq7Y/lOGzm/9j0BB3/kCopk8+RGMVKPGPrW6ffGZnq/UTCCXi2Vwc4/e88npb7V5y
         3QcRjQicNdLLdqGSjicgMAMCBWyAWJn2yhnt761Usml1byJyC9wdwBHqIzQy1GR7AT
         BJztp3il6cFWL2ksj2bljAvq5YAG65gDHupUOx9yMCBATPR1fgp1WW9pIC60RmIUVr
         70hFTfaDOIq0Q==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Chuck Lever <chuck.lever@oracle.com>,
        Sasha Levin <sashal@kernel.org>, linux-nfs@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 09/11] NFSD: Fix offset type in I/O trace points
Date:   Tue, 15 Feb 2022 10:31:02 -0500
Message-Id: <20220215153104.581786-9-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220215153104.581786-1-sashal@kernel.org>
References: <20220215153104.581786-1-sashal@kernel.org>
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
index 80933e4334d84..5b2ef30a8ac06 100644
--- a/fs/nfsd/trace.h
+++ b/fs/nfsd/trace.h
@@ -53,14 +53,14 @@ TRACE_EVENT(nfsd_compound_status,
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
@@ -68,7 +68,7 @@ DECLARE_EVENT_CLASS(nfsd_io_class,
 		__entry->offset = offset;
 		__entry->len = len;
 	),
-	TP_printk("xid=0x%08x fh_hash=0x%08x offset=%lld len=%lu",
+	TP_printk("xid=0x%08x fh_hash=0x%08x offset=%llu len=%u",
 		  __entry->xid, __entry->fh_hash,
 		  __entry->offset, __entry->len)
 )
@@ -77,8 +77,8 @@ DECLARE_EVENT_CLASS(nfsd_io_class,
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

