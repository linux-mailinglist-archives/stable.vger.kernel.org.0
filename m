Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 80D463CDFF4
	for <lists+stable@lfdr.de>; Mon, 19 Jul 2021 17:55:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345087AbhGSPMt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Jul 2021 11:12:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:48644 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1343862AbhGSPLR (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Jul 2021 11:11:17 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1A53B61166;
        Mon, 19 Jul 2021 15:51:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626709916;
        bh=QBt2fCja8wWSrw/yeEU+bxMvfIIKOgsqE0yoYo6aaLA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IPoTXI1jYSzsWDNplG5n9MFiuKa6GzhGaAhaAI4dFP/3naG71Swbjq80yDpYTfqfI
         8a1N7U30qHpt+ya5HvU48jRsHbhnAXze2Q1xHnHgk9uH2iRFVwmayh+gXR5z/aVNx4
         LrXiBcsRwwYXeWbOgx+atjOJBOfzEb0GUnC6y+IQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Colin Ian King <colin.king@canonical.com>,
        Tong Zhang <ztong0001@gmail.com>
Subject: [PATCH 5.4 149/149] misc: alcor_pci: fix inverted branch condition
Date:   Mon, 19 Jul 2021 16:54:17 +0200
Message-Id: <20210719144936.590080578@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210719144901.370365147@linuxfoundation.org>
References: <20210719144901.370365147@linuxfoundation.org>
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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/misc/cardreader/alcor_pci.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/misc/cardreader/alcor_pci.c
+++ b/drivers/misc/cardreader/alcor_pci.c
@@ -138,7 +138,7 @@ static void alcor_pci_init_check_aspm(st
 	 * priv->parent_pdev will be NULL. In this case we don't check its
 	 * capability and disable ASPM completely.
 	 */
-	if (!priv->parent_pdev)
+	if (priv->parent_pdev)
 		priv->parent_cap_off = alcor_pci_find_cap_offset(priv,
 							 priv->parent_pdev);
 


