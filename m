Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4940262173
	for <lists+stable@lfdr.de>; Mon,  8 Jul 2019 17:16:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732543AbfGHPQZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Jul 2019 11:16:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:39296 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732526AbfGHPQW (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Jul 2019 11:16:22 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BF010216E3;
        Mon,  8 Jul 2019 15:16:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1562598981;
        bh=FLoJA22TisOPhVmd/CYDRTtX172G09Aaw02XtNAeIJE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XkDo1/ng70LDOcv5JHE6QDVGuxPfdwsvnY0wMz6bLq2Mmwx+pwzZ9Ec/JRojLSQuF
         PN3BZRT7A8BKuO3ONO9UIx5ea9SEwBdpEZ+Q1vNMnsNoGokjdtzmUyEtAfrSrt6scH
         MErq7i3LSQS7739Z+dJEh7e4+DpAJ9UkIbclWPy0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Geert Uytterhoeven <geert@linux-m68k.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Jiri Kosina <jkosina@suse.cz>,
        Ben Hutchings <ben@decadent.org.uk>
Subject: [PATCH 4.4 39/73] cpu/speculation: Warn on unsupported mitigations= parameter
Date:   Mon,  8 Jul 2019 17:12:49 +0200
Message-Id: <20190708150523.406204248@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190708150513.136580595@linuxfoundation.org>
References: <20190708150513.136580595@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Geert Uytterhoeven <geert@linux-m68k.org>

commit 1bf72720281770162c87990697eae1ba2f1d917a upstream.

Currently, if the user specifies an unsupported mitigation strategy on the
kernel command line, it will be ignored silently.  The code will fall back
to the default strategy, possibly leaving the system more vulnerable than
expected.

This may happen due to e.g. a simple typo, or, for a stable kernel release,
because not all mitigation strategies have been backported.

Inform the user by printing a message.

Fixes: 98af8452945c5565 ("cpu/speculation: Add 'mitigations=' cmdline option")
Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Acked-by: Josh Poimboeuf <jpoimboe@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Jiri Kosina <jkosina@suse.cz>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Ben Hutchings <ben@decadent.org.uk>
Cc: stable@vger.kernel.org
Link: https://lkml.kernel.org/r/20190516070935.22546-1-geert@linux-m68k.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 kernel/cpu.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/kernel/cpu.c
+++ b/kernel/cpu.c
@@ -851,6 +851,9 @@ static int __init mitigations_parse_cmdl
 		cpu_mitigations = CPU_MITIGATIONS_OFF;
 	else if (!strcmp(arg, "auto"))
 		cpu_mitigations = CPU_MITIGATIONS_AUTO;
+	else
+		pr_crit("Unsupported mitigations=%s, system may still be vulnerable\n",
+			arg);
 
 	return 0;
 }


