Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A735E59020B
	for <lists+stable@lfdr.de>; Thu, 11 Aug 2022 18:05:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237292AbiHKQC4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 11 Aug 2022 12:02:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58168 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237206AbiHKQCf (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 11 Aug 2022 12:02:35 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1EDA1B2DBF;
        Thu, 11 Aug 2022 08:49:58 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6976160A09;
        Thu, 11 Aug 2022 15:49:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D6CCC433C1;
        Thu, 11 Aug 2022 15:49:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1660232977;
        bh=2Qn+Sx9L2R/gcJM5MIhzFEiaDv+YJaCyn/9dOfkcXT4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=g4Q8V0zyp+gr6HUFeDAe6YifApLoDK8UBfzSnCtQZ2nl2v4G7XLuG2MHJul2kvzJb
         HWi6C6lsL7WGjdkwp7nP1x4Q6vLKrViqd5voTkzwL+2aKSqG7bvu1NhthWhh9Ictys
         D3bi1Dr3OM6QGDDinWoGq32I7bKhEJcRlkQqkH7LhveyLUDIWLPjbHtlY2h6Se1AI4
         B36+aPOXVDM87hRPvpAURkqAkCkbGrNmZIr73InXnU29Hr47dKZIujqXNkK5fFNvqZ
         OZAFjAoOa8wHcosmKGqq4TkVgsEt5Kk+s9Y5LJHGAxC1yj7iTE5xvA269l3vY7w9lh
         eXe8BB80GATHQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Al Viro <viro@zeniv.linux.org.uk>,
        Jeff Layton <jlayton@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 5.18 55/93] iov_iter_get_pages{,_alloc}(): cap the maxsize with MAX_RW_COUNT
Date:   Thu, 11 Aug 2022 11:41:49 -0400
Message-Id: <20220811154237.1531313-55-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220811154237.1531313-1-sashal@kernel.org>
References: <20220811154237.1531313-1-sashal@kernel.org>
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
index 0b64695ab632..ea588628828b 100644
--- a/lib/iov_iter.c
+++ b/lib/iov_iter.c
@@ -1520,6 +1520,8 @@ ssize_t iov_iter_get_pages(struct iov_iter *i,
 		maxsize = i->count;
 	if (!maxsize)
 		return 0;
+	if (maxsize > MAX_RW_COUNT)
+		maxsize = MAX_RW_COUNT;
 
 	if (likely(iter_is_iovec(i))) {
 		unsigned int gup_flags = 0;
@@ -1640,6 +1642,8 @@ ssize_t iov_iter_get_pages_alloc(struct iov_iter *i,
 		maxsize = i->count;
 	if (!maxsize)
 		return 0;
+	if (maxsize > MAX_RW_COUNT)
+		maxsize = MAX_RW_COUNT;
 
 	if (likely(iter_is_iovec(i))) {
 		unsigned int gup_flags = 0;
-- 
2.35.1

