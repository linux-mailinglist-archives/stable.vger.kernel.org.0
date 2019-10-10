Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2B27BD24DC
	for <lists+stable@lfdr.de>; Thu, 10 Oct 2019 11:00:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390102AbfJJIvY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Oct 2019 04:51:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:58700 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390094AbfJJIvS (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 10 Oct 2019 04:51:18 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5317A2064A;
        Thu, 10 Oct 2019 08:51:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570697476;
        bh=6FO32yOtCVloDZBsqif4npnbRKdAuNoJFjki84pFNh8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ihuO3A/v6Cur8uJYqkutcuP3gK9mcqQxsdFh6ot4ZQ7Fv/u5ZsuyEMlvUtSR4TDB3
         +q8PfCDNM75f87JMkkJHaXSMyq+sDjSvQc1quAGVHEKn4Bi2ziEgtE1uPUm7RH0RNk
         7XmcNRWqBtqJuYUZSvc+ardoAigArowahaMMDWfE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Andreas Krebbel <krebbel@linux.ibm.com>,
        Thomas Richter <tmricht@linux.ibm.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Hendrik Brueckner <brueckner@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 42/61] perf build: Add detection of java-11-openjdk-devel package
Date:   Thu, 10 Oct 2019 10:37:07 +0200
Message-Id: <20191010083516.751061291@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191010083449.500442342@linuxfoundation.org>
References: <20191010083449.500442342@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index f362ee46506ad..b97e31498ff76 100644
--- a/tools/perf/Makefile.config
+++ b/tools/perf/Makefile.config
@@ -795,7 +795,7 @@ ifndef NO_JVMTI
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



