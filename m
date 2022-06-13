Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 15F9E5496C3
	for <lists+stable@lfdr.de>; Mon, 13 Jun 2022 18:35:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351650AbiFMMQW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Jun 2022 08:16:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39284 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237968AbiFMMMl (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Jun 2022 08:12:41 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2AFC753A73;
        Mon, 13 Jun 2022 04:01:09 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 16BE2611B3;
        Mon, 13 Jun 2022 11:01:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 269A0C34114;
        Mon, 13 Jun 2022 11:01:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655118063;
        bh=7TBhTfbaDPhVdwpSz3pA6namIJ2zb0GDJdL83mqp43o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=od8Q7x3RrVg7ARwYu2qmesdM0fP/+uA2ww0eCJMr8HbfNJEnNtTtO1y2PWTkyfNaD
         Q3KMUFBlR0LPf8AGoUxxLPntm9/Cui0Ic0dYhuBwyZY02rVAH746Dl/WfI513WaWoH
         6nWS1m3cLqw9BUjVMxc1x5Js+c0IfcGwN1OJC1Tk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Alexander Lobakin <alexandr.lobakin@intel.com>,
        Petr Mladek <pmladek@suse.com>,
        Masahiro Yamada <masahiroy@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 218/287] modpost: fix removing numeric suffixes
Date:   Mon, 13 Jun 2022 12:10:42 +0200
Message-Id: <20220613094930.470872452@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220613094923.832156175@linuxfoundation.org>
References: <20220613094923.832156175@linuxfoundation.org>
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
index 7c693bd775c1..c42da4a35142 100644
--- a/scripts/mod/modpost.c
+++ b/scripts/mod/modpost.c
@@ -1937,7 +1937,7 @@ static char *remove_dot(char *s)
 
 	if (n && s[n]) {
 		size_t m = strspn(s + n + 1, "0123456789");
-		if (m && (s[n + m] == '.' || s[n + m] == 0))
+		if (m && (s[n + m + 1] == '.' || s[n + m + 1] == 0))
 			s[n] = 0;
 	}
 	return s;
-- 
2.35.1



