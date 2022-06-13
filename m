Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BA6505490DD
	for <lists+stable@lfdr.de>; Mon, 13 Jun 2022 18:26:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238065AbiFMLQ5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Jun 2022 07:16:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36100 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353184AbiFMLPL (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Jun 2022 07:15:11 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE1021706C;
        Mon, 13 Jun 2022 03:37:44 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 67C82610A0;
        Mon, 13 Jun 2022 10:37:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 74790C34114;
        Mon, 13 Jun 2022 10:37:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655116663;
        bh=ZxbUcwez3WdEnE9tY/sNxfsE6rTp4gQ6TFB5pkMV2RI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gxrEoKg6Nv78L/lLL3vrYe/mSTsz5dCkvRu//X18lEmRKv7chzcqNnA68G00SwjIe
         TfScTzNH7fk5uKGtkom+sE2cxF26qs8rN+I8PsCS4t+ariMnAnMlODHyNR86rc+MUh
         PZ5BEeEj4BPMCDI570sa8aWn3u2odVHt/0ofzU3o=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Andreas Gruenbacher <agruenba@redhat.com>,
        "Darrick J. Wong" <djwong@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 128/411] iomap: iomap_write_failed fix
Date:   Mon, 13 Jun 2022 12:06:41 +0200
Message-Id: <20220613094932.510827363@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220613094928.482772422@linuxfoundation.org>
References: <20220613094928.482772422@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Andreas Gruenbacher <agruenba@redhat.com>

[ Upstream commit b71450e2cc4b3c79f33c5bd276d152af9bd54f79 ]

The @lend parameter of truncate_pagecache_range() should be the offset
of the last byte of the hole, not the first byte beyond it.

Fixes: ae259a9c8593 ("fs: introduce iomap infrastructure")
Signed-off-by: Andreas Gruenbacher <agruenba@redhat.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/iomap/buffered-io.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/iomap/buffered-io.c b/fs/iomap/buffered-io.c
index 5c73751adb2d..53cd7b2bb580 100644
--- a/fs/iomap/buffered-io.c
+++ b/fs/iomap/buffered-io.c
@@ -535,7 +535,8 @@ iomap_write_failed(struct inode *inode, loff_t pos, unsigned len)
 	 * write started inside the existing inode size.
 	 */
 	if (pos + len > i_size)
-		truncate_pagecache_range(inode, max(pos, i_size), pos + len);
+		truncate_pagecache_range(inode, max(pos, i_size),
+					 pos + len - 1);
 }
 
 static int
-- 
2.35.1



