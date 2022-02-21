Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 590854BE55C
	for <lists+stable@lfdr.de>; Mon, 21 Feb 2022 19:00:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354290AbiBUKDY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Feb 2022 05:03:24 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:37268 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353552AbiBUJ5c (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 21 Feb 2022 04:57:32 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D90410FF6;
        Mon, 21 Feb 2022 01:26:48 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E26C2B80EB8;
        Mon, 21 Feb 2022 09:26:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B0A4C340E9;
        Mon, 21 Feb 2022 09:26:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1645435605;
        bh=mlCVfXCI/MPFLPPvRfg1e5hONyIiSJQMvH37hKzLE5Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VUcwi/LW5pFRT9MyBBVDxwSblD+ZkirQuVrNAyuWBzDelLFfVPwdzWWYd8F5p4RWa
         NBOzIRhVKbXq6elo9py05UR6vlX3LDH5GyCWMYQheJe8kcE7zugldem9J/lCx2wHv4
         m+cDxytqcIBpnQ9qqf9+b/cl78UTKC6if4Nahh8k=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Brenda Streiff <brenda.streiff@ni.com>,
        Masahiro Yamada <masahiroy@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 215/227] kconfig: let shell return enough output for deep path names
Date:   Mon, 21 Feb 2022 09:50:34 +0100
Message-Id: <20220221084941.962293917@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220221084934.836145070@linuxfoundation.org>
References: <20220221084934.836145070@linuxfoundation.org>
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

From: Brenda Streiff <brenda.streiff@ni.com>

[ Upstream commit 8a4c5b2a6d8ea079fa36034e8167de87ab6f8880 ]

The 'shell' built-in only returns the first 256 bytes of the command's
output. In some cases, 'shell' is used to return a path; by bumping up
the buffer size to 4096 this lets us capture up to PATH_MAX.

The specific case where I ran into this was due to commit 1e860048c53e
("gcc-plugins: simplify GCC plugin-dev capability test"). After this
change, we now use `$(shell,$(CC) -print-file-name=plugin)` to return
a path; if the gcc path is particularly long, then the path ends up
truncated at the 256 byte mark, which makes the HAVE_GCC_PLUGINS
depends test always fail.

Signed-off-by: Brenda Streiff <brenda.streiff@ni.com>
Signed-off-by: Masahiro Yamada <masahiroy@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 scripts/kconfig/preprocess.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/scripts/kconfig/preprocess.c b/scripts/kconfig/preprocess.c
index 0590f86df6e40..748da578b418c 100644
--- a/scripts/kconfig/preprocess.c
+++ b/scripts/kconfig/preprocess.c
@@ -141,7 +141,7 @@ static char *do_lineno(int argc, char *argv[])
 static char *do_shell(int argc, char *argv[])
 {
 	FILE *p;
-	char buf[256];
+	char buf[4096];
 	char *cmd;
 	size_t nread;
 	int i;
-- 
2.34.1



