Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 620AF3782E1
	for <lists+stable@lfdr.de>; Mon, 10 May 2021 12:40:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231446AbhEJKjA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 May 2021 06:39:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:41944 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232229AbhEJKgz (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 May 2021 06:36:55 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B245361481;
        Mon, 10 May 2021 10:29:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620642565;
        bh=2c3G4MUUnXpl7Px7BjBMIkxKo41RxPS0bKWAcCEubNg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sCtoAfW303LmAK73jxp+4o/eRaNwWRmoMuuzsqCBPIquinotOGYDi0DUNdIj+rTBj
         CApb6YdzFHeCrUvwlmQtXav0Ttms5tDJbV7u6EcAERnVrEt0y4ucS7i/INFUnHx2Xq
         COIqA0qI0wFA6cF/H+A6iXLOym9pomIGDqZMXHsU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hansem Ro <hansemro@outlook.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 5.4 146/184] Input: ili210x - add missing negation for touch indication on ili210x
Date:   Mon, 10 May 2021 12:20:40 +0200
Message-Id: <20210510101954.913781725@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210510101950.200777181@linuxfoundation.org>
References: <20210510101950.200777181@linuxfoundation.org>
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
@@ -109,7 +109,7 @@ static bool ili210x_touchdata_to_coords(
 	if (finger >= ILI210X_TOUCHES)
 		return false;
 
-	if (touchdata[0] & BIT(finger))
+	if (!(touchdata[0] & BIT(finger)))
 		return false;
 
 	*x = get_unaligned_be16(touchdata + 1 + (finger * 4) + 0);


