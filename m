Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5A5D1121313
	for <lists+stable@lfdr.de>; Mon, 16 Dec 2019 18:58:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728502AbfLPR6i (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Dec 2019 12:58:38 -0500
Received: from mail.kernel.org ([198.145.29.99]:58588 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728632AbfLPR6i (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 16 Dec 2019 12:58:38 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0B81E21582;
        Mon, 16 Dec 2019 17:58:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576519117;
        bh=0cMTQmwl4BZU+5xKQAthdhFWfd/pUDKDSr2RpGBgt5I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nr56oechQ91y/vFDfYSK0+hVCqIMgttqkpHm3KkvIV+Be47u0oUYSuoUeFhQpRLUI
         kuZO+qD4u9d4zcumaVspTxEmsDgmCVMrDvS7FQmfPPNZLozfuwTzrqrC5TVj1mRLSv
         FIJ4bmaXcjQfCeiAUrRGdq1kw4eGd2aevty6WsVI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Pawel Harlozinski <pawel.harlozinski@linux.intel.com>,
        Mark Brown <broonie@kernel.org>
Subject: [PATCH 4.14 203/267] ASoC: Jack: Fix NULL pointer dereference in snd_soc_jack_report
Date:   Mon, 16 Dec 2019 18:48:49 +0100
Message-Id: <20191216174913.654874111@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191216174848.701533383@linuxfoundation.org>
References: <20191216174848.701533383@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pawel Harlozinski <pawel.harlozinski@linux.intel.com>

commit 8f157d4ff039e03e2ed4cb602eeed2fd4687a58f upstream.

Check for existance of jack before tracing.
NULL pointer dereference has been reported by KASAN while unloading
machine driver (snd_soc_cnl_rt274).

Signed-off-by: Pawel Harlozinski <pawel.harlozinski@linux.intel.com>
Link: https://lore.kernel.org/r/20191112130237.10141-1-pawel.harlozinski@linux.intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/soc/soc-jack.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/sound/soc/soc-jack.c
+++ b/sound/soc/soc-jack.c
@@ -127,10 +127,9 @@ void snd_soc_jack_report(struct snd_soc_
 	unsigned int sync = 0;
 	int enable;
 
-	trace_snd_soc_jack_report(jack, mask, status);
-
 	if (!jack)
 		return;
+	trace_snd_soc_jack_report(jack, mask, status);
 
 	dapm = &jack->card->dapm;
 


