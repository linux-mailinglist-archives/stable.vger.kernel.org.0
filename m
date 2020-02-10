Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C900D15777E
	for <lists+stable@lfdr.de>; Mon, 10 Feb 2020 14:01:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729882AbgBJNAw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Feb 2020 08:00:52 -0500
Received: from mail.kernel.org ([198.145.29.99]:42044 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729847AbgBJMk5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 Feb 2020 07:40:57 -0500
Received: from localhost (unknown [209.37.97.194])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 012FF20873;
        Mon, 10 Feb 2020 12:40:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581338457;
        bh=u2iqX7hdT43KFEBOlVlHugjmufyzlK2o8rbH+aHviW4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=srOWarnixEb74fKvobbGyrG1UZ7X7QO06ZrYuCbdPlC9kWR5Fi6FyW9WYkS8fJ1LR
         OralLZnjZ5wAUkH96ORfTGnS29ozCw+tfxPBFe+vZlWFKJWWZtxowSvIlHbXbOBKIC
         XNZnWpHBiWiVGchye3bXP2QX9fPDxkXCIYrzRKA8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Justin Forbes <jmforbes@linuxtx.org>,
        Thadeu Lima de Souza Cascardo <cascardo@canonical.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andriin@fb.com>,
        Aurelien Jarno <aurelien@aurel32.net>
Subject: [PATCH 5.5 158/367] libbpf: Fix readelf output parsing for Fedora
Date:   Mon, 10 Feb 2020 04:31:11 -0800
Message-Id: <20200210122439.406936935@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200210122423.695146547@linuxfoundation.org>
References: <20200210122423.695146547@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Thadeu Lima de Souza Cascardo <cascardo@canonical.com>

commit aa915931ac3e53ccf371308e6750da510e3591dd upstream.

Fedora binutils has been patched to show "other info" for a symbol at the
end of the line. This was done in order to support unmaintained scripts
that would break with the extra info. [1]

[1] https://src.fedoraproject.org/rpms/binutils/c/b8265c46f7ddae23a792ee8306fbaaeacba83bf8

This in turn has been done to fix the build of ruby, because of checksec.
[2] Thanks Michael Ellerman for the pointer.

[2] https://bugzilla.redhat.com/show_bug.cgi?id=1479302

As libbpf Makefile is not unmaintained, we can simply deal with either
output format, by just removing the "other info" field, as it always comes
inside brackets.

Fixes: 3464afdf11f9 (libbpf: Fix readelf output parsing on powerpc with recent binutils)
Reported-by: Justin Forbes <jmforbes@linuxtx.org>
Signed-off-by: Thadeu Lima de Souza Cascardo <cascardo@canonical.com>
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Acked-by: Andrii Nakryiko <andriin@fb.com>
Cc: Aurelien Jarno <aurelien@aurel32.net>
Link: https://lore.kernel.org/bpf/20191213101114.GA3986@calabresa
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 tools/lib/bpf/Makefile |    2 ++
 1 file changed, 2 insertions(+)

--- a/tools/lib/bpf/Makefile
+++ b/tools/lib/bpf/Makefile
@@ -148,6 +148,7 @@ TAGS_PROG := $(if $(shell which etags 2>
 
 GLOBAL_SYM_COUNT = $(shell readelf -s --wide $(BPF_IN_SHARED) | \
 			   cut -d "@" -f1 | sed 's/_v[0-9]_[0-9]_[0-9].*//' | \
+			   sed 's/\[.*\]//' | \
 			   awk '/GLOBAL/ && /DEFAULT/ && !/UND/ {print $$NF}' | \
 			   sort -u | wc -l)
 VERSIONED_SYM_COUNT = $(shell readelf -s --wide $(OUTPUT)libbpf.so | \
@@ -214,6 +215,7 @@ check_abi: $(OUTPUT)libbpf.so
 		     "versioned in $(VERSION_SCRIPT)." >&2;		 \
 		readelf -s --wide $(BPF_IN_SHARED) |			 \
 		    cut -d "@" -f1 | sed 's/_v[0-9]_[0-9]_[0-9].*//' |	 \
+		    sed 's/\[.*\]//' |					 \
 		    awk '/GLOBAL/ && /DEFAULT/ && !/UND/ {print $$NF}'|  \
 		    sort -u > $(OUTPUT)libbpf_global_syms.tmp;		 \
 		readelf -s --wide $(OUTPUT)libbpf.so |			 \


