Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 765AF45BC13
	for <lists+stable@lfdr.de>; Wed, 24 Nov 2021 13:23:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245455AbhKXMZz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Nov 2021 07:25:55 -0500
Received: from mail.kernel.org ([198.145.29.99]:38266 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S245040AbhKXMYe (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Nov 2021 07:24:34 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 94C1361206;
        Wed, 24 Nov 2021 12:15:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637756106;
        bh=ohuo0QU48rv3K/ooxaBjdZAhGuDZ37MKhXsozrU9CF4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qR3m85uJd+u4fmlCkHEEBaFWYJW5wObEaBeyZtlJojVYZwFzDGlYOgtOvQk5l/4q7
         QDJS6b5W4mOEQ0aFSSAlY5b3Njq758S9DuolDDRV5H2VGFIf7fudP+8Uu2MNpfwDHh
         MhH70QSavUWzyOlLw+YRA2b8mg0kyw4JBv/qQ5T8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>,
        Paul Mundt <lethal@linux-sh.org>,
        Guenter Roeck <linux@roeck-us.net>,
        Nick Desaulniers <ndesaulniers@google.com>,
        John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>,
        Miguel Ojeda <ojeda@kernel.org>, Rich Felker <dalias@libc.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 175/207] sh: check return code of request_irq
Date:   Wed, 24 Nov 2021 12:57:26 +0100
Message-Id: <20211124115709.648378592@linuxfoundation.org>
X-Mailer: git-send-email 2.34.0
In-Reply-To: <20211124115703.941380739@linuxfoundation.org>
References: <20211124115703.941380739@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nick Desaulniers <ndesaulniers@google.com>

[ Upstream commit 0e38225c92c7964482a8bb6b3e37fde4319e965c ]

request_irq is marked __must_check, but the call in shx3_prepare_cpus
has a void return type, so it can't propagate failure to the caller.
Follow cues from hexagon and just print an error.

Fixes: c7936b9abcf5 ("sh: smp: Hook in to the generic IPI handler for SH-X3 SMP.")
Cc: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Cc: Paul Mundt <lethal@linux-sh.org>
Reported-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Nick Desaulniers <ndesaulniers@google.com>
Tested-by: John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>
Reviewed-by: Miguel Ojeda <ojeda@kernel.org>
Signed-off-by: Rich Felker <dalias@libc.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/sh/kernel/cpu/sh4a/smp-shx3.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/arch/sh/kernel/cpu/sh4a/smp-shx3.c b/arch/sh/kernel/cpu/sh4a/smp-shx3.c
index 0d3637c494bfe..c1f66c35e0c12 100644
--- a/arch/sh/kernel/cpu/sh4a/smp-shx3.c
+++ b/arch/sh/kernel/cpu/sh4a/smp-shx3.c
@@ -76,8 +76,9 @@ static void shx3_prepare_cpus(unsigned int max_cpus)
 	BUILD_BUG_ON(SMP_MSG_NR >= 8);
 
 	for (i = 0; i < SMP_MSG_NR; i++)
-		request_irq(104 + i, ipi_interrupt_handler,
-			    IRQF_PERCPU, "IPI", (void *)(long)i);
+		if (request_irq(104 + i, ipi_interrupt_handler,
+			    IRQF_PERCPU, "IPI", (void *)(long)i))
+			pr_err("Failed to request irq %d\n", i);
 
 	for (i = 0; i < max_cpus; i++)
 		set_cpu_present(i, true);
-- 
2.33.0



