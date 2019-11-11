Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 00D1FF7CAF
	for <lists+stable@lfdr.de>; Mon, 11 Nov 2019 19:49:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729885AbfKKSsl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Nov 2019 13:48:41 -0500
Received: from mail.kernel.org ([198.145.29.99]:41796 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730275AbfKKSsl (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 11 Nov 2019 13:48:41 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7903320674;
        Mon, 11 Nov 2019 18:48:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573498121;
        bh=TeLXX2Ib/8rhdeMgFck2M1wdriPcblgMQzdqlKbJ9fI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KAwn3+gJIVFDcmE755EUCT1j+vTmLminxZ35luES4Q0UAtFs3QQUVmwKyIASGU5cW
         KJmz2HzLPw2gOwfkTzcxpJBCUw+Ihbz6P3GYe5WTh8lEN8grI0CXsjlbv9MPRZPZmE
         2jS1km3jki3F1CQwgmJWEYPw/fcLx4WA4lrv4794=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Pan Bian <bianpan2016@163.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.3 009/193] NFC: fdp: fix incorrect free object
Date:   Mon, 11 Nov 2019 19:26:31 +0100
Message-Id: <20191111181500.602757108@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191111181459.850623879@linuxfoundation.org>
References: <20191111181459.850623879@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pan Bian <bianpan2016@163.com>

[ Upstream commit 517ce4e93368938b204451285e53014549804868 ]

The address of fw_vsc_cfg is on stack. Releasing it with devm_kfree() is
incorrect, which may result in a system crash or other security impacts.
The expected object to free is *fw_vsc_cfg.

Signed-off-by: Pan Bian <bianpan2016@163.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/nfc/fdp/i2c.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/nfc/fdp/i2c.c
+++ b/drivers/nfc/fdp/i2c.c
@@ -259,7 +259,7 @@ static void fdp_nci_i2c_read_device_prop
 						  *fw_vsc_cfg, len);
 
 		if (r) {
-			devm_kfree(dev, fw_vsc_cfg);
+			devm_kfree(dev, *fw_vsc_cfg);
 			goto vsc_read_err;
 		}
 	} else {


