Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CA7B1409359
	for <lists+stable@lfdr.de>; Mon, 13 Sep 2021 16:20:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242306AbhIMOU4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Sep 2021 10:20:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:37124 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1343722AbhIMORM (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 13 Sep 2021 10:17:12 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B029661AFD;
        Mon, 13 Sep 2021 13:45:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631540701;
        bh=9Y0OFOHCezxPl7N3Kt31p5suLdAPHG/POeu+xZp/3vs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=aFI1tryKb9njcoFAdDMUpAuSd7RTrdu7OWYbE5XrlTUYYr7lGnqY6qMtaa/8W18Me
         kpWSsRzbmdP3sp3QoWvn62mgJIM7OeZeE2kETEyJ8Se3TMC4gzBt2YA/zYiBSUmX0+
         jBOuE/mjolTv08cmg0xV2KgqwRo8Hk0y/JNMDelo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        Lars Poeschel <poeschel@lemonage.de>,
        Miguel Ojeda <ojeda@kernel.org>
Subject: [PATCH 5.13 268/300] auxdisplay: hd44780: Fix oops on module unloading
Date:   Mon, 13 Sep 2021 15:15:29 +0200
Message-Id: <20210913131118.396647981@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210913131109.253835823@linuxfoundation.org>
References: <20210913131109.253835823@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lars Poeschel <poeschel@lemonage.de>

commit 333ff32d54cdefc2e479892e7f15ac91e026b57d upstream.

Fixes: 718e05ed92ec ("auxdisplay: Introduce hd44780_common.[ch]")
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/lkml/CAHp75VfKyqy+vM0XkP9Yb+znGOTVT4zYCRY3A3nQ7C3WNUVN0g@mail.gmail.com/
Reported-By: Andy Shevchenko <andy.shevchenko@gmail.com>
Signed-off-by: Lars Poeschel <poeschel@lemonage.de>
Tested-by: Andy Shevchenko <andy.shevchenko@gmail.com>
[added Link, Fixes, Cc stable tags, edited message]
Signed-off-by: Miguel Ojeda <ojeda@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/auxdisplay/hd44780.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/auxdisplay/hd44780.c
+++ b/drivers/auxdisplay/hd44780.c
@@ -323,8 +323,8 @@ static int hd44780_remove(struct platfor
 {
 	struct charlcd *lcd = platform_get_drvdata(pdev);
 
-	kfree(lcd->drvdata);
 	charlcd_unregister(lcd);
+	kfree(lcd->drvdata);
 
 	kfree(lcd);
 	return 0;


