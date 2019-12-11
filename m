Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6573211B52B
	for <lists+stable@lfdr.de>; Wed, 11 Dec 2019 16:52:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731926AbfLKPUc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 11 Dec 2019 10:20:32 -0500
Received: from mail.kernel.org ([198.145.29.99]:49894 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732172AbfLKPUc (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 11 Dec 2019 10:20:32 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EC9A72073D;
        Wed, 11 Dec 2019 15:20:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576077631;
        bh=6S/05kR+XRaCCsjFmPqtTFzZMon5uUNj8h1YbodIfFY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hsQrykMAdfHp4Tlc+Zm3uECOnxkkcQkhJSte9zlzURzSSPgOuCQ3UQsan0s6zMvi3
         UpkxbKOjZe0epBhBsErXI9b2i2SbwwLJIoWyeqx0BtKnTMIfIYU8R4C9uDUykvZtus
         m2GAoExbLwDo9yUX38zsWdZ1VK/2l2HWkk18kEQU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dave Ertman <david.m.ertman@intel.com>,
        Anirudh Venkataramanan <anirudh.venkataramanan@intel.com>,
        Andrew Bowers <andrewx.bowers@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 073/243] ice: Fix return value from NAPI poll
Date:   Wed, 11 Dec 2019 16:03:55 +0100
Message-Id: <20191211150344.029162304@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191211150339.185439726@linuxfoundation.org>
References: <20191211150339.185439726@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dave Ertman <david.m.ertman@intel.com>

[ Upstream commit e0c9fd9b77a7334032ec407d9e14d7c3cac1ac4f ]

ice_napi_poll is hard-coded to return zero when it's done. It should
instead return the work done (if any work was done). The only time it
should return zero is if an interrupt or poll is handled and no work
is performed. So change the return value to be the minimum of work
done or budget-1.

Signed-off-by: Dave Ertman <david.m.ertman@intel.com>
Signed-off-by: Anirudh Venkataramanan <anirudh.venkataramanan@intel.com>
Tested-by: Andrew Bowers <andrewx.bowers@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/ice/ice_txrx.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_txrx.c b/drivers/net/ethernet/intel/ice/ice_txrx.c
index 0c95c8f83432c..1d84fedf1f649 100644
--- a/drivers/net/ethernet/intel/ice/ice_txrx.c
+++ b/drivers/net/ethernet/intel/ice/ice_txrx.c
@@ -1106,7 +1106,8 @@ int ice_napi_poll(struct napi_struct *napi, int budget)
 	napi_complete_done(napi, work_done);
 	if (test_bit(ICE_FLAG_MSIX_ENA, pf->flags))
 		ice_irq_dynamic_ena(&vsi->back->hw, vsi, q_vector);
-	return 0;
+
+	return min(work_done, budget - 1);
 }
 
 /* helper function for building cmd/type/offset */
-- 
2.20.1



