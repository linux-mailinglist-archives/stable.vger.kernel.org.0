Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1CE98177EDD
	for <lists+stable@lfdr.de>; Tue,  3 Mar 2020 19:56:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731348AbgCCRr2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Mar 2020 12:47:28 -0500
Received: from mail.kernel.org ([198.145.29.99]:54142 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731315AbgCCRrQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Mar 2020 12:47:16 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CEBE820870;
        Tue,  3 Mar 2020 17:47:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583257636;
        bh=wJ2KCp01KlNHuZcLWsvwY7KPtFEgX8jQ/ItsVEsLmVc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FTT/y2UQdiGwC9YOCeu2Ug4AmQIL4B8yzFUaT20N7fFSZFHKe+9zuE7v9giUNqMOD
         xZ8faux3uXQjx4/XlI2neIxCvjQRBPDx88CyYEWmsuVumeg754v4di/JWnrf8UgZ7M
         Y44Wsu9+V5j2NnEngx2YJbE4HeKZjZfIFUGTCMak=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ben Shelton <benjamin.h.shelton@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Andrew Bowers <andrewx.bowers@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.5 069/176] ice: Use correct netif error function
Date:   Tue,  3 Mar 2020 18:42:13 +0100
Message-Id: <20200303174312.632986231@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200303174304.593872177@linuxfoundation.org>
References: <20200303174304.593872177@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ben Shelton <benjamin.h.shelton@intel.com>

[ Upstream commit 1d8bd9927234081db15a1d42a7f99505244e3703 ]

Use the correct netif_msg_[tx,rx]_error() function to determine whether to
print the MDD event type.

Signed-off-by: Ben Shelton <benjamin.h.shelton@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Tested-by: Andrew Bowers <andrewx.bowers@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/ice/ice_main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_main.c b/drivers/net/ethernet/intel/ice/ice_main.c
index c9b35b202639d..7f71f06fa819c 100644
--- a/drivers/net/ethernet/intel/ice/ice_main.c
+++ b/drivers/net/ethernet/intel/ice/ice_main.c
@@ -1235,7 +1235,7 @@ static void ice_handle_mdd_event(struct ice_pf *pf)
 		u16 queue = ((reg & GL_MDET_TX_TCLAN_QNUM_M) >>
 				GL_MDET_TX_TCLAN_QNUM_S);
 
-		if (netif_msg_rx_err(pf))
+		if (netif_msg_tx_err(pf))
 			dev_info(dev, "Malicious Driver Detection event %d on TX queue %d PF# %d VF# %d\n",
 				 event, queue, pf_num, vf_num);
 		wr32(hw, GL_MDET_TX_TCLAN, 0xffffffff);
-- 
2.20.1



