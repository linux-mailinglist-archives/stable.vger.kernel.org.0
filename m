Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E52D7411B37
	for <lists+stable@lfdr.de>; Mon, 20 Sep 2021 18:55:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238015AbhITQ4i (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Sep 2021 12:56:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:38940 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S245613AbhITQyh (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Sep 2021 12:54:37 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 92C0E61372;
        Mon, 20 Sep 2021 16:50:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632156637;
        bh=RQw5DQ89xXCXSo5Id/Pm7fMDv0gBzher2VlGUzcwsiw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ks7XvBh1T8DtxtSkagQ9MtyIGHPBOLW/io2AZmqC8OAXd+PeCf7CtUo84lCSiHeju
         NtIGtg7gclVJzEllaWVctsZJ8kSKLYzqp1PU6ddXf8MSZF4bxWzlYTXZpW0Ojcr6Hf
         CVJ+zS9GQpaYU/d+O5Cv/+aqSqYx2kAGhEItKFjA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Javier Martinez Canillas <javier@osg.samsung.com>
Subject: [PATCH 4.9 017/175] usb: phy: isp1301: Fix build warning when CONFIG_OF is disabled
Date:   Mon, 20 Sep 2021 18:41:06 +0200
Message-Id: <20210920163918.632790429@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210920163918.068823680@linuxfoundation.org>
References: <20210920163918.068823680@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Javier Martinez Canillas <javier@osg.samsung.com>

commit a7f12a21f6b32bdd8d76d3af81eef9e72ce41ec0 upstream.

Commit fd567653bdb9 ("usb: phy: isp1301: Add OF device ID table")
added an OF device ID table, but used the of_match_ptr() macro
that will lead to a build warning if CONFIG_OF symbol is disabled:

drivers/usb/phy//phy-isp1301.c:36:34: warning: ‘isp1301_of_match’ defined but not used [-Wunused-const-variable=]
 static const struct of_device_id isp1301_of_match[] = {
                                  ^~~~~~~~~~~~~~~~

Fixes: fd567653bdb9 ("usb: phy: isp1301: Add OF device ID table")
Reported-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Javier Martinez Canillas <javier@osg.samsung.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/phy/phy-isp1301.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/usb/phy/phy-isp1301.c
+++ b/drivers/usb/phy/phy-isp1301.c
@@ -136,7 +136,7 @@ static int isp1301_remove(struct i2c_cli
 static struct i2c_driver isp1301_driver = {
 	.driver = {
 		.name = DRV_NAME,
-		.of_match_table = of_match_ptr(isp1301_of_match),
+		.of_match_table = isp1301_of_match,
 	},
 	.probe = isp1301_probe,
 	.remove = isp1301_remove,


