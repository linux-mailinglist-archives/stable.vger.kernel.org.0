Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 963CB4123DC
	for <lists+stable@lfdr.de>; Mon, 20 Sep 2021 20:27:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1378431AbhITS20 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Sep 2021 14:28:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:46128 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1378749AbhITS0V (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Sep 2021 14:26:21 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 504D4632D2;
        Mon, 20 Sep 2021 17:25:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632158725;
        bh=XK4wX9LJSIljoTAwtcTaJD3bviCjOBnfqboBhbiu5R0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Z4jI3FXsT849tHRZXMfa9RFhinAs2RsM2bBLHUb7DcAsOO8mea8FFFUaBS4JzFTXq
         S5y3S4aC4imY5FED+npDF/PrmoJi/jwUFTVbA6X1lHuJW0rEIHPiRPtcOO9ch/SL8a
         qQuouzaMif8P+7U6787cFBBzn2DMelojdgnM/29o=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Juergen Gross <jgross@suse.com>,
        "Rafael J. Wysocki" <rafael@kernel.org>
Subject: [PATCH 5.10 007/122] PM: base: power: dont try to use non-existing RTC for storing data
Date:   Mon, 20 Sep 2021 18:42:59 +0200
Message-Id: <20210920163916.003496347@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210920163915.757887582@linuxfoundation.org>
References: <20210920163915.757887582@linuxfoundation.org>
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
@@ -13,6 +13,7 @@
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
 
 static int __init early_resume_init(void)
 {
+	if (!x86_platform.legacy.rtc)
+		return 0;
+
 	hash_value_early_read = read_magic_time();
 	register_pm_notifier(&pm_trace_nb);
 	return 0;
@@ -277,6 +284,9 @@ static int __init late_resume_init(void)
 	unsigned int val = hash_value_early_read;
 	unsigned int user, file, dev;
 
+	if (!x86_platform.legacy.rtc)
+		return 0;
+
 	user = val % USERHASH;
 	val = val / USERHASH;
 	file = val % FILEHASH;


