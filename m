Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EC8B355197A
	for <lists+stable@lfdr.de>; Mon, 20 Jun 2022 15:06:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243368AbiFTNAQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Jun 2022 09:00:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39424 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243657AbiFTM62 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Jun 2022 08:58:28 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 17B7E1B79D;
        Mon, 20 Jun 2022 05:55:49 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A10A3B811BF;
        Mon, 20 Jun 2022 12:55:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EBA15C3411B;
        Mon, 20 Jun 2022 12:55:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655729735;
        bh=ZDUqt44bbeOu9tG6SfC5lmwbRy4fFSZTfMu/NpoAug8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jtCq5lXGjl27FrCGi6L2oqTom5z/exd0QNvTX+X18/4kKr9rFY6e0dvCX7U8BqZ64
         xA1zeUJ3uf0zGEIv+KOUI8i3onrpT1uKGOZcweEYrY7rAP/Q3y8JWNmdOA4KPmLSqV
         k6tlQE5codJ1kFIW0ZokZ2HZtMzPx5uem7y33GG8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Stephen Rothwell <sfr@canb.auug.org.au>,
        Masahiro Yamada <masahiroy@kernel.org>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Michael Kelley <mikelley@microsoft.com>,
        Wei Liu <wei.liu@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 057/141] clocksource: hyper-v: unexport __init-annotated hv_init_clocksource()
Date:   Mon, 20 Jun 2022 14:49:55 +0200
Message-Id: <20220620124731.222892274@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220620124729.509745706@linuxfoundation.org>
References: <20220620124729.509745706@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Masahiro Yamada <masahiroy@kernel.org>

[ Upstream commit 245b993d8f6c4e25f19191edfbd8080b645e12b1 ]

EXPORT_SYMBOL and __init is a bad combination because the .init.text
section is freed up after the initialization. Hence, modules cannot
use symbols annotated __init. The access to a freed symbol may end up
with kernel panic.

modpost used to detect it, but it has been broken for a decade.

Recently, I fixed modpost so it started to warn it again, then this
showed up in linux-next builds.

There are two ways to fix it:

  - Remove __init
  - Remove EXPORT_SYMBOL

I chose the latter for this case because the only in-tree call-site,
arch/x86/kernel/cpu/mshyperv.c is never compiled as modular.
(CONFIG_HYPERVISOR_GUEST is boolean)

Fixes: dd2cb348613b ("clocksource/drivers: Continue making Hyper-V clocksource ISA agnostic")
Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Masahiro Yamada <masahiroy@kernel.org>
Reviewed-by: Vitaly Kuznetsov <vkuznets@redhat.com>
Reviewed-by: Michael Kelley <mikelley@microsoft.com>
Link: https://lore.kernel.org/r/20220606050238.4162200-1-masahiroy@kernel.org
Signed-off-by: Wei Liu <wei.liu@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clocksource/hyperv_timer.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/clocksource/hyperv_timer.c b/drivers/clocksource/hyperv_timer.c
index ff188ab68496..bb47610bbd1c 100644
--- a/drivers/clocksource/hyperv_timer.c
+++ b/drivers/clocksource/hyperv_timer.c
@@ -565,4 +565,3 @@ void __init hv_init_clocksource(void)
 	hv_sched_clock_offset = hv_read_reference_counter();
 	hv_setup_sched_clock(read_hv_sched_clock_msr);
 }
-EXPORT_SYMBOL_GPL(hv_init_clocksource);
-- 
2.35.1



