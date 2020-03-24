Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0CB23191040
	for <lists+stable@lfdr.de>; Tue, 24 Mar 2020 14:30:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728816AbgCXN0m (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 Mar 2020 09:26:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:51714 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729372AbgCXN0l (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 24 Mar 2020 09:26:41 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BD245208CA;
        Tue, 24 Mar 2020 13:26:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1585056401;
        bh=d/nncTjMbeeP58TbJXgNgimGrQxhP15wf/xapbEf5xI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QiO6u3inqO8ztBt6KL8Mych0TmPqrJ//AcAG6XW9jM417SKlCe0MFXJ/J/IHMrVur
         PNUNIbbTr2ymvzY16NexmxPCBLQZE6YZiCQu1zzD0xu2KOL5WeQKBA8qXQ7YGtFM3k
         L8G49GmXXHtGdx4yBWYnYNukOvs95uOTpD3dNmk0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>
Subject: [PATCH 5.5 106/119] thunderbolt: Fix error code in tb_port_is_width_supported()
Date:   Tue, 24 Mar 2020 14:11:31 +0100
Message-Id: <20200324130818.500007743@linuxfoundation.org>
X-Mailer: git-send-email 2.25.2
In-Reply-To: <20200324130808.041360967@linuxfoundation.org>
References: <20200324130808.041360967@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dan Carpenter <dan.carpenter@oracle.com>

commit e9d0e7511fda92a6511904996dd0aa57b6d7687a upstream.

This function is type bool, and it's supposed to return true on success.
Unfortunately, this path takes negative error codes and casts them to
bool (true) so it's treated as success instead of failure.

Fixes: 91c0c12080d0 ("thunderbolt: Add support for lane bonding")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/thunderbolt/switch.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/thunderbolt/switch.c
+++ b/drivers/thunderbolt/switch.c
@@ -848,7 +848,7 @@ static bool tb_port_is_width_supported(s
 	ret = tb_port_read(port, &phy, TB_CFG_PORT,
 			   port->cap_phy + LANE_ADP_CS_0, 1);
 	if (ret)
-		return ret;
+		return false;
 
 	widths = (phy & LANE_ADP_CS_0_SUPPORTED_WIDTH_MASK) >>
 		LANE_ADP_CS_0_SUPPORTED_WIDTH_SHIFT;


