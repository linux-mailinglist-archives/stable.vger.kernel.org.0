Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7C81F49A4FC
	for <lists+stable@lfdr.de>; Tue, 25 Jan 2022 03:10:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1846497AbiAYAFO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 19:05:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53794 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1850382AbiAXX3w (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 18:29:52 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6BD16C0A8880;
        Mon, 24 Jan 2022 13:34:32 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0D639614CB;
        Mon, 24 Jan 2022 21:34:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E7DA0C340E4;
        Mon, 24 Jan 2022 21:34:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643060071;
        bh=7DerX0b8DALAtu6wevcGsJHv/dcYVQh4/h5h4IeCgWI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hU0UN28UAz0bk/y0EyLR65JG//bYGiiHiev/4UbrxCoOlPTa7KJE0dPx29G/AVNgi
         LlIu/Cb9iUNVrfjE4BKgSqrvqDZ0UKf16qgBLYmql+kAcWLkA9Kwn393kpC9pDhedP
         UqqWbWGQCjkAypm5fc+u6LlRVjL3IrHCRKhhaLNM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Masami Hiramatsu <mhiramat@kernel.org>,
        Xiaoke Wang <xkernel.wang@foxmail.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 0828/1039] tracing/probes: check the return value of kstrndup() for pbuf
Date:   Mon, 24 Jan 2022 19:43:37 +0100
Message-Id: <20220124184153.119249971@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184125.121143506@linuxfoundation.org>
References: <20220124184125.121143506@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
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



