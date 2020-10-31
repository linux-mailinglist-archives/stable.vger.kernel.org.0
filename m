Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AFB052A167F
	for <lists+stable@lfdr.de>; Sat, 31 Oct 2020 12:46:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727427AbgJaLqO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 31 Oct 2020 07:46:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:47374 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727931AbgJaLqH (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 31 Oct 2020 07:46:07 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1850720731;
        Sat, 31 Oct 2020 11:46:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604144766;
        bh=HJNldU3R+7CQqPIEdNyGqla49fjXz32lNs4Xs+FJwFE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JQoXZx3nB8NRRnSJjyEt5eLOn2IDW0QoecAHoyjW0bypIupWfm78hHyaXv2cLTe7J
         Kg1XUnZ/GZ7LXOQ/FehIrxVQiXWOyaub4npD/2NaqdZDQB7bGbVyKkf8h8lwJuDRVl
         4rYEft0PUVjOHbV3aeiuziNc4GkSfbdHH7PRF9VE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ricky Wu <ricky_wu@realtek.com>,
        Chris Clayton <chris2553@googlemail.com>
Subject: [PATCH 5.9 73/74] misc: rtsx: do not setting OC_POWER_DOWN reg in rtsx_pci_init_ocp()
Date:   Sat, 31 Oct 2020 12:36:55 +0100
Message-Id: <20201031113503.533477978@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201031113500.031279088@linuxfoundation.org>
References: <20201031113500.031279088@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ricky Wu <ricky_wu@realtek.com>

commit 551b6729578a8981c46af964c10bf7d5d9ddca83 upstream.

this power saving action in rtsx_pci_init_ocp() cause INTEL-NUC6 platform
missing card reader

Signed-off-by: Ricky Wu <ricky_wu@realtek.com>
Link: https://lore.kernel.org/r/20200824030006.30033-1-ricky_wu@realtek.com
Cc: Chris Clayton <chris2553@googlemail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/misc/cardreader/rtsx_pcr.c |    4 ----
 1 file changed, 4 deletions(-)

--- a/drivers/misc/cardreader/rtsx_pcr.c
+++ b/drivers/misc/cardreader/rtsx_pcr.c
@@ -1155,10 +1155,6 @@ void rtsx_pci_init_ocp(struct rtsx_pcr *
 			rtsx_pci_write_register(pcr, REG_OCPGLITCH,
 				SD_OCP_GLITCH_MASK, pcr->hw_param.ocp_glitch);
 			rtsx_pci_enable_ocp(pcr);
-		} else {
-			/* OC power down */
-			rtsx_pci_write_register(pcr, FPDCTL, OC_POWER_DOWN,
-				OC_POWER_DOWN);
 		}
 	}
 }


