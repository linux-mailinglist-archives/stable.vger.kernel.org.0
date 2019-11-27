Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B88CD10BE2A
	for <lists+stable@lfdr.de>; Wed, 27 Nov 2019 22:34:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730424AbfK0UvD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Nov 2019 15:51:03 -0500
Received: from mail.kernel.org ([198.145.29.99]:37488 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729890AbfK0UvC (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 27 Nov 2019 15:51:02 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AF95E21852;
        Wed, 27 Nov 2019 20:51:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574887862;
        bh=cZPT0WojLQHBwL1aDDdvZwNQLqnruWSL0DxO3nlIPMU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Oon7ThSzxWxyY0Ii+IXOnUQrfDvbepXmVFYK6Pj2PhCXmhD60SAFLb0LWJFd0k5S8
         6kamdK6et2U0/SjBgO8l2tlzgCU5buWrnkBl76Pk+xL6Zw1rsbGSh8QwnC8GExFcK7
         VggkaB7TIFA/KZMa7uzAtSQN4l8BUJCk0WkhqjP0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dave Jiang <dave.jiang@intel.com>,
        Lucas Van <lucas.van@intel.com>, Jon Mason <jdmason@kudzu.us>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 122/211] ntb: intel: fix return value for ndev_vec_mask()
Date:   Wed, 27 Nov 2019 21:30:55 +0100
Message-Id: <20191127203105.690915268@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191127203049.431810767@linuxfoundation.org>
References: <20191127203049.431810767@linuxfoundation.org>
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
index 2557e2c05b90c..58068f1447bb2 100644
--- a/drivers/ntb/hw/intel/ntb_hw_intel.c
+++ b/drivers/ntb/hw/intel/ntb_hw_intel.c
@@ -348,7 +348,7 @@ static inline int ndev_db_clear_mask(struct intel_ntb_dev *ndev, u64 db_bits,
 	return 0;
 }
 
-static inline int ndev_vec_mask(struct intel_ntb_dev *ndev, int db_vector)
+static inline u64 ndev_vec_mask(struct intel_ntb_dev *ndev, int db_vector)
 {
 	u64 shift, mask;
 
-- 
2.20.1



