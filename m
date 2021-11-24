Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 002FF45C336
	for <lists+stable@lfdr.de>; Wed, 24 Nov 2021 14:33:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352477AbhKXNgM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Nov 2021 08:36:12 -0500
Received: from mail.kernel.org ([198.145.29.99]:47486 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1349514AbhKXNeL (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Nov 2021 08:34:11 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id DFC4B61547;
        Wed, 24 Nov 2021 12:54:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637758458;
        bh=KFya8t7XucbD4ytnXfZ1+zfqS0YsfWJVp8FuMTEXMeU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UTGAd1y6UQrC1LUkpdULNAddI13EuM0UGiqV3dxAzpZbgZNIG6YMFfDFABYco7Fb4
         yGncBn8n/28m/ZkFJk6wj2AeDjktDMLyOssTKQ3zvfFAkOpo3C4TVa5Wpn8iEJwqVH
         Mb65J7y3AMUTmnFRMSAq/dY3kq3+lR34P8PXZ+io=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chengfeng Ye <cyeaa@connect.ust.hk>,
        Takashi Iwai <tiwai@suse.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 045/154] ALSA: gus: fix null pointer dereference on pointer block
Date:   Wed, 24 Nov 2021 12:57:21 +0100
Message-Id: <20211124115703.799880857@linuxfoundation.org>
X-Mailer: git-send-email 2.34.0
In-Reply-To: <20211124115702.361983534@linuxfoundation.org>
References: <20211124115702.361983534@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chengfeng Ye <cyeaa@connect.ust.hk>

[ Upstream commit a0d21bb3279476c777434c40d969ea88ca64f9aa ]

The pointer block return from snd_gf1_dma_next_block could be
null, so there is a potential null pointer dereference issue.
Fix this by adding a null check before dereference.

Signed-off-by: Chengfeng Ye <cyeaa@connect.ust.hk>
Link: https://lore.kernel.org/r/20211024104611.9919-1-cyeaa@connect.ust.hk
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/isa/gus/gus_dma.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/sound/isa/gus/gus_dma.c b/sound/isa/gus/gus_dma.c
index a1c770d826dda..6d664dd8dde0b 100644
--- a/sound/isa/gus/gus_dma.c
+++ b/sound/isa/gus/gus_dma.c
@@ -126,6 +126,8 @@ static void snd_gf1_dma_interrupt(struct snd_gus_card * gus)
 	}
 	block = snd_gf1_dma_next_block(gus);
 	spin_unlock(&gus->dma_lock);
+	if (!block)
+		return;
 	snd_gf1_dma_program(gus, block->addr, block->buf_addr, block->count, (unsigned short) block->cmd);
 	kfree(block);
 #if 0
-- 
2.33.0



