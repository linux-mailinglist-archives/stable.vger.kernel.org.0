Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BD8B632E915
	for <lists+stable@lfdr.de>; Fri,  5 Mar 2021 13:31:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232371AbhCEMae (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 5 Mar 2021 07:30:34 -0500
Received: from mail.kernel.org ([198.145.29.99]:39418 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231237AbhCEMaC (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 5 Mar 2021 07:30:02 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id D6EF665019;
        Fri,  5 Mar 2021 12:30:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614947402;
        bh=E5IKQ/916yzEAFACAw5//CUhYpYT4rPxUqksy3z9fM0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OrDHbR9IYD+q7LUnXlUn4A4hgQhtELCpshPdk7XSzpE4JPM0othxkjeudXL84fHuU
         X04CPUKjWavMEywRIBeSDdcY/3klZFZVw8y1Jw2wYR/8az0MdpE1uZbfvBxu8SIFf7
         RSqai8eBx7ooczvLkBlMfYZ9oMNYarOMUy/43FOk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Christian Gromm <christian.gromm@microchip.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 053/102] staging: most: sound: add sanity check for function argument
Date:   Fri,  5 Mar 2021 13:21:12 +0100
Message-Id: <20210305120905.902908895@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210305120903.276489876@linuxfoundation.org>
References: <20210305120903.276489876@linuxfoundation.org>
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
index 8a449ab9bdce..b7666a7b1760 100644
--- a/drivers/staging/most/sound/sound.c
+++ b/drivers/staging/most/sound/sound.c
@@ -96,6 +96,8 @@ static void swap_copy24(u8 *dest, const u8 *source, unsigned int bytes)
 {
 	unsigned int i = 0;
 
+	if (bytes < 2)
+		return;
 	while (i < bytes - 2) {
 		dest[i] = source[i + 2];
 		dest[i + 1] = source[i + 1];
-- 
2.30.1



