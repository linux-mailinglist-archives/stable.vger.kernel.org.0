Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E268813E69D
	for <lists+stable@lfdr.de>; Thu, 16 Jan 2020 18:21:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391182AbgAPRRn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Jan 2020 12:17:43 -0500
Received: from mail.kernel.org ([198.145.29.99]:43416 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732461AbgAPRRn (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Jan 2020 12:17:43 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6678C246AA;
        Thu, 16 Jan 2020 17:17:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579195062;
        bh=6Fd7Q3BMWeJNBGk0kKO5Sfece9B848AW7wMsA8jHAYA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PoBpmXvv7/5yvwZ4sx7+DJMT4tsxlcBXj4/8nIb3oGNO45DzwJkea5EIK7jpqT1AX
         9NqHcWPX/Gu56vfOsNjJXq1dD1YepIWdYLILW2ZCLUregg1TWpVDd7EfPEaWxpJCXc
         RloRPpUETBRPsINn20+MAsyUk61lXd2YmHXDIUP4=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Colin Ian King <colin.king@canonical.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Sasha Levin <sashal@kernel.org>, linux-crypto@vger.kernel.org,
        clang-built-linux@googlegroups.com
Subject: [PATCH AUTOSEL 4.14 017/371] pcrypt: use format specifier in kobject_add
Date:   Thu, 16 Jan 2020 12:11:25 -0500
Message-Id: <20200116171719.16965-17-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200116171719.16965-1-sashal@kernel.org>
References: <20200116171719.16965-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

[ Upstream commit b1e3874c75ab15288f573b3532e507c37e8e7656 ]

Passing string 'name' as the format specifier is potentially hazardous
because name could (although very unlikely to) have a format specifier
embedded in it causing issues when parsing the non-existent arguments
to these.  Follow best practice by using the "%s" format string for
the string 'name'.

Cleans up clang warning:
crypto/pcrypt.c:397:40: warning: format string is not a string literal
(potentially insecure) [-Wformat-security]

Fixes: a3fb1e330dd2 ("pcrypt: Added sysfs interface to pcrypt")
Signed-off-by: Colin Ian King <colin.king@canonical.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 crypto/pcrypt.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/crypto/pcrypt.c b/crypto/pcrypt.c
index f8ec3d4ba4a8..a5718c0a3dc4 100644
--- a/crypto/pcrypt.c
+++ b/crypto/pcrypt.c
@@ -394,7 +394,7 @@ static int pcrypt_sysfs_add(struct padata_instance *pinst, const char *name)
 	int ret;
 
 	pinst->kobj.kset = pcrypt_kset;
-	ret = kobject_add(&pinst->kobj, NULL, name);
+	ret = kobject_add(&pinst->kobj, NULL, "%s", name);
 	if (!ret)
 		kobject_uevent(&pinst->kobj, KOBJ_ADD);
 
-- 
2.20.1

