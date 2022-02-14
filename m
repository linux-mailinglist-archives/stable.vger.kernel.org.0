Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EF6514B47C9
	for <lists+stable@lfdr.de>; Mon, 14 Feb 2022 10:55:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243898AbiBNJht (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Feb 2022 04:37:49 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:51520 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244139AbiBNJfp (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Feb 2022 04:35:45 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D3E3BAE40;
        Mon, 14 Feb 2022 01:33:22 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D43CF61115;
        Mon, 14 Feb 2022 09:33:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 98A71C340EF;
        Mon, 14 Feb 2022 09:33:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1644831191;
        bh=SeVxQyNtXy9Wp9rjGaTR1rfv/6g68X9HcuZxVVLKI+0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kO6vD0KlIuTlvJwm0RMjnEMUn6CJBk8YaTDZb3b28fOfwg8W3LTw1KYIrxipOE6jM
         nd2to7mCXUQKdFQ+ld0W+nr8DNScz5OtMuQryW1kpr8Y5+E9qZ+ZhDK7LfiP+jAPFR
         FGyli5BDnhgZ5RFf5MLQWlYK6ENJwNAEtUDXXnGo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chuck Lever <chuck.lever@oracle.com>
Subject: [PATCH 4.19 08/49] NFSD: Fix offset type in I/O trace points
Date:   Mon, 14 Feb 2022 10:25:34 +0100
Message-Id: <20220214092448.576066308@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220214092448.285381753@linuxfoundation.org>
References: <20220214092448.285381753@linuxfoundation.org>
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


