Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DDF8E194CA9
	for <lists+stable@lfdr.de>; Fri, 27 Mar 2020 00:26:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728306AbgCZXZY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 26 Mar 2020 19:25:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:46240 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728300AbgCZXZW (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 26 Mar 2020 19:25:22 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 61C3220B1F;
        Thu, 26 Mar 2020 23:25:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1585265122;
        bh=h2eGqPeixL/ya52/luORgsLdlKSXvpz5U783GSmKz9E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=H/Vhb7dbw7XvjsaUiAgzWMyAtUUj5FkTPJbipXblcl6izVCBPU+VkbRWZH6m84Xne
         mE4dWB+rs0LoHIVJrydPnf2UsVkECFCozsJd3mfsOS/52SqLF4x5kSPRHD/9Q3dugO
         I+37zsyRmmy5SdvPGYtDpBPkpoCeaqTju0NF8fSo=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Len Brown <len.brown@intel.com>, Sasha Levin <sashal@kernel.org>,
        linux-pm@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 07/10] tools/power turbostat: Fix gcc build warnings
Date:   Thu, 26 Mar 2020 19:25:10 -0400
Message-Id: <20200326232513.8212-7-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200326232513.8212-1-sashal@kernel.org>
References: <20200326232513.8212-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Len Brown <len.brown@intel.com>

[ Upstream commit d8d005ba6afa502ca37ced5782f672c4d2fc1515 ]

Warning: ‘__builtin_strncpy’ specified bound 20 equals destination size
	[-Wstringop-truncation]

reduce param to strncpy, to guarantee that a null byte is always copied
into destination buffer.

Signed-off-by: Len Brown <len.brown@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/power/x86/turbostat/turbostat.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/power/x86/turbostat/turbostat.c b/tools/power/x86/turbostat/turbostat.c
index 19e345cf8193e..0692f2efc25ef 100644
--- a/tools/power/x86/turbostat/turbostat.c
+++ b/tools/power/x86/turbostat/turbostat.c
@@ -4650,9 +4650,9 @@ int add_counter(unsigned int msr_num, char *path, char *name,
 	}
 
 	msrp->msr_num = msr_num;
-	strncpy(msrp->name, name, NAME_BYTES);
+	strncpy(msrp->name, name, NAME_BYTES - 1);
 	if (path)
-		strncpy(msrp->path, path, PATH_BYTES);
+		strncpy(msrp->path, path, PATH_BYTES - 1);
 	msrp->width = width;
 	msrp->type = type;
 	msrp->format = format;
-- 
2.20.1

