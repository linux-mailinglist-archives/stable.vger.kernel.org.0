Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8577CEEE91
	for <lists+stable@lfdr.de>; Mon,  4 Nov 2019 23:16:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389102AbfKDWE4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Nov 2019 17:04:56 -0500
Received: from mail.kernel.org ([198.145.29.99]:35822 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388176AbfKDWEy (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 4 Nov 2019 17:04:54 -0500
Received: from localhost (6.204-14-84.ripe.coltfrance.com [84.14.204.6])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 91B6A217F5;
        Mon,  4 Nov 2019 22:04:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1572905094;
        bh=j4NMKFZCEhXHqiCHNdvO7vjenNr3RiF8my1Dx+JIa0Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UPAD0hYBECTAgADFweRj6iVOVfQ+Pc7Fqtor1kX9VDz+CGmMQrZMhFsvmvCxSsAXS
         3acrZ51mj20EzrnFndvMQ14xpFA2eH1E9zVUl6FJB7BYJtFzZ8fyBcvALjQvDF4ftO
         bk0J2eOnmt5Ubcxsb9/Lot04cMHVxO1B6rwqJOiA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Cristian Marussi <cristian.marussi@arm.com>,
        Shuah Khan <skhan@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.3 026/163] kselftest: exclude failed TARGETS from runlist
Date:   Mon,  4 Nov 2019 22:43:36 +0100
Message-Id: <20191104212142.240096927@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191104212140.046021995@linuxfoundation.org>
References: <20191104212140.046021995@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Cristian Marussi <cristian.marussi@arm.com>

[ Upstream commit 131b30c94fbc0adb15f911609884dd39dada8f00 ]

A TARGET which failed to be built/installed should not be included in the
runlist generated inside the run_kselftest.sh script.

Signed-off-by: Cristian Marussi <cristian.marussi@arm.com>
Signed-off-by: Shuah Khan <skhan@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/Makefile | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/tools/testing/selftests/Makefile b/tools/testing/selftests/Makefile
index 25b43a8c2b159..1779923d7a7b8 100644
--- a/tools/testing/selftests/Makefile
+++ b/tools/testing/selftests/Makefile
@@ -198,8 +198,12 @@ ifdef INSTALL_PATH
 	echo "  cat /dev/null > \$$logfile" >> $(ALL_SCRIPT)
 	echo "fi" >> $(ALL_SCRIPT)
 
+	@# While building run_kselftest.sh skip also non-existent TARGET dirs:
+	@# they could be the result of a build failure and should NOT be
+	@# included in the generated runlist.
 	for TARGET in $(TARGETS); do \
 		BUILD_TARGET=$$BUILD/$$TARGET;	\
+		[ ! -d $$INSTALL_PATH/$$TARGET ] && echo "Skipping non-existent dir: $$TARGET" && continue; \
 		echo "[ -w /dev/kmsg ] && echo \"kselftest: Running tests in $$TARGET\" >> /dev/kmsg" >> $(ALL_SCRIPT); \
 		echo "cd $$TARGET" >> $(ALL_SCRIPT); \
 		echo -n "run_many" >> $(ALL_SCRIPT); \
-- 
2.20.1



