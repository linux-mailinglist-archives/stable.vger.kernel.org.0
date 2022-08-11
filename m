Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AC439590074
	for <lists+stable@lfdr.de>; Thu, 11 Aug 2022 17:43:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236108AbiHKPlo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 11 Aug 2022 11:41:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41128 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236074AbiHKPk0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 11 Aug 2022 11:40:26 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F5EC74CFD;
        Thu, 11 Aug 2022 08:36:07 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0874F6164A;
        Thu, 11 Aug 2022 15:36:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C5F6EC433C1;
        Thu, 11 Aug 2022 15:36:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1660232166;
        bh=2Qn+Sx9L2R/gcJM5MIhzFEiaDv+YJaCyn/9dOfkcXT4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QzwbMGRn0xW0g2ErZnpa4WFLcIjNykpm4/AInvqV7QJeqY2ytzhdcqB9qhT+bek8w
         S/gqmHpzHrLuUXkdnwe5lqzEGFGt+qr9teCO+ShljwgloCnJXV5pMSy0EmtN7mglld
         khkQGzt0IbAQjUpfDW10L40lafgGwGbfULrfLSOg/38FVwluMsimo4z92xim/x5R0+
         D/r0l1r9FP0PTI9BCW06mGDldLz8jSpV7uNgV1ShO68Gey1aGqwDYtDL198m66rK22
         ahpvRsCJrMQQz91gwSwtr706vn0GZQAu7UFyt9YHh2xO9/6O75TCluhDPycWa3gaZQ
         4JhgZkF2oKd4Q==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Al Viro <viro@zeniv.linux.org.uk>,
        Jeff Layton <jlayton@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 5.19 061/105] iov_iter_get_pages{,_alloc}(): cap the maxsize with MAX_RW_COUNT
Date:   Thu, 11 Aug 2022 11:27:45 -0400
Message-Id: <20220811152851.1520029-61-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220811152851.1520029-1-sashal@kernel.org>
References: <20220811152851.1520029-1-sashal@kernel.org>
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

