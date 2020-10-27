Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8225D29C09D
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 18:18:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1818065AbgJ0RRJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 13:17:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:58196 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1782517AbgJ0O5S (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 10:57:18 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 82B6522264;
        Tue, 27 Oct 2020 14:57:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603810638;
        bh=FnOc2oimdimLgd4+mYKGyCjBzGqGhr+vJrVsviBb8Mo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LUltvPd8zgyutynDkMUHPnFG8L6r1PGu9BDL0fP1UqCH5hOKK20khMmHoaVp40P3z
         F3x9reQjkx7Z/sB0JDXmZ08DwwuRqGo+OUOeALoBbaYYRzs5VEM8DuQblSfEFlD4E8
         tLHzmKg77H53z5abrd8NrDE3rNafl/YCA7jdBzdQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Alex Gartrell <alexgartrell@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.8 179/633] libbpf: Fix unintentional success return code in bpf_object__load
Date:   Tue, 27 Oct 2020 14:48:42 +0100
Message-Id: <20201027135531.084985113@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027135522.655719020@linuxfoundation.org>
References: <20201027135522.655719020@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alex Gartrell <alexgartrell@gmail.com>

[ Upstream commit ef05afa66c59c2031a3798916ef3ff3778232129 ]

There are code paths where EINVAL is returned directly without setting
errno. In that case, errno could be 0, which would mask the
failure. For example, if a careless programmer set log_level to 10000
out of laziness, they would have to spend a long time trying to figure
out why.

Fixes: 4f33ddb4e3e2 ("libbpf: Propagate EPERM to caller on program load")
Signed-off-by: Alex Gartrell <alexgartrell@gmail.com>
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Link: https://lore.kernel.org/bpf/20200826075549.1858580-1-alexgartrell@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/lib/bpf/libbpf.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
index 236c91aff48f8..e4d304247c1ba 100644
--- a/tools/lib/bpf/libbpf.c
+++ b/tools/lib/bpf/libbpf.c
@@ -5253,7 +5253,7 @@ load_program(struct bpf_program *prog, struct bpf_insn *insns, int insns_cnt,
 		free(log_buf);
 		goto retry_load;
 	}
-	ret = -errno;
+	ret = errno ? -errno : -LIBBPF_ERRNO__LOAD;
 	cp = libbpf_strerror_r(errno, errmsg, sizeof(errmsg));
 	pr_warn("load bpf program failed: %s\n", cp);
 	pr_perm_msg(ret);
-- 
2.25.1



