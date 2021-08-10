Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4C38D3E81F1
	for <lists+stable@lfdr.de>; Tue, 10 Aug 2021 20:06:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235266AbhHJSEC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Aug 2021 14:04:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:37910 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235287AbhHJSCG (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Aug 2021 14:02:06 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6CB0C613D3;
        Tue, 10 Aug 2021 17:47:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1628617652;
        bh=fYbPD6SIWsNFYHz6S+5gphmdOZh4iGMK8XZxOMbHG2k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=X9a62Lm0FU3MBwcTDDrgGnJeIMeY4Ffw4JEakyhPjOu4JDm6WweS5aAyuwtnt+h5e
         g16B9hXzvGH+7u8LQFNO1sllj6ejCoOCp3b854k36avSjNpCzApoaqFgKOEuwP2mAA
         r/TgHnrzqFOSu5mri/rOwVnjtBTdecyXTKc1MRD0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Pawel Laszczak <pawell@cadence.com>,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        Peter Chen <peter.chen@kernel.org>
Subject: [PATCH 5.13 153/175] usb: cdnsp: Fix the IMAN_IE_SET and IMAN_IE_CLEAR macro
Date:   Tue, 10 Aug 2021 19:31:01 +0200
Message-Id: <20210810173006.019253407@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210810173000.928681411@linuxfoundation.org>
References: <20210810173000.928681411@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>

commit 5df09c15bab98463203c83ecab88b9321466e626 upstream.

IMAN_IE is BIT(1), so these macro are respectively equivalent to BIT(1)
and 0, whatever the value of 'p'.

The purpose was to set and reset a single bit in 'p'.
Fix these macros to do that correctly.

Acked-by: Pawel Laszczak <pawell@cadence.com>
Fixes: e93e58d27402 ("usb: cdnsp: Device side header file for CDNSP driver")
Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Link: https://lore.kernel.org/r/d12bfcc9cbffb89e27b120668821b3c4f09b6755.1624390584.git.christophe.jaillet@wanadoo.fr
Signed-off-by: Peter Chen <peter.chen@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/cdns3/cdnsp-gadget.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/usb/cdns3/cdnsp-gadget.h
+++ b/drivers/usb/cdns3/cdnsp-gadget.h
@@ -383,8 +383,8 @@ struct cdnsp_intr_reg {
 #define IMAN_IE			BIT(1)
 #define IMAN_IP			BIT(0)
 /* bits 2:31 need to be preserved */
-#define IMAN_IE_SET(p)		(((p) & IMAN_IE) | 0x2)
-#define IMAN_IE_CLEAR(p)	(((p) & IMAN_IE) & ~(0x2))
+#define IMAN_IE_SET(p)		((p) | IMAN_IE)
+#define IMAN_IE_CLEAR(p)	((p) & ~IMAN_IE)
 
 /* IMOD - Interrupter Moderation Register - irq_control bitmasks. */
 /*


