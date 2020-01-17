Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DEE6D140BF5
	for <lists+stable@lfdr.de>; Fri, 17 Jan 2020 15:03:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728928AbgAQOCn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 17 Jan 2020 09:02:43 -0500
Received: from fd.dlink.ru ([178.170.168.18]:55796 "EHLO fd.dlink.ru"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728863AbgAQOCm (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 17 Jan 2020 09:02:42 -0500
Received: by fd.dlink.ru (Postfix, from userid 5000)
        id 8CB961B2176F; Fri, 17 Jan 2020 17:02:39 +0300 (MSK)
DKIM-Filter: OpenDKIM Filter v2.11.0 fd.dlink.ru 8CB961B2176F
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=dlink.ru; s=mail;
        t=1579269759; bh=KiF0CQi39vLAPzLaFitmjjtdbiOON526/L6L9tSCSvQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References;
        b=FXiiY4wtgL+qgzOB5BU8jtPsQzhxoEks1cBXNUwI2wMzJbd4j79JUFqF1l/wmzYov
         9YrVlmadRJrnBiOkAj0gx5ZIK8gwDyXzJaOlhnfvD2U1VoSD161GdSE3SyHOXL6nd8
         nVt9Onrfvji6gxReFGGDf0DSNylXfJTPnUTtj6Qw=
X-Spam-Checker-Version: SpamAssassin 3.4.2 (2018-09-13) on mail.dlink.ru
X-Spam-Level: 
X-Spam-Status: No, score=-99.2 required=7.5 tests=BAYES_50,URIBL_BLOCKED,
        USER_IN_WHITELIST autolearn=disabled version=3.4.2
Received: from mail.rzn.dlink.ru (mail.rzn.dlink.ru [178.170.168.13])
        by fd.dlink.ru (Postfix) with ESMTP id 65A1C1B209BB;
        Fri, 17 Jan 2020 17:02:30 +0300 (MSK)
DKIM-Filter: OpenDKIM Filter v2.11.0 fd.dlink.ru 65A1C1B209BB
Received: from mail.rzn.dlink.ru (localhost [127.0.0.1])
        by mail.rzn.dlink.ru (Postfix) with ESMTP id AF5BE1B21422;
        Fri, 17 Jan 2020 17:02:29 +0300 (MSK)
Received: from localhost.localdomain (unknown [196.196.203.126])
        by mail.rzn.dlink.ru (Postfix) with ESMTPA;
        Fri, 17 Jan 2020 17:02:29 +0300 (MSK)
From:   Alexander Lobakin <alobakin@dlink.ru>
To:     Paul Burton <paulburton@kernel.org>
Cc:     Ralf Baechle <ralf@linux-mips.org>,
        James Hogan <jhogan@kernel.org>,
        Masahiro Yamada <yamada.masahiro@socionext.com>,
        Rob Herring <robh@kernel.org>,
        Alexander Lobakin <alobakin@dlink.ru>,
        linux-mips@vger.kernel.org, stable@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH mips-fixes 1/3] MIPS: fix indentation of the 'RELOCS' message
Date:   Fri, 17 Jan 2020 17:02:07 +0300
Message-Id: <20200117140209.17672-2-alobakin@dlink.ru>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200117140209.17672-1-alobakin@dlink.ru>
References: <20200117140209.17672-1-alobakin@dlink.ru>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

quiet_cmd_relocs lacks a whitespace which results in:

  LD      vmlinux
  SORTEX  vmlinux
  SYSMAP  System.map
  RELOCS vmlinux
  Building modules, stage 2.
  MODPOST 64 modules

After this patch:

  LD      vmlinux
  SORTEX  vmlinux
  SYSMAP  System.map
  RELOCS  vmlinux
  Building modules, stage 2.
  MODPOST 64 modules

Typo is present in kernel tree since the introduction of relocatable
kernel support in e818fac595ab ("MIPS: Generate relocation table when
CONFIG_RELOCATABLE"), but the relocation scripts were moved to
Makefile.postlink later with 44079d3509ae ("MIPS: Use Makefile.postlink
to insert relocations into vmlinux").

Fixes: 44079d3509ae ("MIPS: Use Makefile.postlink to insert relocations into vmlinux")
Cc: <stable@vger.kernel.org> # v4.11+
Signed-off-by: Alexander Lobakin <alobakin@dlink.ru>
---
 arch/mips/Makefile.postlink | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/mips/Makefile.postlink b/arch/mips/Makefile.postlink
index f03fdc95143e..4b1d3ba3a8a2 100644
--- a/arch/mips/Makefile.postlink
+++ b/arch/mips/Makefile.postlink
@@ -17,7 +17,7 @@ quiet_cmd_ls3_llsc = LLSCCHK $@
       cmd_ls3_llsc = $(CMD_LS3_LLSC) $@
 
 CMD_RELOCS = arch/mips/boot/tools/relocs
-quiet_cmd_relocs = RELOCS $@
+quiet_cmd_relocs = RELOCS  $@
       cmd_relocs = $(CMD_RELOCS) $@
 
 # `@true` prevents complaint when there is nothing to be done
-- 
2.25.0

