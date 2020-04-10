Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4E0AF1A40E0
	for <lists+stable@lfdr.de>; Fri, 10 Apr 2020 06:15:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726683AbgDJDqi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Apr 2020 23:46:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:56504 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726082AbgDJDqi (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 9 Apr 2020 23:46:38 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1C08D20B1F;
        Fri, 10 Apr 2020 03:46:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1586490397;
        bh=UrwSOr4h2UrF7KC5Oh4oX+BltuND9X9C5BW/wnK2KGY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=K3w8uxR0ySjPqG+66MfVK3p60pz+mpnLcGmE4zz3xmLj5KlYUEvdILkQ7sijctetD
         xCWKmHBjn6esCocdrCmse0Or7gcUQ957L+MKxMQuQMsjAARWAw9cwz5Z0LAoqbGl62
         JlpN0Kf7EAQ673z3hDwBJSnbZ6KH4FZ/yM5o86mI=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Robert Richter <rrichter@marvell.com>,
        Borislav Petkov <bp@suse.de>,
        Aristeu Rozanski <aris@redhat.com>,
        Sasha Levin <sashal@kernel.org>, linux-edac@vger.kernel.org
Subject: [PATCH AUTOSEL 5.6 02/68] EDAC/mc: Report "unknown memory" on too many DIMM labels found
Date:   Thu,  9 Apr 2020 23:45:27 -0400
Message-Id: <20200410034634.7731-2-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200410034634.7731-1-sashal@kernel.org>
References: <20200410034634.7731-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Robert Richter <rrichter@marvell.com>

[ Upstream commit 65bb4d1af92cf007adc0a0c59dadcc393c5cada6 ]

There is a limitation to report only EDAC_MAX_LABELS in e->label of
the error descriptor. This is to prevent a potential string overflow.

The current implementation falls back to "any memory" in this case and
also stops all further processing to find a unique row and channel of
the possible error location.

Reporting "any memory" is wrong as the memory controller reported an
error location for one of the layers. Instead, report "unknown memory"
and also do not break early in the loop to further check row and channel
for uniqueness.

 [ bp: Massage commit message. ]

Signed-off-by: Robert Richter <rrichter@marvell.com>
Signed-off-by: Borislav Petkov <bp@suse.de>
Acked-by: Aristeu Rozanski <aris@redhat.com>
Link: https://lkml.kernel.org/r/20200123090210.26933-7-rrichter@marvell.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/edac/edac_mc.c | 21 +++++++++++----------
 1 file changed, 11 insertions(+), 10 deletions(-)

diff --git a/drivers/edac/edac_mc.c b/drivers/edac/edac_mc.c
index 69e0d90460e6c..2349f2ad946bb 100644
--- a/drivers/edac/edac_mc.c
+++ b/drivers/edac/edac_mc.c
@@ -1180,20 +1180,21 @@ void edac_mc_handle_error(const enum hw_event_mc_err_type type,
 		 * channel/memory controller/...  may be affected.
 		 * Also, don't show errors for empty DIMM slots.
 		 */
-		if (!e->enable_per_layer_report || !dimm->nr_pages)
+		if (!dimm->nr_pages)
 			continue;
 
-		if (n_labels >= EDAC_MAX_LABELS) {
-			e->enable_per_layer_report = false;
-			break;
-		}
 		n_labels++;
-		if (p != e->label) {
-			strcpy(p, OTHER_LABEL);
-			p += strlen(OTHER_LABEL);
+		if (n_labels > EDAC_MAX_LABELS) {
+			p = e->label;
+			*p = '\0';
+		} else {
+			if (p != e->label) {
+				strcpy(p, OTHER_LABEL);
+				p += strlen(OTHER_LABEL);
+			}
+			strcpy(p, dimm->label);
+			p += strlen(p);
 		}
-		strcpy(p, dimm->label);
-		p += strlen(p);
 
 		/*
 		 * get csrow/channel of the DIMM, in order to allow
-- 
2.20.1

