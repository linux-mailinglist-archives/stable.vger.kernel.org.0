Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2015459003E
	for <lists+stable@lfdr.de>; Thu, 11 Aug 2022 17:40:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235977AbiHKPjP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 11 Aug 2022 11:39:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57696 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235990AbiHKPim (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 11 Aug 2022 11:38:42 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D532296740;
        Thu, 11 Aug 2022 08:34:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 950BAB82144;
        Thu, 11 Aug 2022 15:34:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 79A41C433C1;
        Thu, 11 Aug 2022 15:34:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1660232053;
        bh=zijP+AVIy0dgvEkwWHz9o8PrQqVQPjAw+9yR4pEOzbM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VxtluH0mXes8tIOggxpPu1AY8u0e+donDV7zPO6tC+XCdBbwQL/5jb0sNfvRjRieH
         ErZkEvh3q7UefBUmwDyo31kjyyWreblhR9OoHsD3yKCwMFT6lf10viVX5Lg8SNag83
         jiNgK0ZkKLQksFlYs5WrhOZQtVSm6/6qLbv74mMEctTeb9KT1ALIGMSTYQP8oPBBaB
         rgF+IaRHOb/z8IF1vBw4nCkxZ140X7YwVFpjl6u4C2s+VOFlV5J4ZJWHZLi67z4Ioj
         hqu7cEsMw0KIzkjyUt7/uCqNJxXcmzDDztxYKNAvG+Lqirv5zcqdvatDp3rU07sWFl
         ECNeboAbUYw/A==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     David Reaver <me@davidreaver.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Sasha Levin <sashal@kernel.org>, mchehab@kernel.org
Subject: [PATCH AUTOSEL 5.19 055/105] scripts: get_feat.pl: use /usr/bin/env to find perl
Date:   Thu, 11 Aug 2022 11:27:39 -0400
Message-Id: <20220811152851.1520029-55-sashal@kernel.org>
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
index 76cfb96b59b6..5c5397eeb237 100755
--- a/scripts/get_feat.pl
+++ b/scripts/get_feat.pl
@@ -1,4 +1,4 @@
-#!/usr/bin/perl
+#!/usr/bin/env perl
 # SPDX-License-Identifier: GPL-2.0
 
 use strict;
-- 
2.35.1

