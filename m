Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A5B401F3175
	for <lists+stable@lfdr.de>; Tue,  9 Jun 2020 03:10:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727018AbgFIBJ2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Jun 2020 21:09:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:49546 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726987AbgFHXG1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Jun 2020 19:06:27 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C30892078B;
        Mon,  8 Jun 2020 23:06:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591657586;
        bh=QvvVCvpXuafBpUcquVWzRQSZlm/2kfM6wsz5kMmPuOY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VlX2/C5tn7WpAQ3rnSVSb0eQFLlTpTjQPiwpTLt19c7sFwXwPljqmg4ZA+hhz6RCo
         vuxPdWJOYNrElV9pLeixR4IezgltNqwkB6KlFdQ7HAZQRe7/gfteQH0oNcOcLDYoeV
         hk6hHBDk75V/3ZVarK2z/VC7nwCzDvsJAIx3anhw=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Julien Thierry <jthierry@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Miroslav Benes <mbenes@suse.cz>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        Ingo Molnar <mingo@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 5.7 015/274] objtool: Ignore empty alternatives
Date:   Mon,  8 Jun 2020 19:01:48 -0400
Message-Id: <20200608230607.3361041-15-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200608230607.3361041-1-sashal@kernel.org>
References: <20200608230607.3361041-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Julien Thierry <jthierry@redhat.com>

[ Upstream commit 7170cf47d16f1ba29eca07fd818870b7af0a93a5 ]

The .alternatives section can contain entries with no original
instructions. Objtool will currently crash when handling such an entry.

Just skip that entry, but still give a warning to discourage useless
entries.

Signed-off-by: Julien Thierry <jthierry@redhat.com>
Acked-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Reviewed-by: Miroslav Benes <mbenes@suse.cz>
Signed-off-by: Josh Poimboeuf <jpoimboe@redhat.com>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/objtool/check.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/tools/objtool/check.c b/tools/objtool/check.c
index 3c6da70e6084..5a867a469ba5 100644
--- a/tools/objtool/check.c
+++ b/tools/objtool/check.c
@@ -916,6 +916,12 @@ static int add_special_section_alts(struct objtool_file *file)
 		}
 
 		if (special_alt->group) {
+			if (!special_alt->orig_len) {
+				WARN_FUNC("empty alternative entry",
+					  orig_insn->sec, orig_insn->offset);
+				continue;
+			}
+
 			ret = handle_group_alt(file, special_alt, orig_insn,
 					       &new_insn);
 			if (ret)
-- 
2.25.1

