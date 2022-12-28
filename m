Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0807F657E7E
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 16:54:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233220AbiL1PyN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 10:54:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41784 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233612AbiL1PyM (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 10:54:12 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7EC8E15F29
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 07:54:11 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1C1E461562
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 15:54:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2EF1FC433D2;
        Wed, 28 Dec 2022 15:54:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672242850;
        bh=O62DbBscuRieN2HTwu4+4z2wGQ/rMFZe4gk8Z8aF/Ms=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YqGdO2vWbufBi35xxIYr7b0mM1od/fAGqy66ffhcgG9kd+OVZH2KHht725804Eqna
         lg2Teql9NjmOjNgpKXln0cNfaAPefdbwJNK+0J96WLuQklhpp6T75ljOhVcAYtJ29u
         eiiMnw3v8sV4Jm30StwMm+Qs0/+7IntjaSBj5Bcw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Trond Myklebust <trond.myklebust@hammerspace.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0423/1146] NFSv4.2: Always decode the security label
Date:   Wed, 28 Dec 2022 15:32:42 +0100
Message-Id: <20221228144341.665646171@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144330.180012208@linuxfoundation.org>
References: <20221228144330.180012208@linuxfoundation.org>
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

[ Upstream commit c8a62f440229ae7a10874776344dfcc17d860336 ]

If the server returns a reply that includes a security label, then we
must decode it whether or not we can store the results.

Fixes: 1e2f67da8931 ("NFS: Remove the nfs4_label argument from decode_getattr_*() functions")
Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfs/nfs4xdr.c | 10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

diff --git a/fs/nfs/nfs4xdr.c b/fs/nfs/nfs4xdr.c
index 8c5298e37f0f..9103e022376a 100644
--- a/fs/nfs/nfs4xdr.c
+++ b/fs/nfs/nfs4xdr.c
@@ -4755,12 +4755,10 @@ static int decode_getfattr_attrs(struct xdr_stream *xdr, uint32_t *bitmap,
 	if (status < 0)
 		goto xdr_error;
 
-	if (fattr->label) {
-		status = decode_attr_security_label(xdr, bitmap, fattr->label);
-		if (status < 0)
-			goto xdr_error;
-		fattr->valid |= status;
-	}
+	status = decode_attr_security_label(xdr, bitmap, fattr->label);
+	if (status < 0)
+		goto xdr_error;
+	fattr->valid |= status;
 
 xdr_error:
 	dprintk("%s: xdr returned %d\n", __func__, -status);
-- 
2.35.1



