Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 587F3201430
	for <lists+stable@lfdr.de>; Fri, 19 Jun 2020 18:13:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390779AbgFSPFJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Jun 2020 11:05:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:33928 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391243AbgFSPFG (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 19 Jun 2020 11:05:06 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2A63A21852;
        Fri, 19 Jun 2020 15:05:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592579105;
        bh=APWOxe5i+4mN0d7ABUNLsvxwK/Ip4U9lQs6A6LrDs1E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ae+sefvZgiD/9CmoWjzT7Kh7k+ir1xPVfthbHequo3h66+Qc5zZSqaZNljOK7/3aX
         1uYwl/OK5Iqg1i+F3MneWPAdx1ulhrneQ35o1dyO3WCl6tn0CRl7ntd19HXMedX+Kw
         Z3T//XbM2jgxbJSo4Xo70K9FWG8/VKyHcSLWif4g=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Julien Thierry <jthierry@redhat.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Miroslav Benes <mbenes@suse.cz>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        Ingo Molnar <mingo@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 010/261] objtool: Ignore empty alternatives
Date:   Fri, 19 Jun 2020 16:30:21 +0200
Message-Id: <20200619141650.372901698@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200619141649.878808811@linuxfoundation.org>
References: <20200619141649.878808811@linuxfoundation.org>
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
index fcc6cd404f56..48b234d8f251 100644
--- a/tools/objtool/check.c
+++ b/tools/objtool/check.c
@@ -865,6 +865,12 @@ static int add_special_section_alts(struct objtool_file *file)
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



