Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B800E396061
	for <lists+stable@lfdr.de>; Mon, 31 May 2021 16:24:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232322AbhEaOZ1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 May 2021 10:25:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:46050 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233408AbhEaOX0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 31 May 2021 10:23:26 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A73A0613F2;
        Mon, 31 May 2021 13:45:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1622468745;
        bh=RQhlUaPK0txnvTpB8EbPl0THdMYPjTwx7mfDkn3q924=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AT0LtAN3gOqVaUxrSb6Ku69evSyr2h9bh2Z9INbEhgKQv/Pn6n5hEFFAF8lPJ31lN
         V2Dc6Vq8qkUwV1aPZu5iPJtj2dfVtaCVg2zYZvJOMaxMWOWJBP0wvYWh2KnyL9ZKgS
         +cSAY6KPfLUPD6upprXBn/7NmWbygZ/CYSmT4O5o=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kangjie Lu <kjlu@umn.edu>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 111/177] Revert "ASoC: cs43130: fix a NULL pointer dereference"
Date:   Mon, 31 May 2021 15:14:28 +0200
Message-Id: <20210531130651.752580694@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210531130647.887605866@linuxfoundation.org>
References: <20210531130647.887605866@linuxfoundation.org>
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



