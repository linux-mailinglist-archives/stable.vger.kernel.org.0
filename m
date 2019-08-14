Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CE8D88C83E
	for <lists+stable@lfdr.de>; Wed, 14 Aug 2019 04:31:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729832AbfHNCX2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 13 Aug 2019 22:23:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:52498 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729811AbfHNCX1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 13 Aug 2019 22:23:27 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3E9B520842;
        Wed, 14 Aug 2019 02:23:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1565749407;
        bh=fDEtZsFIYm5HYRGuh/FkCw7ClI9UfM2kYm/fzPXNZ8w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=N3zL7pns6GbW7Aj2bAo0I7Ilzt1v+6BzSmDFzCbSpOTW5koEIOUS7KZ7FCqLjiUhg
         6LDv/7X+FeTbG2KhvcQjU+2isez5/1LmZdw3apL3rc7UWNFKS9mWdbEL2eLNtcZBVA
         spG5jGICQW2Ouo7gj1rXL1MjaO3ED40xQRVQxh30=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Thomas Bogendoerfer <tbogendoerfer@suse.de>,
        Paul Burton <paul.burton@mips.com>,
        Ralf Baechle <ralf@linux-mips.org>,
        James Hogan <jhogan@kernel.org>, linux-mips@vger.kernel.org,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 4.9 02/33] MIPS: kernel: only use i8253 clocksource with periodic clockevent
Date:   Tue, 13 Aug 2019 22:22:52 -0400
Message-Id: <20190814022323.17111-2-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190814022323.17111-1-sashal@kernel.org>
References: <20190814022323.17111-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Thomas Bogendoerfer <tbogendoerfer@suse.de>

[ Upstream commit a07e3324538a989b7cdbf2c679be6a7f9df2544f ]

i8253 clocksource needs a free running timer. This could only
be used, if i8253 clockevent is set up as periodic.

Signed-off-by: Thomas Bogendoerfer <tbogendoerfer@suse.de>
Signed-off-by: Paul Burton <paul.burton@mips.com>
Cc: Ralf Baechle <ralf@linux-mips.org>
Cc: James Hogan <jhogan@kernel.org>
Cc: linux-mips@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/mips/kernel/i8253.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/mips/kernel/i8253.c b/arch/mips/kernel/i8253.c
index c5bc344fc745c..73039746ae364 100644
--- a/arch/mips/kernel/i8253.c
+++ b/arch/mips/kernel/i8253.c
@@ -31,7 +31,8 @@ void __init setup_pit_timer(void)
 
 static int __init init_pit_clocksource(void)
 {
-	if (num_possible_cpus() > 1) /* PIT does not scale! */
+	if (num_possible_cpus() > 1 || /* PIT does not scale! */
+	    !clockevent_state_periodic(&i8253_clockevent))
 		return 0;
 
 	return clocksource_i8253_init();
-- 
2.20.1

