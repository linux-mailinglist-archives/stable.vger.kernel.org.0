Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 19A3340555D
	for <lists+stable@lfdr.de>; Thu,  9 Sep 2021 15:33:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358811AbhIINJl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Sep 2021 09:09:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:54086 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1357975AbhIINFq (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 9 Sep 2021 09:05:46 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 70A6D632A9;
        Thu,  9 Sep 2021 12:00:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631188826;
        bh=5DE08k53AFm6jaC5cL0oBCr2ZiaYYOFJ2ifxKjrUXew=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=b9YIBeuHq7nTDmVGM9TaqwRm2ri06D90rhkVtsCFebe50Vuh69dI7rrc+wxlz6XRT
         iASTtUWXmJvYMzJs3X1LxiKETxkPuBVw79wJq/qBTV8fcUEgBjZwkxx9QizlNvi2lS
         tqbOGoqKH7BsDa0hyCGPvA60xrDGMsk31PPt6193HXmHlwoiis/gyFj5t4Fa1n2Rzz
         j+EdGuAN0r2PFs8K/N6GK9L7z3w3pv//JOjCkT/6i/OxAhkmq+sBWt0BP86QS27er9
         NnSndMiNqBwAvbhmohtIUsw8lP00K6OS2gmXdo6rsw3yoYtpmrd/bHROt2Et5F0SGZ
         zY4hi3QiDFS1Q==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Kelly Devilliv <kelly.devilliv@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>, linux-usb@vger.kernel.org
Subject: [PATCH AUTOSEL 4.9 08/48] usb: host: fotg210: fix the actual_length of an iso packet
Date:   Thu,  9 Sep 2021 07:59:35 -0400
Message-Id: <20210909120015.150411-8-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210909120015.150411-1-sashal@kernel.org>
References: <20210909120015.150411-1-sashal@kernel.org>
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
index 725abc08550e..f0ec538a8813 100644
--- a/drivers/usb/host/fotg210-hcd.c
+++ b/drivers/usb/host/fotg210-hcd.c
@@ -4488,13 +4488,12 @@ static bool itd_complete(struct fotg210_hcd *fotg210, struct fotg210_itd *itd)
 
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

