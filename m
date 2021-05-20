Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9AFD838A891
	for <lists+stable@lfdr.de>; Thu, 20 May 2021 12:52:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237484AbhETKvY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 May 2021 06:51:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:49448 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238607AbhETKtw (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 May 2021 06:49:52 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5D610613B9;
        Thu, 20 May 2021 09:59:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621504751;
        bh=yenn2MovbEYOhqv8ZBhe6QTikmS7lPioOrbShAv+WZ8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PcrLeZDVJyXp1GzdvATA5R6Gz/7oKQwMBh21gA+qmYVPtkgeM9iqXa+y06auAipC+
         Iy5kby7eTsqfzRyuidezK55LdGLVbgH1D3Rv+TATlPdxMIJ1lGIL7bMaDs42Xhuj9i
         8Bfq91D+62gzKaw5KHR/dzERBc0T8/4xCWKl381M=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Peter Chen <peter.chen@kernel.org>,
        Hemant Kumar <hemantk@codeaurora.org>,
        Wesley Cheng <wcheng@codeaurora.org>
Subject: [PATCH 4.9 063/240] usb: gadget: Fix double free of device descriptor pointers
Date:   Thu, 20 May 2021 11:20:55 +0200
Message-Id: <20210520092110.795545838@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210520092108.587553970@linuxfoundation.org>
References: <20210520092108.587553970@linuxfoundation.org>
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
 


