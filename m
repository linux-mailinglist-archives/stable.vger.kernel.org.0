Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 17FDE328BA1
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 19:40:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240247AbhCASiV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 13:38:21 -0500
Received: from mail.kernel.org ([198.145.29.99]:43170 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235419AbhCAS3I (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 13:29:08 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0E3876525C;
        Mon,  1 Mar 2021 17:28:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614619713;
        bh=AeM1sUaPQEBLlCCsPmlL8E90/x6jk0T8/zUba93pCt0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qqTM0721XdbjIuzFOvka1YOkN1X+UJoIzSecQqdotd5WWslNoy788sfwh+McQUreD
         gl56UOASWTBrJVxlPpdZq0Wv96Z4L0HzQPba5EzI5a3c1WU/CFMqG2Nw6up2Wlj+mi
         Emop3ozuU+PZAZ6B5ARIShJOw+fLqP4ha5PWhtaU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ricky Wu <ricky_wu@realtek.com>
Subject: [PATCH 5.10 553/663] misc: rtsx: init of rts522a add OCP power off when no card is present
Date:   Mon,  1 Mar 2021 17:13:21 +0100
Message-Id: <20210301161209.231497197@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161141.760350206@linuxfoundation.org>
References: <20210301161141.760350206@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ricky Wu <ricky_wu@realtek.com>

commit 920fd8a70619074eac7687352c8f1c6f3c2a64a5 upstream.

Power down OCP for power consumption
when no SD/MMC card is present

Cc: stable@vger.kernel.org
Signed-off-by: Ricky Wu <ricky_wu@realtek.com>
Link: https://lore.kernel.org/r/20210204083115.9471-1-ricky_wu@realtek.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/misc/cardreader/rts5227.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/drivers/misc/cardreader/rts5227.c
+++ b/drivers/misc/cardreader/rts5227.c
@@ -398,6 +398,11 @@ static int rts522a_extra_init_hw(struct
 {
 	rts5227_extra_init_hw(pcr);
 
+	/* Power down OCP for power consumption */
+	if (!pcr->card_exist)
+		rtsx_pci_write_register(pcr, FPDCTL, OC_POWER_DOWN,
+				OC_POWER_DOWN);
+
 	rtsx_pci_write_register(pcr, FUNC_FORCE_CTL, FUNC_FORCE_UPME_XMT_DBG,
 		FUNC_FORCE_UPME_XMT_DBG);
 	rtsx_pci_write_register(pcr, PCLK_CTL, 0x04, 0x04);


