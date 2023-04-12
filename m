Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 767736DEF46
	for <lists+stable@lfdr.de>; Wed, 12 Apr 2023 10:49:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231301AbjDLIt1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 Apr 2023 04:49:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35912 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231274AbjDLItX (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 12 Apr 2023 04:49:23 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 601A26A65
        for <stable@vger.kernel.org>; Wed, 12 Apr 2023 01:48:56 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0E6646311B
        for <stable@vger.kernel.org>; Wed, 12 Apr 2023 08:48:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F123C4339B;
        Wed, 12 Apr 2023 08:48:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1681289321;
        bh=tizzr9Z/DD9nqnYD6GLHyGMJyjTbjh2odzIXH3yIEpA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ck3amsqXnBlJANiY588TPX+L7f+Pfa460Z235nuLPxT/C/yi35sobvlsMsMhNDIzp
         kgkxU8N/uQbsXMO0rnd3MGazdjBw4VPZ8m6t0CHj0Z7aHmPs7bIiJddgTUGiFwYxxD
         JVOMCaHix8Gs0uZnxDGhAOc15M+hwHaWoySwuKsQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Jeff Layton <jlayton@kernel.org>,
        Chuck Lever <chuck.lever@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 025/173] NFSD: Avoid calling OPDESC() with ops->opnum == OP_ILLEGAL
Date:   Wed, 12 Apr 2023 10:32:31 +0200
Message-Id: <20230412082839.110157319@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230412082838.125271466@linuxfoundation.org>
References: <20230412082838.125271466@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chuck Lever <chuck.lever@oracle.com>

[ Upstream commit 804d8e0a6e54427268790472781e03bc243f4ee3 ]

OPDESC() simply indexes into nfsd4_ops[] by the op's operation
number, without range checking that value. It assumes callers are
careful to avoid calling it with an out-of-bounds opnum value.

nfsd4_decode_compound() is not so careful, and can invoke OPDESC()
with opnum set to OP_ILLEGAL, which is 10044 -- well beyond the end
of nfsd4_ops[].

Reported-by: Jeff Layton <jlayton@kernel.org>
Fixes: f4f9ef4a1b0a ("nfsd4: opdesc will be useful outside nfs4proc.c")
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfsd/nfs4xdr.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/fs/nfsd/nfs4xdr.c b/fs/nfsd/nfs4xdr.c
index 97edb32be77f1..67bbd2d6334c4 100644
--- a/fs/nfsd/nfs4xdr.c
+++ b/fs/nfsd/nfs4xdr.c
@@ -2476,10 +2476,12 @@ nfsd4_decode_compound(struct nfsd4_compoundargs *argp)
 	for (i = 0; i < argp->opcnt; i++) {
 		op = &argp->ops[i];
 		op->replay = NULL;
+		op->opdesc = NULL;
 
 		if (xdr_stream_decode_u32(argp->xdr, &op->opnum) < 0)
 			return false;
 		if (nfsd4_opnum_in_range(argp, op)) {
+			op->opdesc = OPDESC(op);
 			op->status = nfsd4_dec_ops[op->opnum](argp, &op->u);
 			if (op->status != nfs_ok)
 				trace_nfsd_compound_decode_err(argp->rqstp,
@@ -2490,7 +2492,7 @@ nfsd4_decode_compound(struct nfsd4_compoundargs *argp)
 			op->opnum = OP_ILLEGAL;
 			op->status = nfserr_op_illegal;
 		}
-		op->opdesc = OPDESC(op);
+
 		/*
 		 * We'll try to cache the result in the DRC if any one
 		 * op in the compound wants to be cached:
-- 
2.39.2



