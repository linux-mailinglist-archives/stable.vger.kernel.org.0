Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 76C6B1D3BC7
	for <lists+stable@lfdr.de>; Thu, 14 May 2020 21:06:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728981AbgENSyQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 14 May 2020 14:54:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:54168 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728990AbgENSyQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 14 May 2020 14:54:16 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3ABEB206DC;
        Thu, 14 May 2020 18:54:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589482456;
        bh=OVlUxvQzNgSgG9OZhB+Tn+fOPYQA6MAVSLwyu1c3VL0=;
        h=From:To:Cc:Subject:Date:From;
        b=LQA361c/HG1AyboJXmgcITRaJJv97J1GVlKrCDnYOeQEnOSzveTCRc90CDD132BcX
         eU4OlubjCbKf1FQmzYHFGklOGhV7xwhWLV1sS5dWL5z5/mEKG0Y1u8uiwc6OZhcqQ2
         yEJCcFO8Ng6s5OE35B7zQROCLKBLvm8eqS8DUE3I=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Sergei Trofimovich <slyfox@gentoo.org>,
        Jiri Kosina <jkosina@suse.cz>,
        Masahiro Yamada <masahiroy@kernel.org>,
        Sasha Levin <sashal@kernel.org>, linux-kbuild@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 01/31] Makefile: disallow data races on gcc-10 as well
Date:   Thu, 14 May 2020 14:53:43 -0400
Message-Id: <20200514185413.20755-1-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sergei Trofimovich <slyfox@gentoo.org>

[ Upstream commit b1112139a103b4b1101d0d2d72931f2d33d8c978 ]

gcc-10 will rename --param=allow-store-data-races=0
to -fno-allow-store-data-races.

The flag change happened at https://gcc.gnu.org/PR92046.

Signed-off-by: Sergei Trofimovich <slyfox@gentoo.org>
Acked-by: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Masahiro Yamada <masahiroy@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 Makefile | 1 +
 1 file changed, 1 insertion(+)

diff --git a/Makefile b/Makefile
index 68fa15edd662c..3008cf448649c 100644
--- a/Makefile
+++ b/Makefile
@@ -671,6 +671,7 @@ KBUILD_CFLAGS += $(call cc-ifversion, -lt, 0409, \
 
 # Tell gcc to never replace conditional load with a non-conditional one
 KBUILD_CFLAGS	+= $(call cc-option,--param=allow-store-data-races=0)
+KBUILD_CFLAGS	+= $(call cc-option,-fno-allow-store-data-races)
 
 include scripts/Makefile.kcov
 include scripts/Makefile.gcc-plugins
-- 
2.20.1

