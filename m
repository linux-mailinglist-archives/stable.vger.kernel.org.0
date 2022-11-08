Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 91DA762159D
	for <lists+stable@lfdr.de>; Tue,  8 Nov 2022 15:13:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235290AbiKHONe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Nov 2022 09:13:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51932 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235255AbiKHONc (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 8 Nov 2022 09:13:32 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 54220120AE
        for <stable@vger.kernel.org>; Tue,  8 Nov 2022 06:13:30 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 816FC615AD
        for <stable@vger.kernel.org>; Tue,  8 Nov 2022 14:13:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 91BBBC433C1;
        Tue,  8 Nov 2022 14:13:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1667916809;
        bh=Enubm5nSAt5pDKW3LGllasN5GiNRBGOeVDohoUocnLI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rG2sjCzCDlkC8TmdD/VeEE/2jVvYaOxJF1gszH53ET0/YxWYn8qjzJxZcRyDW+Tpo
         KI2hvj1TtwVV8u2SSG2dPO9C5SWkVsumE44EAnOcW1WPNnFkvtxEdVvNLSTAyZ3kVh
         clHso388XkyoRIpGiFImJMUVQIPMiksZe5XAw0Oo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Rafael Mendonca <rafaelmendsr@gmail.com>,
        "Steven Rostedt (Google)" <rostedt@goodmis.org>,
        "Masami Hiramatsu (Google)" <mhiramat@kernel.org>
Subject: [PATCH 6.0 140/197] fprobe: Check rethook_alloc() return in rethook initialization
Date:   Tue,  8 Nov 2022 14:39:38 +0100
Message-Id: <20221108133401.305366497@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221108133354.787209461@linuxfoundation.org>
References: <20221108133354.787209461@linuxfoundation.org>
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

From: Rafael Mendonca <rafaelmendsr@gmail.com>

commit d05ea35e7eea14d32f29fd688d3daeb9089de1a5 upstream.

Check if fp->rethook succeeded to be allocated. Otherwise, if
rethook_alloc() fails, then we end up dereferencing a NULL pointer in
rethook_add_node().

Link: https://lore.kernel.org/all/20221025031209.954836-1-rafaelmendsr@gmail.com/

Fixes: 5b0ab78998e3 ("fprobe: Add exit_handler support")
Cc: stable@vger.kernel.org
Signed-off-by: Rafael Mendonca <rafaelmendsr@gmail.com>
Acked-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Acked-by: Masami Hiramatsu (Google) <mhiramat@kernel.org>
Signed-off-by: Masami Hiramatsu (Google) <mhiramat@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/trace/fprobe.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/kernel/trace/fprobe.c
+++ b/kernel/trace/fprobe.c
@@ -141,6 +141,8 @@ static int fprobe_init_rethook(struct fp
 		return -E2BIG;
 
 	fp->rethook = rethook_alloc((void *)fp, fprobe_exit_handler);
+	if (!fp->rethook)
+		return -ENOMEM;
 	for (i = 0; i < size; i++) {
 		struct fprobe_rethook_node *node;
 


