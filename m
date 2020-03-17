Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2FD8518809F
	for <lists+stable@lfdr.de>; Tue, 17 Mar 2020 12:11:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729324AbgCQLLo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Mar 2020 07:11:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:55130 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729318AbgCQLLo (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 17 Mar 2020 07:11:44 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 13850206EC;
        Tue, 17 Mar 2020 11:11:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1584443502;
        bh=CtFChaZy2GO3I0OiYW2OxCA1vTzF4bPl0CXFS3Z8Gu0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KxKvainIx6M/XgMekmdAPmVG683AQULlluXaLMo6YnJz2iqmrg+JQhiZX0TduHx0b
         Mwew4kHdO5NNleYL9s1dSrPHqJoCV1ZjQuROBjFK4GO0atj3EhZVLpt/oziEurCVwz
         n8rcvGo5AIv58ORwg6l4YB43vIvrkouNQtksYwXk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Paul Cercueil <paul@crapouillou.net>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Subject: [PATCH 5.5 104/151] MIPS: Fix CONFIG_MIPS_CMDLINE_DTB_EXTEND handling
Date:   Tue, 17 Mar 2020 11:55:14 +0100
Message-Id: <20200317103333.847496173@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200317103326.593639086@linuxfoundation.org>
References: <20200317103326.593639086@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Paul Cercueil <paul@crapouillou.net>

commit 8e029eb0bcd6a7fab6dc9191152c085784c31ee6 upstream.

The CONFIG_MIPS_CMDLINE_DTB_EXTEND option is used so that the kernel
arguments provided in the 'bootargs' property in devicetree are extended
with the kernel arguments provided by the bootloader.

The code was broken, as it didn't actually take any of the kernel
arguments provided in devicetree when that option was set.

Fixes: 7784cac69735 ("MIPS: cmdline: Clean up boot_command_line initialization")
Cc: stable@vger.kernel.org
Signed-off-by: Paul Cercueil <paul@crapouillou.net>
Signed-off-by: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/mips/kernel/setup.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/arch/mips/kernel/setup.c
+++ b/arch/mips/kernel/setup.c
@@ -606,7 +606,8 @@ static void __init bootcmdline_init(char
 	 * If we're configured to take boot arguments from DT, look for those
 	 * now.
 	 */
-	if (IS_ENABLED(CONFIG_MIPS_CMDLINE_FROM_DTB))
+	if (IS_ENABLED(CONFIG_MIPS_CMDLINE_FROM_DTB) ||
+	    IS_ENABLED(CONFIG_MIPS_CMDLINE_DTB_EXTEND))
 		of_scan_flat_dt(bootcmdline_scan_chosen, &dt_bootargs);
 #endif
 


