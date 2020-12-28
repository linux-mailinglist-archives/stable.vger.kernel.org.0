Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 78CD92E3BB9
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 14:54:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2407373AbgL1Nxz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 08:53:55 -0500
Received: from mail.kernel.org ([198.145.29.99]:55686 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2407369AbgL1Nxw (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 08:53:52 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id B97BD2078D;
        Mon, 28 Dec 2020 13:53:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609163592;
        bh=NQWHQvaQphVXKPh//J8vr+afTSGvyzyE21jpRPHA51s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LA8OVl2QUZSQRfinM5eoPCe2/U9/buAy6OrcuK7Axd8MRRRGyOtZE4EAymst60e0N
         B2T7whSVSjVRZB3VK/ec3tibQ6UYUHY9/hYv/RLepd0fIwxq7iNEkciXKDR8cwvRVk
         vCtOLf/IW7/x3EkjCj+ofMO5aRnJihBFFAhmjU7k=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Masahiro Yamada <masahiroy@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 309/453] kconfig: fix return value of do_error_if()
Date:   Mon, 28 Dec 2020 13:49:05 +0100
Message-Id: <20201228124952.082201074@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228124937.240114599@linuxfoundation.org>
References: <20201228124937.240114599@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Masahiro Yamada <masahiroy@kernel.org>

[ Upstream commit 135b4957eac43af2aedf8e2a277b9540f33c2558 ]

$(error-if,...) is expanded to an empty string. Currently, it relies on
eval_clause() returning xstrdup("") when all attempts for expansion fail,
but the correct implementation is to make do_error_if() return xstrdup("").

Fixes: 1d6272e6fe43 ("kconfig: add 'info', 'warning-if', and 'error-if' built-in functions")
Signed-off-by: Masahiro Yamada <masahiroy@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 scripts/kconfig/preprocess.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/scripts/kconfig/preprocess.c b/scripts/kconfig/preprocess.c
index 0243086fb1685..0590f86df6e40 100644
--- a/scripts/kconfig/preprocess.c
+++ b/scripts/kconfig/preprocess.c
@@ -114,7 +114,7 @@ static char *do_error_if(int argc, char *argv[])
 	if (!strcmp(argv[0], "y"))
 		pperror("%s", argv[1]);
 
-	return NULL;
+	return xstrdup("");
 }
 
 static char *do_filename(int argc, char *argv[])
-- 
2.27.0



