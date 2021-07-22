Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AF9BC3D281A
	for <lists+stable@lfdr.de>; Thu, 22 Jul 2021 18:37:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232693AbhGVPyw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 22 Jul 2021 11:54:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:58608 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232716AbhGVPyk (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 22 Jul 2021 11:54:40 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8658E6135C;
        Thu, 22 Jul 2021 16:35:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626971714;
        bh=FnmlkeINLPY41CeHpte7FXoZb1WuJZxR0hRPRv2NUNk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=C/7SWEhXIWesRvzEykvsrxLFV95oiTPACl462CjxjXVH9fpeCJSkmov364f6kgi6s
         zQ/bwQrvLmTb36i2WJ+yLf+FnnoeCxRpPCic/ednhigLZ646elOOtfdSABv5Ub9+IZ
         chpAHqzpi66rc4CoGBCMHb+QkeBEY0lFrtY/i5Gc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Gu Shengxian <gushengxian@yulong.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jiri Olsa <jolsa@redhat.com>
Subject: [PATCH 5.4 69/71] bpftool: Properly close va_list ap by va_end() on error
Date:   Thu, 22 Jul 2021 18:31:44 +0200
Message-Id: <20210722155620.211345975@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210722155617.865866034@linuxfoundation.org>
References: <20210722155617.865866034@linuxfoundation.org>
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
@@ -44,11 +44,13 @@ static int fprintf_json(void *out, const
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


