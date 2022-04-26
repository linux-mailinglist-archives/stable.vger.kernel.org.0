Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 623B450F481
	for <lists+stable@lfdr.de>; Tue, 26 Apr 2022 10:37:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345117AbiDZIg2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 Apr 2022 04:36:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39300 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345498AbiDZIek (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 26 Apr 2022 04:34:40 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 13237762B1;
        Tue, 26 Apr 2022 01:27:29 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4425E617F1;
        Tue, 26 Apr 2022 08:27:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 07E75C385A0;
        Tue, 26 Apr 2022 08:27:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1650961648;
        bh=uohlWFwBq9UC0CYbsoaezznRmsKwW5dkGs3AXvj3XO4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NAjEYCoPu8Cg5Hx93RdZpGYeSyzt869XDG06BkDd7hNqHp8hq/4LC/zHAYdTOAzVD
         JpxgiHvea1VV3TiLPhU8ie1464rksKOp20e3UTui8e/MO8GUHOTCbsU6/Th//PSogW
         eTkAAITVc0utVWZYHL2sn2iR2Vsx8HRcHaBiDA9Q=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Al Grant <al.grant@arm.com>,
        Will Deacon <will@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Rob Herring <robh@kernel.org>
Subject: [PATCH 4.19 38/53] arm_pmu: Validate single/group leader events
Date:   Tue, 26 Apr 2022 10:21:18 +0200
Message-Id: <20220426081736.765051355@linuxfoundation.org>
X-Mailer: git-send-email 2.36.0
In-Reply-To: <20220426081735.651926456@linuxfoundation.org>
References: <20220426081735.651926456@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Rob Herring <robh@kernel.org>

commit e5c23779f93d45e39a52758ca593bd7e62e9b4be upstream.

In the case where there is only a cycle counter available (i.e.
PMCR_EL0.N is 0) and an event other than CPU cycles is opened, the open
should fail as the event can never possibly be scheduled. However, the
event validation when an event is opened is skipped when the group
leader is opened. Fix this by always validating the group leader events.

Reported-by: Al Grant <al.grant@arm.com>
Cc: Will Deacon <will@kernel.org>
Cc: Mark Rutland <mark.rutland@arm.com>
Signed-off-by: Rob Herring <robh@kernel.org>
Acked-by: Mark Rutland <mark.rutland@arm.com>
Link: https://lore.kernel.org/r/20220408203330.4014015-1-robh@kernel.org
Cc: <stable@vger.kernel.org>
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/perf/arm_pmu.c |   10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

--- a/drivers/perf/arm_pmu.c
+++ b/drivers/perf/arm_pmu.c
@@ -321,6 +321,9 @@ validate_group(struct perf_event *event)
 	if (!validate_event(event->pmu, &fake_pmu, leader))
 		return -EINVAL;
 
+	if (event == leader)
+		return 0;
+
 	for_each_sibling_event(sibling, leader) {
 		if (!validate_event(event->pmu, &fake_pmu, sibling))
 			return -EINVAL;
@@ -418,12 +421,7 @@ __hw_perf_event_init(struct perf_event *
 		local64_set(&hwc->period_left, hwc->sample_period);
 	}
 
-	if (event->group_leader != event) {
-		if (validate_group(event) != 0)
-			return -EINVAL;
-	}
-
-	return 0;
+	return validate_group(event);
 }
 
 static int armpmu_event_init(struct perf_event *event)


