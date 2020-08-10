Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 724BB240956
	for <lists+stable@lfdr.de>; Mon, 10 Aug 2020 17:33:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728152AbgHJPaA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Aug 2020 11:30:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:36608 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729033AbgHJP36 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 Aug 2020 11:29:58 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6BF0622D02;
        Mon, 10 Aug 2020 15:29:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597073397;
        bh=PZcRqQCNsNEq1ZS0iX1apEtdikPbEajs+XFzXYEZ6VM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CJyY/hDz5ge29JKa5430OqgN+RSleU8wioh6yBfZeoPlSWDEDQe838mIoY0hgyjPd
         6+uOG/ahZgH+A4Jn6gODWGjYAh1xwYMweemNf4ToUSzqNK3kIPQhv8EsNXxc0HjvKx
         kL5/sjdJe3nJ3uR7pX2DLRXFYzc/zcxjvjoT+SPI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hui Wang <hui.wang@canonical.com>,
        Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 4.19 05/48] Revert "ALSA: hda: call runtime_allow() for all hda controllers"
Date:   Mon, 10 Aug 2020 17:21:27 +0200
Message-Id: <20200810151804.483653043@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200810151804.199494191@linuxfoundation.org>
References: <20200810151804.199494191@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hui Wang <hui.wang@canonical.com>

commit 07c9983b567d0ef33aefc063299de95a987e12a8 upstream.

This reverts commit 9a6418487b56 ("ALSA: hda: call runtime_allow()
for all hda controllers").

The reverted patch already introduced some regressions on some
machines:
 - on gemini-lake machines, the error of "azx_get_response timeout"
   happens in the hda driver.
 - on the machines with alc662 codec, the audio jack detection doesn't
   work anymore.

Fixes: 9a6418487b56 ("ALSA: hda: call runtime_allow() for all hda controllers")
BugLink: https://bugzilla.kernel.org/show_bug.cgi?id=208511
Cc: <stable@vger.kernel.org>
Signed-off-by: Hui Wang <hui.wang@canonical.com>
Link: https://lore.kernel.org/r/20200803064638.6139-1-hui.wang@canonical.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/pci/hda/hda_intel.c |    1 -
 1 file changed, 1 deletion(-)

--- a/sound/pci/hda/hda_intel.c
+++ b/sound/pci/hda/hda_intel.c
@@ -2478,7 +2478,6 @@ static int azx_probe_continue(struct azx
 
 	if (azx_has_pm_runtime(chip)) {
 		pm_runtime_use_autosuspend(&pci->dev);
-		pm_runtime_allow(&pci->dev);
 		pm_runtime_put_autosuspend(&pci->dev);
 	}
 


