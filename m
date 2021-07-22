Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C14043D2A4C
	for <lists+stable@lfdr.de>; Thu, 22 Jul 2021 19:07:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234876AbhGVQK2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 22 Jul 2021 12:10:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:51984 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235596AbhGVQJd (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 22 Jul 2021 12:09:33 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D610E613AF;
        Thu, 22 Jul 2021 16:49:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626972577;
        bh=P4TsWLQzzp23saKALdUXxxzi6dTa38+LKw2Xj+iEBWs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zAriDOdX17MOhU4Y/3vnG4176tC03sTfzFbeB2hEoyc+L4LiiLIE83vEKVjNTrqrH
         3fQovOeoTSrVcS5wVQHpwVCfvpS6xYjDzlTPtXAQgBJAwykZMyXD7UBjHi83CgOTn/
         FgSjJ2/SOMhwjGpo3Fa9eLCfnpAShIWpqeb47W1k=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Gu Shengxian <gushengxian@yulong.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jiri Olsa <jolsa@redhat.com>
Subject: [PATCH 5.13 149/156] bpftool: Properly close va_list ap by va_end() on error
Date:   Thu, 22 Jul 2021 18:32:04 +0200
Message-Id: <20210722155633.166019965@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210722155628.371356843@linuxfoundation.org>
References: <20210722155628.371356843@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Gu Shengxian <gushengxian@yulong.com>

commit bc832065b60f973771ff3e657214bb21b559833c upstream.

va_list 'ap' was opened but not closed by va_end() in error case. It should
be closed by va_end() before the return.

Fixes: aa52bcbe0e72 ("tools: bpftool: Fix json dump crash on powerpc")
Signed-off-by: Gu Shengxian <gushengxian@yulong.com>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Cc: Jiri Olsa <jolsa@redhat.com>
Link: https://lore.kernel.org/bpf/20210706013543.671114-1-gushengxian507419@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/bpf/bpftool/jit_disasm.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/tools/bpf/bpftool/jit_disasm.c
+++ b/tools/bpf/bpftool/jit_disasm.c
@@ -43,11 +43,13 @@ static int fprintf_json(void *out, const
 {
 	va_list ap;
 	char *s;
+	int err;
 
 	va_start(ap, fmt);
-	if (vasprintf(&s, fmt, ap) < 0)
-		return -1;
+	err = vasprintf(&s, fmt, ap);
 	va_end(ap);
+	if (err < 0)
+		return -1;
 
 	if (!oper_count) {
 		int i;


