Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 81FF36214DE
	for <lists+stable@lfdr.de>; Tue,  8 Nov 2022 15:06:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235083AbiKHOGE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Nov 2022 09:06:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40388 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235074AbiKHOFz (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 8 Nov 2022 09:05:55 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B386A7057A
        for <stable@vger.kernel.org>; Tue,  8 Nov 2022 06:05:54 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id AAF0DB816DD
        for <stable@vger.kernel.org>; Tue,  8 Nov 2022 14:05:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E6E60C433C1;
        Tue,  8 Nov 2022 14:05:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1667916349;
        bh=D42wWdO13UaRA6r0dT1KYdG5P+boJfd8j/dcntP/OPQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sUxqCMfBFb6NrH6pawlzpmG6Quu0jCDTd00QYRnd09Le0gna5fAeokgI1z3qMzlYv
         4N4EGdr5JJmR80yBLnpdAUnQRtB960NsN6u20OFObY/0ToNCcblfsSIODCZCK1Kmha
         skJEPhQawzvZzrVJ2KgmR70tID1SHdbN3T+p89eI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Li Qiang <liq3ea@163.com>,
        "Masami Hiramatsu (Google)" <mhiramat@kernel.org>
Subject: [PATCH 5.15 108/144] kprobe: reverse kp->flags when arm_kprobe failed
Date:   Tue,  8 Nov 2022 14:39:45 +0100
Message-Id: <20221108133349.880590763@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221108133345.346704162@linuxfoundation.org>
References: <20221108133345.346704162@linuxfoundation.org>
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

From: Li Qiang <liq3ea@163.com>

commit 4a6f316d6855a434f56dbbeba05e14c01acde8f8 upstream.

In aggregate kprobe case, when arm_kprobe failed,
we need set the kp->flags with KPROBE_FLAG_DISABLED again.
If not, the 'kp' kprobe will been considered as enabled
but it actually not enabled.

Link: https://lore.kernel.org/all/20220902155820.34755-1-liq3ea@163.com/

Fixes: 12310e343755 ("kprobes: Propagate error from arm_kprobe_ftrace()")
Cc: stable@vger.kernel.org
Signed-off-by: Li Qiang <liq3ea@163.com>
Acked-by: Masami Hiramatsu (Google) <mhiramat@kernel.org>
Signed-off-by: Masami Hiramatsu (Google) <mhiramat@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/kprobes.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/kernel/kprobes.c
+++ b/kernel/kprobes.c
@@ -2208,8 +2208,11 @@ int enable_kprobe(struct kprobe *kp)
 	if (!kprobes_all_disarmed && kprobe_disabled(p)) {
 		p->flags &= ~KPROBE_FLAG_DISABLED;
 		ret = arm_kprobe(p);
-		if (ret)
+		if (ret) {
 			p->flags |= KPROBE_FLAG_DISABLED;
+			if (p != kp)
+				kp->flags |= KPROBE_FLAG_DISABLED;
+		}
 	}
 out:
 	mutex_unlock(&kprobe_mutex);


