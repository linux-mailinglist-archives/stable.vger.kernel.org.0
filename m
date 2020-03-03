Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D00831781CD
	for <lists+stable@lfdr.de>; Tue,  3 Mar 2020 20:02:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732357AbgCCSGi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Mar 2020 13:06:38 -0500
Received: from mail.kernel.org ([198.145.29.99]:38338 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732568AbgCCR4R (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Mar 2020 12:56:17 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 415B4206D5;
        Tue,  3 Mar 2020 17:56:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583258176;
        bh=L0CY501USvhcsiuO9rnQOSZEAjIyjx5IZH1J/ItUlgY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lCtyk+A3UvZpKsJs7iqOCK7UEzi+XUwuUqtGpv37liEed82dyKqq/nYXBPJwFahWF
         /QmLzJtOFKYTC7BihONWXGLNDSvIDHoERC3LDML9c9lSPDb9bks2DNKPRu9U9ZAB95
         eihBx86Io0x0hy1X/nu8xZzpZO5bfFrlwPzqstuM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Masahiro Yamada <masahiroy@kernel.org>,
        Rob Herring <robh@kernel.org>
Subject: [PATCH 5.4 101/152] kbuild: fix DT binding schema rule to detect command line changes
Date:   Tue,  3 Mar 2020 18:43:19 +0100
Message-Id: <20200303174314.062989519@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200303174302.523080016@linuxfoundation.org>
References: <20200303174302.523080016@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Masahiro Yamada <masahiroy@kernel.org>

commit 7a04960560640ac5b0b89461f7757322b57d0c7a upstream.

This if_change_rule is not working properly; it cannot detect any
command line change.

The reason is because cmd-check in scripts/Kbuild.include compares
$(cmd_$@) and $(cmd_$1), but cmd_dtc_dt_yaml does not exist here.

For if_change_rule to work properly, the stem part of cmd_* and rule_*
must match. Because this cmd_and_fixdep invokes cmd_dtc, this rule must
be named rule_dtc.

Fixes: 4f0e3a57d6eb ("kbuild: Add support for DT binding schema checks")
Signed-off-by: Masahiro Yamada <masahiroy@kernel.org>
Acked-by: Rob Herring <robh@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 scripts/Makefile.lib |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/scripts/Makefile.lib
+++ b/scripts/Makefile.lib
@@ -305,13 +305,13 @@ DT_TMP_SCHEMA := $(objtree)/$(DT_BINDING
 quiet_cmd_dtb_check =	CHECK   $@
       cmd_dtb_check =	$(DT_CHECKER) -u $(srctree)/$(DT_BINDING_DIR) -p $(DT_TMP_SCHEMA) $@ ;
 
-define rule_dtc_dt_yaml
+define rule_dtc
 	$(call cmd_and_fixdep,dtc,yaml)
 	$(call cmd,dtb_check)
 endef
 
 $(obj)/%.dt.yaml: $(src)/%.dts $(DTC) $(DT_TMP_SCHEMA) FORCE
-	$(call if_changed_rule,dtc_dt_yaml)
+	$(call if_changed_rule,dtc)
 
 dtc-tmp = $(subst $(comma),_,$(dot-target).dts.tmp)
 


