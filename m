Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4D7682E6926
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 17:47:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728741AbgL1Qph (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 11:45:37 -0500
Received: from mail.kernel.org ([198.145.29.99]:52674 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728738AbgL1M4U (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 07:56:20 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id CF6CC22573;
        Mon, 28 Dec 2020 12:55:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609160140;
        bh=lcxeqXc4xtm5cEOZOGF//d4Kv16Y7KqjFQXnyC5S9f0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IfG2KPimHTWxMo2vUey1YUjob8r+wFJyS/TABjnGpouKV0dG7D5gVXvb1erAqQyGz
         HyyMUW/8rmD3S7iV9aIFJ5E69u5G8+6SgSqFtI14jf0B2DQOlmijwzZ+0l9XQnrEi5
         27zGOO8TppG/QFk76Etflgk2+zeoSstZwFAMOdZ4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        Charles Keepax <ckeepax@opensource.cirrus.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 082/132] ASoC: wm_adsp: remove "ctl" from list on error in wm_adsp_create_control()
Date:   Mon, 28 Dec 2020 13:49:26 +0100
Message-Id: <20201228124850.401747869@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228124846.409999325@linuxfoundation.org>
References: <20201228124846.409999325@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dan Carpenter <dan.carpenter@oracle.com>

[ Upstream commit 85a7555575a0e48f9b73db310d0d762a08a46d63 ]

The error handling frees "ctl" but it's still on the "dsp->ctl_list"
list so that could result in a use after free.  Remove it from the list
before returning.

Fixes: 2323736dca72 ("ASoC: wm_adsp: Add basic support for rev 1 firmware file format")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Acked-by: Charles Keepax <ckeepax@opensource.cirrus.com>
Link: https://lore.kernel.org/r/X9B0keV/02wrx9Xs@mwanda
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/wm_adsp.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/sound/soc/codecs/wm_adsp.c b/sound/soc/codecs/wm_adsp.c
index f1f990b325ad7..5ff0d3b10bcfd 100644
--- a/sound/soc/codecs/wm_adsp.c
+++ b/sound/soc/codecs/wm_adsp.c
@@ -852,7 +852,7 @@ static int wm_adsp_create_control(struct wm_adsp *dsp,
 	ctl_work = kzalloc(sizeof(*ctl_work), GFP_KERNEL);
 	if (!ctl_work) {
 		ret = -ENOMEM;
-		goto err_ctl_cache;
+		goto err_list_del;
 	}
 
 	ctl_work->dsp = dsp;
@@ -862,7 +862,8 @@ static int wm_adsp_create_control(struct wm_adsp *dsp,
 
 	return 0;
 
-err_ctl_cache:
+err_list_del:
+	list_del(&ctl->list);
 	kfree(ctl->cache);
 err_ctl_name:
 	kfree(ctl->name);
-- 
2.27.0



