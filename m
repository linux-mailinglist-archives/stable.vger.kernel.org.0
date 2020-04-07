Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 646231A0BC6
	for <lists+stable@lfdr.de>; Tue,  7 Apr 2020 12:29:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728696AbgDGKYV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Apr 2020 06:24:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:34562 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728074AbgDGKYU (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 7 Apr 2020 06:24:20 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CBB7D20692;
        Tue,  7 Apr 2020 10:24:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1586255060;
        bh=HDOf5iL2WzIZq9OFWuzWL8Xs5UhCelii0BSjOQdYEbQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yyDX3YuJc85Y2izEL/ocJ9fXKHeyOitKkK4BJxflGWNk7v6v1wjzA+rJqw/tEhEiS
         EGUywrOwe4qDcBe2IKN8dIl31E98X0rduZC9lgeV7EievEda5+WRfVSek1hqWxGRXp
         79XtikM4vxSF1RX0ECogDvAjvWJJW47l0vm3+VPU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Len Brown <len.brown@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.5 14/46] tools/power turbostat: Fix gcc build warnings
Date:   Tue,  7 Apr 2020 12:21:45 +0200
Message-Id: <20200407101501.021916292@linuxfoundation.org>
X-Mailer: git-send-email 2.26.0
In-Reply-To: <20200407101459.502593074@linuxfoundation.org>
References: <20200407101459.502593074@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index 5d0fddda842c4..78507cd479bb4 100644
--- a/tools/power/x86/turbostat/turbostat.c
+++ b/tools/power/x86/turbostat/turbostat.c
@@ -5323,9 +5323,9 @@ int add_counter(unsigned int msr_num, char *path, char *name,
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



