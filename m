Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4A5DA66EAE
	for <lists+stable@lfdr.de>; Fri, 12 Jul 2019 14:40:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728231AbfGLMZG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 12 Jul 2019 08:25:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:34660 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728225AbfGLMZF (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 12 Jul 2019 08:25:05 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F0BCC21783;
        Fri, 12 Jul 2019 12:25:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1562934304;
        bh=1zbwKMqX+T8msQTcbbRyHvD6ZrMG04BBpZ8BAEgZcfw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=raD5gmL2eDZDqjn/MVaZ86dsXgzLzyy8XTemdJgnHClr89PPbxGWSVuRlV2xhQcWz
         eqylNi71qlmAbaJex4fhztad0fmwd0lf2c13TdhZAaFxBeBULadqfqtTkSqCz5rIx6
         y4K0fTLBbF26nuwYwKnAbt/nwPz2mMxZcSJcICBw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Matteo Croce <mcroce@redhat.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.1 012/138] samples, bpf: suppress compiler warning
Date:   Fri, 12 Jul 2019 14:17:56 +0200
Message-Id: <20190712121629.193225639@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190712121628.731888964@linuxfoundation.org>
References: <20190712121628.731888964@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit a195cefff49f60054998333e81ee95170ce8bf92 ]

GCC 9 fails to calculate the size of local constant strings and produces a
false positive:

samples/bpf/task_fd_query_user.c: In function ‘test_debug_fs_uprobe’:
samples/bpf/task_fd_query_user.c:242:67: warning: ‘%s’ directive output may be truncated writing up to 255 bytes into a region of size 215 [-Wformat-truncation=]
  242 |  snprintf(buf, sizeof(buf), "/sys/kernel/debug/tracing/events/%ss/%s/id",
      |                                                                   ^~
  243 |    event_type, event_alias);
      |                ~~~~~~~~~~~
samples/bpf/task_fd_query_user.c:242:2: note: ‘snprintf’ output between 45 and 300 bytes into a destination of size 256
  242 |  snprintf(buf, sizeof(buf), "/sys/kernel/debug/tracing/events/%ss/%s/id",
      |  ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  243 |    event_type, event_alias);
      |    ~~~~~~~~~~~~~~~~~~~~~~~~

Workaround this by lowering the buffer size to a reasonable value.
Related GCC Bugzilla: https://gcc.gnu.org/bugzilla/show_bug.cgi?id=83431

Signed-off-by: Matteo Croce <mcroce@redhat.com>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 samples/bpf/task_fd_query_user.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/samples/bpf/task_fd_query_user.c b/samples/bpf/task_fd_query_user.c
index aff2b4ae914e..e39938058223 100644
--- a/samples/bpf/task_fd_query_user.c
+++ b/samples/bpf/task_fd_query_user.c
@@ -216,7 +216,7 @@ static int test_debug_fs_uprobe(char *binary_path, long offset, bool is_return)
 {
 	const char *event_type = "uprobe";
 	struct perf_event_attr attr = {};
-	char buf[256], event_alias[256];
+	char buf[256], event_alias[sizeof("test_1234567890")];
 	__u64 probe_offset, probe_addr;
 	__u32 len, prog_id, fd_type;
 	int err, res, kfd, efd;
-- 
2.20.1



