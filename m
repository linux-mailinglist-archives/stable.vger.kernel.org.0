Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 27E9C4ABDB0
	for <lists+stable@lfdr.de>; Mon,  7 Feb 2022 13:03:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1388985AbiBGLpw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Feb 2022 06:45:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47524 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1378322AbiBGLfu (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Feb 2022 06:35:50 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 66ED9C0401C3;
        Mon,  7 Feb 2022 03:35:43 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 042A060B5B;
        Mon,  7 Feb 2022 11:35:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BCDE2C004E1;
        Mon,  7 Feb 2022 11:35:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1644233742;
        bh=Z7H7oZrmQOOS5dhXt+kfnsPedSGfqT1i5+pCQHO2n5E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QT4Km53LWiJ+Bg3Evq/VAcdYGefZvDoDtkhEs2JagNk8vVcFDbt3XKHGhFs6Phy69
         Z6hgqrurdgpQdeQxmk9m+Ax5s9lrf5Z3gC8aUx3ttehbB7xqStJV95lyT4UqlFnf/t
         NXyxf40NuQDRHwe5xzKfgEJfBbasYrZRUgCNNKhk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Adam Borowski <kilobyte@angband.pl>,
        =?UTF-8?q?Martin=20Li=C5=A1ka?= <mliska@suse.cz>,
        Sergei Trofimovich <slyich@gmail.com>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 107/126] objtool: Fix truncated string warning
Date:   Mon,  7 Feb 2022 12:07:18 +0100
Message-Id: <20220207103807.759609312@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220207103804.053675072@linuxfoundation.org>
References: <20220207103804.053675072@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sergei Trofimovich <slyich@gmail.com>

[ Upstream commit 82880283d7fcd0a1d20964a56d6d1a5cc0df0713 ]

On GCC 12, the build fails due to a possible truncated string:

    check.c: In function 'validate_call':
    check.c:2865:58: error: '%d' directive output may be truncated writing between 1 and 10 bytes into a region of size 9 [-Werror=format-truncation=]
     2865 |                 snprintf(pvname, sizeof(pvname), "pv_ops[%d]", idx);
          |                                                          ^~

In theory it's a valid bug:

    static char pvname[16];
    int idx;
    ...
    idx = (rel->addend / sizeof(void *));
    snprintf(pvname, sizeof(pvname), "pv_ops[%d]", idx);

There are only 7 chars for %d while it could take up to 9, so the
printed "pv_ops[%d]" string could get truncated.

In reality the bug should never happen, because pv_ops only has ~80
entries, so 7 chars for the integer is more than enough.  Still, it's
worth fixing.  Bump the buffer size by 2 bytes to silence the warning.

[ jpoimboe: changed size to 19; massaged changelog ]

Fixes: db2b0c5d7b6f ("objtool: Support pv_opsindirect calls for noinstr")
Reported-by: Adam Borowski <kilobyte@angband.pl>
Reported-by: Martin Liška <mliska@suse.cz>
Signed-off-by: Sergei Trofimovich <slyich@gmail.com>
Signed-off-by: Josh Poimboeuf <jpoimboe@redhat.com>
Link: https://lore.kernel.org/r/20220120233748.2062559-1-slyich@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/objtool/check.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/objtool/check.c b/tools/objtool/check.c
index 21735829b860c..750ef1c446c8a 100644
--- a/tools/objtool/check.c
+++ b/tools/objtool/check.c
@@ -2823,7 +2823,7 @@ static inline bool func_uaccess_safe(struct symbol *func)
 
 static inline const char *call_dest_name(struct instruction *insn)
 {
-	static char pvname[16];
+	static char pvname[19];
 	struct reloc *rel;
 	int idx;
 
-- 
2.34.1



