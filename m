Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2244F450D89
	for <lists+stable@lfdr.de>; Mon, 15 Nov 2021 18:56:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239511AbhKOR72 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 12:59:28 -0500
Received: from mail.kernel.org ([198.145.29.99]:40038 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239057AbhKOR5W (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 12:57:22 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id A98196332C;
        Mon, 15 Nov 2021 17:34:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1636997675;
        bh=g9YqIBsJqPHUuvpLJDbPcXidbZmOm3hbsrEoiwDQWSs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=A3xpYJEteD92lWCHvLtSkpyF5QNEdXdk4xmCUKLoKzkMugLA6zxKKVCGOTF+9APeS
         /UgwrEEInH5xw/qX5VAKpxnv3W7DQpMkVXpkI4pc5vrsxYYgLld1BM/94LOdJAQW2T
         Td1U+LJqiI1M/nnRQKCJOVhdCnYyUqDgdfFSxFA4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kees Cook <keescook@chromium.org>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 217/575] leaking_addresses: Always print a trailing newline
Date:   Mon, 15 Nov 2021 17:59:02 +0100
Message-Id: <20211115165351.221086061@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165343.579890274@linuxfoundation.org>
References: <20211115165343.579890274@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index b2d8b8aa2d99e..8f636a23bc3f2 100755
--- a/scripts/leaking_addresses.pl
+++ b/scripts/leaking_addresses.pl
@@ -455,8 +455,9 @@ sub parse_file
 
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



