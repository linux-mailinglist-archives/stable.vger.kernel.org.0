Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 933FA1CB036
	for <lists+stable@lfdr.de>; Fri,  8 May 2020 15:24:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727861AbgEHMgn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 May 2020 08:36:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:50170 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727844AbgEHMgk (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 8 May 2020 08:36:40 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6F61021473;
        Fri,  8 May 2020 12:36:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588941399;
        bh=C4uUhk0YLhuLSdUkE+dP14X/bpJOJg8ZfomfZOV7kuQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2udYCEpgkW5MQWgGFzk9RAqI+MHy+FkSyGH26dgb3xKpQSw0zNsxmI6I8lfnbrzV8
         KlavS03hbHZxyxZPSYJvVImHe704u10BOkmdGvO28N/0xiymdQuMZyBSg6Rbp7JrKY
         oQlw9546cHJPeLcl60ZPzPFPWW3YAnGIlGUn53LY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Florian Fainelli <f.fainelli@gmail.com>,
        linux-mips@linux-mips.org, Ralf Baechle <ralf@linux-mips.org>
Subject: [PATCH 4.4 017/312] MIPS: BMIPS: Pretty print BMIPS5200 processor name
Date:   Fri,  8 May 2020 14:30:08 +0200
Message-Id: <20200508123125.704211127@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200508123124.574959822@linuxfoundation.org>
References: <20200508123124.574959822@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Florian Fainelli <f.fainelli@gmail.com>

commit 37808d62afcdc420d98875c4b514c178d56f6815 upstream.

Just to ease debugging of multiplatform kernel, make sure we print
"Broadcom BMIPS5200" for the BMIPS5200 implementation instead of
Broadcom BMIPS5000.

Fixes: 68e6a78373a6d ("MIPS: BMIPS: Add PRId for BMIPS5200 (Whirlwind)")
Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
Cc: linux-mips@linux-mips.org
Patchwork: https://patchwork.linux-mips.org/patch/13014/
Signed-off-by: Ralf Baechle <ralf@linux-mips.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/mips/kernel/cpu-probe.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/arch/mips/kernel/cpu-probe.c
+++ b/arch/mips/kernel/cpu-probe.c
@@ -1284,7 +1284,10 @@ static inline void cpu_probe_broadcom(st
 	case PRID_IMP_BMIPS5000:
 	case PRID_IMP_BMIPS5200:
 		c->cputype = CPU_BMIPS5000;
-		__cpu_name[cpu] = "Broadcom BMIPS5000";
+		if ((c->processor_id & PRID_IMP_MASK) == PRID_IMP_BMIPS5200)
+			__cpu_name[cpu] = "Broadcom BMIPS5200";
+		else
+			__cpu_name[cpu] = "Broadcom BMIPS5000";
 		set_elf_platform(cpu, "bmips5000");
 		c->options |= MIPS_CPU_ULRI;
 		break;


