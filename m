Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F2921451F0F
	for <lists+stable@lfdr.de>; Tue, 16 Nov 2021 01:36:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355461AbhKPAiZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 19:38:25 -0500
Received: from mail.kernel.org ([198.145.29.99]:45214 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1344476AbhKOTYs (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 14:24:48 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8E2EE633D5;
        Mon, 15 Nov 2021 18:58:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637002704;
        bh=/H18LPwuKYXmCGNFa8h/UaqiCGfSbKhy5oUgPM6OL40=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TihYqg41RyofYfZ0S5ydkI9aRMEcZ36dL0L19VxPUYWv7Np6nFB/8vF84tWZFqoYK
         MB/UCtTDQPpuO/TsZ4JBptkjMTTTV75UBRNwwNqw/gEufYRucXcPqtGRRsaT/f1Og9
         OjK+kTqOFVDzdA1Tn3W/+c+e+F/eRSxexezq/DHY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jim Cromie <jim.cromie@gmail.com>,
        Andrew Halaney <ahalaney@redhat.com>,
        Jason Baron <jbaron@akamai.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 633/917] dyndbg: make dyndbg a known cli param
Date:   Mon, 15 Nov 2021 18:02:08 +0100
Message-Id: <20211115165450.272173597@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165428.722074685@linuxfoundation.org>
References: <20211115165428.722074685@linuxfoundation.org>
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



