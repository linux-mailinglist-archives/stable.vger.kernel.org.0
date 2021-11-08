Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 28C5144A299
	for <lists+stable@lfdr.de>; Tue,  9 Nov 2021 02:17:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241630AbhKIBT1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Nov 2021 20:19:27 -0500
Received: from mail.kernel.org ([198.145.29.99]:44354 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243103AbhKIBPF (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Nov 2021 20:15:05 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id A0AC161989;
        Tue,  9 Nov 2021 01:06:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1636419964;
        bh=gSKZ8ZQS1zDIh541hS5ZMLEVK9bKopB7UiB0BBGvPEQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FLnA0B33ofx7TT3AkS1K5IKHDbS2rkonmiCN0CbdHGe2O0lBdSendh7mBe+X/acDN
         +nl8qV4qFYapiwDo2ykR2K9mJhnmt/0QhXdLt/UYvE2gN61spsFXyTFQku3ZwOx3fw
         84IDiiQGP95Se51aEntfp2LOpWhepiutKy11F0aJ4bIpywrUEP4HcS3EWCpSRnlKNu
         I4N7cDA8dSyAnGTw+x8dP94DfFBzUvzycUUSn6zCQNQd5aXhi83ceJZ6MTvd5FAvw5
         r6Q+78+Dmotz2ExomR0W8FuMk8QDRcyKvp0JFBw50QN+XcO5KL9MPqSGcFLxJV5Mfh
         5pMrISYk/gUrQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Kees Cook <keescook@chromium.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Sasha Levin <sashal@kernel.org>, me@tobin.cc,
        tycho@tycho.pizza, linux-hardening@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 28/47] leaking_addresses: Always print a trailing newline
Date:   Mon,  8 Nov 2021 12:50:12 -0500
Message-Id: <20211108175031.1190422-28-sashal@kernel.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211108175031.1190422-1-sashal@kernel.org>
References: <20211108175031.1190422-1-sashal@kernel.org>
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
index 6a897788f5a7e..6e4b0f7ae38cf 100755
--- a/scripts/leaking_addresses.pl
+++ b/scripts/leaking_addresses.pl
@@ -456,8 +456,9 @@ sub parse_file
 
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

