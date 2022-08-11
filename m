Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DDC555904EE
	for <lists+stable@lfdr.de>; Thu, 11 Aug 2022 18:49:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237550AbiHKQhS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 11 Aug 2022 12:37:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52598 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239239AbiHKQgi (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 11 Aug 2022 12:36:38 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5EE2989839;
        Thu, 11 Aug 2022 09:11:57 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D7F876147D;
        Thu, 11 Aug 2022 16:11:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF22BC433D6;
        Thu, 11 Aug 2022 16:11:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1660234316;
        bh=F4uvCad/1BCLxgS9pmSKTphS/Hg/xghqqFmhW47YyAw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=E8djzqBa9mowiz8oedZ+Wk4GrNDcnuVOujHZhzv0nTzOitO70uqIiT0DJc+JVZTzs
         vHYGVGyfBNKZ5Hq7MM3wsfFquWKfeSCClw/rm0MjZKIfg4hTWluQWL+g8tyHReN4lf
         hKR2+ULAkpcIPMWbr0uSzXm92h2sMduSRFn0tIEAiU1tGijLBUTcm+yf2kMeELm++h
         4DcDgCAJOwcKhZ34PyZWK3dD/H0VyMlG0vOVaYr5wuXTdn9et3egsHFu8dpJP78JKS
         mmu16ACEgRSzFeWWAIq+W+qh4R7f9c7uvRfKQysfO8WfTrabMsYVEbId+0kBZwdKFV
         ebhW6FBe42HlA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Al Viro <viro@zeniv.linux.org.uk>,
        Jeff Layton <jlayton@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 4.9 06/12] iov_iter_get_pages{,_alloc}(): cap the maxsize with MAX_RW_COUNT
Date:   Thu, 11 Aug 2022 12:11:32 -0400
Message-Id: <20220811161144.1543598-6-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220811161144.1543598-1-sashal@kernel.org>
References: <20220811161144.1543598-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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

From: Al Viro <viro@zeniv.linux.org.uk>

[ Upstream commit 7392ed1734c319150b5ddec3f192a6405728e8d0 ]

All callers can and should handle iov_iter_get_pages() returning
fewer pages than requested.  All in-kernel ones do.  And it makes
the arithmetical overflow analysis much simpler...

Reviewed-by: Jeff Layton <jlayton@kernel.org>
Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 lib/iov_iter.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/lib/iov_iter.c b/lib/iov_iter.c
index e01bb1c51d87..c4b9896422ae 100644
--- a/lib/iov_iter.c
+++ b/lib/iov_iter.c
@@ -951,6 +951,8 @@ ssize_t iov_iter_get_pages(struct iov_iter *i,
 
 	if (!maxsize)
 		return 0;
+	if (maxsize > MAX_RW_COUNT)
+		maxsize = MAX_RW_COUNT;
 
 	if (unlikely(i->type & ITER_PIPE))
 		return pipe_get_pages(i, pages, maxsize, maxpages, start);
@@ -1031,6 +1033,8 @@ ssize_t iov_iter_get_pages_alloc(struct iov_iter *i,
 
 	if (!maxsize)
 		return 0;
+	if (maxsize > MAX_RW_COUNT)
+		maxsize = MAX_RW_COUNT;
 
 	if (unlikely(i->type & ITER_PIPE))
 		return pipe_get_pages_alloc(i, pages, maxsize, start);
-- 
2.35.1

