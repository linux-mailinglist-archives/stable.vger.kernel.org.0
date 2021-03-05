Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4C53932EA7B
	for <lists+stable@lfdr.de>; Fri,  5 Mar 2021 13:39:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232816AbhCEMip (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 5 Mar 2021 07:38:45 -0500
Received: from mail.kernel.org ([198.145.29.99]:52076 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232830AbhCEMi1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 5 Mar 2021 07:38:27 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0BFB46501D;
        Fri,  5 Mar 2021 12:38:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614947904;
        bh=QKlhfge7VBouI/yVxkROOjTtlX5LpXm6OJM/jBXLAA0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cvOzxHzFRU8ZDK175lxuZ4Pit+61q9yrmG4/TU94huARtOtmt+WzABRk1KUmDeyFD
         RXQLyQu8AwjII5gSzszUCYfLceqN4feZZk/LixK921eWqFcgQMH8a2ucdeBkm052L0
         LCu7KEzaDJhRqLC/4zzkgJnEH2cPtwEkr0sxSCJk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Christian Gromm <christian.gromm@microchip.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 30/52] staging: most: sound: add sanity check for function argument
Date:   Fri,  5 Mar 2021 13:22:01 +0100
Message-Id: <20210305120855.157148641@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210305120853.659441428@linuxfoundation.org>
References: <20210305120853.659441428@linuxfoundation.org>
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
index 89b02fc305b8..fd9245d7eeb9 100644
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



