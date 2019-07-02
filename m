Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 082FD5CB76
	for <lists+stable@lfdr.de>; Tue,  2 Jul 2019 10:13:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728204AbfGBIHI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Jul 2019 04:07:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:54204 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728195AbfGBIHH (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 2 Jul 2019 04:07:07 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 054082184E;
        Tue,  2 Jul 2019 08:07:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1562054826;
        bh=vxlSxloGy9FiBx6D4K/fVsTHST9rZqG0BZe4InvsPp4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=S+moHf9QWVNBp2ZtqwJt8oVrj1dbrWa/AxhoscTw++Tkx7DPk2ThQHU6BMXwe2lCU
         r+YRJN4gOp8RX3Ze76mDFxcqyOKojLs8R3AAEAvVw8GNnKxX2bqSAzSUdRmHyp+rpf
         U6GxdRN6X5166f5qmDUya2cXYDIoRBKTa/WXD6ow=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Geert Uytterhoeven <geert@linux-m68k.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Jiri Kosina <jkosina@suse.cz>,
        Ben Hutchings <ben@decadent.org.uk>
Subject: [PATCH 4.19 46/72] cpu/speculation: Warn on unsupported mitigations= parameter
Date:   Tue,  2 Jul 2019 10:01:47 +0200
Message-Id: <20190702080126.998230881@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190702080124.564652899@linuxfoundation.org>
References: <20190702080124.564652899@linuxfoundation.org>
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
@@ -2289,6 +2289,9 @@ static int __init mitigations_parse_cmdl
 		cpu_mitigations = CPU_MITIGATIONS_AUTO;
 	else if (!strcmp(arg, "auto,nosmt"))
 		cpu_mitigations = CPU_MITIGATIONS_AUTO_NOSMT;
+	else
+		pr_crit("Unsupported mitigations=%s, system may still be vulnerable\n",
+			arg);
 
 	return 0;
 }


