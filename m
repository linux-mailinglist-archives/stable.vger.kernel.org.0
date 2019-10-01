Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 33E11C3C6D
	for <lists+stable@lfdr.de>; Tue,  1 Oct 2019 18:52:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727673AbfJAQvp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Oct 2019 12:51:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:56280 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387412AbfJAQoD (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 1 Oct 2019 12:44:03 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D746321A4C;
        Tue,  1 Oct 2019 16:44:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1569948242;
        bh=EsGY4Ro3QJMVIc6Pr48axtXJLhwkNlHF1eAwIn0tiHA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=v+iobtXwOCcmw4dL2jtU8q5yHvyiFlMaIS0Uq3x90e5v2PTw1TQFRAXyoJMGFdYUz
         vSLjocm43xgn5Ntfra+lKnUiF6NCVbWl8dKAYIB6OUJ4nfLNc8mF4IzuEmbO+0HCql
         eQmGAEOBPCYcSHQ+B1N73Uk9GSt/rs9VsqjiskK4=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Thomas Richter <tmricht@linux.ibm.com>,
        Andreas Krebbel <krebbel@linux.ibm.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Hendrik Brueckner <brueckner@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 4.19 34/43] perf build: Add detection of java-11-openjdk-devel package
Date:   Tue,  1 Oct 2019 12:43:02 -0400
Message-Id: <20191001164311.15993-34-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191001164311.15993-1-sashal@kernel.org>
References: <20191001164311.15993-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Thomas Richter <tmricht@linux.ibm.com>

[ Upstream commit 815c1560bf8fd522b8d93a1d727868b910c1cc24 ]

With Java 11 there is no seperate JRE anymore.

Details:

  https://coderanch.com/t/701603/java/JRE-JDK

Therefore the detection of the JRE needs to be adapted.

This change works for s390 and x86.  I have not tested other platforms.

Committer testing:

Continues to work with the OpenJDK 8:

  $ rm -f ~acme/lib64/libperf-jvmti.so
  $ rpm -qa | grep jdk-devel
  java-1.8.0-openjdk-devel-1.8.0.222.b10-0.fc30.x86_64
  $ git log --oneline -1
  a51937170f33 (HEAD -> perf/core) perf build: Add detection of java-11-openjdk-devel package
  $ rm -rf /tmp/build/perf ; mkdir -p /tmp/build/perf ; make -C tools/perf O=/tmp/build/perf install > /dev/null 2>1
  $ ls -la ~acme/lib64/libperf-jvmti.so
  -rwxr-xr-x. 1 acme acme 230744 Sep 24 16:46 /home/acme/lib64/libperf-jvmti.so
  $

Suggested-by: Andreas Krebbel <krebbel@linux.ibm.com>
Signed-off-by: Thomas Richter <tmricht@linux.ibm.com>
Tested-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Hendrik Brueckner <brueckner@linux.ibm.com>
Cc: Vasily Gorbik <gor@linux.ibm.com>
Link: http://lore.kernel.org/lkml/20190909114116.50469-4-tmricht@linux.ibm.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/Makefile.config | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/perf/Makefile.config b/tools/perf/Makefile.config
index 849b3be15bd89..510caedd73194 100644
--- a/tools/perf/Makefile.config
+++ b/tools/perf/Makefile.config
@@ -837,7 +837,7 @@ ifndef NO_JVMTI
     JDIR=$(shell /usr/sbin/update-java-alternatives -l | head -1 | awk '{print $$3}')
   else
     ifneq (,$(wildcard /usr/sbin/alternatives))
-      JDIR=$(shell /usr/sbin/alternatives --display java | tail -1 | cut -d' ' -f 5 | sed 's%/jre/bin/java.%%g')
+      JDIR=$(shell /usr/sbin/alternatives --display java | tail -1 | cut -d' ' -f 5 | sed -e 's%/jre/bin/java.%%g' -e 's%/bin/java.%%g')
     endif
   endif
   ifndef JDIR
-- 
2.20.1

