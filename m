Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4C14630062B
	for <lists+stable@lfdr.de>; Fri, 22 Jan 2021 15:54:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728433AbhAVOyN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 22 Jan 2021 09:54:13 -0500
Received: from mail.kernel.org ([198.145.29.99]:40024 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728332AbhAVOXo (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 22 Jan 2021 09:23:44 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9130623B8A;
        Fri, 22 Jan 2021 14:18:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1611325089;
        bh=eTUjOqrazmNR+sYhqLigH/tF5ngdkSBGNgxIO1tUKn4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fAnQUd2Cwe2npgEJvjuwZQtisJZo7rayY6sCmvxB//AaiJy0wqzmTZQIVVw1SDH3L
         yJIS6uw50ndhX+5bKjYRx3gDbZBLYPSQRAwz5P59tFPGgstcsv+T+pkwMvCdMIgAzg
         HMNbDKB+eeL8jTy+Oj47RQV/FYY4GYB47IzyX8zM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Alex Elder <elder@kernel.org>,
        Stephan Gerhold <stephan@gerhold.net>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.10 11/43] net: ipa: modem: add missing SET_NETDEV_DEV() for proper sysfs links
Date:   Fri, 22 Jan 2021 15:12:27 +0100
Message-Id: <20210122135736.105072018@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210122135735.652681690@linuxfoundation.org>
References: <20210122135735.652681690@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Stephan Gerhold <stephan@gerhold.net>

[ Upstream commit afba9dc1f3a5390475006061c0bdc5ad4915878e ]

At the moment it is quite hard to identify the network interface
provided by IPA in userspace components: The network interface is
created as virtual device, without any link to the IPA device.
The interface name ("rmnet_ipa%d") is the only indication that the
network interface belongs to IPA, but this is not very reliable.

Add SET_NETDEV_DEV() to associate the network interface with the
IPA parent device. This allows userspace services like ModemManager
to properly identify that this network interface is provided by IPA
and belongs to the modem.

Cc: Alex Elder <elder@kernel.org>
Fixes: a646d6ec9098 ("soc: qcom: ipa: modem and microcontroller")
Signed-off-by: Stephan Gerhold <stephan@gerhold.net>
Link: https://lore.kernel.org/r/20210106100755.56800-1-stephan@gerhold.net
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ipa/ipa_modem.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/net/ipa/ipa_modem.c
+++ b/drivers/net/ipa/ipa_modem.c
@@ -216,6 +216,7 @@ int ipa_modem_start(struct ipa *ipa)
 	ipa->name_map[IPA_ENDPOINT_AP_MODEM_TX]->netdev = netdev;
 	ipa->name_map[IPA_ENDPOINT_AP_MODEM_RX]->netdev = netdev;
 
+	SET_NETDEV_DEV(netdev, &ipa->pdev->dev);
 	priv = netdev_priv(netdev);
 	priv->ipa = ipa;
 


