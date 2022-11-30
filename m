Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DBA7763DDA5
	for <lists+stable@lfdr.de>; Wed, 30 Nov 2022 19:29:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229851AbiK3S3U (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 30 Nov 2022 13:29:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35106 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229853AbiK3S3T (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 30 Nov 2022 13:29:19 -0500
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 23F183D90B
        for <stable@vger.kernel.org>; Wed, 30 Nov 2022 10:29:18 -0800 (PST)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 6EADCD6E;
        Wed, 30 Nov 2022 10:29:24 -0800 (PST)
Received: from eglon.cambridge.arm.com (eglon.cambridge.arm.com [10.1.197.38])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 2D0673F73B;
        Wed, 30 Nov 2022 10:29:17 -0800 (PST)
From:   James Morse <james.morse@arm.com>
To:     stable@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Cc:     Catalin Marinas <catalin.marinas@arm.com>,
        James Morse <james.morse@arm.com>
Subject: [stable:PATCH v4.19.267 0/2] arm64: errata: Spectre-BHB fixes
Date:   Wed, 30 Nov 2022 18:29:05 +0000
Message-Id: <20221130182907.739150-1-james.morse@arm.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hello!

The first patch fixes an issue reported by Sami, where linux panic()s
when bringing secondary CPUs online. The problem was the Spectre
workarounds trying to allocate a new slot for mitigating KVM when
those pages are no longer writeable.

While debugging that issue, I spotted the Spectre-BHB KVM mitigation was
over-riding the Spectre-v2 KVM Mitigation. It's supposed to happen the
other way round.

The backports aren't the same as mainline because the spectre mitigation code
was totally rewritten for v5.10, and prior to that the KVM infrastructure
is very different.


Thanks,

James Morse (2):
  arm64: Fix panic() when Spectre-v2 causes Spectre-BHB to re-allocate
    KVM vectors
  arm64: errata: Fix KVM Spectre-v2 mitigation selection for
    Cortex-A57/A72

 arch/arm64/kernel/cpu_errata.c | 24 ++++++++++++++++++------
 1 file changed, 18 insertions(+), 6 deletions(-)

-- 
2.30.2

