Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3A746259417
	for <lists+stable@lfdr.de>; Tue,  1 Sep 2020 17:35:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728663AbgIAPfi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Sep 2020 11:35:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:41470 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727903AbgIAPff (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 1 Sep 2020 11:35:35 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 39D2C20866;
        Tue,  1 Sep 2020 15:35:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598974534;
        bh=kJroAU+bPWmuBWwjyzwkJDmAEwa1hWHKBm6/zt7PGJo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=c2uDSOYMntUbW67lLDKrvSaBEvRWMxjKlzrGLQjSxwltBDugcXwAqbtbFPuzolq53
         n/9gDUMmQItaFoNnpPK8/RhVnq8mProO++NviXE/U2Z/qesheoPL9nCs9Pb//zP5tW
         m+NAighaVziHWmxUDoJDuFZtK82zOVoEHcYDTOnU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Andrii Nakryiko <andriin@fb.com>,
        Alexei Starovoitov <ast@kernel.org>
Subject: [PATCH 5.4 213/214] libbpf: Fix build on ppc64le architecture
Date:   Tue,  1 Sep 2020 17:11:33 +0200
Message-Id: <20200901151003.130906588@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200901150952.963606936@linuxfoundation.org>
References: <20200901150952.963606936@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Andrii Nakryiko <andriin@fb.com>

commit 3fb1a96a91120877488071a167d26d76be4be977 upstream.

On ppc64le we get the following warning:

  In file included from btf_dump.c:16:0:
  btf_dump.c: In function ‘btf_dump_emit_struct_def’:
  ../include/linux/kernel.h:20:17: error: comparison of distinct pointer types lacks a cast [-Werror]
    (void) (&_max1 == &_max2);  \
                   ^
  btf_dump.c:882:11: note: in expansion of macro ‘max’
      m_sz = max(0LL, btf__resolve_size(d->btf, m->type));
             ^~~

Fix by explicitly casting to __s64, which is a return type from
btf__resolve_size().

Fixes: 702eddc77a90 ("libbpf: Handle GCC built-in types for Arm NEON")
Signed-off-by: Andrii Nakryiko <andriin@fb.com>
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Link: https://lore.kernel.org/bpf/20200818164456.1181661-1-andriin@fb.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 tools/lib/bpf/btf_dump.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/tools/lib/bpf/btf_dump.c
+++ b/tools/lib/bpf/btf_dump.c
@@ -906,7 +906,7 @@ static void btf_dump_emit_struct_def(str
 			btf_dump_printf(d, ": %d", m_sz);
 			off = m_off + m_sz;
 		} else {
-			m_sz = max(0LL, btf__resolve_size(d->btf, m->type));
+			m_sz = max((__s64)0, btf__resolve_size(d->btf, m->type));
 			off = m_off + m_sz * 8;
 		}
 		btf_dump_printf(d, ";");


