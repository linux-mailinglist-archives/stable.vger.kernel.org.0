Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BB047593CF2
	for <lists+stable@lfdr.de>; Mon, 15 Aug 2022 22:39:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347382AbiHOU1a (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 16:27:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57580 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347942AbiHOU06 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 16:26:58 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF3299F0FD;
        Mon, 15 Aug 2022 12:03:54 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0B4BCB81062;
        Mon, 15 Aug 2022 19:03:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4124BC433C1;
        Mon, 15 Aug 2022 19:03:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660590228;
        bh=mpaC7JTvOmrNnf3T/xWqblB2Q03w8cm7v5oJam1g27I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ow3VRmYYj3JtGEPKiXsTRyro6f1EY0iDKrx+U/R7ckRkM0ptXOQ9VXzuWtgYXw9IO
         B3A1zed6991BvVdalzSxxGB8GSj1FphsNOpTwvKum4dICFWgMpPhEwEsgO17QgzqX9
         nZB3LO6H3n+EOKsezhufaB0K7ISJlGyTgg/okaqE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "Guilherme G. Piccoli" <gpiccoli@igalia.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 0192/1095] ACPI: processor/idle: Annotate more functions to live in cpuidle section
Date:   Mon, 15 Aug 2022 19:53:11 +0200
Message-Id: <20220815180437.570682105@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180429.240518113@linuxfoundation.org>
References: <20220815180429.240518113@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Guilherme G. Piccoli <gpiccoli@igalia.com>

[ Upstream commit 409dfdcaffb266acfc1f33529a26b1443c9332d4 ]

Commit 6727ad9e206c ("nmi_backtrace: generate one-line reports for idle cpus")
introduced a new text section called cpuidle; with that, we have a mechanism
to add idling functions in such section and skip them from nmi_backtrace
output, since they're useless and potentially flooding for such report.

Happens that inlining might cause some real idle functions to end-up
outside of such section; this is currently the case of ACPI processor_idle
driver; the functions acpi_idle_enter_* do inline acpi_idle_do_entry(),
hence they stay out of the cpuidle section.
Fix that by marking such functions to also live in the cpuidle section.

Fixes: 6727ad9e206c ("nmi_backtrace: generate one-line reports for idle cpus")
Signed-off-by: Guilherme G. Piccoli <gpiccoli@igalia.com>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/acpi/processor_idle.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/acpi/processor_idle.c b/drivers/acpi/processor_idle.c
index eb95e188d62b..573ba7f617e8 100644
--- a/drivers/acpi/processor_idle.c
+++ b/drivers/acpi/processor_idle.c
@@ -602,7 +602,7 @@ static DEFINE_RAW_SPINLOCK(c3_lock);
  * @cx: Target state context
  * @index: index of target state
  */
-static int acpi_idle_enter_bm(struct cpuidle_driver *drv,
+static int __cpuidle acpi_idle_enter_bm(struct cpuidle_driver *drv,
 			       struct acpi_processor *pr,
 			       struct acpi_processor_cx *cx,
 			       int index)
@@ -659,7 +659,7 @@ static int acpi_idle_enter_bm(struct cpuidle_driver *drv,
 	return index;
 }
 
-static int acpi_idle_enter(struct cpuidle_device *dev,
+static int __cpuidle acpi_idle_enter(struct cpuidle_device *dev,
 			   struct cpuidle_driver *drv, int index)
 {
 	struct acpi_processor_cx *cx = per_cpu(acpi_cstate[index], dev->cpu);
@@ -688,7 +688,7 @@ static int acpi_idle_enter(struct cpuidle_device *dev,
 	return index;
 }
 
-static int acpi_idle_enter_s2idle(struct cpuidle_device *dev,
+static int __cpuidle acpi_idle_enter_s2idle(struct cpuidle_device *dev,
 				  struct cpuidle_driver *drv, int index)
 {
 	struct acpi_processor_cx *cx = per_cpu(acpi_cstate[index], dev->cpu);
-- 
2.35.1



