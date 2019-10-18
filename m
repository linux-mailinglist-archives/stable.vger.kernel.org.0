Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B8E93DD48E
	for <lists+stable@lfdr.de>; Sat, 19 Oct 2019 00:26:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728291AbfJRWEc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 18 Oct 2019 18:04:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:36190 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728266AbfJRWEb (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 18 Oct 2019 18:04:31 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 014B8222D3;
        Fri, 18 Oct 2019 22:04:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1571436270;
        bh=XMB82K2xXOWsCRusDL8vhZUFHGoHirItflBZMUYFA0A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pE5uUkz1W+XBAV1hHvFx6JzZDlCV1t2AzbYmhkXrivrn6deBsA1jjbUYLulRwZNzJ
         w8uJ7st7AIjRXFhwCXNMqjoeWgwFzlMWJZIId31eWUJzA4iErsh6Z0zX1gMKNrAYSw
         Co5UN7l09IVDbTCnuvbaZJJqFtlu+vrl9Ik7EPYY=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Masahiro Yamada <yamada.masahiro@socionext.com>,
        Matthias Maennich <maennich@google.com>,
        Jessica Yu <jeyu@kernel.org>, Sasha Levin <sashal@kernel.org>,
        linux-kbuild@vger.kernel.org
Subject: [PATCH AUTOSEL 5.3 50/89] kbuild: fix build error of 'make nsdeps' in clean tree
Date:   Fri, 18 Oct 2019 18:02:45 -0400
Message-Id: <20191018220324.8165-50-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191018220324.8165-1-sashal@kernel.org>
References: <20191018220324.8165-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Masahiro Yamada <yamada.masahiro@socionext.com>

[ Upstream commit d85103ac78a6d8573b21348b36f4cca2e1839a31 ]

Running 'make nsdeps' in a clean source tree fails as follows:

$ make -s clean; make -s defconfig; make nsdeps
   [ snip ]
awk: fatal: cannot open file `init/modules.order' for reading (No such file or directory)
make: *** [Makefile;1307: modules.order] Error 2
make: *** Deleting file 'modules.order'
make: *** Waiting for unfinished jobs....

The cause of the error is 'make nsdeps' does not build modules at all.
Set KBUILD_MODULES to fix it.

Reviewed-by: Matthias Maennich <maennich@google.com>
Signed-off-by: Masahiro Yamada <yamada.masahiro@socionext.com>
Signed-off-by: Jessica Yu <jeyu@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 Makefile | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Makefile b/Makefile
index d7469f0926a67..62b9640d007a0 100644
--- a/Makefile
+++ b/Makefile
@@ -594,7 +594,7 @@ endif
 # in addition to whatever we do anyway.
 # Just "make" or "make all" shall build modules as well
 
-ifneq ($(filter all _all modules,$(MAKECMDGOALS)),)
+ifneq ($(filter all _all modules nsdeps,$(MAKECMDGOALS)),)
   KBUILD_MODULES := 1
 endif
 
-- 
2.20.1

