Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 110081C14A6
	for <lists+stable@lfdr.de>; Fri,  1 May 2020 15:45:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730886AbgEANli (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 1 May 2020 09:41:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:41958 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729426AbgEANlh (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 1 May 2020 09:41:37 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7494A20757;
        Fri,  1 May 2020 13:41:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588340496;
        bh=GMXiiPQKHX1FTn0hWKLhX1Whtb//R682Rms0uUbCt50=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Cpomy3zLwclqGx6TLqkzowSp41YzkplC4+ARhqGmNyc9JVWKUUkNbnx9/BlZxRiFv
         jctezUT3GImsTM9WV7FIYkzUiMnvhx1gfg+52S8/iR7IIgbqAFSczBi/YqmVDIIVVJ
         i2815iZfnqSZVcEJmXWfy4RJETouuonm2hNNk3Vo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Masahiro Yamada <masahiroy@kernel.org>
Subject: [PATCH 5.6 006/106] kbuild: fix DT binding schema rule again to avoid needless rebuilds
Date:   Fri,  1 May 2020 15:22:39 +0200
Message-Id: <20200501131544.262669852@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200501131543.421333643@linuxfoundation.org>
References: <20200501131543.421333643@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Masahiro Yamada <masahiroy@kernel.org>

commit 3d4b2238684ac919394eba7fb51bb7eeeec6ab57 upstream.

Since commit 7a0496056064 ("kbuild: fix DT binding schema rule to detect
command line changes"), this rule is every time re-run even if you change
nothing.

cmd_dtc takes one additional parameter to pass to the -O option of dtc.

We need to pass 'yaml' to if_changed_rule. Otherwise, cmd-check invoked
from if_changed_rule is false positive.

Fixes: 7a0496056064 ("kbuild: fix DT binding schema rule to detect command line changes")
Signed-off-by: Masahiro Yamada <masahiroy@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 scripts/Makefile.lib |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/scripts/Makefile.lib
+++ b/scripts/Makefile.lib
@@ -308,7 +308,7 @@ define rule_dtc
 endef
 
 $(obj)/%.dt.yaml: $(src)/%.dts $(DTC) $(DT_TMP_SCHEMA) FORCE
-	$(call if_changed_rule,dtc)
+	$(call if_changed_rule,dtc,yaml)
 
 dtc-tmp = $(subst $(comma),_,$(dot-target).dts.tmp)
 


