Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B945D38A673
	for <lists+stable@lfdr.de>; Thu, 20 May 2021 12:25:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235907AbhETK1K (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 May 2021 06:27:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:52120 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236033AbhETKZJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 May 2021 06:25:09 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1D13C61358;
        Thu, 20 May 2021 09:49:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621504184;
        bh=yenn2MovbEYOhqv8ZBhe6QTikmS7lPioOrbShAv+WZ8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZlM2zaAJIc6N4cx0Z8nlOi0EE1nzCjYpuy97i/rIsGyFWNEc/g4jFs97Qt6ziwnYA
         hw2PVW3/9Ym9IfKAHh2OGayGxDrk6z4CkaHgBLzXpLvCh4lrtlSyEgTdvCFLQHgnzZ
         OOhhcxGUYroIFug4jkMu19RUTi0fFslcceWitlGM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Peter Chen <peter.chen@kernel.org>,
        Hemant Kumar <hemantk@codeaurora.org>,
        Wesley Cheng <wcheng@codeaurora.org>
Subject: [PATCH 4.14 096/323] usb: gadget: Fix double free of device descriptor pointers
Date:   Thu, 20 May 2021 11:19:48 +0200
Message-Id: <20210520092123.396940763@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210520092120.115153432@linuxfoundation.org>
References: <20210520092120.115153432@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hemant Kumar <hemantk@codeaurora.org>

commit 43c4cab006f55b6ca549dd1214e22f5965a8675f upstream.

Upon driver unbind usb_free_all_descriptors() function frees all
speed descriptor pointers without setting them to NULL. In case
gadget speed changes (i.e from super speed plus to super speed)
after driver unbind only upto super speed descriptor pointers get
populated. Super speed plus desc still holds the stale (already
freed) pointer. Fix this issue by setting all descriptor pointers
to NULL after freeing them in usb_free_all_descriptors().

Fixes: f5c61225cf29 ("usb: gadget: Update function for SuperSpeedPlus")
cc: stable@vger.kernel.org
Reviewed-by: Peter Chen <peter.chen@kernel.org>
Signed-off-by: Hemant Kumar <hemantk@codeaurora.org>
Signed-off-by: Wesley Cheng <wcheng@codeaurora.org>
Link: https://lore.kernel.org/r/1619034452-17334-1-git-send-email-wcheng@codeaurora.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/gadget/config.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/drivers/usb/gadget/config.c
+++ b/drivers/usb/gadget/config.c
@@ -198,9 +198,13 @@ EXPORT_SYMBOL_GPL(usb_assign_descriptors
 void usb_free_all_descriptors(struct usb_function *f)
 {
 	usb_free_descriptors(f->fs_descriptors);
+	f->fs_descriptors = NULL;
 	usb_free_descriptors(f->hs_descriptors);
+	f->hs_descriptors = NULL;
 	usb_free_descriptors(f->ss_descriptors);
+	f->ss_descriptors = NULL;
 	usb_free_descriptors(f->ssp_descriptors);
+	f->ssp_descriptors = NULL;
 }
 EXPORT_SYMBOL_GPL(usb_free_all_descriptors);
 


