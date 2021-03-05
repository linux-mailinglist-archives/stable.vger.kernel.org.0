Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 97D9432E839
	for <lists+stable@lfdr.de>; Fri,  5 Mar 2021 13:26:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231182AbhCEMZr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 5 Mar 2021 07:25:47 -0500
Received: from mail.kernel.org ([198.145.29.99]:60672 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229718AbhCEMZW (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 5 Mar 2021 07:25:22 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 179AA65030;
        Fri,  5 Mar 2021 12:25:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614947121;
        bh=IJtFoxfe/jZAKsp5H1o9NHy21KgRCcsBT+ceJEZ5R+o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=r92rMQaChfQAQgDSWM+Xfv4EiD/b9Y32l8g2mA38DwCjnApFhOch2uV10cNq30cTE
         meTOARWdnOh2GeSKDzZqh93mdpBDjFsnuEfvXL3WtYvu4ASfJBXq7QgpPXWGMjMAlu
         Euxl/ya+eeotpDni+jagC/Yt1o6aI8ebXmZj8otk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Christian Gromm <christian.gromm@microchip.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 054/104] staging: most: sound: add sanity check for function argument
Date:   Fri,  5 Mar 2021 13:20:59 +0100
Message-Id: <20210305120905.821870388@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210305120903.166929741@linuxfoundation.org>
References: <20210305120903.166929741@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christian Gromm <christian.gromm@microchip.com>

[ Upstream commit 45b754ae5b82949dca2b6e74fa680313cefdc813 ]

This patch checks the function parameter 'bytes' before doing the
subtraction to prevent memory corruption.

Signed-off-by: Christian Gromm <christian.gromm@microchip.com>
Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Link: https://lore.kernel.org/r/1612282865-21846-1-git-send-email-christian.gromm@microchip.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/staging/most/sound/sound.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/staging/most/sound/sound.c b/drivers/staging/most/sound/sound.c
index 3a1a59058042..45befb8c1126 100644
--- a/drivers/staging/most/sound/sound.c
+++ b/drivers/staging/most/sound/sound.c
@@ -86,6 +86,8 @@ static void swap_copy24(u8 *dest, const u8 *source, unsigned int bytes)
 {
 	unsigned int i = 0;
 
+	if (bytes < 2)
+		return;
 	while (i < bytes - 2) {
 		dest[i] = source[i + 2];
 		dest[i + 1] = source[i + 1];
-- 
2.30.1



