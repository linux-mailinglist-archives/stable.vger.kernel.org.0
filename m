Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BCFC610B863
	for <lists+stable@lfdr.de>; Wed, 27 Nov 2019 21:43:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727823AbfK0Um4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Nov 2019 15:42:56 -0500
Received: from mail.kernel.org ([198.145.29.99]:49502 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729356AbfK0Umr (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 27 Nov 2019 15:42:47 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5E40321780;
        Wed, 27 Nov 2019 20:42:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574887366;
        bh=OqVoey58BstSGCzT7Cy3FNTTDtc2UNvTtORa3PHd4co=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OquqfNuho8efGL1QWwSehTwkFA1llTeDwYbK4821pMaIY+sBerdOrWelpB2ubPQNN
         Fo7sGzhR6s02l03Pg4l7eaUgS4s4GMW8uuhcqfjYRGUW4YeO99TaiRynBFjZ6vWXjG
         Z3iGQtRIJw7fZYHrSzG3R8rK/OtBfWD1ycrVEPes=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dave Jiang <dave.jiang@intel.com>,
        Lucas Van <lucas.van@intel.com>, Jon Mason <jdmason@kudzu.us>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 083/151] ntb: intel: fix return value for ndev_vec_mask()
Date:   Wed, 27 Nov 2019 21:31:06 +0100
Message-Id: <20191127203036.218714867@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191127203000.773542911@linuxfoundation.org>
References: <20191127203000.773542911@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dave Jiang <dave.jiang@intel.com>

[ Upstream commit 7756e2b5d68c36e170a111dceea22f7365f83256 ]

ndev_vec_mask() should be returning u64 mask value instead of int.
Otherwise the mask value returned can be incorrect for larger
vectors.

Fixes: e26a5843f7f5 ("NTB: Split ntb_hw_intel and ntb_transport drivers")

Signed-off-by: Dave Jiang <dave.jiang@intel.com>
Tested-by: Lucas Van <lucas.van@intel.com>
Signed-off-by: Jon Mason <jdmason@kudzu.us>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/ntb/hw/intel/ntb_hw_intel.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/ntb/hw/intel/ntb_hw_intel.c b/drivers/ntb/hw/intel/ntb_hw_intel.c
index 7310a261c858b..e175cbeba266f 100644
--- a/drivers/ntb/hw/intel/ntb_hw_intel.c
+++ b/drivers/ntb/hw/intel/ntb_hw_intel.c
@@ -330,7 +330,7 @@ static inline int ndev_db_clear_mask(struct intel_ntb_dev *ndev, u64 db_bits,
 	return 0;
 }
 
-static inline int ndev_vec_mask(struct intel_ntb_dev *ndev, int db_vector)
+static inline u64 ndev_vec_mask(struct intel_ntb_dev *ndev, int db_vector)
 {
 	u64 shift, mask;
 
-- 
2.20.1



