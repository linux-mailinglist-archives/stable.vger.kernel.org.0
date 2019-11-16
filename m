Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BCF01FF2C9
	for <lists+stable@lfdr.de>; Sat, 16 Nov 2019 17:21:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728910AbfKPQVU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 16 Nov 2019 11:21:20 -0500
Received: from mail.kernel.org ([198.145.29.99]:47696 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728777AbfKPPng (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 16 Nov 2019 10:43:36 -0500
Received: from sasha-vm.mshome.net (unknown [50.234.116.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7135620729;
        Sat, 16 Nov 2019 15:43:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573919015;
        bh=QapvbyAR0UCwp5TQJRgpF5BAlHZWPUtIxkqmXmTEBlI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HfT59ara3/2VtDWsfvuSZwURMpD3v2RHpJTGp53pzDt0mZDtt4ahZRfZj3Ylg9G0M
         LgqsXadZdA2RM0WPFeQx4CngxYv8YwhkCbmPRCzSRJiHir7M7Eey3pDDEeyIhhO+Ch
         /jDYQs0ibWkTdJHdSrupbs0wC3dFXU/FactJ4nsE=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     "Shuah Khan (Samsung OSG)" <shuah@kernel.org>,
        Sasha Levin <sashal@kernel.org>,
        linux-kselftest@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 117/237] selftests: watchdog: fix message when /dev/watchdog open fails
Date:   Sat, 16 Nov 2019 10:39:12 -0500
Message-Id: <20191116154113.7417-117-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191116154113.7417-1-sashal@kernel.org>
References: <20191116154113.7417-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: "Shuah Khan (Samsung OSG)" <shuah@kernel.org>

[ Upstream commit 9a244229a4b850b11952a0df79607c69b18fd8df ]

When /dev/watchdog open fails, watchdog exits with "watchdog not enabled"
message. This is incorrect when open fails due to insufficient privilege.

Fix message to clearly state the reason when open fails with EACCESS when
a non-root user runs it.

Signed-off-by: Shuah Khan (Samsung OSG) <shuah@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/watchdog/watchdog-test.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/watchdog/watchdog-test.c b/tools/testing/selftests/watchdog/watchdog-test.c
index 6e290874b70e2..e029e2017280f 100644
--- a/tools/testing/selftests/watchdog/watchdog-test.c
+++ b/tools/testing/selftests/watchdog/watchdog-test.c
@@ -89,7 +89,13 @@ int main(int argc, char *argv[])
 	fd = open("/dev/watchdog", O_WRONLY);
 
 	if (fd == -1) {
-		printf("Watchdog device not enabled.\n");
+		if (errno == ENOENT)
+			printf("Watchdog device not enabled.\n");
+		else if (errno == EACCES)
+			printf("Run watchdog as root.\n");
+		else
+			printf("Watchdog device open failed %s\n",
+				strerror(errno));
 		exit(-1);
 	}
 
-- 
2.20.1

