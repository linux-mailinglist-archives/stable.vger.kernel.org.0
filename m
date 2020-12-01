Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A60A82C9C3B
	for <lists+stable@lfdr.de>; Tue,  1 Dec 2020 10:18:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390305AbgLAJO1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Dec 2020 04:14:27 -0500
Received: from mail.kernel.org ([198.145.29.99]:52236 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390162AbgLAJNv (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 1 Dec 2020 04:13:51 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AFE1021D7A;
        Tue,  1 Dec 2020 09:13:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1606813990;
        bh=f7LGGGLs+G8aUclUb5lOFtZxAShetPfKAwZ164xh7jY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pisCsEEeSqDFYwhFhK0fPtZ8b4Fps3JC85pCePmgJ6pOSS5v6/af31ZWhN0e2iWbc
         rQAZiry7DrD+ZFHD0Aab4mv/hd1lHvDU9NwrygzVXKWKX75cm8aAmT48n8R3kJ++Fs
         PTv1FMRJYO80NIpG1jtFO/krU3U/b1BwNbWGWOl0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Min Li <min.li.xe@renesas.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.9 128/152] ptp: clockmatrix: bug fix for idtcm_strverscmp
Date:   Tue,  1 Dec 2020 09:54:03 +0100
Message-Id: <20201201084728.567665251@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201201084711.707195422@linuxfoundation.org>
References: <20201201084711.707195422@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Min Li <min.li.xe@renesas.com>

[ Upstream commit 3cb2e6d92be637b79d6ba0746d610a8dfcc0400b ]

Feed kstrtou8 with NULL terminated string.

Changes since v1:
-Use sscanf to get rid of adhoc string parse.
Changes since v2:
-Check if sscanf returns 3.

Fixes: 7ea5fda2b132 ("ptp: ptp_clockmatrix: update to support 4.8.7 firmware")
Signed-off-by: Min Li <min.li.xe@renesas.com>
Link: https://lore.kernel.org/r/1606273115-25792-1-git-send-email-min.li.xe@renesas.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/ptp/ptp_clockmatrix.c | 49 ++++++++++++-----------------------
 1 file changed, 16 insertions(+), 33 deletions(-)

diff --git a/drivers/ptp/ptp_clockmatrix.c b/drivers/ptp/ptp_clockmatrix.c
index e020faff7da53..663255774c0b0 100644
--- a/drivers/ptp/ptp_clockmatrix.c
+++ b/drivers/ptp/ptp_clockmatrix.c
@@ -103,43 +103,26 @@ static int timespec_to_char_array(struct timespec64 const *ts,
 	return 0;
 }
 
-static int idtcm_strverscmp(const char *ver1, const char *ver2)
+static int idtcm_strverscmp(const char *version1, const char *version2)
 {
-	u8 num1;
-	u8 num2;
-	int result = 0;
-
-	/* loop through each level of the version string */
-	while (result == 0) {
-		/* extract leading version numbers */
-		if (kstrtou8(ver1, 10, &num1) < 0)
-			return -1;
+	u8 ver1[3], ver2[3];
+	int i;
 
-		if (kstrtou8(ver2, 10, &num2) < 0)
-			return -1;
+	if (sscanf(version1, "%hhu.%hhu.%hhu",
+		   &ver1[0], &ver1[1], &ver1[2]) != 3)
+		return -1;
+	if (sscanf(version2, "%hhu.%hhu.%hhu",
+		   &ver2[0], &ver2[1], &ver2[2]) != 3)
+		return -1;
 
-		/* if numbers differ, then set the result */
-		if (num1 < num2)
-			result = -1;
-		else if (num1 > num2)
-			result = 1;
-		else {
-			/* if numbers are the same, go to next level */
-			ver1 = strchr(ver1, '.');
-			ver2 = strchr(ver2, '.');
-			if (!ver1 && !ver2)
-				break;
-			else if (!ver1)
-				result = -1;
-			else if (!ver2)
-				result = 1;
-			else {
-				ver1++;
-				ver2++;
-			}
-		}
+	for (i = 0; i < 3; i++) {
+		if (ver1[i] > ver2[i])
+			return 1;
+		if (ver1[i] < ver2[i])
+			return -1;
 	}
-	return result;
+
+	return 0;
 }
 
 static int idtcm_xfer_read(struct idtcm *idtcm,
-- 
2.27.0



