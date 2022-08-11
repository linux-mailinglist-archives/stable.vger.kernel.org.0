Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4AAF8590316
	for <lists+stable@lfdr.de>; Thu, 11 Aug 2022 18:21:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237727AbiHKQUX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 11 Aug 2022 12:20:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59022 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237611AbiHKQTg (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 11 Aug 2022 12:19:36 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C635BF6C;
        Thu, 11 Aug 2022 09:01:27 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9604D60FA0;
        Thu, 11 Aug 2022 16:01:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 36F71C433D6;
        Thu, 11 Aug 2022 16:01:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1660233686;
        bh=qVINmhzz+PMqzGddv+GQJQiuKZ96c2yZCBIM0818SSk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=k9NZL4lGjGabnSKEysFM+l4itquqYUC6ashnkGa3Cti9okeNj3wf+kFMq7/31O5+I
         1GOjBE6/+cXBhbNPq2Bl407W5X0OjAKZnqlX9P6sipz1QGnsvsBuH0pCq65flE8tvo
         gZ2ZnlUlAZpO9e1wYM3FKjLXEO7WLTMdSs8C1++NJtgjQRPw3FvADyt+tTar7hR+Zf
         W9F3Dzg6QV5dUUo7wsJLHUEnl4bZcSU1h/RbZVH2tFCqXhdh4DsWdz9CpbPKycVtmz
         pxH+rC02Ff2lnPAX4r4xvgM15+LXpmszSFVA4GPtTyvzwt4jzug692IRmcjih6vgfe
         XoqiVgPlmBZ2w==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     David Reaver <me@davidreaver.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Sasha Levin <sashal@kernel.org>, mchehab@kernel.org
Subject: [PATCH AUTOSEL 5.15 42/69] scripts: get_feat.pl: use /usr/bin/env to find perl
Date:   Thu, 11 Aug 2022 11:55:51 -0400
Message-Id: <20220811155632.1536867-42-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220811155632.1536867-1-sashal@kernel.org>
References: <20220811155632.1536867-1-sashal@kernel.org>
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

From: David Reaver <me@davidreaver.com>

[ Upstream commit 2bc6430884d5ee0e30ae18652d31f821d8e9ec32 ]

I tried running `make pdfdocs` on NixOS, but it failed because
get_feat.pl uses a shebang line with /usr/bin/perl, and that file path
doesn't exist on NixOS. Using the more portable /usr/bin/env perl fixes
the problem.

Signed-off-by: David Reaver <me@davidreaver.com>
Link: https://lore.kernel.org/r/20220625211548.1200198-1-me@davidreaver.com
Signed-off-by: Jonathan Corbet <corbet@lwn.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 scripts/get_feat.pl | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/scripts/get_feat.pl b/scripts/get_feat.pl
index 457712355676..18d933f8bf9d 100755
--- a/scripts/get_feat.pl
+++ b/scripts/get_feat.pl
@@ -1,4 +1,4 @@
-#!/usr/bin/perl
+#!/usr/bin/env perl
 # SPDX-License-Identifier: GPL-2.0
 
 use strict;
-- 
2.35.1

