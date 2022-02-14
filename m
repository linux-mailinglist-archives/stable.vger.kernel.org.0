Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CD6B34B4A34
	for <lists+stable@lfdr.de>; Mon, 14 Feb 2022 11:38:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346174AbiBNKR0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Feb 2022 05:17:26 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:44746 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347999AbiBNKRD (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Feb 2022 05:17:03 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 049E08CDAE;
        Mon, 14 Feb 2022 01:54:29 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0510661291;
        Mon, 14 Feb 2022 09:54:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA8E1C340E9;
        Mon, 14 Feb 2022 09:54:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1644832448;
        bh=1ntWSla+5nh9tEUa/mvCSg1/ISzaLNJ5FQu7JQZLhyo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=u+tb+laQkad2/gOcVAvh0vDJ4lqRhwXnuV2HQnJhYjm71KfzfrgnETqsaoOmMRYKp
         jRIFa/fGXEAJkiQ9FUXtHnWzDY9+Otxn80T99c3oPAxOuC65Qsu4g4fSxjdFcpLasK
         UUS+ooBEYczvW0g/jaY1IH5uIVxeloRlbkr1lwfA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chuck Lever <chuck.lever@oracle.com>
Subject: [PATCH 5.16 018/203] NFSD: Fix offset type in I/O trace points
Date:   Mon, 14 Feb 2022 10:24:22 +0100
Message-Id: <20220214092510.839136424@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220214092510.221474733@linuxfoundation.org>
References: <20220214092510.221474733@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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

commit 6a4d333d540041d244b2fca29b8417bfde20af81 upstream.

NFSv3 and NFSv4 use u64 offset values on the wire. Record these values
verbatim without the implicit type case to loff_t.

Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/nfsd/trace.h |   14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

--- a/fs/nfsd/trace.h
+++ b/fs/nfsd/trace.h
@@ -320,14 +320,14 @@ TRACE_EVENT(nfsd_export_update,
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
@@ -335,7 +335,7 @@ DECLARE_EVENT_CLASS(nfsd_io_class,
 		__entry->offset = offset;
 		__entry->len = len;
 	),
-	TP_printk("xid=0x%08x fh_hash=0x%08x offset=%lld len=%lu",
+	TP_printk("xid=0x%08x fh_hash=0x%08x offset=%llu len=%u",
 		  __entry->xid, __entry->fh_hash,
 		  __entry->offset, __entry->len)
 )
@@ -344,8 +344,8 @@ DECLARE_EVENT_CLASS(nfsd_io_class,
 DEFINE_EVENT(nfsd_io_class, nfsd_##name,	\
 	TP_PROTO(struct svc_rqst *rqstp,	\
 		 struct svc_fh	*fhp,		\
-		 loff_t		offset,		\
-		 unsigned long	len),		\
+		 u64		offset,		\
+		 u32		len),		\
 	TP_ARGS(rqstp, fhp, offset, len))
 
 DEFINE_NFSD_IO_EVENT(read_start);


