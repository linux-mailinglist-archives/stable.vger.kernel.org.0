Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 846EE145598
	for <lists+stable@lfdr.de>; Wed, 22 Jan 2020 14:25:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730375AbgAVNX1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Jan 2020 08:23:27 -0500
Received: from mail.kernel.org ([198.145.29.99]:41640 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730747AbgAVNXZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 22 Jan 2020 08:23:25 -0500
Received: from localhost (unknown [84.241.205.26])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4473D205F4;
        Wed, 22 Jan 2020 13:23:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579699404;
        bh=2fLv5w3+eifqC4KGzxoRe/B+TKlAwrj8u4H0SXcaz9Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=v+/m2BUN/lC6pTTa+9HhS8MhIGlpf9kPFJTRMDpXfyAGy/uzt9ae3xS6jjKYoVQ2p
         SwAuzW6HB1B9fWw5zPhQF7oEGBtVzfUFG2x/6LaJzB+EVzexViYfnsnLKbruyOuQ6T
         st3ut/VLWrpX/JAQS+1KqlaOJqbVLj4x35crQp+s=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Martin KaFai Lau <kafai@fb.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Quentin Monnet <quentin.monnet@netronome.com>
Subject: [PATCH 5.4 134/222] bpftool: Fix printing incorrect pointer in btf_dump_ptr
Date:   Wed, 22 Jan 2020 10:28:40 +0100
Message-Id: <20200122092843.337350817@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200122092833.339495161@linuxfoundation.org>
References: <20200122092833.339495161@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Martin KaFai Lau <kafai@fb.com>

commit 555089fdfc37ad65e0ee9b42ca40c238ff546f83 upstream.

For plain text output, it incorrectly prints the pointer value
"void *data".  The "void *data" is actually pointing to memory that
contains a bpf-map's value.  The intention is to print the content of
the bpf-map's value instead of printing the pointer pointing to the
bpf-map's value.

In this case, a member of the bpf-map's value is a pointer type.
Thus, it should print the "*(void **)data".

Fixes: 22c349e8db89 ("tools: bpftool: fix format strings and arguments for jsonw_printf()")
Signed-off-by: Martin KaFai Lau <kafai@fb.com>
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Reviewed-by: Quentin Monnet <quentin.monnet@netronome.com>
Link: https://lore.kernel.org/bpf/20200110231644.3484151-1-kafai@fb.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 tools/bpf/bpftool/btf_dumper.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/tools/bpf/bpftool/btf_dumper.c
+++ b/tools/bpf/bpftool/btf_dumper.c
@@ -26,7 +26,7 @@ static void btf_dumper_ptr(const void *d
 			   bool is_plain_text)
 {
 	if (is_plain_text)
-		jsonw_printf(jw, "%p", data);
+		jsonw_printf(jw, "%p", *(void **)data);
 	else
 		jsonw_printf(jw, "%lu", *(unsigned long *)data);
 }


