Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D23112B652B
	for <lists+stable@lfdr.de>; Tue, 17 Nov 2020 14:54:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733231AbgKQNvs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Nov 2020 08:51:48 -0500
Received: from mail.kernel.org ([198.145.29.99]:39378 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731891AbgKQNaR (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 17 Nov 2020 08:30:17 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D122B2078E;
        Tue, 17 Nov 2020 13:30:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605619816;
        bh=xpxuWE5pO62/YMqkZ2nFUDwZHSXCZjj46pc1owWSEDs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=l0tqQ/LKt2B71OUJjyRIuETK53wv95LeBcXvkinyQJcRnMhNwgjq11RW+0/n9I62w
         TAPAtCPUT5xL9MBRT+v2cu6AqSriPuWSCf6ZAbcNQyYpIl3jC6Jiezfg6sESMnOWbz
         0nIXT12bLg+MyZl6Fizr2Sh+jsm2T0KdWzWkMAf4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, David Gow <davidgow@google.com>,
        Brendan Higgins <brendanhiggins@google.com>,
        Shuah Khan <skhan@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.9 014/255] kunit: Fix kunit.py --raw_output option
Date:   Tue, 17 Nov 2020 14:02:34 +0100
Message-Id: <20201117122139.634413840@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201117122138.925150709@linuxfoundation.org>
References: <20201117122138.925150709@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: David Gow <davidgow@google.com>

[ Upstream commit 3023d8ff3fc60e5d32dc1d05f99ad6ffa12b0033 ]

Due to the raw_output() function on kunit_parser.py actually being a
generator, it only runs if something reads the lines it returns. Since
we no-longer do that (parsing doesn't actually happen if raw_output is
enabled), it was not printing anything.

Fixes: 45ba7a893ad8 ("kunit: kunit_tool: Separate out config/build/exec/parse")
Signed-off-by: David Gow <davidgow@google.com>
Reviewed-by: Brendan Higgins <brendanhiggins@google.com>
Tested-by: Brendan Higgins <brendanhiggins@google.com>
Signed-off-by: Shuah Khan <skhan@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/kunit/kunit_parser.py | 1 -
 1 file changed, 1 deletion(-)

diff --git a/tools/testing/kunit/kunit_parser.py b/tools/testing/kunit/kunit_parser.py
index f13e0c0d66639..62a0848699671 100644
--- a/tools/testing/kunit/kunit_parser.py
+++ b/tools/testing/kunit/kunit_parser.py
@@ -65,7 +65,6 @@ def isolate_kunit_output(kernel_output):
 def raw_output(kernel_output):
 	for line in kernel_output:
 		print(line)
-		yield line
 
 DIVIDER = '=' * 60
 
-- 
2.27.0



