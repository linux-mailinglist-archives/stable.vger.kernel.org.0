Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5942BD9FD6
	for <lists+stable@lfdr.de>; Thu, 17 Oct 2019 00:24:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2438263AbfJPV6r (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 16 Oct 2019 17:58:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:52646 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2438260AbfJPV6q (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 16 Oct 2019 17:58:46 -0400
Received: from localhost (unknown [192.55.54.58])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4BD3A20872;
        Wed, 16 Oct 2019 21:58:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1571263126;
        bh=wrPFR4hMu8e3GqW0eIvzAndNN0lyryXQlDzQkmqeg+A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=O4LTZGZEHo0jih5T4FHS6KfJgOXaTOajYNQyv9Kd+l4aYmI+3msZKSK/2A8smvCWh
         4xRAB0cCYyNUveRFbMxXeljc0QY/aMreSRK/hnF3pe68KfnySVgFyzpoYfjr2W7MxV
         MAxmlS0Fqi7MskByvgp50r4yPLOX3gFlyr+3g6Mc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Michael Straube <straube.linux@gmail.com>,
        Denis Efremov <efremov@linux.com>,
        Larry Finger <Larry.Finger@lwfinger.net>
Subject: [PATCH 5.3 050/112] staging: rtl8188eu: fix HighestRate check in odm_ARFBRefresh_8188E()
Date:   Wed, 16 Oct 2019 14:50:42 -0700
Message-Id: <20191016214856.566046359@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191016214844.038848564@linuxfoundation.org>
References: <20191016214844.038848564@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Denis Efremov <efremov@linux.com>

commit 22d67a01d8d89552b989c9651419824bb4111200 upstream.

It's incorrect to compare HighestRate with 0x0b twice in the following
manner "if (HighestRate > 0x0b) ... else if (HighestRate > 0x0b) ...". The
"else if" branch is constantly false. The second comparision should be
with 0x03 according to the max_rate_idx in ODM_RAInfo_Init().

Cc: Michael Straube <straube.linux@gmail.com>
Cc: stable@vger.kernel.org
Signed-off-by: Denis Efremov <efremov@linux.com>
Acked-by: Larry Finger <Larry.Finger@lwfinger.net>
Link: https://lore.kernel.org/r/20190926073138.12109-1-efremov@linux.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/staging/rtl8188eu/hal/hal8188e_rate_adaptive.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/staging/rtl8188eu/hal/hal8188e_rate_adaptive.c
+++ b/drivers/staging/rtl8188eu/hal/hal8188e_rate_adaptive.c
@@ -409,7 +409,7 @@ static int odm_ARFBRefresh_8188E(struct
 		pRaInfo->PTModeSS = 3;
 	else if (pRaInfo->HighestRate > 0x0b)
 		pRaInfo->PTModeSS = 2;
-	else if (pRaInfo->HighestRate > 0x0b)
+	else if (pRaInfo->HighestRate > 0x03)
 		pRaInfo->PTModeSS = 1;
 	else
 		pRaInfo->PTModeSS = 0;


