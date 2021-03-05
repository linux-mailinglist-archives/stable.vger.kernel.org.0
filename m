Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4A4D932EAE7
	for <lists+stable@lfdr.de>; Fri,  5 Mar 2021 13:41:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230495AbhCEMk4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 5 Mar 2021 07:40:56 -0500
Received: from mail.kernel.org ([198.145.29.99]:56040 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233386AbhCEMka (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 5 Mar 2021 07:40:30 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id DC36364EE8;
        Fri,  5 Mar 2021 12:40:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614948030;
        bh=5D/oe9p2HEYs9BSK4ZbRzw/WvDx4brx0dIqWPydmd3A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=y2YcNAuARkYZprVIv5ZsCNtL+WjFSaSDH69j/QYrBgzLZ3hJngGI3I4/U6oWzqPE5
         xcoGNPorBRQk/OBq7IXCUFJtvCh9e9Gc8JMqTZEcmoLMDFtyPnMTf8IQ0NaWcdYoYS
         93RE/i0pI9QKdrVrnTnQ73yCXBdc2xgAIkWWUm/8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Christian Gromm <christian.gromm@microchip.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 27/39] staging: most: sound: add sanity check for function argument
Date:   Fri,  5 Mar 2021 13:22:26 +0100
Message-Id: <20210305120853.135395910@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210305120851.751937389@linuxfoundation.org>
References: <20210305120851.751937389@linuxfoundation.org>
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
 drivers/staging/most/aim-sound/sound.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/staging/most/aim-sound/sound.c b/drivers/staging/most/aim-sound/sound.c
index ea1366a44008..e259bf4956ab 100644
--- a/drivers/staging/most/aim-sound/sound.c
+++ b/drivers/staging/most/aim-sound/sound.c
@@ -92,6 +92,8 @@ static void swap_copy24(u8 *dest, const u8 *source, unsigned int bytes)
 {
 	unsigned int i = 0;
 
+	if (bytes < 2)
+		return;
 	while (i < bytes - 2) {
 		dest[i] = source[i + 2];
 		dest[i + 1] = source[i + 1];
-- 
2.30.1



