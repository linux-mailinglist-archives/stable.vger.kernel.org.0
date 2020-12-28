Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1B1C52E3A2C
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 14:34:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387847AbgL1NdD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 08:33:03 -0500
Received: from mail.kernel.org ([198.145.29.99]:33496 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387819AbgL1Nc4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 08:32:56 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id AF25422582;
        Mon, 28 Dec 2020 13:32:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609162336;
        bh=cEH1ohLZUhbTG5A4vYlmMy+XmPUBtcJyo7fVo6bKm4Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FA9hefT7L7RFjuRxcVWM18ySNd01qGttCA9MgIPcaZa6mgB1bdxE90tlq3ORSPi/B
         ZBBu0ihqatXOQdpO1SE1+YtVjwyI8eT8qlJnl4uD65SrZ8iRNmXi1UhEtGlrne8fp1
         mflmYUE9HFmDpp/A2K/CvIQamf8gjrYanln9CXJ0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Masahiro Yamada <masahiroy@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 251/346] kconfig: fix return value of do_error_if()
Date:   Mon, 28 Dec 2020 13:49:30 +0100
Message-Id: <20201228124931.915987057@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228124919.745526410@linuxfoundation.org>
References: <20201228124919.745526410@linuxfoundation.org>
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
index 5ca2df790d3cf..389814b02d06b 100644
--- a/scripts/kconfig/preprocess.c
+++ b/scripts/kconfig/preprocess.c
@@ -111,7 +111,7 @@ static char *do_error_if(int argc, char *argv[])
 	if (!strcmp(argv[0], "y"))
 		pperror("%s", argv[1]);
 
-	return NULL;
+	return xstrdup("");
 }
 
 static char *do_filename(int argc, char *argv[])
-- 
2.27.0



