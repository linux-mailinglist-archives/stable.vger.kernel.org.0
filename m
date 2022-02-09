Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D381D4AFA9A
	for <lists+stable@lfdr.de>; Wed,  9 Feb 2022 19:39:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239925AbiBISij (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 9 Feb 2022 13:38:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53560 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239903AbiBISiQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 9 Feb 2022 13:38:16 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D4A7C05CB9E;
        Wed,  9 Feb 2022 10:38:08 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4045FB82384;
        Wed,  9 Feb 2022 18:38:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 16482C340F1;
        Wed,  9 Feb 2022 18:38:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1644431886;
        bh=6TGHFzWoBF8VCHFHfVRCuz5fx3lT8j5ALTDaaJYk2OE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Qw0Etd3tRlKn+qSj1d1+xKSpVuGcFfD8XwQD3pUjnOwiM03pSrjPWXyaaioxsnvSY
         cGe0IXsGfv6/MXrE/6k916i9Xq/knwzyZ6cJPx3nwT6AlN/xDJyx68HxpiziOYzxm1
         UNYLXk8gXDkaqcpUsxTD/tR3YSgmrY/XB4FBaiMUpsr76RCH93+Qpea4gBUINGMKbV
         sl7ivfU1DxyIt5jwnUN4RB48vMKmW+QAqoR7knfwKw6OUMpdtcFaXms3cZ4jGbEFEB
         aNtuEak4/ol2BBMJ+eWx2UMZK8utWzt/FQIW8YzEgbwC58R8tmdxi9GkEnLmTGapal
         33J2lzjT57n7g==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     =?UTF-8?q?Micha=C5=82=20Winiarski?= <michal.winiarski@intel.com>,
        Daniel Latypov <dlatypov@google.com>,
        Brendan Higgins <brendanhiggins@google.com>,
        Shuah Khan <skhan@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>,
        linux-kselftest@vger.kernel.org, kunit-dev@googlegroups.com
Subject: [PATCH AUTOSEL 5.15 03/36] kunit: tool: Import missing importlib.abc
Date:   Wed,  9 Feb 2022 13:37:26 -0500
Message-Id: <20220209183759.47134-3-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220209183759.47134-1-sashal@kernel.org>
References: <20220209183759.47134-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Michał Winiarski <michal.winiarski@intel.com>

[ Upstream commit 235528072f28b3b0a1446279b7eaddda36dbf743 ]

Python 3.10.0 contains:
9e09849d20 ("bpo-41006: importlib.util no longer imports typing (GH-20938)")

It causes importlib.util to no longer import importlib.abs, which leads
to the following error when trying to use kunit with qemu:
AttributeError: module 'importlib' has no attribute 'abc'. Did you mean: '_abc'?

Add the missing import.

Signed-off-by: Michał Winiarski <michal.winiarski@intel.com>
Reviewed-by: Daniel Latypov <dlatypov@google.com>
Reviewed-by: Brendan Higgins <brendanhiggins@google.com>
Signed-off-by: Shuah Khan <skhan@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/kunit/kunit_kernel.py | 1 +
 1 file changed, 1 insertion(+)

diff --git a/tools/testing/kunit/kunit_kernel.py b/tools/testing/kunit/kunit_kernel.py
index 2c6f916ccbafa..0874e512d109b 100644
--- a/tools/testing/kunit/kunit_kernel.py
+++ b/tools/testing/kunit/kunit_kernel.py
@@ -6,6 +6,7 @@
 # Author: Felix Guo <felixguoxiuping@gmail.com>
 # Author: Brendan Higgins <brendanhiggins@google.com>
 
+import importlib.abc
 import importlib.util
 import logging
 import subprocess
-- 
2.34.1

