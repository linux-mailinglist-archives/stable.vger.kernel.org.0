Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0F9414511CD
	for <lists+stable@lfdr.de>; Mon, 15 Nov 2021 20:12:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244525AbhKOTPJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 14:15:09 -0500
Received: from mail.kernel.org ([198.145.29.99]:42974 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S244244AbhKOTMO (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 14:12:14 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id A5601632B3;
        Mon, 15 Nov 2021 18:19:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637000383;
        bh=/H18LPwuKYXmCGNFa8h/UaqiCGfSbKhy5oUgPM6OL40=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OLiBAc05cQlC8I6ya/NFLKCTopczf1UM4/q8V2xObls/UUdYR5162PDp4mmdlXCpo
         AbjIwYidYe9pFl9RTp3Dv9MK3fjE9UUhJWcrNTNctc8/WzQWmcNYtJYvrantkj0N0j
         XbykXBGheTb1Q48U80gRNnwNaO93PM73Eveg8Vcw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jim Cromie <jim.cromie@gmail.com>,
        Andrew Halaney <ahalaney@redhat.com>,
        Jason Baron <jbaron@akamai.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 608/849] dyndbg: make dyndbg a known cli param
Date:   Mon, 15 Nov 2021 18:01:31 +0100
Message-Id: <20211115165440.819399065@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165419.961798833@linuxfoundation.org>
References: <20211115165419.961798833@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Andrew Halaney <ahalaney@redhat.com>

[ Upstream commit 5ca173974888368fecfb17ae6fe455df5fd2a9d2 ]

Right now dyndbg shows up as an unknown parameter if used on boot:

    Unknown command line parameters: dyndbg=+p

That's because it is unknown, it doesn't sit in the __param
section, so the processing done to warn users supplying an unknown
parameter doesn't think it is legitimate.

Install a dummy handler to register it. dynamic debug needs to search
the whole command line for modules listed that are currently builtin,
so there's no real work to be done in this callback.

Fixes: 86d1919a4fb0 ("init: print out unknown kernel parameters")
Tested-by: Jim Cromie <jim.cromie@gmail.com>
Signed-off-by: Andrew Halaney <ahalaney@redhat.com>
Signed-off-by: Jason Baron <jbaron@akamai.com>
Link: https://lore.kernel.org/r/1634139622-20667-2-git-send-email-jbaron@akamai.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 lib/dynamic_debug.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/lib/dynamic_debug.c b/lib/dynamic_debug.c
index cb5abb42c16a2..84c16309cc637 100644
--- a/lib/dynamic_debug.c
+++ b/lib/dynamic_debug.c
@@ -761,6 +761,18 @@ static __init int ddebug_setup_query(char *str)
 
 __setup("ddebug_query=", ddebug_setup_query);
 
+/*
+ * Install a noop handler to make dyndbg look like a normal kernel cli param.
+ * This avoids warnings about dyndbg being an unknown cli param when supplied
+ * by a user.
+ */
+static __init int dyndbg_setup(char *str)
+{
+	return 1;
+}
+
+__setup("dyndbg=", dyndbg_setup);
+
 /*
  * File_ops->write method for <debugfs>/dynamic_debug/control.  Gathers the
  * command text from userspace, parses and executes it.
-- 
2.33.0



