Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 264B64CF79B
	for <lists+stable@lfdr.de>; Mon,  7 Mar 2022 10:46:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238297AbiCGJqs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Mar 2022 04:46:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57918 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238068AbiCGJol (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Mar 2022 04:44:41 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C12CE58382;
        Mon,  7 Mar 2022 01:41:36 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 74910B810B2;
        Mon,  7 Mar 2022 09:41:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A7DA1C340E9;
        Mon,  7 Mar 2022 09:41:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1646646094;
        bh=7DerX0b8DALAtu6wevcGsJHv/dcYVQh4/h5h4IeCgWI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1NF3XcU9X1nAjL5kbeniCm+ANEGnWdjdLGY10vMfZ1Nc0JDqfuxIc9e5uTHIbYFOC
         3XlvpYSFmQ1OM5/mh6REEPA5JulKNyvsJI6rhUeFZHbtVmnkr98uLapDG2ipgljoKw
         zADgDJPFiv4wDwOkxNNk+IuGv/pn+HDoRzGCwTgQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Masami Hiramatsu <mhiramat@kernel.org>,
        Xiaoke Wang <xkernel.wang@foxmail.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 091/262] tracing/probes: check the return value of kstrndup() for pbuf
Date:   Mon,  7 Mar 2022 10:17:15 +0100
Message-Id: <20220307091705.045364043@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220307091702.378509770@linuxfoundation.org>
References: <20220307091702.378509770@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Xiaoke Wang <xkernel.wang@foxmail.com>

[ Upstream commit 1c1857d400355e96f0fe8b32adc6fa7594d03b52 ]

kstrndup() is a memory allocation-related function, it returns NULL when
some internal memory errors happen. It is better to check the return
value of it so to catch the memory error in time.

Link: https://lkml.kernel.org/r/tencent_4D6E270731456EB88712ED7F13883C334906@qq.com

Acked-by: Masami Hiramatsu <mhiramat@kernel.org>
Fixes: a42e3c4de964 ("tracing/probe: Add immediate string parameter support")
Signed-off-by: Xiaoke Wang <xkernel.wang@foxmail.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/trace/trace_probe.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/kernel/trace/trace_probe.c b/kernel/trace/trace_probe.c
index 3ed2a3f372972..bb4605b60de79 100644
--- a/kernel/trace/trace_probe.c
+++ b/kernel/trace/trace_probe.c
@@ -356,6 +356,8 @@ static int __parse_imm_string(char *str, char **pbuf, int offs)
 		return -EINVAL;
 	}
 	*pbuf = kstrndup(str, len - 1, GFP_KERNEL);
+	if (!*pbuf)
+		return -ENOMEM;
 	return 0;
 }
 
-- 
2.34.1



