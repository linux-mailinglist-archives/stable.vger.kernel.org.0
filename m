Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9710810140A
	for <lists+stable@lfdr.de>; Tue, 19 Nov 2019 06:29:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728522AbfKSF3l (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Nov 2019 00:29:41 -0500
Received: from mail.kernel.org ([198.145.29.99]:48234 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729016AbfKSF3i (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 19 Nov 2019 00:29:38 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2BE5F21783;
        Tue, 19 Nov 2019 05:29:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574141377;
        bh=dpSjd1hk84fWWcoabhUygmApwukG2qV9KDnFTNF0n4o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=v1mazikRd+sqggaSNrgEar2vY0vt2xDMcVgYLOERtfgyH0XmfY9r2SexyUJ0rmfQj
         uy5T2ooALx2ALJ5zRUlWzcOunaBo50a4eCXSEnGG6Mn926B+kRzh0gm3A0P+RdOHRQ
         INZqZMzF6dEjAxNksegf8Z2T6gcAtJgeeT09w/6g=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 099/422] brcmfmac: fix wrong strnchr usage
Date:   Tue, 19 Nov 2019 06:14:56 +0100
Message-Id: <20191119051405.677762994@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191119051400.261610025@linuxfoundation.org>
References: <20191119051400.261610025@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Rasmus Villemoes <linux@rasmusvillemoes.dk>

[ Upstream commit cb18e2e9ec71d42409a51b83546686c609780dde ]

strnchr takes arguments in the order of its name: string, max bytes to
read, character to search for. Here we're passing '\n' aka 10 as the
buffer size, and searching for sizeof(buf) aka BRCMF_DCMD_SMLEN aka
256 (aka '\0', since it's implicitly converted to char) within those 10
bytes.

Just interchanging the last two arguments would still leave a bug,
because if we've been successful once, there are not sizeof(buf)
characters left after the new value of p.

Since clmver is immediately afterwards passed as a %s argument, I assume
that it is actually a properly nul-terminated string. For that case, we
have strreplace().

Signed-off-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/common.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/common.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/common.c
index 27893af63ebc3..8510d207ee87d 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/common.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/common.c
@@ -296,9 +296,7 @@ int brcmf_c_preinit_dcmds(struct brcmf_if *ifp)
 		/* Replace all newline/linefeed characters with space
 		 * character
 		 */
-		ptr = clmver;
-		while ((ptr = strnchr(ptr, '\n', sizeof(buf))) != NULL)
-			*ptr = ' ';
+		strreplace(clmver, '\n', ' ');
 
 		brcmf_dbg(INFO, "CLM version = %s\n", clmver);
 	}
-- 
2.20.1



