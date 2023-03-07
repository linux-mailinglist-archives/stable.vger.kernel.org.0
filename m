Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5F3AA6AEA94
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 18:35:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231695AbjCGRfM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 12:35:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33052 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231649AbjCGReq (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 12:34:46 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 455A19BA5A
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 09:30:54 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E35FFB819A3
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 17:30:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4EFD4C433EF;
        Tue,  7 Mar 2023 17:30:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678210251;
        bh=G8Ypl3TrIQpvm4SS0kqlt73WoxE5mdo/N3H9iZVA1Qo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gX7wMAVeUkd5gAQtjiZd/MmV2SQkBBRfyw8A02mMEe7BptOKNehJBKr7fRxcQjcAE
         OirQdVMP2nM1OgT7K6dqiwcPUD+EXgeex6lTqVls4mZcFmYNj009WO0SItxrTTnPW3
         vjF4wl1W1dbR3atn6cc7e2fg92g4VoKsaot20hD0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        "Masami Hiramatsu (Google)" <mhiramat@kernel.org>,
        "Steven Rostedt (Google)" <rostedt@goodmis.org>,
        Shuah Khan <skhan@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 0481/1001] selftests/ftrace: Fix probepoint testcase to ignore __pfx_* symbols
Date:   Tue,  7 Mar 2023 17:54:13 +0100
Message-Id: <20230307170042.281953847@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170022.094103862@linuxfoundation.org>
References: <20230307170022.094103862@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Masami Hiramatsu (Google) <mhiramat@kernel.org>

[ Upstream commit 96cd93af794cf3ef83ae1ad7291160029d7b525e ]

Fix kprobe probepoint testcase to ignore __pfx_* prefix symbols. Those are
introduced by commit b341b20d648b ("x86: Add prefix symbols for function
padding") for identifying PADDING_BYTES of NOPs. Since kprobe events can
not probe these prefix symbols, this testcase has to skip those symbols.

Link: https://lore.kernel.org/all/167309835609.640500.9664678940260305746.stgit@devnote3/

Fixes: b341b20d648b ("x86: Add prefix symbols for function padding")
Signed-off-by: Masami Hiramatsu (Google) <mhiramat@kernel.org>
Reviewed-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Acked-by: Shuah Khan <skhan@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/ftrace/test.d/kprobe/probepoint.tc | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/ftrace/test.d/kprobe/probepoint.tc b/tools/testing/selftests/ftrace/test.d/kprobe/probepoint.tc
index 624269c8d5343..68425987a5dd9 100644
--- a/tools/testing/selftests/ftrace/test.d/kprobe/probepoint.tc
+++ b/tools/testing/selftests/ftrace/test.d/kprobe/probepoint.tc
@@ -21,7 +21,7 @@ set_offs() { # prev target next
 
 # We have to decode symbol addresses to get correct offsets.
 # If the offset is not an instruction boundary, it cause -EILSEQ.
-set_offs `grep -A1 -B1 ${TARGET_FUNC} /proc/kallsyms | cut -f 1 -d " " | xargs`
+set_offs `grep -v __pfx_ /proc/kallsyms | grep -A1 -B1 ${TARGET_FUNC} | cut -f 1 -d " " | xargs`
 
 UINT_TEST=no
 # printf "%x" -1 returns (unsigned long)-1.
-- 
2.39.2



