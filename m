Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D929C43A220
	for <lists+stable@lfdr.de>; Mon, 25 Oct 2021 21:44:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236736AbhJYTpV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 25 Oct 2021 15:45:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:57940 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236149AbhJYTmh (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 25 Oct 2021 15:42:37 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A30C560238;
        Mon, 25 Oct 2021 19:37:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1635190630;
        bh=fFdN2I5CoC7BHpUjF2gdbFeZ+AtyiRK6Y53biS+Cq5U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=l7nEjiQ8a3PZtADApo26rLu9/Woi1OOWm0YyMTomIcdb3SPU3kuHEvGwAg45eIcKW
         pnVfnM+/mk/zlVxa+/MPBVVQMQ9Nicmn1aDVAJ+HbLlRu5ItSYZBn/svI00my7GiPi
         H2QlbQEK4H5Fwn298MHRNajI9htTRAZAoigE8gUA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Brett Creeley <brett.creeley@intel.com>,
        Gurucharan G <gurucharanx.g@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 031/169] ice: Print the api_patch as part of the fw.mgmt.api
Date:   Mon, 25 Oct 2021 21:13:32 +0200
Message-Id: <20211025191021.901290749@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211025191017.756020307@linuxfoundation.org>
References: <20211025191017.756020307@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Brett Creeley <brett.creeley@intel.com>

[ Upstream commit b726ddf984a56a385c9df406a66c221f3a77c951 ]

Currently when a user uses "devlink dev info", the fw.mgmt.api will be
the major.minor numbers as shown below:

devlink dev info pci/0000:3b:00.0
pci/0000:3b:00.0:
  driver ice
  serial_number 00-01-00-ff-ff-00-00-00
  versions:
      fixed:
        board.id K91258-000
      running:
        fw.mgmt 6.1.2
        fw.mgmt.api 1.7 <--- No patch number included
        fw.mgmt.build 0xd75e7d06
        fw.mgmt.srev 5
        fw.undi 1.2992.0
        fw.undi.srev 5
        fw.psid.api 3.10
        fw.bundle_id 0x800085cc
        fw.app.name ICE OS Default Package
        fw.app 1.3.27.0
        fw.app.bundle_id 0xc0000001
        fw.netlist 3.10.2000-3.1e.0
        fw.netlist.build 0x2a76e110
      stored:
        fw.mgmt.srev 5
        fw.undi 1.2992.0
        fw.undi.srev 5
        fw.psid.api 3.10
        fw.bundle_id 0x800085cc
        fw.netlist 3.10.2000-3.1e.0
        fw.netlist.build 0x2a76e110

There are many features in the driver that depend on the major, minor,
and patch version of the FW. Without the patch number in the output for
fw.mgmt.api debugging issues related to the FW API version is difficult.
Also, using major.minor.patch aligns with the existing firmware version
which uses a 3 digit value.

Fix this by making the fw.mgmt.api print the major.minor.patch
versions. Shown below is the result:

devlink dev info pci/0000:3b:00.0
pci/0000:3b:00.0:
  driver ice
  serial_number 00-01-00-ff-ff-00-00-00
  versions:
      fixed:
        board.id K91258-000
      running:
        fw.mgmt 6.1.2
        fw.mgmt.api 1.7.9 <--- patch number included
        fw.mgmt.build 0xd75e7d06
        fw.mgmt.srev 5
        fw.undi 1.2992.0
        fw.undi.srev 5
        fw.psid.api 3.10
        fw.bundle_id 0x800085cc
        fw.app.name ICE OS Default Package
        fw.app 1.3.27.0
        fw.app.bundle_id 0xc0000001
        fw.netlist 3.10.2000-3.1e.0
        fw.netlist.build 0x2a76e110
      stored:
        fw.mgmt.srev 5
        fw.undi 1.2992.0
        fw.undi.srev 5
        fw.psid.api 3.10
        fw.bundle_id 0x800085cc
        fw.netlist 3.10.2000-3.1e.0
        fw.netlist.build 0x2a76e110

Fixes: ff2e5c700e08 ("ice: add basic handler for devlink .info_get")
Signed-off-by: Brett Creeley <brett.creeley@intel.com>
Tested-by: Gurucharan G <gurucharanx.g@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 Documentation/networking/devlink/ice.rst     | 9 +++++----
 drivers/net/ethernet/intel/ice/ice_devlink.c | 3 ++-
 2 files changed, 7 insertions(+), 5 deletions(-)

diff --git a/Documentation/networking/devlink/ice.rst b/Documentation/networking/devlink/ice.rst
index a432dc419fa4..5d97cee9457b 100644
--- a/Documentation/networking/devlink/ice.rst
+++ b/Documentation/networking/devlink/ice.rst
@@ -30,10 +30,11 @@ The ``ice`` driver reports the following versions
         PHY, link, etc.
     * - ``fw.mgmt.api``
       - running
-      - 1.5
-      - 2-digit version number of the API exported over the AdminQ by the
-        management firmware. Used by the driver to identify what commands
-        are supported.
+      - 1.5.1
+      - 3-digit version number (major.minor.patch) of the API exported over
+        the AdminQ by the management firmware. Used by the driver to
+        identify what commands are supported. Historical versions of the
+        kernel only displayed a 2-digit version number (major.minor).
     * - ``fw.mgmt.build``
       - running
       - 0x305d955f
diff --git a/drivers/net/ethernet/intel/ice/ice_devlink.c b/drivers/net/ethernet/intel/ice/ice_devlink.c
index 7fe6e8ea39f0..64bea7659cf7 100644
--- a/drivers/net/ethernet/intel/ice/ice_devlink.c
+++ b/drivers/net/ethernet/intel/ice/ice_devlink.c
@@ -63,7 +63,8 @@ static int ice_info_fw_api(struct ice_pf *pf, struct ice_info_ctx *ctx)
 {
 	struct ice_hw *hw = &pf->hw;
 
-	snprintf(ctx->buf, sizeof(ctx->buf), "%u.%u", hw->api_maj_ver, hw->api_min_ver);
+	snprintf(ctx->buf, sizeof(ctx->buf), "%u.%u.%u", hw->api_maj_ver,
+		 hw->api_min_ver, hw->api_patch);
 
 	return 0;
 }
-- 
2.33.0



