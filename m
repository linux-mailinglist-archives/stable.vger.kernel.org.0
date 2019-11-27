Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 673FF10BE34
	for <lists+stable@lfdr.de>; Wed, 27 Nov 2019 22:35:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730246AbfK0Utc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Nov 2019 15:49:32 -0500
Received: from mail.kernel.org ([198.145.29.99]:35174 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730243AbfK0Utb (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 27 Nov 2019 15:49:31 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E7B8721774;
        Wed, 27 Nov 2019 20:49:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574887771;
        bh=lVm6YqHpo7guvAgq3Pxt5xirqFmtv4mPKPJex/8STw8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YOxQp+ImXN6OObzUQTOmZq4oHQnk8bZz6xn7aFbtPAP4LjMqo4ukfrOUfdLsfkdOZ
         8cLdgG5ciaLn5SoQjoGdhD57EfCj/aGoFwm6lXEBbbjQYIa6gJwQidSFKV31hSXKRH
         IG5iW87DXo+d2r3B97BWI4j/VPEobqL1oM+W/7f0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "Shuah Khan (Samsung OSG)" <shuah@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 086/211] selftests: watchdog: fix message when /dev/watchdog open fails
Date:   Wed, 27 Nov 2019 21:30:19 +0100
Message-Id: <20191127203101.888525419@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191127203049.431810767@linuxfoundation.org>
References: <20191127203049.431810767@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Shuah Khan (Samsung OSG) <shuah@kernel.org>

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



