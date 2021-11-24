Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AE38945C7DF
	for <lists+stable@lfdr.de>; Wed, 24 Nov 2021 15:44:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348954AbhKXOrZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Nov 2021 09:47:25 -0500
Received: from mail.kernel.org ([198.145.29.99]:49480 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1349328AbhKXOq5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Nov 2021 09:46:57 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0502163362;
        Wed, 24 Nov 2021 13:06:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637759206;
        bh=YE8EY1GlhZ/XSHKCNt5kOW9k9RphWGLlY3T93Jdx3BY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rT8a5oS2bBgJmQMal0ljTr0F9uuF63BEEPAa/Uzk4yECXhWJzyglVdQHQ3oOtsbnN
         UvVrBd4q6FY2TxZREWsKLRLh2QGZ7guwYifCz5CB/ED6HjFQoKop34YbPu/ResacQd
         phfqScIj9EP2AslecA/V4faGorRo+2Jd/r97m234=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Grzegorz Szczurek <grzegorzx.szczurek@intel.com>,
        Mateusz Palczewski <mateusz.palczewski@intel.com>,
        Dave Switzer <david.switzer@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 167/279] i40e: Fix display error code in dmesg
Date:   Wed, 24 Nov 2021 12:57:34 +0100
Message-Id: <20211124115724.521327930@linuxfoundation.org>
X-Mailer: git-send-email 2.34.0
In-Reply-To: <20211124115718.776172708@linuxfoundation.org>
References: <20211124115718.776172708@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Grzegorz Szczurek <grzegorzx.szczurek@intel.com>

[ Upstream commit 5aff430d4e33a0b48a6b3d5beb06f79da23f9916 ]

Fix misleading display error in dmesg if tc filter return fail.
Only i40e status error code should be converted to string, not linux
error code. Otherwise, we return false information about the error.

Fixes: 2f4b411a3d67 ("i40e: Enable cloud filters via tc-flower")
Signed-off-by: Grzegorz Szczurek <grzegorzx.szczurek@intel.com>
Signed-off-by: Mateusz Palczewski <mateusz.palczewski@intel.com>
Tested-by: Dave Switzer <david.switzer@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/i40e/i40e_main.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/intel/i40e/i40e_main.c b/drivers/net/ethernet/intel/i40e/i40e_main.c
index 83413999902e5..76d0b809d1340 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_main.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_main.c
@@ -8531,9 +8531,8 @@ static int i40e_configure_clsflower(struct i40e_vsi *vsi,
 		err = i40e_add_del_cloud_filter(vsi, filter, true);
 
 	if (err) {
-		dev_err(&pf->pdev->dev,
-			"Failed to add cloud filter, err %s\n",
-			i40e_stat_str(&pf->hw, err));
+		dev_err(&pf->pdev->dev, "Failed to add cloud filter, err %d\n",
+			err);
 		goto err;
 	}
 
-- 
2.33.0



