Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5B4A1F7B0D
	for <lists+stable@lfdr.de>; Mon, 11 Nov 2019 19:32:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727893AbfKKScK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Nov 2019 13:32:10 -0500
Received: from mail.kernel.org ([198.145.29.99]:49198 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727875AbfKKScK (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 11 Nov 2019 13:32:10 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 073BB2190F;
        Mon, 11 Nov 2019 18:32:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573497129;
        bh=gpJkM8tSzbzYkk30CQsNGrRPwbI6TaIqNSKozZigDIs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sJQWCUsz1GBw+yJW34MbT0nWX71koTOaGeTX0CIDrZFbXcur3pKdS81ok3dkPZWuT
         v6PPVd/RUpgRULsRgyS/+sm6evkaPsEu3wrb62TP0+Q1cn5geyyJBxcPPwGotCfzRQ
         wh1YF09Af7QTgoeRzJ0Ly1nxtlYI9a+rfBGhkfUI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Pan Bian <bianpan2016@163.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.9 05/65] NFC: fdp: fix incorrect free object
Date:   Mon, 11 Nov 2019 19:28:05 +0100
Message-Id: <20191111181335.317608971@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191111181331.917659011@linuxfoundation.org>
References: <20191111181331.917659011@linuxfoundation.org>
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
@@ -268,7 +268,7 @@ static void fdp_nci_i2c_read_device_prop
 						  *fw_vsc_cfg, len);
 
 		if (r) {
-			devm_kfree(dev, fw_vsc_cfg);
+			devm_kfree(dev, *fw_vsc_cfg);
 			goto vsc_read_err;
 		}
 	} else {


