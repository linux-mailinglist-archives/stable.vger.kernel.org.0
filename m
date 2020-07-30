Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B57D5232DF9
	for <lists+stable@lfdr.de>; Thu, 30 Jul 2020 10:16:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729331AbgG3IQG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 Jul 2020 04:16:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:50742 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729556AbgG3IL1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 30 Jul 2020 04:11:27 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5CCFC2074B;
        Thu, 30 Jul 2020 08:11:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1596096686;
        bh=WVGseNld/B1+IQwECE9FwtgVtrQctphA6KMqHwfC9lk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=O/pHUYMcSxI4HWhUvytln0vS545DwTibF9iXsQaGSRz7OqAnqcIsL70bxih0a1AOl
         BZF/cB5aZMP33bmqFAo2QlVyJ/MQsJY7fz3ruqbebn4B78tpwGtluiz+GJ3/KCLvf2
         QxFGnbTWkaxFkc/P0pFJ/nN0VyChInJCPk2QwFmo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Pi-Hsun Shih <pihsun@chromium.org>,
        Shik Chen <shik@chromium.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Stephen Boyd <swboyd@chromium.org>,
        Sasha Levin <sashal@kernel.org>,
        Nicolas Boichat <drinkcat@chromium.org>,
        Jiri Slaby <jslaby@suse.cz>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 4.4 21/54] scripts/decode_stacktrace: strip basepath from all paths
Date:   Thu, 30 Jul 2020 10:05:00 +0200
Message-Id: <20200730074422.227700703@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200730074421.203879987@linuxfoundation.org>
References: <20200730074421.203879987@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pi-Hsun Shih <pihsun@chromium.org>

[ Upstream commit d178770d8d21489abf5bafefcbb6d5243b482e9a ]

Currently the basepath is removed only from the beginning of the string.
When the symbol is inlined and there's multiple line outputs of
addr2line, only the first line would have basepath removed.

Change to remove the basepath prefix from all lines.

Fixes: 31013836a71e ("scripts/decode_stacktrace: match basepath using shell prefix operator, not regex")
Co-developed-by: Shik Chen <shik@chromium.org>
Signed-off-by: Pi-Hsun Shih <pihsun@chromium.org>
Signed-off-by: Shik Chen <shik@chromium.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Stephen Boyd <swboyd@chromium.org>
Cc: Sasha Levin <sashal@kernel.org>
Cc: Nicolas Boichat <drinkcat@chromium.org>
Cc: Jiri Slaby <jslaby@suse.cz>
Link: http://lkml.kernel.org/r/20200720082709.252805-1-pihsun@chromium.org
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 scripts/decode_stacktrace.sh | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/scripts/decode_stacktrace.sh b/scripts/decode_stacktrace.sh
index 4f5e76f76b9dc..003968cb04d4a 100755
--- a/scripts/decode_stacktrace.sh
+++ b/scripts/decode_stacktrace.sh
@@ -63,8 +63,8 @@ parse_symbol() {
 		return
 	fi
 
-	# Strip out the base of the path
-	code=${code#$basepath/}
+	# Strip out the base of the path on each line
+	code=$(while read -r line; do echo "${line#$basepath/}"; done <<< "$code")
 
 	# In the case of inlines, move everything to same line
 	code=${code//$'\n'/' '}
-- 
2.25.1



