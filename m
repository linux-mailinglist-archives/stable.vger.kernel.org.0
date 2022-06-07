Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DA275541A8A
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 23:34:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379487AbiFGVe3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 17:34:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51026 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352049AbiFGVcp (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 17:32:45 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1FF5A17A88B;
        Tue,  7 Jun 2022 12:04:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1936661787;
        Tue,  7 Jun 2022 19:04:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 23E9BC385A5;
        Tue,  7 Jun 2022 19:04:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654628653;
        bh=z738e8BO/UJzm9zIi0Uml3nSYGvE+UB3QROE2NXxJmA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Mi8uqq72aLpQc898sKeKyaeHIgD0rr+SIL3ectcBMvobQZ19tTuXqBnAUAWk1lpXv
         UuVtvJbEF9nsRSK1NuZ0etl6ALP8LKC9Ng2bbY9PwvAU6INe1nsAsu+Gee0CnE+3VF
         8lOuJbLLNt7yNE+fcNfVpaP0AY7vEtNYQQMV1rWo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Andrii Nakryiko <andrii@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 406/879] selftests/bpf: Prevent skeleton generation race
Date:   Tue,  7 Jun 2022 18:58:44 +0200
Message-Id: <20220607165014.646932607@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607165002.659942637@linuxfoundation.org>
References: <20220607165002.659942637@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Andrii Nakryiko <andrii@kernel.org>

[ Upstream commit 1e2666e029e5cc2b81dbd7c85af5bcc8c80524e0 ]

Prevent "classic" and light skeleton generation rules from stomping on
each other's toes due to the use of the same <obj>.linked{1,2,3}.o
naming pattern. There is no coordination and synchronizataion between
.skel.h and .lskel.h rules, so they can easily overwrite each other's
intermediate object files, leading to errors like:

  /bin/sh: line 1: 170928 Bus error               (core dumped)
  /data/users/andriin/linux/tools/testing/selftests/bpf/tools/sbin/bpftool gen skeleton
  /data/users/andriin/linux/tools/testing/selftests/bpf/test_ksyms_weak.linked3.o
  name test_ksyms_weak
  > /data/users/andriin/linux/tools/testing/selftests/bpf/test_ksyms_weak.skel.h
  make: *** [Makefile:507: /data/users/andriin/linux/tools/testing/selftests/bpf/test_ksyms_weak.skel.h] Error 135
  make: *** Deleting file '/data/users/andriin/linux/tools/testing/selftests/bpf/test_ksyms_weak.skel.h'

Fix by using different suffix for light skeleton rule.

Fixes: c48e51c8b07a ("bpf: selftests: Add selftests for module kfunc support")
Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Link: https://lore.kernel.org/bpf/20220509004148.1801791-2-andrii@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/bpf/Makefile | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/tools/testing/selftests/bpf/Makefile b/tools/testing/selftests/bpf/Makefile
index 3820608faf57..a15c47d2fa73 100644
--- a/tools/testing/selftests/bpf/Makefile
+++ b/tools/testing/selftests/bpf/Makefile
@@ -415,11 +415,11 @@ $(TRUNNER_BPF_SKELS): %.skel.h: %.o $(BPFTOOL) | $(TRUNNER_OUTPUT)
 
 $(TRUNNER_BPF_LSKELS): %.lskel.h: %.o $(BPFTOOL) | $(TRUNNER_OUTPUT)
 	$$(call msg,GEN-SKEL,$(TRUNNER_BINARY),$$@)
-	$(Q)$$(BPFTOOL) gen object $$(<:.o=.linked1.o) $$<
-	$(Q)$$(BPFTOOL) gen object $$(<:.o=.linked2.o) $$(<:.o=.linked1.o)
-	$(Q)$$(BPFTOOL) gen object $$(<:.o=.linked3.o) $$(<:.o=.linked2.o)
-	$(Q)diff $$(<:.o=.linked2.o) $$(<:.o=.linked3.o)
-	$(Q)$$(BPFTOOL) gen skeleton -L $$(<:.o=.linked3.o) name $$(notdir $$(<:.o=_lskel)) > $$@
+	$(Q)$$(BPFTOOL) gen object $$(<:.o=.llinked1.o) $$<
+	$(Q)$$(BPFTOOL) gen object $$(<:.o=.llinked2.o) $$(<:.o=.llinked1.o)
+	$(Q)$$(BPFTOOL) gen object $$(<:.o=.llinked3.o) $$(<:.o=.llinked2.o)
+	$(Q)diff $$(<:.o=.llinked2.o) $$(<:.o=.llinked3.o)
+	$(Q)$$(BPFTOOL) gen skeleton -L $$(<:.o=.llinked3.o) name $$(notdir $$(<:.o=_lskel)) > $$@
 
 $(TRUNNER_BPF_SKELS_LINKED): $(TRUNNER_BPF_OBJS) $(BPFTOOL) | $(TRUNNER_OUTPUT)
 	$$(call msg,LINK-BPF,$(TRUNNER_BINARY),$$(@:.skel.h=.o))
-- 
2.35.1



