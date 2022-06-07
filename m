Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D8C54540624
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 19:34:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347161AbiFGRds (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 13:33:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39720 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347511AbiFGRat (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 13:30:49 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4DBF1F5502;
        Tue,  7 Jun 2022 10:27:11 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CE50060906;
        Tue,  7 Jun 2022 17:27:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E1DB6C385A5;
        Tue,  7 Jun 2022 17:27:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654622830;
        bh=gQN9moGRLrnOzCRzusZ5LSPrgH65OK3ea7YSNgedsgk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VvNUVoiJWzW32rT37w31ckle6hcdfdFEMMA9EOw8BG4wpJZtCuCpztWTT92wkwTVz
         kNd/ktZcFG/RRUbGlJ/MfglgF6p133katTyTsAFaCWfUtYGrGKCg2jMSGKYpCsulsi
         jJcg+XXTdPaIbzBQGBT2TLztHbgyI1xbs8YgCg7I=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Andreas Gruenbacher <agruenba@redhat.com>,
        "Darrick J. Wong" <djwong@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 196/452] iomap: iomap_write_failed fix
Date:   Tue,  7 Jun 2022 19:00:53 +0200
Message-Id: <20220607164914.405791789@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607164908.521895282@linuxfoundation.org>
References: <20220607164908.521895282@linuxfoundation.org>
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
index cd9f7baa5bb7..dd33b31b0a82 100644
--- a/fs/iomap/buffered-io.c
+++ b/fs/iomap/buffered-io.c
@@ -528,7 +528,8 @@ iomap_write_failed(struct inode *inode, loff_t pos, unsigned len)
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



