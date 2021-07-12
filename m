Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C9B7B3C4EFA
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:43:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238817AbhGLHWj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 03:22:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:59348 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240966AbhGLHVT (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 03:21:19 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9AC9C60FF1;
        Mon, 12 Jul 2021 07:18:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626074311;
        bh=SqgqjwXJJX6J2I5vegfmJ0u8E68kgN5L3j4QWGbwvZY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hMf0bhFLUjTI6q5wBwq9S2CAoYndgClqbcdqB9toQMEzi59HC0kGZH+Mkwp0o6zgg
         JIAgN6VsjzDcZagdfZG7qlZSPnjN9MgDItm6F2pYSy66IQgsMVtxFalr/usGZuP878
         F+UtRQNF9b0T6oWOBrCK5wuurCGTIbgjWbY6tmMg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Martin Loviska <mloviska@suse.com>,
        Gary Lin <glin@suse.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Dmitrii Banshchikov <me@ubique.spb.ru>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 494/700] bpfilter: Specify the log level for the kmsg message
Date:   Mon, 12 Jul 2021 08:09:37 +0200
Message-Id: <20210712061029.072967766@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060924.797321836@linuxfoundation.org>
References: <20210712060924.797321836@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Gary Lin <glin@suse.com>

[ Upstream commit a196fa78a26571359740f701cf30d774eb8a72cb ]

Per the kmsg document [0], if we don't specify the log level with a
prefix "<N>" in the message string, the default log level will be
applied to the message. Since the default level could be warning(4),
this would make the log utility such as journalctl treat the message,
"Started bpfilter", as a warning. To avoid confusion, this commit
adds the prefix "<5>" to make the message always a notice.

  [0] https://www.kernel.org/doc/Documentation/ABI/testing/dev-kmsg

Fixes: 36c4357c63f3 ("net: bpfilter: print umh messages to /dev/kmsg")
Reported-by: Martin Loviska <mloviska@suse.com>
Signed-off-by: Gary Lin <glin@suse.com>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Acked-by: Dmitrii Banshchikov <me@ubique.spb.ru>
Link: https://lore.kernel.org/bpf/20210623040918.8683-1-glin@suse.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bpfilter/main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/bpfilter/main.c b/net/bpfilter/main.c
index 05e1cfc1e5cd..291a92546246 100644
--- a/net/bpfilter/main.c
+++ b/net/bpfilter/main.c
@@ -57,7 +57,7 @@ int main(void)
 {
 	debug_f = fopen("/dev/kmsg", "w");
 	setvbuf(debug_f, 0, _IOLBF, 0);
-	fprintf(debug_f, "Started bpfilter\n");
+	fprintf(debug_f, "<5>Started bpfilter\n");
 	loop();
 	fclose(debug_f);
 	return 0;
-- 
2.30.2



