Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5A4D017FC34
	for <lists+stable@lfdr.de>; Tue, 10 Mar 2020 14:19:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731131AbgCJNIl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Mar 2020 09:08:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:55302 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730085AbgCJNIk (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Mar 2020 09:08:40 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 710D3208E4;
        Tue, 10 Mar 2020 13:08:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583845718;
        bh=jWDCjtYXgCN/oYeyT1eU+DWTqGu7bZ3vvAUPWIQIHwI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qZHzxcFiFawQ5v0b7qzMqynm2XhiSyirZUzZH2XY598FCIpB177aLKQPFjZs6cVok
         AwFH/25tZoLKpxSwNPi7Je2OGJlJAV9POy0UNyxMkaJWHJBs19Ny2ACPKtpdy4m8a1
         8YAm1K5IeZvfrJop+uRAeoHbNjMrAPwPZCPApuO4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Yauheni Kaliuta <yauheni.kaliuta@redhat.com>,
        Jiri Benc <jbenc@redhat.com>,
        Shuah Khan <skhan@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 075/126] selftests: fix too long argument
Date:   Tue, 10 Mar 2020 13:41:36 +0100
Message-Id: <20200310124208.765852221@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200310124203.704193207@linuxfoundation.org>
References: <20200310124203.704193207@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jiri Benc <jbenc@redhat.com>

[ Upstream commit c363eb48ada5cf732b3f489fab799fc881097842 ]

With some shells, the command construed for install of bpf selftests becomes
too large due to long list of files:

make[1]: execvp: /bin/sh: Argument list too long
make[1]: *** [../lib.mk:73: install] Error 127

Currently, each of the file lists is replicated three times in the command:
in the shell 'if' condition, in the 'echo' and in the 'rsync'. Reduce that
by one instance by using make conditionals and separate the echo and rsync
into two shell commands. (One would be inclined to just remove the '@' at
the beginning of the rsync command and let 'make' echo it by itself;
unfortunately, it appears that the '@' in the front of mkdir silences output
also for the following commands.)

Also, separate handling of each of the lists to its own shell command.

The semantics of the makefile is unchanged before and after the patch. The
ability of individual test directories to override INSTALL_RULE is retained.

Reported-by: Yauheni Kaliuta <yauheni.kaliuta@redhat.com>
Tested-by: Yauheni Kaliuta <yauheni.kaliuta@redhat.com>
Signed-off-by: Jiri Benc <jbenc@redhat.com>
Signed-off-by: Shuah Khan <skhan@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/lib.mk | 23 +++++++++++++----------
 1 file changed, 13 insertions(+), 10 deletions(-)

diff --git a/tools/testing/selftests/lib.mk b/tools/testing/selftests/lib.mk
index 5bef05d6ba393..c9be64dc681d2 100644
--- a/tools/testing/selftests/lib.mk
+++ b/tools/testing/selftests/lib.mk
@@ -54,17 +54,20 @@ else
 	$(call RUN_TESTS, $(TEST_GEN_PROGS) $(TEST_CUSTOM_PROGS) $(TEST_PROGS))
 endif
 
+define INSTALL_SINGLE_RULE
+	$(if $(INSTALL_LIST),@mkdir -p $(INSTALL_PATH))
+	$(if $(INSTALL_LIST),@echo rsync -a $(INSTALL_LIST) $(INSTALL_PATH)/)
+	$(if $(INSTALL_LIST),@rsync -a $(INSTALL_LIST) $(INSTALL_PATH)/)
+endef
+
 define INSTALL_RULE
-	@if [ "X$(TEST_PROGS)$(TEST_PROGS_EXTENDED)$(TEST_FILES)" != "X" ]; then					\
-		mkdir -p ${INSTALL_PATH};										\
-		echo "rsync -a $(TEST_PROGS) $(TEST_PROGS_EXTENDED) $(TEST_FILES) $(INSTALL_PATH)/";	\
-		rsync -a $(TEST_PROGS) $(TEST_PROGS_EXTENDED) $(TEST_FILES) $(INSTALL_PATH)/;		\
-	fi
-	@if [ "X$(TEST_GEN_PROGS)$(TEST_CUSTOM_PROGS)$(TEST_GEN_PROGS_EXTENDED)$(TEST_GEN_FILES)" != "X" ]; then					\
-		mkdir -p ${INSTALL_PATH};										\
-		echo "rsync -a $(TEST_GEN_PROGS) $(TEST_CUSTOM_PROGS) $(TEST_GEN_PROGS_EXTENDED) $(TEST_GEN_FILES) $(INSTALL_PATH)/";	\
-		rsync -a $(TEST_GEN_PROGS) $(TEST_CUSTOM_PROGS) $(TEST_GEN_PROGS_EXTENDED) $(TEST_GEN_FILES) $(INSTALL_PATH)/;		\
-	fi
+	$(eval INSTALL_LIST = $(TEST_PROGS)) $(INSTALL_SINGLE_RULE)
+	$(eval INSTALL_LIST = $(TEST_PROGS_EXTENDED)) $(INSTALL_SINGLE_RULE)
+	$(eval INSTALL_LIST = $(TEST_FILES)) $(INSTALL_SINGLE_RULE)
+	$(eval INSTALL_LIST = $(TEST_GEN_PROGS)) $(INSTALL_SINGLE_RULE)
+	$(eval INSTALL_LIST = $(TEST_CUSTOM_PROGS)) $(INSTALL_SINGLE_RULE)
+	$(eval INSTALL_LIST = $(TEST_GEN_PROGS_EXTENDED)) $(INSTALL_SINGLE_RULE)
+	$(eval INSTALL_LIST = $(TEST_GEN_FILES)) $(INSTALL_SINGLE_RULE)
 endef
 
 install: all
-- 
2.20.1



