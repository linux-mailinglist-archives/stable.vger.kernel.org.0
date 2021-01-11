Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ABE572F14FC
	for <lists+stable@lfdr.de>; Mon, 11 Jan 2021 14:34:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732197AbhAKNcr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Jan 2021 08:32:47 -0500
Received: from mail.kernel.org ([198.145.29.99]:33178 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732211AbhAKNO6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 11 Jan 2021 08:14:58 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8188A2255F;
        Mon, 11 Jan 2021 13:14:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1610370883;
        bh=NsoAK2b0s/Yhrt/Z6oMGfQ1c04owza6RbgTsWv722GE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wv6S7OgQiuw9QiIDFrF+qM6fJTu241XJUuG9UXhaWxNmNWZy/ihZ+z4DwXoQgyYgc
         SpOtx0Nc89ClJwEXi0wOmGzoMHeEkZJUXyxjWlwJQ2JsfFP6oTAAI0XAUZovErRVxK
         CryJhAs2eg95pmst4cQAQo0u6cUHh9aBWKsbedq0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Aaron Ma <aaron.ma@canonical.com>,
        Sasha Netfin <sasha.neftin@intel.com>,
        Hans de Goede <hdegoede@redhat.com>,
        Mark Pearson <markpearson@lenovo.com>,
        Mario Limonciello <mario.limonciello@dell.com>,
        Yijun Shen <Yijun.shen@dell.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>
Subject: [PATCH 5.10 028/145] e1000e: bump up timeout to wait when ME un-configures ULP mode
Date:   Mon, 11 Jan 2021 14:00:52 +0100
Message-Id: <20210111130049.862760972@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210111130048.499958175@linuxfoundation.org>
References: <20210111130048.499958175@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mario Limonciello <mario.limonciello@dell.com>

[ Upstream commit 3cf31b1a9effd859bb3d6ff9f8b5b0d5e6cac952 ]

Per guidance from Intel ethernet architecture team, it may take
up to 1 second for unconfiguring ULP mode.

However in practice this seems to be taking up to 2 seconds on
some Lenovo machines.  Detect scenarios that take more than 1 second
but less than 2.5 seconds and emit a warning on resume for those
scenarios.

Suggested-by: Aaron Ma <aaron.ma@canonical.com>
Suggested-by: Sasha Netfin <sasha.neftin@intel.com>
Suggested-by: Hans de Goede <hdegoede@redhat.com>
CC: Mark Pearson <markpearson@lenovo.com>
Fixes: f15bb6dde738cc8fa0 ("e1000e: Add support for S0ix")
BugLink: https://bugs.launchpad.net/bugs/1865570
Link: https://patchwork.ozlabs.org/project/intel-wired-lan/patch/20200323191639.48826-1-aaron.ma@canonical.com/
Link: https://lkml.org/lkml/2020/12/13/15
Link: https://lkml.org/lkml/2020/12/14/708
Signed-off-by: Mario Limonciello <mario.limonciello@dell.com>
Reviewed-by: Hans de Goede <hdegoede@redhat.com>
Tested-by: Yijun Shen <Yijun.shen@dell.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/intel/e1000e/ich8lan.c |   17 ++++++++++++++---
 1 file changed, 14 insertions(+), 3 deletions(-)

--- a/drivers/net/ethernet/intel/e1000e/ich8lan.c
+++ b/drivers/net/ethernet/intel/e1000e/ich8lan.c
@@ -1240,6 +1240,9 @@ static s32 e1000_disable_ulp_lpt_lp(stru
 		return 0;
 
 	if (er32(FWSM) & E1000_ICH_FWSM_FW_VALID) {
+		struct e1000_adapter *adapter = hw->adapter;
+		bool firmware_bug = false;
+
 		if (force) {
 			/* Request ME un-configure ULP mode in the PHY */
 			mac_reg = er32(H2ME);
@@ -1248,16 +1251,24 @@ static s32 e1000_disable_ulp_lpt_lp(stru
 			ew32(H2ME, mac_reg);
 		}
 
-		/* Poll up to 300msec for ME to clear ULP_CFG_DONE. */
+		/* Poll up to 2.5 seconds for ME to clear ULP_CFG_DONE.
+		 * If this takes more than 1 second, show a warning indicating a
+		 * firmware bug
+		 */
 		while (er32(FWSM) & E1000_FWSM_ULP_CFG_DONE) {
-			if (i++ == 30) {
+			if (i++ == 250) {
 				ret_val = -E1000_ERR_PHY;
 				goto out;
 			}
+			if (i > 100 && !firmware_bug)
+				firmware_bug = true;
 
 			usleep_range(10000, 11000);
 		}
-		e_dbg("ULP_CONFIG_DONE cleared after %dmsec\n", i * 10);
+		if (firmware_bug)
+			e_warn("ULP_CONFIG_DONE took %dmsec.  This is a firmware bug\n", i * 10);
+		else
+			e_dbg("ULP_CONFIG_DONE cleared after %dmsec\n", i * 10);
 
 		if (force) {
 			mac_reg = er32(H2ME);


