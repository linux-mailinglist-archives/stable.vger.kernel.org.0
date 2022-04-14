Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 429FA50103F
	for <lists+stable@lfdr.de>; Thu, 14 Apr 2022 16:44:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229651AbiDNNrp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 14 Apr 2022 09:47:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36796 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343559AbiDNNjG (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 14 Apr 2022 09:39:06 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F060818392;
        Thu, 14 Apr 2022 06:34:26 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id AACFFB8296A;
        Thu, 14 Apr 2022 13:34:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1E965C385A5;
        Thu, 14 Apr 2022 13:34:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649943264;
        bh=CdMOvF6r2GW8m2roTh6MVKEvGZyY1x+ccDj8OjjuD2Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Jo6XPMrT7i4m0IRj+9BNe5Mj9DSJKFXVOr+qtiuzxhwkUTDaFp+5a+21d05f3FPjc
         dRkpTd48zKR/AoiTiMxZcHbqYDKuOqHOLiJueJsdwlq13DXq3hx3m/ZPjYXdzDmzVF
         HS2Zd58Sc/sGuygIlwQL+rc1PIbE4me31rDaNVq8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Nikita Shubin <n.shubin@yadro.com>,
        Palmer Dabbelt <palmer@rivosinc.com>
Subject: [PATCH 5.4 053/475] riscv: Fix fill_callchain return value
Date:   Thu, 14 Apr 2022 15:07:18 +0200
Message-Id: <20220414110856.638091092@linuxfoundation.org>
X-Mailer: git-send-email 2.35.2
In-Reply-To: <20220414110855.141582785@linuxfoundation.org>
References: <20220414110855.141582785@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nikita Shubin <n.shubin@yadro.com>

commit 2b2b574ac587ec5bd7716a356492a85ab8b0ce9f upstream.

perf_callchain_store return 0 on success, -1 otherwise,
fix fill_callchain to return correct bool value.

Fixes: dbeb90b0c1eb ("riscv: Add perf callchain support")
Signed-off-by: Nikita Shubin <n.shubin@yadro.com>
Cc: stable@vger.kernel.org
Signed-off-by: Palmer Dabbelt <palmer@rivosinc.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/riscv/kernel/perf_callchain.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/riscv/kernel/perf_callchain.c
+++ b/arch/riscv/kernel/perf_callchain.c
@@ -77,7 +77,7 @@ void perf_callchain_user(struct perf_cal
 
 bool fill_callchain(unsigned long pc, void *entry)
 {
-	return perf_callchain_store(entry, pc);
+	return perf_callchain_store(entry, pc) == 0;
 }
 
 void notrace walk_stackframe(struct task_struct *task,


