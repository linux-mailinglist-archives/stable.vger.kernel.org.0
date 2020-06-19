Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 224212012F7
	for <lists+stable@lfdr.de>; Fri, 19 Jun 2020 18:00:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404214AbgFSPTk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Jun 2020 11:19:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:49042 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2392592AbgFSPSj (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 19 Jun 2020 11:18:39 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 826FD206DB;
        Fri, 19 Jun 2020 15:18:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592579919;
        bh=QvvVCvpXuafBpUcquVWzRQSZlm/2kfM6wsz5kMmPuOY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xnSiCQ/4vHTVijhEZeFf+hBusMZUbw3GAw3eiqNWeNFHWdxkhvHwciIb9U7A9EAFf
         XDWFiv6KtAAUyN0fgjqwFGiCkSaJMOc3QYVNKLCUtnH7m3Gmo/0W+PFLOnN0dPGcN1
         9RZyMtRaaHOI9kYhIX6fmoIIwBG1odu7bVyju8fQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Julien Thierry <jthierry@redhat.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Miroslav Benes <mbenes@suse.cz>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        Ingo Molnar <mingo@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.7 013/376] objtool: Ignore empty alternatives
Date:   Fri, 19 Jun 2020 16:28:51 +0200
Message-Id: <20200619141710.991167259@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200619141710.350494719@linuxfoundation.org>
References: <20200619141710.350494719@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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



