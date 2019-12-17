Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 52DF5122129
	for <lists+stable@lfdr.de>; Tue, 17 Dec 2019 02:01:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726526AbfLQAvb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Dec 2019 19:51:31 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:34494 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726402AbfLQAva (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Dec 2019 19:51:30 -0500
Received: from [192.168.4.242] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1ih15E-0003If-Nr; Tue, 17 Dec 2019 00:51:28 +0000
Received: from ben by deadeye with local (Exim 4.93-RC7)
        (envelope-from <ben@decadent.org.uk>)
        id 1ih15D-0005Ro-N9; Tue, 17 Dec 2019 00:51:27 +0000
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        "Larry Finger" <Larry.Finger@lwfinger.net>,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
        "Denis Efremov" <efremov@linux.com>,
        "Michael Straube" <straube.linux@gmail.com>
Date:   Tue, 17 Dec 2019 00:45:41 +0000
Message-ID: <lsq.1576543535.761050065@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 007/136] staging: rtl8188eu: fix HighestRate check in
 odm_ARFBRefresh_8188E()
In-Reply-To: <lsq.1576543534.33060804@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.242
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

3.16.80-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Denis Efremov <efremov@linux.com>

commit 22d67a01d8d89552b989c9651419824bb4111200 upstream.

It's incorrect to compare HighestRate with 0x0b twice in the following
manner "if (HighestRate > 0x0b) ... else if (HighestRate > 0x0b) ...". The
"else if" branch is constantly false. The second comparision should be
with 0x03 according to the max_rate_idx in ODM_RAInfo_Init().

Cc: Michael Straube <straube.linux@gmail.com>
Signed-off-by: Denis Efremov <efremov@linux.com>
Acked-by: Larry Finger <Larry.Finger@lwfinger.net>
Link: https://lore.kernel.org/r/20190926073138.12109-1-efremov@linux.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
[bwh: Backported to 3.16: adjust filename, indentation]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/staging/rtl8188eu/hal/Hal8188ERateAdaptive.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/staging/rtl8188eu/hal/Hal8188ERateAdaptive.c
+++ b/drivers/staging/rtl8188eu/hal/Hal8188ERateAdaptive.c
@@ -403,7 +403,7 @@ static int odm_ARFBRefresh_8188E(struct
 			pRaInfo->PTModeSS = 3;
 		else if (pRaInfo->HighestRate > 0x0b)
 			pRaInfo->PTModeSS = 2;
-		else if (pRaInfo->HighestRate > 0x0b)
+		else if (pRaInfo->HighestRate > 0x03)
 			pRaInfo->PTModeSS = 1;
 		else
 			pRaInfo->PTModeSS = 0;

