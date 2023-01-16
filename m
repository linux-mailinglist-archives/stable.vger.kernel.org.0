Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 690DD66C731
	for <lists+stable@lfdr.de>; Mon, 16 Jan 2023 17:29:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233195AbjAPQ3D (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Jan 2023 11:29:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43046 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233165AbjAPQ2Y (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Jan 2023 11:28:24 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8891F2D169
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 08:16:44 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DBF9261031
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 16:16:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F1405C433EF;
        Mon, 16 Jan 2023 16:16:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673885803;
        bh=hGxg/op7zcqYpPji529cCOOsaQdPXlDh+7S8HNuZETA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cqw5cHO26lUkDjhPVyP5a9rpsht9wieLMHp9qYIXl88TBMe90n5pR1+F+CeKsdH7k
         VgsCRWcKgbVsjdXBDpwy34oR56ZO1C6P8tamX6ExVQMi7Uu9YwYE72MQBmDfvFFR5L
         Rb0Xw1JVecn7sR3xy1FWtohLdhoTLtNnz9NJjs90=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Trond Myklebust <trond.myklebust@hammerspace.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 160/658] NFSv4.2: Clear FATTR4_WORD2_SECURITY_LABEL when done decoding
Date:   Mon, 16 Jan 2023 16:44:08 +0100
Message-Id: <20230116154916.774177741@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230116154909.645460653@linuxfoundation.org>
References: <20230116154909.645460653@linuxfoundation.org>
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
index 2b7741fe42ea..ac9ffe184451 100644
--- a/fs/nfs/nfs4xdr.c
+++ b/fs/nfs/nfs4xdr.c
@@ -4169,6 +4169,7 @@ static int decode_attr_security_label(struct xdr_stream *xdr, uint32_t *bitmap,
 		p = xdr_inline_decode(xdr, len);
 		if (unlikely(!p))
 			return -EIO;
+		bitmap[2] &= ~FATTR4_WORD2_SECURITY_LABEL;
 		if (len < NFS4_MAXLABELLEN) {
 			if (label) {
 				if (label->len) {
@@ -4181,7 +4182,6 @@ static int decode_attr_security_label(struct xdr_stream *xdr, uint32_t *bitmap,
 				label->lfs = lfs;
 				status = NFS_ATTR_FATTR_V4_SECURITY_LABEL;
 			}
-			bitmap[2] &= ~FATTR4_WORD2_SECURITY_LABEL;
 		} else
 			printk(KERN_WARNING "%s: label too long (%u)!\n",
 					__func__, len);
-- 
2.35.1



