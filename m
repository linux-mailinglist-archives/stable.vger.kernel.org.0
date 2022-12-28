Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ECE9F65794C
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 16:00:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233290AbiL1O76 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 09:59:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46714 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233369AbiL1O7c (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 09:59:32 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F9A6120B8
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 06:59:32 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B8473B81719
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 14:59:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 14C8FC433F0;
        Wed, 28 Dec 2022 14:59:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672239569;
        bh=mZxfjgMbuKdGvct+30V9py4QHMbsZ7T5ri43MT4MQQk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oOJ7VbfVsMgROWRAPBakoU6dtc/8ygBkTzKGPs37dFN3IRUDYWHz6BUg6bwOLFrnR
         7fARR+UyFs3k95zsVVYVi76fa8OB3JtkmN2Ee25ShAzYq05Xpsl/c13eSLOsLdy1tB
         qwz62VX8iozFZS48hXgeQsnYHmpjdwKElI8lh7fM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Trond Myklebust <trond.myklebust@hammerspace.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 244/731] NFSv4.2: Clear FATTR4_WORD2_SECURITY_LABEL when done decoding
Date:   Wed, 28 Dec 2022 15:35:51 +0100
Message-Id: <20221228144303.635722335@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144256.536395940@linuxfoundation.org>
References: <20221228144256.536395940@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Trond Myklebust <trond.myklebust@hammerspace.com>

[ Upstream commit eef7314caf2d73a94b68ba293cd105154d3a664e ]

We need to clear the FATTR4_WORD2_SECURITY_LABEL bitmap flag
irrespective of whether or not the label is too long.

Fixes: aa9c2669626c ("NFS: Client implementation of Labeled-NFS")
Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfs/nfs4xdr.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/nfs/nfs4xdr.c b/fs/nfs/nfs4xdr.c
index 046788afb6d9..9d19b801cb39 100644
--- a/fs/nfs/nfs4xdr.c
+++ b/fs/nfs/nfs4xdr.c
@@ -4179,6 +4179,7 @@ static int decode_attr_security_label(struct xdr_stream *xdr, uint32_t *bitmap,
 		p = xdr_inline_decode(xdr, len);
 		if (unlikely(!p))
 			return -EIO;
+		bitmap[2] &= ~FATTR4_WORD2_SECURITY_LABEL;
 		if (len < NFS4_MAXLABELLEN) {
 			if (label) {
 				if (label->len) {
@@ -4191,7 +4192,6 @@ static int decode_attr_security_label(struct xdr_stream *xdr, uint32_t *bitmap,
 				label->lfs = lfs;
 				status = NFS_ATTR_FATTR_V4_SECURITY_LABEL;
 			}
-			bitmap[2] &= ~FATTR4_WORD2_SECURITY_LABEL;
 		} else
 			printk(KERN_WARNING "%s: label too long (%u)!\n",
 					__func__, len);
-- 
2.35.1



