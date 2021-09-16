Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C8D0D40DFC5
	for <lists+stable@lfdr.de>; Thu, 16 Sep 2021 18:12:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235318AbhIPQNr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Sep 2021 12:13:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:49222 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235243AbhIPQMB (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Sep 2021 12:12:01 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id DE7326135E;
        Thu, 16 Sep 2021 16:09:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631808554;
        bh=xHS6AlhJcwDQTw0B7RWU++5YEdgq3/cRxwIjtyD45fY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JHkQX4uxfRG+G/ioPzOye7CUSX/awnhK7eN6opQTaHa/upF4jHeJLS/vHp5YeKYRr
         VaXgMGnTrXiqNel08eqdp3+BP8hdSzzt+0h+YgERni4yeMCOQRC7kpD3RQSPtmPY4p
         2BGeAs1uwxBX9cV9CvA0klUdcgbXy0iSbxkep1O8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kelly Devilliv <kelly.devilliv@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 133/306] usb: host: fotg210: fix the actual_length of an iso packet
Date:   Thu, 16 Sep 2021 17:57:58 +0200
Message-Id: <20210916155758.585358828@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210916155753.903069397@linuxfoundation.org>
References: <20210916155753.903069397@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index 1eb8bb55c59c..ff0b3457fd34 100644
--- a/drivers/usb/host/fotg210-hcd.c
+++ b/drivers/usb/host/fotg210-hcd.c
@@ -4459,13 +4459,12 @@ static bool itd_complete(struct fotg210_hcd *fotg210, struct fotg210_itd *itd)
 
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
index 6cee40ec65b4..67f59517ebad 100644
--- a/drivers/usb/host/fotg210.h
+++ b/drivers/usb/host/fotg210.h
@@ -686,11 +686,6 @@ static inline unsigned fotg210_read_frame_index(struct fotg210_hcd *fotg210)
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



