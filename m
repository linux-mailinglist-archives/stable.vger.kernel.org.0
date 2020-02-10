Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 840BE157A98
	for <lists+stable@lfdr.de>; Mon, 10 Feb 2020 14:24:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729013AbgBJNXr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Feb 2020 08:23:47 -0500
Received: from mail.kernel.org ([198.145.29.99]:58240 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728652AbgBJMhK (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 Feb 2020 07:37:10 -0500
Received: from localhost (unknown [209.37.97.194])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AA9F3208C4;
        Mon, 10 Feb 2020 12:37:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581338229;
        bh=zSg6T09HqcBiqYeTqt4FTCQO6B5h/IbyxlbEvz0yLW8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PhqQF2rHK98OyIW+Ha9Wd24BLfFI4+fwO8R2u37mjGYSy1Ffr771dVxl+gmx9vyTu
         ycPS8C1fX7ihnLDF1FSawi+c7MaBuBCHQ1h+eS4K0N2K4SaKdK5ZD8n5wdAgKI78ec
         vy6YF5nQ0cbyx9dtpCr/qEmJ0DhNSCx2fO7pU2k8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Alexander Lobakin <alobakin@dlink.ru>,
        Paul Burton <paulburton@kernel.org>,
        Ralf Baechle <ralf@linux-mips.org>,
        James Hogan <jhogan@kernel.org>,
        Masahiro Yamada <yamada.masahiro@socionext.com>,
        Rob Herring <robh@kernel.org>, linux-mips@vger.kernel.org
Subject: [PATCH 5.4 071/309] MIPS: fix indentation of the RELOCS message
Date:   Mon, 10 Feb 2020 04:30:27 -0800
Message-Id: <20200210122412.710756016@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200210122406.106356946@linuxfoundation.org>
References: <20200210122406.106356946@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alexander Lobakin <alobakin@dlink.ru>

commit a53998802e178451701d59d38e36f551422977ba upstream.

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
kernel support in commit e818fac595ab ("MIPS: Generate relocation table
when CONFIG_RELOCATABLE"), but the relocation scripts were moved to
Makefile.postlink later with commit 44079d3509ae ("MIPS: Use
Makefile.postlink to insert relocations into vmlinux").

Fixes: 44079d3509ae ("MIPS: Use Makefile.postlink to insert relocations into vmlinux")
Cc: <stable@vger.kernel.org> # v4.11+
Signed-off-by: Alexander Lobakin <alobakin@dlink.ru>
[paulburton@kernel.org: Fixup commit references in commit message.]
Signed-off-by: Paul Burton <paulburton@kernel.org>
Cc: Ralf Baechle <ralf@linux-mips.org>
Cc: James Hogan <jhogan@kernel.org>
Cc: Masahiro Yamada <yamada.masahiro@socionext.com>
Cc: Rob Herring <robh@kernel.org>
Cc: linux-mips@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/mips/Makefile.postlink |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/mips/Makefile.postlink
+++ b/arch/mips/Makefile.postlink
@@ -12,7 +12,7 @@ __archpost:
 include scripts/Kbuild.include
 
 CMD_RELOCS = arch/mips/boot/tools/relocs
-quiet_cmd_relocs = RELOCS $@
+quiet_cmd_relocs = RELOCS  $@
       cmd_relocs = $(CMD_RELOCS) $@
 
 # `@true` prevents complaint when there is nothing to be done


