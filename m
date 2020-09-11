Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4313B26667E
	for <lists+stable@lfdr.de>; Fri, 11 Sep 2020 19:28:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726095AbgIKR2z (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 11 Sep 2020 13:28:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:49246 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726107AbgIKM6C (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 11 Sep 2020 08:58:02 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C5D3322210;
        Fri, 11 Sep 2020 12:55:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599828938;
        bh=ug9mE9ruhklk8XJEVwovo3PR5kkUnVDdg0W9JMDkpRU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qJ3Nkqyvjw5pTGyj8B98Um0krd4wbShNYKwQrzCXIlXnSj1bdBpu6Aq38K35Jx09r
         laoGAD7rVI5cLZxCbH4084vRsY/hKgQEqn3fMVyBU/aXcCaPNf5+poWPuCl+lbyOOx
         WnTBlqwKTroUksx1obKsLDdlHaKz6xmvlpjAcWLI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Michael Chan <michael.chan@broadcom.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.4 58/62] bnxt_en: Failure to update PHY is not fatal condition.
Date:   Fri, 11 Sep 2020 14:46:41 +0200
Message-Id: <20200911122505.281166065@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200911122502.395450276@linuxfoundation.org>
References: <20200911122502.395450276@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Michael Chan <mchan@broadcom.com>

commit ba41d46fe03223279054e58d570069fdc62fb768 upstream.

If we fail to update the PHY, we should print a warning and continue.
The current code to exit is buggy as it has not freed up the NIC
resources yet.

Signed-off-by: Michael Chan <michael.chan@broadcom.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/ethernet/broadcom/bnxt/bnxt.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -4623,7 +4623,7 @@ static int __bnxt_open_nic(struct bnxt *
 	if (link_re_init) {
 		rc = bnxt_update_phy_setting(bp);
 		if (rc)
-			goto open_err;
+			netdev_warn(bp->dev, "failed to update phy settings\n");
 	}
 
 	if (irq_re_init) {


