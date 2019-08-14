Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 066C28DB2B
	for <lists+stable@lfdr.de>; Wed, 14 Aug 2019 19:23:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729271AbfHNRIF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 14 Aug 2019 13:08:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:57854 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730046AbfHNRID (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 14 Aug 2019 13:08:03 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7C359208C2;
        Wed, 14 Aug 2019 17:08:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1565802483;
        bh=lcMozOM5yjam6HkNiqU50QQ7u0Xe0A4WXIsFCJZkTMQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2FeCKMVITp6V9QlcbF8QGilrzEcGDPEWX7THq/nQHO3kWTmdJ5B/XP2RbtxBlnD9t
         SKDYnZQNqSQOsYSYKHtOeauNE9Qm/aUrM7xtuNzLk3XXYK9+Z8VQa3xBIK4yXOQT7Z
         hRJW345m9drFWxf0Z2gQ4mQ93vWOcyFLZg8InfZA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Masahiro Yamada <yamada.masahiro@socionext.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.2 117/144] gen_compile_commands: lower the entry count threshold
Date:   Wed, 14 Aug 2019 19:01:13 +0200
Message-Id: <20190814165804.824720229@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190814165759.466811854@linuxfoundation.org>
References: <20190814165759.466811854@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit cb36955a5569f1ff17a42ae93264ef391c013a97 ]

Running gen_compile_commands.py after building the kernel with
allnoconfig gave this:

$ ./scripts/gen_compile_commands.py
WARNING: Found 449 entries. Have you compiled the kernel?

Signed-off-by: Masahiro Yamada <yamada.masahiro@socionext.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 scripts/gen_compile_commands.py | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/scripts/gen_compile_commands.py b/scripts/gen_compile_commands.py
index 7915823b92a5e..c458696ef3a79 100755
--- a/scripts/gen_compile_commands.py
+++ b/scripts/gen_compile_commands.py
@@ -21,9 +21,9 @@ _LINE_PATTERN = r'^cmd_[^ ]*\.o := (.* )([^ ]*\.c)$'
 _VALID_LOG_LEVELS = ['DEBUG', 'INFO', 'WARNING', 'ERROR', 'CRITICAL']
 
 # A kernel build generally has over 2000 entries in its compile_commands.json
-# database. If this code finds 500 or fewer, then warn the user that they might
+# database. If this code finds 300 or fewer, then warn the user that they might
 # not have all the .cmd files, and they might need to compile the kernel.
-_LOW_COUNT_THRESHOLD = 500
+_LOW_COUNT_THRESHOLD = 300
 
 
 def parse_arguments():
-- 
2.20.1



