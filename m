Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4A19313FDC9
	for <lists+stable@lfdr.de>; Fri, 17 Jan 2020 00:30:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391257AbgAPX3T (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Jan 2020 18:29:19 -0500
Received: from mail.kernel.org ([198.145.29.99]:34736 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389191AbgAPX3P (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Jan 2020 18:29:15 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2B89220684;
        Thu, 16 Jan 2020 23:29:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579217354;
        bh=86Pm6fYfDDizdEsbuHEgjTe6dYvfZcvkBZXO+WecKPA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=T8p/QZ7gVGatBoREejvh2w3Ylnbx/sUWcUEuhfiUi5hjh7/QEqZo9B1aehmrkRg5p
         YL+9MnGz/ViZPMo8K7b9wOkByJg6lp8OULoxTwbsYH3eGLQjRh5nQoh2lUDCzrxts6
         wnGAbQoAUMp9K8wLPQRhuM6FdfpaaBkbfY9o93n8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Colin Ian King <colin.king@canonical.com>,
        Tony Lindgren <tony@atomide.com>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH 4.19 48/84] pinctl: ti: iodelay: fix error checking on pinctrl_count_index_with_args call
Date:   Fri, 17 Jan 2020 00:18:22 +0100
Message-Id: <20200116231719.456216729@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200116231713.087649517@linuxfoundation.org>
References: <20200116231713.087649517@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

commit 5ff8aca906f3a7a7db79fad92f2a4401107ef50d upstream.

The call to pinctrl_count_index_with_args checks for a -EINVAL return
however this function calls pinctrl_get_list_and_count and this can
return -ENOENT. Rather than check for a specific error, fix this by
checking for any error return to catch the -ENOENT case.

Addresses-Coverity: ("Improper use of negative")
Fixes: 003910ebc83b ("pinctrl: Introduce TI IOdelay configuration driver")
Signed-off-by: Colin Ian King <colin.king@canonical.com>
Link: https://lore.kernel.org/r/20190920122030.14340-1-colin.king@canonical.com
Acked-by: Tony Lindgren <tony@atomide.com>
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/pinctrl/ti/pinctrl-ti-iodelay.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/pinctrl/ti/pinctrl-ti-iodelay.c
+++ b/drivers/pinctrl/ti/pinctrl-ti-iodelay.c
@@ -496,7 +496,7 @@ static int ti_iodelay_dt_node_to_map(str
 		return -EINVAL;
 
 	rows = pinctrl_count_index_with_args(np, name);
-	if (rows == -EINVAL)
+	if (rows < 0)
 		return rows;
 
 	*map = devm_kzalloc(iod->dev, sizeof(**map), GFP_KERNEL);


