Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7E09C56FCC0
	for <lists+stable@lfdr.de>; Mon, 11 Jul 2022 11:47:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233633AbiGKJrl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Jul 2022 05:47:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49964 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233599AbiGKJrI (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 11 Jul 2022 05:47:08 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E8235B040;
        Mon, 11 Jul 2022 02:23:01 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 76D3C612FE;
        Mon, 11 Jul 2022 09:23:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 80D97C34115;
        Mon, 11 Jul 2022 09:22:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1657531379;
        bh=qA3BFqcQaxF/A7x7eR1efEtNeDX0omYnIc7NJ9zzW8Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=f77AsYbBAgys2v7v4dKZmzAEH28Dc7G8cIGPiex/2XzbT6j8TXVVIYF9xJRVAcTB9
         1bfCNXTuPA6EWGSh0k0AZoTwVi2GXrwvQnrzdQmO9i1IWNLRV5Ybh8yQ088Yk+U8zU
         QyTIH9bPiKC8F3WerjYIdH5dEixmmEPzP5HJvDuc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Andreas Gruenbacher <agruenba@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 083/230] gfs2: Fix gfs2_file_buffered_write endless loop workaround
Date:   Mon, 11 Jul 2022 11:05:39 +0200
Message-Id: <20220711090606.428962510@linuxfoundation.org>
X-Mailer: git-send-email 2.37.0
In-Reply-To: <20220711090604.055883544@linuxfoundation.org>
References: <20220711090604.055883544@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Andreas Gruenbacher <agruenba@redhat.com>

[ Upstream commit 46f3e0421ccb5474b5c006b0089b9dfd42534bb6 ]

Since commit 554c577cee95b, gfs2_file_buffered_write() can accidentally
return a truncated iov_iter, which might confuse callers.  Fix that.

Fixes: 554c577cee95b ("gfs2: Prevent endless loops in gfs2_file_buffered_write")
Signed-off-by: Andreas Gruenbacher <agruenba@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/gfs2/file.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/gfs2/file.c b/fs/gfs2/file.c
index 60390f9dc31f..e93185d804e0 100644
--- a/fs/gfs2/file.c
+++ b/fs/gfs2/file.c
@@ -1086,6 +1086,7 @@ static ssize_t gfs2_file_buffered_write(struct kiocb *iocb,
 	gfs2_holder_uninit(gh);
 	if (statfs_gh)
 		kfree(statfs_gh);
+	from->count = orig_count - read;
 	return read ? read : ret;
 }
 
-- 
2.35.1



