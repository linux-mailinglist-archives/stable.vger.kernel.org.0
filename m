Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 94D1B34DA3E
	for <lists+stable@lfdr.de>; Tue, 30 Mar 2021 00:22:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231985AbhC2WWQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Mar 2021 18:22:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:45820 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231825AbhC2WVo (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Mar 2021 18:21:44 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5EB2F6198E;
        Mon, 29 Mar 2021 22:21:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1617056504;
        bh=NhaI0SL/MmBSbRKlDCWdKIDuQX1aTMHOU7/UqAfc4yM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pOsPwZoHCHMeu09LSWG8PjBJEj6gQLRrVA1T41MtvupXRvuzSWMNoyaceZwqYdfIS
         e4QgEiRxKrytweDnUO3lrwdCIX0nGN3Mwy3Zs4gPbekYd3q6IW7RMx/7FRvEYLeZmD
         8RHz1UwZ0LOgWiZzlko0UKq2R1We/O5vO2pUPo2O/KPnGvv4BVECzjOeGiqc4niWM4
         FCFLWOFpJUk7/+Ra5gGHfenwj4j89qR1FNiPW1W5OIYoYoKbcsDtqXRAcr2s8W4U47
         gzVFKw2RM1feF35bQ+D556Nqk7HVJaQIde7+YCnEqCixYmTBvTxsiGqHjnmuMgSdKg
         RXFAOzw3gzpsg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     David Gow <davidgow@google.com>,
        Daniel Latypov <dlatypov@google.com>,
        Brendan Higgins <brendanhiggins@google.com>,
        Shuah Khan <skhan@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>,
        linux-kselftest@vger.kernel.org, kunit-dev@googlegroups.com
Subject: [PATCH AUTOSEL 5.11 08/38] kunit: tool: Fix a python tuple typing error
Date:   Mon, 29 Mar 2021 18:21:03 -0400
Message-Id: <20210329222133.2382393-8-sashal@kernel.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210329222133.2382393-1-sashal@kernel.org>
References: <20210329222133.2382393-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: David Gow <davidgow@google.com>

[ Upstream commit 7421b1a4d10c633ca5f14c8236d3e2c1de07e52b ]

The first argument to namedtuple() should match the name of the type,
which wasn't the case for KconfigEntryBase.

Fixing this is enough to make mypy show no python typing errors again.

Fixes 97752c39bd ("kunit: kunit_tool: Allow .kunitconfig to disable config items")
Signed-off-by: David Gow <davidgow@google.com>
Reviewed-by: Daniel Latypov <dlatypov@google.com>
Acked-by: Brendan Higgins <brendanhiggins@google.com>
Signed-off-by: Shuah Khan <skhan@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/kunit/kunit_config.py | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/kunit/kunit_config.py b/tools/testing/kunit/kunit_config.py
index bdd60230764b..27fe086d2d0d 100644
--- a/tools/testing/kunit/kunit_config.py
+++ b/tools/testing/kunit/kunit_config.py
@@ -13,7 +13,7 @@ from typing import List, Set
 CONFIG_IS_NOT_SET_PATTERN = r'^# CONFIG_(\w+) is not set$'
 CONFIG_PATTERN = r'^CONFIG_(\w+)=(\S+|".*")$'
 
-KconfigEntryBase = collections.namedtuple('KconfigEntry', ['name', 'value'])
+KconfigEntryBase = collections.namedtuple('KconfigEntryBase', ['name', 'value'])
 
 class KconfigEntry(KconfigEntryBase):
 
-- 
2.30.1

