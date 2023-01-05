Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F1A7F65EB92
	for <lists+stable@lfdr.de>; Thu,  5 Jan 2023 14:00:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233581AbjAENAf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 5 Jan 2023 08:00:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47450 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233953AbjAENAC (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 5 Jan 2023 08:00:02 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE9923D9EC
        for <stable@vger.kernel.org>; Thu,  5 Jan 2023 04:59:58 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 82D91B81979
        for <stable@vger.kernel.org>; Thu,  5 Jan 2023 12:59:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B181EC433EF;
        Thu,  5 Jan 2023 12:59:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672923596;
        bh=BSokVUf6OaLBP2nrzZrp7QnsBaaOEmYJBuJcG0JRhgM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=D+JFeZ50ku4Bqr37fRHYwRaYqJy8oI+y4OUksBhV5YnGhnmmnHaxbvkEjeUS0lIJs
         wlDgzmA/u8xCpeMV8eNHBP84tNtHn5iRHLcv/oM7EWUsvxQiYhD63CNeRio06cnJbp
         A/m35fagmErxMWucGGM14r6yzgtYfult2tpGC9mE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Trond Myklebust <trond.myklebust@hammerspace.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 071/251] NFSv4.2: Fix a memory stomp in decode_attr_security_label
Date:   Thu,  5 Jan 2023 13:53:28 +0100
Message-Id: <20230105125338.021599526@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230105125334.727282894@linuxfoundation.org>
References: <20230105125334.727282894@linuxfoundation.org>
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

[ Upstream commit 43c1031f7110967c240cb6e922adcfc4b8899183 ]

We must not change the value of label->len if it is zero, since that
indicates we stored a label.

Fixes: b4487b935452 ("nfs: Fix getxattr kernel panic and memory overflow")
Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfs/nfs4xdr.c | 10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

diff --git a/fs/nfs/nfs4xdr.c b/fs/nfs/nfs4xdr.c
index b50c97c6aecb..fc5583531fc0 100644
--- a/fs/nfs/nfs4xdr.c
+++ b/fs/nfs/nfs4xdr.c
@@ -4160,12 +4160,10 @@ static int decode_attr_security_label(struct xdr_stream *xdr, uint32_t *bitmap,
 		if (unlikely(!p))
 			goto out_overflow;
 		if (len < NFS4_MAXLABELLEN) {
-			if (label) {
-				if (label->len) {
-					if (label->len < len)
-						return -ERANGE;
-					memcpy(label->label, p, len);
-				}
+			if (label && label->len) {
+				if (label->len < len)
+					return -ERANGE;
+				memcpy(label->label, p, len);
 				label->len = len;
 				label->pi = pi;
 				label->lfs = lfs;
-- 
2.35.1



