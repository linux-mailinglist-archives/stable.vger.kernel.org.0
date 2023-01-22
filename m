Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9C2D6676F74
	for <lists+stable@lfdr.de>; Sun, 22 Jan 2023 16:22:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231288AbjAVPWI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 22 Jan 2023 10:22:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49520 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231289AbjAVPWF (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 22 Jan 2023 10:22:05 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 786D422795
        for <stable@vger.kernel.org>; Sun, 22 Jan 2023 07:21:41 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E260C60C64
        for <stable@vger.kernel.org>; Sun, 22 Jan 2023 15:21:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 00F66C433EF;
        Sun, 22 Jan 2023 15:21:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1674400896;
        bh=eiQNqA92x9v1MGl4YClQ6n1QZApY+mCVJDS8aNI0cRk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=M1rTVnDP0TccKZADJE/SC30GRPYoUrdqeXfKHYVviSaFYe3ld9wS3YeugWdBie+I4
         Oj0nNi4k1YK5pLGOXWDxu/UPTS5mOLTFpVhLWhxvyy+dtOVDVyAFmVJfFbJjo/67W4
         mes5S9a9WclMLAOqqr6Ij6xbq3frLrl7ydmwX7Sk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Olga Kornievskaia <kolga@netapp.com>,
        Trond Myklebust <trond.myklebust@hammerspace.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 004/193] pNFS/filelayout: Fix coalescing test for single DS
Date:   Sun, 22 Jan 2023 16:02:13 +0100
Message-Id: <20230122150246.547513092@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230122150246.321043584@linuxfoundation.org>
References: <20230122150246.321043584@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Olga Kornievskaia <olga.kornievskaia@gmail.com>

[ Upstream commit a6b9d2fa0024e7e399c26facd0fb466b7396e2b9 ]

When there is a single DS no striping constraints need to be placed on
the IO. When such constraint is applied then buffered reads don't
coalesce to the DS's rsize.

Signed-off-by: Olga Kornievskaia <kolga@netapp.com>
Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfs/filelayout/filelayout.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/fs/nfs/filelayout/filelayout.c b/fs/nfs/filelayout/filelayout.c
index ad34a33b0737..4974cd18ca46 100644
--- a/fs/nfs/filelayout/filelayout.c
+++ b/fs/nfs/filelayout/filelayout.c
@@ -783,6 +783,12 @@ filelayout_alloc_lseg(struct pnfs_layout_hdr *layoutid,
 	return &fl->generic_hdr;
 }
 
+static bool
+filelayout_lseg_is_striped(const struct nfs4_filelayout_segment *flseg)
+{
+	return flseg->num_fh > 1;
+}
+
 /*
  * filelayout_pg_test(). Called by nfs_can_coalesce_requests()
  *
@@ -803,6 +809,8 @@ filelayout_pg_test(struct nfs_pageio_descriptor *pgio, struct nfs_page *prev,
 	size = pnfs_generic_pg_test(pgio, prev, req);
 	if (!size)
 		return 0;
+	else if (!filelayout_lseg_is_striped(FILELAYOUT_LSEG(pgio->pg_lseg)))
+		return size;
 
 	/* see if req and prev are in the same stripe */
 	if (prev) {
-- 
2.35.1



