Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 26A403788E5
	for <lists+stable@lfdr.de>; Mon, 10 May 2021 13:49:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235534AbhEJLYu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 May 2021 07:24:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:53306 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233530AbhEJLMO (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 May 2021 07:12:14 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6DFBA610A7;
        Mon, 10 May 2021 11:09:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620644994;
        bh=YucLfOKQ5QiviNoTGIjV6vunvvQ44u9yba2IfMpEblU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lu8zQItxPGVt4gfG1NFshkYr9ly5xVNuRiDCwC9L2QkqUdCuSFXawOTBTzzpgWSuf
         A9Tzp+xJaKI0eQ2IZt0XtTb6VgMOqQ25/SfOSHaNqmz9aMwXZqhdFiP3noNYBTw32U
         LDXel1ytmtxqspPCovQGRTMYSPwHyLeDdVvz3MEs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hansem Ro <hansemro@outlook.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 5.12 301/384] Input: ili210x - add missing negation for touch indication on ili210x
Date:   Mon, 10 May 2021 12:21:30 +0200
Message-Id: <20210510102024.728948284@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210510102014.849075526@linuxfoundation.org>
References: <20210510102014.849075526@linuxfoundation.org>
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


