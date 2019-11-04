Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0E164EEC95
	for <lists+stable@lfdr.de>; Mon,  4 Nov 2019 22:58:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730625AbfKDV6h (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Nov 2019 16:58:37 -0500
Received: from mail.kernel.org ([198.145.29.99]:55640 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388089AbfKDV6g (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 4 Nov 2019 16:58:36 -0500
Received: from localhost (6.204-14-84.ripe.coltfrance.com [84.14.204.6])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9B04920650;
        Mon,  4 Nov 2019 21:58:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1572904716;
        bh=dNn/LIJ/CoShNtr+baPOMrLT5mYlfNxfN/Toz60p2fQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hoxlMktaeHSWRA3kupu4Rnk3YMoFDC28FWCaXlqBYBxLzNDCzPTfCNmkEsGvrAv2D
         UAp87iAf42e2xlgUK3cNvCPK0VD36Li7v7oDp3bPfLpu2uHpxtaJjfvF9tyWOcK8b6
         b4xkU3+H+bzGm7U1z8+iXXcbP1+dp5mUw8nQWMr4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, "Daniel T. Lee" <danieltimlee@gmail.com>,
        Song Liu <songliubraving@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 037/149] samples: bpf: fix: seg fault with NULL pointer arg
Date:   Mon,  4 Nov 2019 22:43:50 +0100
Message-Id: <20191104212138.357301251@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191104212126.090054740@linuxfoundation.org>
References: <20191104212126.090054740@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Daniel T. Lee <danieltimlee@gmail.com>

[ Upstream commit d59dd69d5576d699d7d3f5da0b4738c3a36d0133 ]

When NULL pointer accidentally passed to write_kprobe_events,
due to strlen(NULL), segmentation fault happens.
Changed code returns -1 to deal with this situation.

Bug issued with Smatch, static analysis.

Signed-off-by: Daniel T. Lee <danieltimlee@gmail.com>
Acked-by: Song Liu <songliubraving@fb.com>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 samples/bpf/bpf_load.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/samples/bpf/bpf_load.c b/samples/bpf/bpf_load.c
index 5061a2ec45646..176c04a454dc9 100644
--- a/samples/bpf/bpf_load.c
+++ b/samples/bpf/bpf_load.c
@@ -59,7 +59,9 @@ static int write_kprobe_events(const char *val)
 {
 	int fd, ret, flags;
 
-	if ((val != NULL) && (val[0] == '\0'))
+	if (val == NULL)
+		return -1;
+	else if (val[0] == '\0')
 		flags = O_WRONLY | O_TRUNC;
 	else
 		flags = O_WRONLY | O_APPEND;
-- 
2.20.1



