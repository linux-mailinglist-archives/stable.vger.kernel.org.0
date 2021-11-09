Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3F88944A324
	for <lists+stable@lfdr.de>; Tue,  9 Nov 2021 02:24:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242588AbhKIBZ7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Nov 2021 20:25:59 -0500
Received: from mail.kernel.org ([198.145.29.99]:44364 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241710AbhKIBTM (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Nov 2021 20:19:12 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id C96C361288;
        Tue,  9 Nov 2021 01:07:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1636420051;
        bh=LWheMsac2MLhKOBfcd9MAnPJyZJjzi9UNrW/13Um3tc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jCF1+EyFG2jEpTY4NEWn+8osVfdHH8zeUivrwkkJ6A7HXIuYWW051QcXMal6LXmqe
         TWCP6uGqNSlSLt0Z8gdlUE7CUzMk/TnfvqOXO0nm9mKtHlHzTGkyVrIUlxXBToASkg
         KhAPfB4AW7d/B5VFF6NtBFgHMuohBTtatOcG7fl35krp5AZkUc9ncURu8sObBkyYNK
         jCmjCAmwjub8kSYaoyh0XF0uVGpPYSes6eQAn0iqUd9xaFhCPOw4MsliU0vn5GuIP+
         4sam9Y4BoxPeECiOonFfv4xJMMF1HTSqguSWVAiZZOoNfzymMNZCUEMtL4xQ1F3AWz
         FDmFG39E+4mqg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Kees Cook <keescook@chromium.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Sasha Levin <sashal@kernel.org>, me@tobin.cc,
        tycho@tycho.pizza, linux-hardening@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 24/39] leaking_addresses: Always print a trailing newline
Date:   Mon,  8 Nov 2021 20:06:34 -0500
Message-Id: <20211109010649.1191041-24-sashal@kernel.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211109010649.1191041-1-sashal@kernel.org>
References: <20211109010649.1191041-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kees Cook <keescook@chromium.org>

[ Upstream commit cf2a85efdade117e2169d6e26641016cbbf03ef0 ]

For files that lack trailing newlines and match a leaking address (e.g.
wchan[1]), the leaking_addresses.pl report would run together with the
next line, making things look corrupted.

Unconditionally remove the newline on input, and write it back out on
output.

[1] https://lore.kernel.org/all/20210103142726.GC30643@xsang-OptiPlex-9020/

Signed-off-by: Kees Cook <keescook@chromium.org>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Link: https://lkml.kernel.org/r/20211008111626.151570317@infradead.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 scripts/leaking_addresses.pl | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/scripts/leaking_addresses.pl b/scripts/leaking_addresses.pl
index 2977371b29563..de5196c08943a 100755
--- a/scripts/leaking_addresses.pl
+++ b/scripts/leaking_addresses.pl
@@ -262,8 +262,9 @@ sub parse_file
 
 	open my $fh, "<", $file or return;
 	while ( <$fh> ) {
+		chomp;
 		if (may_leak_address($_)) {
-			print $file . ': ' . $_;
+			printf("$file: $_\n");
 		}
 	}
 	close $fh;
-- 
2.33.0

