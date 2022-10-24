Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 64F4060AC8A
	for <lists+stable@lfdr.de>; Mon, 24 Oct 2022 16:08:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233564AbiJXOIg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Oct 2022 10:08:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36556 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233996AbiJXOHL (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Oct 2022 10:07:11 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 36D553DBD2;
        Mon, 24 Oct 2022 05:50:04 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9B5B9612C9;
        Mon, 24 Oct 2022 12:50:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8655DC433D6;
        Mon, 24 Oct 2022 12:50:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666615804;
        bh=G2L0nwBjn5VtTyRobVNartiz1/0xuFjNYrEZ5NJlSKU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AfqR38GZVrSvARtWr/dChJ4pHrNH6hDEhO8aGa2hBuFIIpVw+xJ0xsQgsPVSJnx3F
         DcPYtFUaiYOv/AqCJbsbaCMhGuO8WccZ0rDfmuDCvV5z9Frjt1A4NeMlyO5tJl3018
         uii5+/H8e0RlyjNAwT8PqX++sLnEv84hX2/R+0EY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, linux-riscv@lists.infradead.org,
        mingo@redhat.com, paul.walmsley@sifive.com, palmer@dabbelt.com,
        aou@eecs.berkeley.edu, zanussi@kernel.org, liaochang1@huawei.com,
        chris.zjh@huawei.com, Yipeng Zou <zouyipeng@huawei.com>,
        "Masami Hiramatsu (Google)" <mhiramat@kernel.org>,
        "Steven Rostedt (Google)" <rostedt@goodmis.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 388/530] tracing: kprobe: Fix kprobe event gen test module on exit
Date:   Mon, 24 Oct 2022 13:32:12 +0200
Message-Id: <20221024113102.627762726@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221024113044.976326639@linuxfoundation.org>
References: <20221024113044.976326639@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yipeng Zou <zouyipeng@huawei.com>

[ Upstream commit ac48e189527fae87253ef2bf58892e782fb36874 ]

Correct gen_kretprobe_test clr event para on module exit.
This will make it can't to delete.

Link: https://lkml.kernel.org/r/20220919125629.238242-2-zouyipeng@huawei.com

Cc: <linux-riscv@lists.infradead.org>
Cc: <mingo@redhat.com>
Cc: <paul.walmsley@sifive.com>
Cc: <palmer@dabbelt.com>
Cc: <aou@eecs.berkeley.edu>
Cc: <zanussi@kernel.org>
Cc: <liaochang1@huawei.com>
Cc: <chris.zjh@huawei.com>
Fixes: 64836248dda2 ("tracing: Add kprobe event command generation test module")
Signed-off-by: Yipeng Zou <zouyipeng@huawei.com>
Acked-by: Masami Hiramatsu (Google) <mhiramat@kernel.org>
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/trace/kprobe_event_gen_test.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/trace/kprobe_event_gen_test.c b/kernel/trace/kprobe_event_gen_test.c
index 18b0f1cbb947..e023154be0f8 100644
--- a/kernel/trace/kprobe_event_gen_test.c
+++ b/kernel/trace/kprobe_event_gen_test.c
@@ -206,7 +206,7 @@ static void __exit kprobe_event_gen_test_exit(void)
 	WARN_ON(kprobe_event_delete("gen_kprobe_test"));
 
 	/* Disable the event or you can't remove it */
-	WARN_ON(trace_array_set_clr_event(gen_kprobe_test->tr,
+	WARN_ON(trace_array_set_clr_event(gen_kretprobe_test->tr,
 					  "kprobes",
 					  "gen_kretprobe_test", false));
 
-- 
2.35.1



