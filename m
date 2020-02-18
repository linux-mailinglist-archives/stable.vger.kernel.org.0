Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 51DB21631B1
	for <lists+stable@lfdr.de>; Tue, 18 Feb 2020 21:05:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728874AbgBRUCM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Feb 2020 15:02:12 -0500
Received: from mail.kernel.org ([198.145.29.99]:42350 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728706AbgBRUCL (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 18 Feb 2020 15:02:11 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 821E324670;
        Tue, 18 Feb 2020 20:02:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582056131;
        bh=j0PgUILrAPLlqw9FlakRmgTtyD9KYhlMmIoEr2+Azow=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pPtCiOxh5WLQ5Klqe3DXH8vXpMtUKYDj3h98XN6oxVWUTacqJ1tvMVV8STY6YMAk9
         c7+q7ALBgjfa7Ax02s3uMJDCVLrvG4w9O7p/JAfEQ7/A2ml93Cf97l4sjHCsCaT04q
         17OnmvG193qAqXkIZqHskE9ofYzErsqrZT1yj7RU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Colin Ian King <colin.king@canonical.com>,
        Asmaa Mnebhi <asmaa@mellanox.com>,
        Corey Minyard <cminyard@mvista.com>
Subject: [PATCH 5.5 47/80] drivers: ipmi: fix off-by-one bounds check that leads to a out-of-bounds write
Date:   Tue, 18 Feb 2020 20:55:08 +0100
Message-Id: <20200218190436.795711768@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200218190432.043414522@linuxfoundation.org>
References: <20200218190432.043414522@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

commit e0354d147e5889b5faa12e64fa38187aed39aad4 upstream.

The end of buffer check is off-by-one since the check is against
an index that is pre-incremented before a store to buf[]. Fix this
adjusting the bounds check appropriately.

Addresses-Coverity: ("Out-of-bounds write")
Fixes: 51bd6f291583 ("Add support for IPMB driver")
Signed-off-by: Colin Ian King <colin.king@canonical.com>
Message-Id: <20200114144031.358003-1-colin.king@canonical.com>
Reviewed-by: Asmaa Mnebhi <asmaa@mellanox.com>
Signed-off-by: Corey Minyard <cminyard@mvista.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/char/ipmi/ipmb_dev_int.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/char/ipmi/ipmb_dev_int.c
+++ b/drivers/char/ipmi/ipmb_dev_int.c
@@ -253,7 +253,7 @@ static int ipmb_slave_cb(struct i2c_clie
 		break;
 
 	case I2C_SLAVE_WRITE_RECEIVED:
-		if (ipmb_dev->msg_idx >= sizeof(struct ipmb_msg))
+		if (ipmb_dev->msg_idx >= sizeof(struct ipmb_msg) - 1)
 			break;
 
 		buf[++ipmb_dev->msg_idx] = *val;


