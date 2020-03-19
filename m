Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0136A18B536
	for <lists+stable@lfdr.de>; Thu, 19 Mar 2020 14:16:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727138AbgCSNQf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 Mar 2020 09:16:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:37084 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728859AbgCSNQe (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 19 Mar 2020 09:16:34 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 75E55216FD;
        Thu, 19 Mar 2020 13:16:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1584623793;
        bh=P1Cv3fel8WKmU0E8OLq16QVgX3hV8+DnzSpL2TRqCKQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BeXw0M0J9yXUmjE/998M9E01PIYpntC+r9V8G7JWouEccWLiWYCRXp/wyakTOEcn1
         BWlMb85XE9wsbooIQ9kyh3yfs7HFe/qJj3YEOKcDj+RwwsjHR32XjDs3P9ziOeLeNN
         xKtuoJvCHiKL1wyzZf0SHslC9qFYlo6u8ymyWZRQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Charles Keepax <ckeepax@opensource.cirrus.com>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH 4.14 55/99] pinctrl: core: Remove extra kref_get which blocks hogs being freed
Date:   Thu, 19 Mar 2020 14:03:33 +0100
Message-Id: <20200319123958.564985744@linuxfoundation.org>
X-Mailer: git-send-email 2.25.2
In-Reply-To: <20200319123941.630731708@linuxfoundation.org>
References: <20200319123941.630731708@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Charles Keepax <ckeepax@opensource.cirrus.com>

commit aafd56fc79041bf36f97712d4b35208cbe07db90 upstream.

kref_init starts with the reference count at 1, which will be balanced
by the pinctrl_put in pinctrl_unregister. The additional kref_get in
pinctrl_claim_hogs will increase this count to 2 and cause the hogs to
not get freed when pinctrl_unregister is called.

Fixes: 6118714275f0 ("pinctrl: core: Fix pinctrl_register_and_init() with pinctrl_enable()")
Signed-off-by: Charles Keepax <ckeepax@opensource.cirrus.com>
Link: https://lore.kernel.org/r/20200228154142.13860-1-ckeepax@opensource.cirrus.com
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/pinctrl/core.c |    1 -
 1 file changed, 1 deletion(-)

--- a/drivers/pinctrl/core.c
+++ b/drivers/pinctrl/core.c
@@ -2031,7 +2031,6 @@ static int pinctrl_claim_hogs(struct pin
 		return PTR_ERR(pctldev->p);
 	}
 
-	kref_get(&pctldev->p->users);
 	pctldev->hog_default =
 		pinctrl_lookup_state(pctldev->p, PINCTRL_STATE_DEFAULT);
 	if (IS_ERR(pctldev->hog_default)) {


