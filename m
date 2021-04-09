Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2EFD8359B1F
	for <lists+stable@lfdr.de>; Fri,  9 Apr 2021 12:07:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234126AbhDIKHj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 9 Apr 2021 06:07:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:50620 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234207AbhDIKFM (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 9 Apr 2021 06:05:12 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3A5C261220;
        Fri,  9 Apr 2021 10:01:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1617962498;
        bh=2bBfFwl2STD3U2v71d89twdNtHHGFFxTU9BETJfBpso=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=i65Fd4LtFqa0eIgNFZjpgJ7uU+xWghocc1HJrXoFmXsT42GUnIQwQK7v7a49nbON+
         tFxfdpfra9YXWCLnH/E8cJo3NJ1q1Q9KJr6H+/hHon+nvF+AJn17K32QMl7PYH4xCC
         GsmOj0bBiAKK/3Ef6E73Jh8/sSFrSofG7ZCOs3vI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, David Gow <davidgow@google.com>,
        Daniel Latypov <dlatypov@google.com>,
        Brendan Higgins <brendanhiggins@google.com>,
        Shuah Khan <skhan@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 08/45] kunit: tool: Fix a python tuple typing error
Date:   Fri,  9 Apr 2021 11:53:34 +0200
Message-Id: <20210409095305.656480586@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210409095305.397149021@linuxfoundation.org>
References: <20210409095305.397149021@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
2.30.2



