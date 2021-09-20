Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 033C1411E64
	for <lists+stable@lfdr.de>; Mon, 20 Sep 2021 19:29:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347698AbhITRab (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Sep 2021 13:30:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:56306 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1347496AbhITR2Q (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Sep 2021 13:28:16 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 40D1861AAA;
        Mon, 20 Sep 2021 17:03:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632157404;
        bh=l16qG+F5o+7kNpPs82jL7PXkKb+2Vx1dGgZH8LU5+/8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KDwX21YyJeKlhrdXOs1rngEH1aLQiVd3+7eanTIEmXOKzxmkkKfVAuZZVVG8pk2MV
         SMkYrYjBJ9VRF7syUKFKO0wLMwhlZ1WUWeMQlDE1pgJbb0qm+yfnBSSDb83BCh6DTI
         B6jZl+ik7NOCacEY/ri04eKDDLvXkxvFsoeJNNwQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Juergen Gross <jgross@suse.com>,
        "Rafael J. Wysocki" <rafael@kernel.org>
Subject: [PATCH 4.14 193/217] PM: base: power: dont try to use non-existing RTC for storing data
Date:   Mon, 20 Sep 2021 18:43:34 +0200
Message-Id: <20210920163931.180448520@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210920163924.591371269@linuxfoundation.org>
References: <20210920163924.591371269@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Juergen Gross <jgross@suse.com>

commit 0560204b360a332c321124dbc5cdfd3364533a74 upstream.

If there is no legacy RTC device, don't try to use it for storing trace
data across suspend/resume.

Cc: <stable@vger.kernel.org>
Signed-off-by: Juergen Gross <jgross@suse.com>
Reviewed-by: Rafael J. Wysocki <rafael@kernel.org>
Link: https://lore.kernel.org/r/20210903084937.19392-2-jgross@suse.com
Signed-off-by: Juergen Gross <jgross@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/base/power/trace.c |   10 ++++++++++
 1 file changed, 10 insertions(+)

--- a/drivers/base/power/trace.c
+++ b/drivers/base/power/trace.c
@@ -11,6 +11,7 @@
 #include <linux/export.h>
 #include <linux/rtc.h>
 #include <linux/suspend.h>
+#include <linux/init.h>
 
 #include <linux/mc146818rtc.h>
 
@@ -165,6 +166,9 @@ void generate_pm_trace(const void *trace
 	const char *file = *(const char **)(tracedata + 2);
 	unsigned int user_hash_value, file_hash_value;
 
+	if (!x86_platform.legacy.rtc)
+		return;
+
 	user_hash_value = user % USERHASH;
 	file_hash_value = hash_string(lineno, file, FILEHASH);
 	set_magic_time(user_hash_value, file_hash_value, dev_hash_value);
@@ -267,6 +271,9 @@ static struct notifier_block pm_trace_nb
 
 static int early_resume_init(void)
 {
+	if (!x86_platform.legacy.rtc)
+		return 0;
+
 	hash_value_early_read = read_magic_time();
 	register_pm_notifier(&pm_trace_nb);
 	return 0;
@@ -277,6 +284,9 @@ static int late_resume_init(void)
 	unsigned int val = hash_value_early_read;
 	unsigned int user, file, dev;
 
+	if (!x86_platform.legacy.rtc)
+		return 0;
+
 	user = val % USERHASH;
 	val = val / USERHASH;
 	file = val % FILEHASH;


