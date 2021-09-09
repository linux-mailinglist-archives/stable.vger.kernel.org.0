Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3AD9D405672
	for <lists+stable@lfdr.de>; Thu,  9 Sep 2021 15:37:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1359732AbhIINTw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Sep 2021 09:19:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:35410 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1358471AbhIINLR (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 9 Sep 2021 09:11:17 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id EB1C5632BE;
        Thu,  9 Sep 2021 12:01:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631188885;
        bh=OegV4XZiTSm/ViS5j36yq5Ljf73puaGDEcIdEG3Azbs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mMycPdSlIZvxUUrfAcJ+So3QcNlGk/D+IAJAOvHyUVG/RtyLCTwgOx37y/+DRCrOQ
         qjdzdVwCPfgXP/ChPCjxoIHH2lb/3NDPWj4KDs0lzDXD5GfQhfr0sAHZwNqLHGtvkL
         Wv4aTPBV3atEz72UWR3TKnNjtTiHRCVAjqt1NfRWIapTtXGlm9HBcGFGQo25Fgpdnq
         w2Z9V4Oi6URmTQP41fu56y3m3REQwOo4HkNdwPkogEXX6O4kwVTsx5B67jxJVMsTRY
         6ISlGhhUso18I+lhnGksMXwsh4s93AxtQlfhYy0QB2rSdacRGa6eW8pTqmfpNO36kI
         3GvNcN3nYBvKA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Kelly Devilliv <kelly.devilliv@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>, linux-usb@vger.kernel.org
Subject: [PATCH AUTOSEL 4.4 07/35] usb: host: fotg210: fix the actual_length of an iso packet
Date:   Thu,  9 Sep 2021 08:00:48 -0400
Message-Id: <20210909120116.150912-7-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210909120116.150912-1-sashal@kernel.org>
References: <20210909120116.150912-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kelly Devilliv <kelly.devilliv@gmail.com>

[ Upstream commit 091cb2f782f32ab68c6f5f326d7868683d3d4875 ]

We should acquire the actual_length of an iso packet
from the iTD directly using FOTG210_ITD_LENGTH() macro.

Signed-off-by: Kelly Devilliv <kelly.devilliv@gmail.com>
Link: https://lore.kernel.org/r/20210627125747.127646-4-kelly.devilliv@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/host/fotg210-hcd.c | 5 ++---
 drivers/usb/host/fotg210.h     | 5 -----
 2 files changed, 2 insertions(+), 8 deletions(-)

diff --git a/drivers/usb/host/fotg210-hcd.c b/drivers/usb/host/fotg210-hcd.c
index 5dacc3076efd..e081392ec830 100644
--- a/drivers/usb/host/fotg210-hcd.c
+++ b/drivers/usb/host/fotg210-hcd.c
@@ -4495,13 +4495,12 @@ static bool itd_complete(struct fotg210_hcd *fotg210, struct fotg210_itd *itd)
 
 			/* HC need not update length with this error */
 			if (!(t & FOTG210_ISOC_BABBLE)) {
-				desc->actual_length =
-					fotg210_itdlen(urb, desc, t);
+				desc->actual_length = FOTG210_ITD_LENGTH(t);
 				urb->actual_length += desc->actual_length;
 			}
 		} else if (likely((t & FOTG210_ISOC_ACTIVE) == 0)) {
 			desc->status = 0;
-			desc->actual_length = fotg210_itdlen(urb, desc, t);
+			desc->actual_length = FOTG210_ITD_LENGTH(t);
 			urb->actual_length += desc->actual_length;
 		} else {
 			/* URB was too late */
diff --git a/drivers/usb/host/fotg210.h b/drivers/usb/host/fotg210.h
index b5cfa7aeb277..1a3f94123c88 100644
--- a/drivers/usb/host/fotg210.h
+++ b/drivers/usb/host/fotg210.h
@@ -682,11 +682,6 @@ static inline unsigned fotg210_read_frame_index(struct fotg210_hcd *fotg210)
 	return fotg210_readl(fotg210, &fotg210->regs->frame_index);
 }
 
-#define fotg210_itdlen(urb, desc, t) ({			\
-	usb_pipein((urb)->pipe) ?				\
-	(desc)->length - FOTG210_ITD_LENGTH(t) :			\
-	FOTG210_ITD_LENGTH(t);					\
-})
 /*-------------------------------------------------------------------------*/
 
 #endif /* __LINUX_FOTG210_H */
-- 
2.30.2

