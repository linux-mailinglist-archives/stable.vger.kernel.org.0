Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 02CED395F0E
	for <lists+stable@lfdr.de>; Mon, 31 May 2021 16:05:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232506AbhEaOHV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 May 2021 10:07:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:36738 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232523AbhEaOFM (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 31 May 2021 10:05:12 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0E30461953;
        Mon, 31 May 2021 13:38:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1622468304;
        bh=RQhlUaPK0txnvTpB8EbPl0THdMYPjTwx7mfDkn3q924=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ElIQu1Orn7h9/bzo1FaST7xGAqk6l4xb6fUmya1ZOclOJKiKjM2smTRXFbUAoGr82
         ZgemA2eKwp2Grfvv5EmSQD0k4RmuiAgwN3LOqVxcHRUNYLQZxj4VPinyrzr42pNSgC
         2M0r9WK1K8t0rYhsk3aUH2oFwqftRp8fcOS2MlWY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kangjie Lu <kjlu@umn.edu>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 158/252] Revert "ASoC: cs43130: fix a NULL pointer dereference"
Date:   Mon, 31 May 2021 15:13:43 +0200
Message-Id: <20210531130703.380162829@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210531130657.971257589@linuxfoundation.org>
References: <20210531130657.971257589@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

[ Upstream commit fdda0dd2686ecd1f2e616c9e0366ea71b40c485d ]

This reverts commit a2be42f18d409213bb7e7a736e3ef6ba005115bb.

Because of recent interactions with developers from @umn.edu, all
commits from them have been recently re-reviewed to ensure if they were
correct or not.

Upon review, this commit was found to be incorrect for the reasons
below, so it must be reverted.  It will be fixed up "correctly" in a
later kernel change.

The original patch here is not correct, sysfs files that were created
are not unwound.

Cc: Kangjie Lu <kjlu@umn.edu>
Cc: Mark Brown <broonie@kernel.org>
Link: https://lore.kernel.org/r/20210503115736.2104747-57-gregkh@linuxfoundation.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/cs43130.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/sound/soc/codecs/cs43130.c b/sound/soc/codecs/cs43130.c
index 7fb34422a2a4..bb46e993c353 100644
--- a/sound/soc/codecs/cs43130.c
+++ b/sound/soc/codecs/cs43130.c
@@ -2319,8 +2319,6 @@ static int cs43130_probe(struct snd_soc_component *component)
 			return ret;
 
 		cs43130->wq = create_singlethread_workqueue("cs43130_hp");
-		if (!cs43130->wq)
-			return -ENOMEM;
 		INIT_WORK(&cs43130->work, cs43130_imp_meas);
 	}
 
-- 
2.30.2



