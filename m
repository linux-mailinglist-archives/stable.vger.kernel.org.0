Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0BC7E359B3D
	for <lists+stable@lfdr.de>; Fri,  9 Apr 2021 12:07:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234564AbhDIKH5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 9 Apr 2021 06:07:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:45652 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233903AbhDIKBK (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 9 Apr 2021 06:01:10 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 195E761249;
        Fri,  9 Apr 2021 09:59:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1617962377;
        bh=eAVbZECCGzinOdd+zQ6+2Z/Yv99BrMtGMiISdvyA+Fk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YX07buPkEh1kMwUfPi9n+nSG9M1Jc0cBIfv68ulNDtrhvuxb9lXIFqMLUhvdLz808
         0tlcldC2CGHUisCe7ERkxv3vq3lRyrob6TjmrZe+6qrXUWhCg5bvNXUBnVfwpF4Ei3
         KQtvoYFtVJVYX+jnKJUWB8sVhMdPU36QSeF5b5Gw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jiri Olsa <jolsa@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 33/41] tools/resolve_btfids: Check objects before removing
Date:   Fri,  9 Apr 2021 11:53:55 +0200
Message-Id: <20210409095305.873115556@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210409095304.818847860@linuxfoundation.org>
References: <20210409095304.818847860@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jiri Olsa <jolsa@kernel.org>

[ Upstream commit f23130979c2f15ea29a431cd9e1ea7916337bbd4 ]

We want this clean to be called from tree's root clean
and that one is silent if there's nothing to clean.

Adding check for all object to clean and display CLEAN
messages only if there are objects to remove.

Signed-off-by: Jiri Olsa <jolsa@kernel.org>
Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
Acked-by: Andrii Nakryiko <andrii@kernel.org>
Link: https://lore.kernel.org/bpf/20210205124020.683286-3-jolsa@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/bpf/resolve_btfids/Makefile | 17 ++++++++++++-----
 1 file changed, 12 insertions(+), 5 deletions(-)

diff --git a/tools/bpf/resolve_btfids/Makefile b/tools/bpf/resolve_btfids/Makefile
index 1d46a247ec95..be09ec4f03ff 100644
--- a/tools/bpf/resolve_btfids/Makefile
+++ b/tools/bpf/resolve_btfids/Makefile
@@ -64,13 +64,20 @@ $(BINARY): $(BPFOBJ) $(SUBCMDOBJ) $(BINARY_IN)
 	$(call msg,LINK,$@)
 	$(Q)$(CC) $(BINARY_IN) $(LDFLAGS) -o $@ $(BPFOBJ) $(SUBCMDOBJ) $(LIBS)
 
+clean_objects := $(wildcard $(OUTPUT)/*.o                \
+                            $(OUTPUT)/.*.o.cmd           \
+                            $(OUTPUT)/.*.o.d             \
+                            $(OUTPUT)/libbpf             \
+                            $(OUTPUT)/libsubcmd          \
+                            $(OUTPUT)/resolve_btfids)
+
+ifneq ($(clean_objects),)
 clean: fixdep-clean
 	$(call msg,CLEAN,$(BINARY))
-	$(Q)$(RM) -f $(BINARY); \
-	$(RM) -rf $(if $(OUTPUT),$(OUTPUT),.)/feature; \
-	$(RM) -rf $(OUTPUT)/libbpf; \
-	$(RM) -rf $(OUTPUT)/libsubcmd; \
-	find $(if $(OUTPUT),$(OUTPUT),.) -name \*.o -or -name \*.o.cmd -or -name \*.o.d | xargs $(RM)
+	$(Q)$(RM) -rf $(clean_objects)
+else
+clean:
+endif
 
 tags:
 	$(call msg,GEN,,tags)
-- 
2.30.2



