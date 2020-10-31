Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 309232A1631
	for <lists+stable@lfdr.de>; Sat, 31 Oct 2020 12:43:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727225AbgJaLmv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 31 Oct 2020 07:42:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:42590 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727042AbgJaLmu (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 31 Oct 2020 07:42:50 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D1A13205F4;
        Sat, 31 Oct 2020 11:42:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604144570;
        bh=d+MRtzD7Pk3lm4OSWL1yHP5iUYh2DznGTlcV/iBkqFk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=k5D+w+GZOEA3FxOtfGb0B6fRfwpeaIyZtPqv0wZx9M0Le8gM2+y72p83yVmBlO1OY
         JBqgpEQIBlKDtSFZdQDLaMwNqSbOlRofoxkvEpxoxfFmHsliWjdWVwP6LNJr+T4ovi
         n5KXCyZIi+edTCeMyw6w7Evc/kztUubTsz2z/YpY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ricky Wu <ricky_wu@realtek.com>,
        Chris Clayton <chris2553@googlemail.com>
Subject: [PATCH 5.8 69/70] misc: rtsx: do not setting OC_POWER_DOWN reg in rtsx_pci_init_ocp()
Date:   Sat, 31 Oct 2020 12:36:41 +0100
Message-Id: <20201031113502.789434092@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201031113459.481803250@linuxfoundation.org>
References: <20201031113459.481803250@linuxfoundation.org>
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
@@ -1172,10 +1172,6 @@ void rtsx_pci_init_ocp(struct rtsx_pcr *
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


