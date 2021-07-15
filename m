Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 520123CA5EE
	for <lists+stable@lfdr.de>; Thu, 15 Jul 2021 20:42:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236777AbhGOSpX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 15 Jul 2021 14:45:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:45802 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235738AbhGOSpP (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 15 Jul 2021 14:45:15 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 82DED613D1;
        Thu, 15 Jul 2021 18:42:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626374542;
        bh=THJPcmkfH78OpzqAj5LeSvs8Vk5FqCJ8OEAfz0IuGEg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DoUHVaaE7T1nh0E004M5H2ST+ZpPFxORkj1CRnQto235TqBgXa28ki5drkaRgsaHt
         iUch92D8hKmj9wqROoosrwU5Ac2+IXAH1O190GxpXq/n72JZaegit1UNyllqIZMvyy
         fh6Oadq2b4R26v7cEW0qhOQb/8coyw2M2Acu1/28=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Liwei Song <liwei.song@windriver.com>,
        Tony Brelinski <tonyx.brelinski@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 026/122] ice: set the value of global config lock timeout longer
Date:   Thu, 15 Jul 2021 20:37:53 +0200
Message-Id: <20210715182455.715995230@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210715182448.393443551@linuxfoundation.org>
References: <20210715182448.393443551@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Liwei Song <liwei.song@windriver.com>

[ Upstream commit fb3612840d4f587a0af9511a11d7989d1fa48206 ]

It may need hold Global Config Lock a longer time when download DDP
package file, extend the timeout value to 5000ms to ensure that
download can be finished before other AQ command got time to run,
this will fix the issue below when probe the device, 5000ms is a test
value that work with both Backplane and BreakoutCable NVM image:

ice 0000:f4:00.0: VSI 12 failed lan queue config, error ICE_ERR_CFG
ice 0000:f4:00.0: Failed to delete VSI 12 in FW - error: ICE_ERR_AQ_TIMEOUT
ice 0000:f4:00.0: probe failed due to setup PF switch: -12
ice: probe of 0000:f4:00.0 failed with error -12

Signed-off-by: Liwei Song <liwei.song@windriver.com>
Tested-by: Tony Brelinski <tonyx.brelinski@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/ice/ice_type.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_type.h b/drivers/net/ethernet/intel/ice/ice_type.h
index 6667d17a4206..0b2e657b96eb 100644
--- a/drivers/net/ethernet/intel/ice/ice_type.h
+++ b/drivers/net/ethernet/intel/ice/ice_type.h
@@ -48,7 +48,7 @@ enum ice_aq_res_ids {
 /* FW update timeout definitions are in milliseconds */
 #define ICE_NVM_TIMEOUT			180000
 #define ICE_CHANGE_LOCK_TIMEOUT		1000
-#define ICE_GLOBAL_CFG_LOCK_TIMEOUT	3000
+#define ICE_GLOBAL_CFG_LOCK_TIMEOUT	5000
 
 enum ice_aq_res_access_type {
 	ICE_RES_READ = 1,
-- 
2.30.2



