Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6E2FC21FB48
	for <lists+stable@lfdr.de>; Tue, 14 Jul 2020 21:00:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730107AbgGNTA2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Jul 2020 15:00:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:59398 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731368AbgGNTA1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 14 Jul 2020 15:00:27 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 46B632240B;
        Tue, 14 Jul 2020 19:00:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1594753226;
        bh=Gqrc7C2TViUlKciu8jFDR0TJn0ksrLybIEHAs9KjtaE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fQR1jdPNeaExdco+YZ8IViG5D+A4MD3+lTwpWk6pSBohIMvNsDqKSDC0kFE/V1KwF
         ajHF7ojxUsq5hzWjYT0d6LhT6uvGL0LiPfCp6ZLPjkIo3wywvhnPf/lIQHqgLJ6O++
         D5rpFs+EVP962jyHZGedJGk6E2QPEaewutCvCaVw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Will Deacon <will@kernel.org>
Subject: [PATCH 5.7 159/166] arm64: arch_timer: Disable the compat vdso for cores affected by ARM64_WORKAROUND_1418040
Date:   Tue, 14 Jul 2020 20:45:24 +0200
Message-Id: <20200714184123.436051558@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200714184115.844176932@linuxfoundation.org>
References: <20200714184115.844176932@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Marc Zyngier <maz@kernel.org>

commit 4b661d6133c5d3a7c9aca0b4ee5a78c7766eff3f upstream.

ARM64_WORKAROUND_1418040 requires that AArch32 EL0 accesses to
the virtual counter register are trapped and emulated by the kernel.
This makes the vdso pretty pointless, and in some cases livelock
prone.

Provide a workaround entry that limits the vdso to 64bit tasks.

Signed-off-by: Marc Zyngier <maz@kernel.org>
Acked-by: Mark Rutland <mark.rutland@arm.com>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20200706163802.1836732-4-maz@kernel.org
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/clocksource/arm_arch_timer.c |    8 ++++++++
 1 file changed, 8 insertions(+)

--- a/drivers/clocksource/arm_arch_timer.c
+++ b/drivers/clocksource/arm_arch_timer.c
@@ -480,6 +480,14 @@ static const struct arch_timer_erratum_w
 		.set_next_event_virt = erratum_set_next_event_tval_virt,
 	},
 #endif
+#ifdef CONFIG_ARM64_ERRATUM_1418040
+	{
+		.match_type = ate_match_local_cap_id,
+		.id = (void *)ARM64_WORKAROUND_1418040,
+		.desc = "ARM erratum 1418040",
+		.disable_compat_vdso = true,
+	},
+#endif
 };
 
 typedef bool (*ate_match_fn_t)(const struct arch_timer_erratum_workaround *,


