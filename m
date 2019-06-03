Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A676832C5E
	for <lists+stable@lfdr.de>; Mon,  3 Jun 2019 11:17:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727248AbfFCJQt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Jun 2019 05:16:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:57468 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728048AbfFCJMC (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 3 Jun 2019 05:12:02 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8BD4327E5C;
        Mon,  3 Jun 2019 09:12:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559553122;
        bh=3uhOgWtwXAoAVnDkN0BtdVnEqdI/wKvo3nohKpjXZz4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jjMFlVrvTVcwCDLkjtz4OV0HUb2Cu1kzRktr6+3ANjoRKLLLTEcO2zuTLTNl+sBCq
         TBE5uao9KEwoxiO98+uSn1khgoNiXK3g0HruC0nQnJim5AXuc2k/ISXCpEMSb2mMHI
         72ygt5sDit75BqlnOL95BZFuniXxsuLXVYzh0hfg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Alex Kushnarov <alexanderk@mellanox.com>,
        Jiri Pirko <jiri@mellanox.com>,
        Ido Schimmel <idosch@mellanox.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.0 09/36] mlxsw: spectrum_acl: Avoid warning after identical rules insertion
Date:   Mon,  3 Jun 2019 11:08:57 +0200
Message-Id: <20190603090521.569034163@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190603090520.998342694@linuxfoundation.org>
References: <20190603090520.998342694@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jiri Pirko <jiri@mellanox.com>

[ Upstream commit ef74422020aa8c224b00a927e3e47faac4d8fae3 ]

When identical rules are inserted, the latter one goes to C-TCAM. For
that, a second eRP with the same mask is created. These 2 eRPs by the
nature cannot be merged and also one cannot be parent of another.
Teach mlxsw_sp_acl_erp_delta_fill() about this possibility and handle it
gracefully.

Reported-by: Alex Kushnarov <alexanderk@mellanox.com>
Fixes: c22291f7cf45 ("mlxsw: spectrum: acl: Implement delta for ERP")
Signed-off-by: Jiri Pirko <jiri@mellanox.com>
Signed-off-by: Ido Schimmel <idosch@mellanox.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/mellanox/mlxsw/spectrum_acl_erp.c |   11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_acl_erp.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_acl_erp.c
@@ -1169,13 +1169,12 @@ mlxsw_sp_acl_erp_delta_fill(const struct
 			return -EINVAL;
 	}
 	if (si == -1) {
-		/* The masks are the same, this cannot happen.
-		 * That means the caller is broken.
+		/* The masks are the same, this can happen in case eRPs with
+		 * the same mask were created in both A-TCAM and C-TCAM.
+		 * The only possible condition under which this can happen
+		 * is identical rule insertion. Delta is not possible here.
 		 */
-		WARN_ON(1);
-		*delta_start = 0;
-		*delta_mask = 0;
-		return 0;
+		return -EINVAL;
 	}
 	pmask = (unsigned char) parent_key->mask[__MASK_IDX(si)];
 	mask = (unsigned char) key->mask[__MASK_IDX(si)];


