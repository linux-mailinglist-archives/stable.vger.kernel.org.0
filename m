Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E88E12C0A16
	for <lists+stable@lfdr.de>; Mon, 23 Nov 2020 14:19:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733060AbgKWMnV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 Nov 2020 07:43:21 -0500
Received: from mail.kernel.org ([198.145.29.99]:56470 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1733056AbgKWMnT (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 23 Nov 2020 07:43:19 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 152B620732;
        Mon, 23 Nov 2020 12:43:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1606135399;
        bh=zb0Ime6XI530MGXlEJNwNAMm6EzzeWNku9TaSwKyjMI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ucRashszdArwrUEwQlKlAWJaAHyGqJnIosiidfV8RpsQv03O6ZQUFUqIuwJN6LEQg
         ug8jpayNA8jQ3InoL0xzaBoQ+k1Doi6DcefyR6ZkXtLmXbYzbvuH7weK/aLQHjWUos
         lpL3Rvq8+0lrwzP8sIWoAkd38XwKWHxlLlcTfCsI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ian Rogers <irogers@google.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Tobias Klauser <tklauser@distanz.ch>,
        Andrii Nakryiko <andrii@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.9 055/252] tools, bpftool: Avoid array index warnings.
Date:   Mon, 23 Nov 2020 13:20:05 +0100
Message-Id: <20201123121838.246582620@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201123121835.580259631@linuxfoundation.org>
References: <20201123121835.580259631@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ian Rogers <irogers@google.com>

[ Upstream commit 1e6f5dcc1b9ec9068f5d38331cec38b35498edf5 ]

The bpf_caps array is shorter without CAP_BPF, avoid out of bounds reads
if this isn't defined. Working around this avoids -Wno-array-bounds with
clang.

Signed-off-by: Ian Rogers <irogers@google.com>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Reviewed-by: Tobias Klauser <tklauser@distanz.ch>
Acked-by: Andrii Nakryiko <andrii@kernel.org>
Link: https://lore.kernel.org/bpf/20201027233646.3434896-1-irogers@google.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/bpf/bpftool/feature.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/tools/bpf/bpftool/feature.c b/tools/bpf/bpftool/feature.c
index a43a6f10b564c..359960a8f1def 100644
--- a/tools/bpf/bpftool/feature.c
+++ b/tools/bpf/bpftool/feature.c
@@ -843,9 +843,14 @@ static int handle_perms(void)
 		else
 			p_err("missing %s%s%s%s%s%s%s%srequired for full feature probing; run as root or use 'unprivileged'",
 			      capability_msg(bpf_caps, 0),
+#ifdef CAP_BPF
 			      capability_msg(bpf_caps, 1),
 			      capability_msg(bpf_caps, 2),
-			      capability_msg(bpf_caps, 3));
+			      capability_msg(bpf_caps, 3)
+#else
+				"", "", "", "", "", ""
+#endif /* CAP_BPF */
+				);
 		goto exit_free;
 	}
 
-- 
2.27.0



