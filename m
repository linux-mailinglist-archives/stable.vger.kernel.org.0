Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AB8E73CE426
	for <lists+stable@lfdr.de>; Mon, 19 Jul 2021 18:31:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242639AbhGSPmX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Jul 2021 11:42:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:34378 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232463AbhGSPgu (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Jul 2021 11:36:50 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7153461002;
        Mon, 19 Jul 2021 16:17:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626711450;
        bh=bkn6UMMR9BBtxrlL349w98XDe8KGbGvKtQmVWOdrbGw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yHL1TByqufjNIAmuHuxz+EJCzuruj6vn0LJA4K2C6wj78V7YDz28+US9e+aqyVPwT
         9a0hEBLYt/PQBd+z0U+M0mU27nrABGAS8ugTsexvD9NUAche3rSC+jDU61Td3AFIV9
         yuStAsCPB6gt5tR/YPSPBU/6j60ARjs1AQPRxXCI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Colin Ian King <colin.king@canonical.com>,
        Tong Zhang <ztong0001@gmail.com>
Subject: [PATCH 5.13 351/351] misc: alcor_pci: fix inverted branch condition
Date:   Mon, 19 Jul 2021 16:54:57 +0200
Message-Id: <20210719144956.691322243@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210719144944.537151528@linuxfoundation.org>
References: <20210719144944.537151528@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tong Zhang <ztong0001@gmail.com>

commit 281e468446994a7672733af2bf941f4110d4a895 upstream.

This patch fixes a trivial mistake that I made in the previous attempt
in fixing the null bridge issue. The branch condition is inverted and we
should call alcor_pci_find_cap_offset() only if bridge is not null.

Reported-by: Colin Ian King <colin.king@canonical.com>
Fixes: 3ce3e45cc333 ("misc: alcor_pci: fix null-ptr-deref when there is no PCI bridge")
Signed-off-by: Tong Zhang <ztong0001@gmail.com>
Link: https://lore.kernel.org/r/20210522043725.602179-1-ztong0001@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/misc/cardreader/alcor_pci.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/misc/cardreader/alcor_pci.c
+++ b/drivers/misc/cardreader/alcor_pci.c
@@ -144,7 +144,7 @@ static void alcor_pci_init_check_aspm(st
 	 * priv->parent_pdev will be NULL. In this case we don't check its
 	 * capability and disable ASPM completely.
 	 */
-	if (!priv->parent_pdev)
+	if (priv->parent_pdev)
 		priv->parent_cap_off = alcor_pci_find_cap_offset(priv,
 							 priv->parent_pdev);
 


