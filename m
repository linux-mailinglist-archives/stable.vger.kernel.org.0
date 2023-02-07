Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C9AAC68D770
	for <lists+stable@lfdr.de>; Tue,  7 Feb 2023 14:00:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231967AbjBGM7u (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Feb 2023 07:59:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45046 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231977AbjBGM7p (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Feb 2023 07:59:45 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B92921A2E
        for <stable@vger.kernel.org>; Tue,  7 Feb 2023 04:59:45 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BC016613EF
        for <stable@vger.kernel.org>; Tue,  7 Feb 2023 12:59:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF094C433D2;
        Tue,  7 Feb 2023 12:59:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1675774784;
        bh=wEq3xTnrr2wqBm5536SFXOcTYfD8vUjYjzXfKukwGko=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kKKbdKhQwC+v8FJ/56BWTHDjxyEq8VhZB+6zKM4ZlpAA8iuN7WDMd4psdZHfJG79m
         UjmWI/fikiJFkwt20fH0pWnKa8Vp7PT60S8/NWQMHsikZjqNKAj/2MNKkP0LYNdme0
         9t8w4yyTCrR3bqDdhrdR8bNgbp6Ke19GlItf7zAI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Al Viro <viro@zeniv.linux.org.uk>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 033/208] zcore: WRITE is "data source", not destination...
Date:   Tue,  7 Feb 2023 13:54:47 +0100
Message-Id: <20230207125635.814136639@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230207125634.292109991@linuxfoundation.org>
References: <20230207125634.292109991@linuxfoundation.org>
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

From: Al Viro <viro@zeniv.linux.org.uk>

[ Upstream commit 4ba48e1bae5f68af24d8d71d4f28de9eb658af1d ]

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
Stable-dep-of: 6dd88fd59da8 ("vhost-scsi: unbreak any layout for response")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/s390/char/zcore.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/s390/char/zcore.c b/drivers/s390/char/zcore.c
index 6165e6aae762..83ddac1e5838 100644
--- a/drivers/s390/char/zcore.c
+++ b/drivers/s390/char/zcore.c
@@ -103,7 +103,7 @@ static inline int memcpy_hsa_kernel(void *dst, unsigned long src, size_t count)
 
 	kvec.iov_base = dst;
 	kvec.iov_len = count;
-	iov_iter_kvec(&iter, WRITE, &kvec, 1, count);
+	iov_iter_kvec(&iter, READ, &kvec, 1, count);
 	if (memcpy_hsa_iter(&iter, src, count) < count)
 		return -EIO;
 	return 0;
-- 
2.39.0



