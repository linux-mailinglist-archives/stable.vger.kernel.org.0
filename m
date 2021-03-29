Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0832D34DA95
	for <lists+stable@lfdr.de>; Tue, 30 Mar 2021 00:25:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231928AbhC2WW6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Mar 2021 18:22:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:46650 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232134AbhC2WWe (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Mar 2021 18:22:34 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2D6E5619A0;
        Mon, 29 Mar 2021 22:22:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1617056551;
        bh=MHwa5JohzyHavIM4/OUmGPozr92pgczCuttU/ev3D8Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VwegJBgAP+47oukFPQwZW+hTFtILOSgueV7dOowdWXq9284/ZiN7jVOxY9Hm+3/oJ
         AZMfAjuOCaxysbHpAVpi511wRuv9ra2zrYlwdiT1jrJpeTzeyjZAaW+Kituxwf+lL9
         S9+dHQNTeEPzpwVB63QOSjyt2vjK8dVcgkFEFSM/fcDKThJmp/YrM0Ws6/QEMb4CZh
         DkXR9S4ONl0Nx0b7c+J7oisWkEieVhU6uO0HoTfDw4VkDti+FdltvtIBP44o5Z/Snh
         hwrN4gu3lreDN8wN6EGoOJPhWLeNusLWiyrUigMXsQ6GD3Jr6SAvcUczG8+QCwh+T5
         Wc7e/V5TdzxMA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     David Gow <davidgow@google.com>,
        Daniel Latypov <dlatypov@google.com>,
        Brendan Higgins <brendanhiggins@google.com>,
        Shuah Khan <skhan@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>,
        linux-kselftest@vger.kernel.org, kunit-dev@googlegroups.com
Subject: [PATCH AUTOSEL 5.10 07/33] kunit: tool: Fix a python tuple typing error
Date:   Mon, 29 Mar 2021 18:21:55 -0400
Message-Id: <20210329222222.2382987-7-sashal@kernel.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210329222222.2382987-1-sashal@kernel.org>
References: <20210329222222.2382987-1-sashal@kernel.org>
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
index 02ffc3a3e5dc..b30e9d6db6b4 100644
--- a/tools/testing/kunit/kunit_config.py
+++ b/tools/testing/kunit/kunit_config.py
@@ -12,7 +12,7 @@ import re
 CONFIG_IS_NOT_SET_PATTERN = r'^# CONFIG_(\w+) is not set$'
 CONFIG_PATTERN = r'^CONFIG_(\w+)=(\S+|".*")$'
 
-KconfigEntryBase = collections.namedtuple('KconfigEntry', ['name', 'value'])
+KconfigEntryBase = collections.namedtuple('KconfigEntryBase', ['name', 'value'])
 
 class KconfigEntry(KconfigEntryBase):
 
-- 
2.30.1

