Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EB084B1E56
	for <lists+stable@lfdr.de>; Fri, 13 Sep 2019 15:11:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388450AbfIMNJR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 13 Sep 2019 09:09:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:33772 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388463AbfIMNJP (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 13 Sep 2019 09:09:15 -0400
Received: from localhost (unknown [104.132.45.99])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E7D6B208C0;
        Fri, 13 Sep 2019 13:09:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1568380154;
        bh=SJB/SZBZ512Lz00RrXmy++B4RO1M66TXhT5Mr0YbSBU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0KWx41ZYnN5jLrquE7zn4D8rku17SmQ8nxBoKPP+P85j/2LfPfsB91ofQJgL0994E
         nrA4hqOCSRSFEYAMC7cMHnCTtzA9rOtZYbqdFId17FspSU7N/0eoLUqtGo+jG1+M6Z
         RTcVuoLw3QpF1iJfpEiSnFszkNLJl72BbI59TkuE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Nicolas Boichat <drinkcat@chromium.org>,
        Stephen Boyd <swboyd@chromium.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 11/14] scripts/decode_stacktrace: match basepath using shell prefix operator, not regex
Date:   Fri, 13 Sep 2019 14:07:04 +0100
Message-Id: <20190913130446.021198073@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190913130440.264749443@linuxfoundation.org>
References: <20190913130440.264749443@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 31013836a71e07751a6827f9d2ad41ef502ddaff ]

The basepath may contain special characters, which would confuse the regex
matcher.  ${var#prefix} does the right thing.

Link: http://lkml.kernel.org/r/20190518055946.181563-1-drinkcat@chromium.org
Fixes: 67a28de47faa8358 ("scripts/decode_stacktrace: only strip base path when a prefix of the path")
Signed-off-by: Nicolas Boichat <drinkcat@chromium.org>
Reviewed-by: Stephen Boyd <swboyd@chromium.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 scripts/decode_stacktrace.sh | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/scripts/decode_stacktrace.sh b/scripts/decode_stacktrace.sh
index 381acfc4c59dd..98cf6343afcd7 100755
--- a/scripts/decode_stacktrace.sh
+++ b/scripts/decode_stacktrace.sh
@@ -77,7 +77,7 @@ parse_symbol() {
 	fi
 
 	# Strip out the base of the path
-	code=${code//^$basepath/""}
+	code=${code#$basepath/}
 
 	# In the case of inlines, move everything to same line
 	code=${code//$'\n'/' '}
-- 
2.20.1



