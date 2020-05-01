Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CB2001C16B2
	for <lists+stable@lfdr.de>; Fri,  1 May 2020 16:09:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730628AbgEANwF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 1 May 2020 09:52:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:37404 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730447AbgEANiA (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 1 May 2020 09:38:00 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 72AC32173E;
        Fri,  1 May 2020 13:37:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588340279;
        bh=IxfNikbsqk3Bz7Xb54p/LMUBJJZQxxJ67uGYBUBEZrc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=M5sLWbPhsUzFSAAY79cjbR1xVtAefKqPywbkyn6+hW8Fmi6/9N165h1RRckn4sc6+
         4EeC6wzUcN+5jKkTnef5QzmFGOKTOIroyIBB0/MXyT0SqlLvBjbVpNxF2PDv8Wl8mW
         HLkyv4nA3XWoqGqsDWVMi/YRtPQW/ujMQcxaLjkQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Masahiro Yamada <masahiroy@kernel.org>
Subject: [PATCH 5.4 06/83] kbuild: fix DT binding schema rule again to avoid needless rebuilds
Date:   Fri,  1 May 2020 15:22:45 +0200
Message-Id: <20200501131525.585194480@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200501131524.004332640@linuxfoundation.org>
References: <20200501131524.004332640@linuxfoundation.org>
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
@@ -297,7 +297,7 @@ define rule_dtc
 endef
 
 $(obj)/%.dt.yaml: $(src)/%.dts $(DTC) $(DT_TMP_SCHEMA) FORCE
-	$(call if_changed_rule,dtc)
+	$(call if_changed_rule,dtc,yaml)
 
 dtc-tmp = $(subst $(comma),_,$(dot-target).dts.tmp)
 


