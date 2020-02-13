Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 35BFF15C42D
	for <lists+stable@lfdr.de>; Thu, 13 Feb 2020 16:53:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729017AbgBMP1P (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 Feb 2020 10:27:15 -0500
Received: from mail.kernel.org ([198.145.29.99]:49450 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728162AbgBMP1O (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 13 Feb 2020 10:27:14 -0500
Received: from localhost (unknown [104.132.1.104])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7777E2168B;
        Thu, 13 Feb 2020 15:27:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581607633;
        bh=zV/QW4fl9Cuxy5M6xglKsBrt77kyVjIW5pP/yHdZHpA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cDurxpJ5ag4wQ4eby0WNsQyRWScChg8yGDzfT2Q4RmIAr1iLaTcQ59znPtoTX9Tp+
         QYjf+5CYnBQ47l4DN+xsimfZ7Xmje+6xB48eofl1+8afRZyHMwGltf9Z4iKPmqM0xM
         1jCtu43BNfHCqVD1QdaCyZnQF5/WPXvjf5bO1OI0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Paul Kocialkowski <paul.kocialkowski@bootlin.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>
Subject: [PATCH 5.4 35/96] rtc: hym8563: Return -EINVAL if the time is known to be invalid
Date:   Thu, 13 Feb 2020 07:20:42 -0800
Message-Id: <20200213151852.676420303@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200213151839.156309910@linuxfoundation.org>
References: <20200213151839.156309910@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Paul Kocialkowski <paul.kocialkowski@bootlin.com>

commit f236a2a2ebabad0848ad0995af7ad1dc7029e895 upstream.

The current code returns -EPERM when the voltage loss bit is set.
Since the bit indicates that the time value is not valid, return
-EINVAL instead, which is the appropriate error code for this
situation.

Fixes: dcaf03849352 ("rtc: add hym8563 rtc-driver")
Signed-off-by: Paul Kocialkowski <paul.kocialkowski@bootlin.com>
Link: https://lore.kernel.org/r/20191212153111.966923-1-paul.kocialkowski@bootlin.com
Signed-off-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/rtc/rtc-hym8563.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/rtc/rtc-hym8563.c
+++ b/drivers/rtc/rtc-hym8563.c
@@ -97,7 +97,7 @@ static int hym8563_rtc_read_time(struct
 
 	if (!hym8563->valid) {
 		dev_warn(&client->dev, "no valid clock/calendar values available\n");
-		return -EPERM;
+		return -EINVAL;
 	}
 
 	ret = i2c_smbus_read_i2c_block_data(client, HYM8563_SEC, 7, buf);


