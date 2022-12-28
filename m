Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5C104657EAA
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 16:56:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234180AbiL1P4Y (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 10:56:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44228 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234204AbiL1P4L (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 10:56:11 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 94BBD644F
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 07:56:02 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 091B8B8171C
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 15:56:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5502DC433D2;
        Wed, 28 Dec 2022 15:55:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672242959;
        bh=8dTnNC3owmHgJcwS36gZ32Srf3hhV0RyQCfB7G7HIMo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yayySYEn5dye6YIQUWKEpISDYfYcQx+jQc4CmwZe8KqAAI7IqVsmCBMYbMhoLJht2
         MuXStk++nDUz2f2YIe2thdX9hGLEJ3lQFgwS7FWa+fy13hGUOOIufjmlXpVf0VuItf
         aW78EmBUATbNClW6BXEL8qLOkhJRtNnZKsUfAJh0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Anna Schumaker <Anna.Schumaker@Netapp.com>,
        Trond Myklebust <trond.myklebust@hammerspace.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 0473/1073] NFSv4.2: Set the correct size scratch buffer for decoding READ_PLUS
Date:   Wed, 28 Dec 2022 15:34:21 +0100
Message-Id: <20221228144340.882956183@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144328.162723588@linuxfoundation.org>
References: <20221228144328.162723588@linuxfoundation.org>
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

From: Anna Schumaker <Anna.Schumaker@Netapp.com>

[ Upstream commit 36357fe74ef736524a29fbd3952948768510a8b9 ]

The scratch_buf array is 16 bytes, but I was passing 32 to the
xdr_set_scratch_buffer() function. Fix this by using sizeof(), which is
what I probably should have been doing this whole time.

Fixes: d3b00a802c84 ("NFS: Replace the READ_PLUS decoding code")
Signed-off-by: Anna Schumaker <Anna.Schumaker@Netapp.com>
Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfs/nfs42xdr.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/nfs/nfs42xdr.c b/fs/nfs/nfs42xdr.c
index b56f05113d36..f742c7a5745e 100644
--- a/fs/nfs/nfs42xdr.c
+++ b/fs/nfs/nfs42xdr.c
@@ -1134,7 +1134,7 @@ static int decode_read_plus(struct xdr_stream *xdr, struct nfs_pgio_res *res)
 	if (!segs)
 		return -ENOMEM;
 
-	xdr_set_scratch_buffer(xdr, &scratch_buf, 32);
+	xdr_set_scratch_buffer(xdr, &scratch_buf, sizeof(scratch_buf));
 	status = -EIO;
 	for (i = 0; i < segments; i++) {
 		status = decode_read_plus_segment(xdr, &segs[i]);
-- 
2.35.1



