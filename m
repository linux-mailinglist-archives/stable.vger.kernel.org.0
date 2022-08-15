Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0BE1B594566
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 01:00:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233454AbiHOWc1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 18:32:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52602 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348982AbiHOWaP (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 18:30:15 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E06B470E4B;
        Mon, 15 Aug 2022 12:48:10 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0274761269;
        Mon, 15 Aug 2022 19:48:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E77C9C433C1;
        Mon, 15 Aug 2022 19:48:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660592889;
        bh=v+8BW4sU+DYYuLIMxucs4tnKqWv7E/wqEuADuGahClE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TsjIcO4LyXuwSbDNaLBSTUOy2u5KgYZS0zI+u1Dj7GcdLKxEWXLOSEUmJ/JMwXgJ3
         zsXxm85oTOBwf0IYrpav5R5RbizTm+bTLn2qeFGK/JXMBfmkvmRUjdXTaMqEXQ9CgP
         pIZAMAzcgzfJa9Py251u8+Ib5f7SCKYCquXiR8Tc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Mark Rutland <mark.rutland@arm.com>,
        Andrey Konovalov <andreyknvl@google.com>,
        Will Deacon <will@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 0150/1157] arm64: stacktrace: use non-atomic __set_bit
Date:   Mon, 15 Aug 2022 19:51:46 +0200
Message-Id: <20220815180445.663554581@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180439.416659447@linuxfoundation.org>
References: <20220815180439.416659447@linuxfoundation.org>
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

From: Andrey Konovalov <andreyknvl@google.com>

[ Upstream commit 446297b28a21244e4045026c4599d1b14a67e2ce ]

Use the non-atomic version of set_bit() in arch/arm64/kernel/stacktrace.c,
as there is no concurrent accesses to frame->prev_type.

This speeds up stack trace collection and improves the boot time of
Generic KASAN by 2-5%.

Suggested-by: Mark Rutland <mark.rutland@arm.com>
Acked-by: Mark Rutland <mark.rutland@arm.com>
Signed-off-by: Andrey Konovalov <andreyknvl@google.com>
Link: https://lore.kernel.org/r/23dfa36d1cc91e4a1059945b7834eac22fb9854d.1653317461.git.andreyknvl@google.com
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/kernel/stacktrace.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/kernel/stacktrace.c b/arch/arm64/kernel/stacktrace.c
index c246e8d9f95b..d6bef106e37e 100644
--- a/arch/arm64/kernel/stacktrace.c
+++ b/arch/arm64/kernel/stacktrace.c
@@ -117,7 +117,7 @@ static int notrace unwind_next(struct task_struct *tsk,
 		if (fp <= state->prev_fp)
 			return -EINVAL;
 	} else {
-		set_bit(state->prev_type, state->stacks_done);
+		__set_bit(state->prev_type, state->stacks_done);
 	}
 
 	/*
-- 
2.35.1



