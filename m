Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3D7EE3786B1
	for <lists+stable@lfdr.de>; Mon, 10 May 2021 13:32:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235411AbhEJLKM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 May 2021 07:10:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:34814 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234294AbhEJLCv (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 May 2021 07:02:51 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1CF7E6142D;
        Mon, 10 May 2021 10:54:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620644053;
        bh=YucLfOKQ5QiviNoTGIjV6vunvvQ44u9yba2IfMpEblU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RPBBjKxwYpE/gYFQ1jLGDGGhRNFtAgTnwlqcxfDMvYe+L+puvXrPvBgTcJx03bsX6
         Ck4ST1BXuM2T4pdc71hNE+utpqhJ592odrsblbghMozBAHbP8/RGF7A6T0S48cuF3m
         zG9QxWZ1sDH02X8K8uBgMPfBGFGwkY4PnA8AsWMU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hansem Ro <hansemro@outlook.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 5.11 268/342] Input: ili210x - add missing negation for touch indication on ili210x
Date:   Mon, 10 May 2021 12:20:58 +0200
Message-Id: <20210510102018.951520614@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210510102010.096403571@linuxfoundation.org>
References: <20210510102010.096403571@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hansem Ro <hansemro@outlook.com>

commit ac05a8a927e5a1027592d8f98510a511dadeed14 upstream.

This adds the negation needed for proper finger detection on Ilitek
ili2107/ili210x. This fixes polling issues (on Amazon Kindle Fire)
caused by returning false for the cooresponding finger on the touchscreen.

Signed-off-by: Hansem Ro <hansemro@outlook.com>
Fixes: e3559442afd2a ("ili210x - rework the touchscreen sample processing")
Cc: stable@vger.kernel.org
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/input/touchscreen/ili210x.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/input/touchscreen/ili210x.c
+++ b/drivers/input/touchscreen/ili210x.c
@@ -87,7 +87,7 @@ static bool ili210x_touchdata_to_coords(
 					unsigned int *x, unsigned int *y,
 					unsigned int *z)
 {
-	if (touchdata[0] & BIT(finger))
+	if (!(touchdata[0] & BIT(finger)))
 		return false;
 
 	*x = get_unaligned_be16(touchdata + 1 + (finger * 4) + 0);


