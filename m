Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 65F2645C4E6
	for <lists+stable@lfdr.de>; Wed, 24 Nov 2021 14:49:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354751AbhKXNw5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Nov 2021 08:52:57 -0500
Received: from mail.kernel.org ([198.145.29.99]:40066 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1354510AbhKXNu4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Nov 2021 08:50:56 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8DDDF613A2;
        Wed, 24 Nov 2021 13:04:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637759053;
        bh=6jzrpu1IB4KzL64Cup0k7+yPjn+oPFXAfrXYbuACXSY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yADNEZ7/fmAI6MytwyW7F9adhFvX5woHiuNsQNJo68FJHbJKPASYS0szmDEajlBoC
         +UJASD7KBFxe/vRcrBpZEE6XIQSKBE7kuxqMWcGvd2+fEKGQCK6Vjj2P6DecjwKWi1
         qFZfl7TLYlyuU9O+RlC6925gSL3VbCwCs2PWIDFw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, kernel test robot <lkp@intel.com>,
        Li Zhijian <lizhijian@cn.fujitsu.com>,
        Kent Gibson <warthog618@gmail.com>,
        Bartosz Golaszewski <brgl@bgdev.pl>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 116/279] selftests: gpio: fix gpio compiling error
Date:   Wed, 24 Nov 2021 12:56:43 +0100
Message-Id: <20211124115722.799599054@linuxfoundation.org>
X-Mailer: git-send-email 2.34.0
In-Reply-To: <20211124115718.776172708@linuxfoundation.org>
References: <20211124115718.776172708@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Li Zhijian <lizhijian@cn.fujitsu.com>

[ Upstream commit 92a59d7f381d2caf69385bfa00590028e32eea26 ]

The gpio selftests build against the system includes rather than the
headers from the linux tree.  This results in the compile failing if
the system includes are outdated.

Prefer the headers from the linux tree, as per other selftests.

Fixes: 8bc395a6a2e2 ("selftests: gpio: rework and simplify test implementation")
Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: Li Zhijian <lizhijian@cn.fujitsu.com>
[Kent: reworded commit comment and added Fixes:]
Signed-off-by: Kent Gibson <warthog618@gmail.com>
Signed-off-by: Bartosz Golaszewski <brgl@bgdev.pl>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/gpio/Makefile | 1 +
 1 file changed, 1 insertion(+)

diff --git a/tools/testing/selftests/gpio/Makefile b/tools/testing/selftests/gpio/Makefile
index 39f2bbe8dd3df..42ea7d2aa8440 100644
--- a/tools/testing/selftests/gpio/Makefile
+++ b/tools/testing/selftests/gpio/Makefile
@@ -3,5 +3,6 @@
 TEST_PROGS := gpio-mockup.sh
 TEST_FILES := gpio-mockup-sysfs.sh
 TEST_GEN_PROGS_EXTENDED := gpio-mockup-cdev
+CFLAGS += -I../../../../usr/include
 
 include ../lib.mk
-- 
2.33.0



