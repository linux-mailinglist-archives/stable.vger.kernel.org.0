Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 45EDA549765
	for <lists+stable@lfdr.de>; Mon, 13 Jun 2022 18:35:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353934AbiFMLcb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Jun 2022 07:32:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56080 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355030AbiFMLaZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Jun 2022 07:30:25 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C1ECF40A37;
        Mon, 13 Jun 2022 03:46:22 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5F8DD60FDB;
        Mon, 13 Jun 2022 10:46:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6BEDFC34114;
        Mon, 13 Jun 2022 10:46:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655117181;
        bh=tHsvPguDk4QYluyRhb/0DQkGCdQEav2w/GLJP1pJuA0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Z8boFe9LAp37D52RSfvNgXdnvhvnZFOS8dYTH2fnmD0trzwVOJI2iPxQYYoz5MLYx
         Laj4J2ijKo91C+/32uvtN79smhE3HW6qmiUmy/JYbQDo1m5G0O4y5lny3dbzDdKmwK
         Su0qAQwkDkzglpW3jyDx3vRHCZI4kQ2A7GhfAJUM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Alexander Lobakin <alexandr.lobakin@intel.com>,
        Petr Mladek <pmladek@suse.com>,
        Masahiro Yamada <masahiroy@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 326/411] modpost: fix removing numeric suffixes
Date:   Mon, 13 Jun 2022 12:09:59 +0200
Message-Id: <20220613094938.505365480@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220613094928.482772422@linuxfoundation.org>
References: <20220613094928.482772422@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alexander Lobakin <alexandr.lobakin@intel.com>

[ Upstream commit b5beffa20d83c4e15306c991ffd00de0d8628338 ]

With the `-z unique-symbol` linker flag or any similar mechanism,
it is possible to trigger the following:

ERROR: modpost: "param_set_uint.0" [vmlinux] is a static EXPORT_SYMBOL

The reason is that for now the condition from remove_dot():

if (m && (s[n + m] == '.' || s[n + m] == 0))

which was designed to test if it's a dot or a '\0' after the suffix
is never satisfied.
This is due to that `s[n + m]` always points to the last digit of a
numeric suffix, not on the symbol next to it (from a custom debug
print added to modpost):

param_set_uint.0, s[n + m] is '0', s[n + m + 1] is '\0'

So it's off-by-one and was like that since 2014.

Fix this for the sake of any potential upcoming features, but don't
bother stable-backporting, as it's well hidden -- apart from that
LD flag, it can be triggered only with GCC LTO which never landed
upstream.

Fixes: fcd38ed0ff26 ("scripts: modpost: fix compilation warning")
Signed-off-by: Alexander Lobakin <alexandr.lobakin@intel.com>
Reviewed-by: Petr Mladek <pmladek@suse.com>
Signed-off-by: Masahiro Yamada <masahiroy@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 scripts/mod/modpost.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/scripts/mod/modpost.c b/scripts/mod/modpost.c
index 13cda6aa2688..74e2052f429d 100644
--- a/scripts/mod/modpost.c
+++ b/scripts/mod/modpost.c
@@ -1998,7 +1998,7 @@ static char *remove_dot(char *s)
 
 	if (n && s[n]) {
 		size_t m = strspn(s + n + 1, "0123456789");
-		if (m && (s[n + m] == '.' || s[n + m] == 0))
+		if (m && (s[n + m + 1] == '.' || s[n + m + 1] == 0))
 			s[n] = 0;
 	}
 	return s;
-- 
2.35.1



