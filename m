Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BE33C157BF0
	for <lists+stable@lfdr.de>; Mon, 10 Feb 2020 14:33:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728002AbgBJNdk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Feb 2020 08:33:40 -0500
Received: from mail.kernel.org ([198.145.29.99]:52764 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727999AbgBJMff (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 Feb 2020 07:35:35 -0500
Received: from localhost (unknown [209.37.97.194])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DF710208C4;
        Mon, 10 Feb 2020 12:35:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581338134;
        bh=al0af/Le0lWXcOzENGelh4CW2ewtkpIsHSnaTMAvg44=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ga1NMajglyd5IBwUGFVlCnlgPiRIdXFTzqiQguochjFP95ZFlL8B9CUl2OQPfoRXv
         /VtRf/6dWwhGm+6/FsCITG0kIiNvG83uZZlV9EQ0ndraDlfOcyX0IwCBC+QQG0zLVy
         XhrBOxQYpJxUZ2v/NfO38lkxRiU+o2u+BWr0NuoQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sven Van Asbroeck <TheSven73@gmail.com>,
        Sebastian Reichel <sebastian.reichel@collabora.com>
Subject: [PATCH 4.19 079/195] power: supply: ltc2941-battery-gauge: fix use-after-free
Date:   Mon, 10 Feb 2020 04:32:17 -0800
Message-Id: <20200210122313.310885621@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200210122305.731206734@linuxfoundation.org>
References: <20200210122305.731206734@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sven Van Asbroeck <thesven73@gmail.com>

commit a60ec78d306c6548d4adbc7918b587a723c555cc upstream.

This driver's remove path calls cancel_delayed_work().
However, that function does not wait until the work function
finishes. This could mean that the work function is still
running after the driver's remove function has finished,
which would result in a use-after-free.

Fix by calling cancel_delayed_work_sync(), which ensures that
that the work is properly cancelled, no longer running, and
unable to re-schedule itself.

This issue was detected with the help of Coccinelle.

Cc: stable <stable@vger.kernel.org>
Signed-off-by: Sven Van Asbroeck <TheSven73@gmail.com>
Signed-off-by: Sebastian Reichel <sebastian.reichel@collabora.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/power/supply/ltc2941-battery-gauge.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/power/supply/ltc2941-battery-gauge.c
+++ b/drivers/power/supply/ltc2941-battery-gauge.c
@@ -448,7 +448,7 @@ static int ltc294x_i2c_remove(struct i2c
 {
 	struct ltc294x_info *info = i2c_get_clientdata(client);
 
-	cancel_delayed_work(&info->work);
+	cancel_delayed_work_sync(&info->work);
 	power_supply_unregister(info->supply);
 	return 0;
 }


