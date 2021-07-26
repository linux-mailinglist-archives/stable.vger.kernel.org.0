Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2CA4A3D5EC0
	for <lists+stable@lfdr.de>; Mon, 26 Jul 2021 17:52:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235988AbhGZPLf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Jul 2021 11:11:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:51168 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237295AbhGZPKn (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 26 Jul 2021 11:10:43 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 263FC6056C;
        Mon, 26 Jul 2021 15:51:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1627314671;
        bh=+Q0kmk20efq6otsEGua0Kwje4GuuD0Js5L3tlTrET+0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RWLV5DQl9y4qegyQvzj8I9+sFiPQo+lshZDY1gCpv9DTAAxDl6+SsTaNMitBCiP+o
         OXVYLlWnXUg5bRZrLWFeKLeVbrrtiowizMmLVSL6X0Rm4c+XW7QwcRHBo9qrC97lOD
         Dz63gLGwyvJJb0lKIO+Hnx8UJfigfij0Cvr7czdw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Gu Shengxian <gushengxian@yulong.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jiri Olsa <jolsa@redhat.com>
Subject: [PATCH 4.19 050/120] bpftool: Properly close va_list ap by va_end() on error
Date:   Mon, 26 Jul 2021 17:38:22 +0200
Message-Id: <20210726153833.991668817@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210726153832.339431936@linuxfoundation.org>
References: <20210726153832.339431936@linuxfoundation.org>
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
@@ -51,11 +51,13 @@ static int fprintf_json(void *out, const
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


