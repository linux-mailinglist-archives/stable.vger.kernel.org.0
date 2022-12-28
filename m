Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EE2C56579F8
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 16:06:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233484AbiL1PGi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 10:06:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53948 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233577AbiL1PGe (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 10:06:34 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A4B7912AB9
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 07:06:32 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4243161365
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 15:06:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5516EC433EF;
        Wed, 28 Dec 2022 15:06:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672239991;
        bh=hyw9iTH/H0D6kJE+QzSnNUXjr2YuX9hc9tBhjqu3n0E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=j9f0Y5MF5tWYUuawRyOjQX7RXFqgN202zn1jKqvy4AoO+tufr3wdW/G+B8m1BI/ZL
         hO9T33onJAdFh275K39wXIqPgnMOG3ddtUIAPFZiIVnz360MDdLUciHyYAs2Fu9qaF
         cmuO8JEqtU6pZ/ofbGwX2buZ7rLFXtKDAJ2zy5HQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Hao Lee <haolee.swjtu@gmail.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Suren Baghdasaryan <surenb@google.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 0105/1073] sched/psi: Fix possible missing or delayed pending event
Date:   Wed, 28 Dec 2022 15:28:13 +0100
Message-Id: <20221228144330.897656160@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144328.162723588@linuxfoundation.org>
References: <20221228144328.162723588@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hao Lee <haolee.swjtu@gmail.com>

[ Upstream commit e38f89af6a13e895805febd3a329a13ab7e66fa4 ]

When a pending event exists and growth is less than the threshold, the
current logic is to skip this trigger without generating event. However,
from e6df4ead85d9 ("psi: fix possible trigger missing in the window"),
our purpose is to generate event as long as pending event exists and the
rate meets the limit, no matter what growth is.
This patch handles this case properly.

Fixes: e6df4ead85d9 ("psi: fix possible trigger missing in the window")
Signed-off-by: Hao Lee <haolee.swjtu@gmail.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Acked-by: Suren Baghdasaryan <surenb@google.com>
Link: https://lore.kernel.org/r/20220919072356.GA29069@haolee.io
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/sched/psi.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/kernel/sched/psi.c b/kernel/sched/psi.c
index ecb4b4ff4ce0..559416a27c0e 100644
--- a/kernel/sched/psi.c
+++ b/kernel/sched/psi.c
@@ -537,10 +537,12 @@ static u64 update_triggers(struct psi_group *group, u64 now)
 
 			/* Calculate growth since last update */
 			growth = window_update(&t->win, now, total[t->state]);
-			if (growth < t->threshold)
-				continue;
+			if (!t->pending_event) {
+				if (growth < t->threshold)
+					continue;
 
-			t->pending_event = true;
+				t->pending_event = true;
+			}
 		}
 		/* Limit event signaling to once per window */
 		if (now < t->last_event_time + t->win.size)
-- 
2.35.1



