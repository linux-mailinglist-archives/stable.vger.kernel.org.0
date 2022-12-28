Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2587F657BED
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 16:27:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232770AbiL1P1Q (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 10:27:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45210 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233786AbiL1P0w (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 10:26:52 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 760CE140A7
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 07:26:51 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 12CA761551
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 15:26:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 26639C433D2;
        Wed, 28 Dec 2022 15:26:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672241210;
        bh=XWTCl5dflEC2C6jV1NT4qsB6XBXD7Pi+Nebs7hEj1xk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eHraxle0W0y+GqwrukJbUrP/MJ7uAXO7E3SSilw0AWb7fuktdaEYZurzwK9nid+rF
         6+hJO5BSYCstrpRszh5Ct3CA8I2WcEwDq7dlnEJfsWcLsRqmfZoH5rpXmvuPNzrCCU
         SPHsSfSvaFYFgykew2dkFzyb+6xLoib91Vb7E/Dg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Samuel Holland <samuel@sholland.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 453/731] usb: typec: Factor out non-PD fwnode properties
Date:   Wed, 28 Dec 2022 15:39:20 +0100
Message-Id: <20221228144309.684664008@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144256.536395940@linuxfoundation.org>
References: <20221228144256.536395940@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Samuel Holland <samuel@sholland.org>

[ Upstream commit 2e7dfb0e9cacad0f1adbc4b97f0b96ba35027f24 ]

Basic programmable non-PD Type-C port controllers do not need the full
TCPM library, but they share the same devicetree binding and the same
typec_capability structure. Factor out a helper for parsing those
properties which map to fields in struct typec_capability, so the code
can be shared between TCPM and basic non-TCPM drivers.

Reviewed-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
Signed-off-by: Samuel Holland <samuel@sholland.org>
Link: https://lore.kernel.org/r/20220214050118.61015-4-samuel@sholland.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Stable-dep-of: 581c848b610d ("extcon: usbc-tusb320: Update state on probe even if no IRQ pending")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/typec/class.c     | 43 +++++++++++++++++++++++++++++++++++
 drivers/usb/typec/tcpm/tcpm.c | 24 +------------------
 include/linux/usb/typec.h     |  3 +++
 3 files changed, 47 insertions(+), 23 deletions(-)

diff --git a/drivers/usb/typec/class.c b/drivers/usb/typec/class.c
index ff6c14d7b1a8..339752fef65e 100644
--- a/drivers/usb/typec/class.c
+++ b/drivers/usb/typec/class.c
@@ -1895,6 +1895,49 @@ void *typec_get_drvdata(struct typec_port *port)
 }
 EXPORT_SYMBOL_GPL(typec_get_drvdata);
 
+int typec_get_fw_cap(struct typec_capability *cap,
+		     struct fwnode_handle *fwnode)
+{
+	const char *cap_str;
+	int ret;
+
+	cap->fwnode = fwnode;
+
+	ret = fwnode_property_read_string(fwnode, "power-role", &cap_str);
+	if (ret < 0)
+		return ret;
+
+	ret = typec_find_port_power_role(cap_str);
+	if (ret < 0)
+		return ret;
+	cap->type = ret;
+
+	/* USB data support is optional */
+	ret = fwnode_property_read_string(fwnode, "data-role", &cap_str);
+	if (ret == 0) {
+		ret = typec_find_port_data_role(cap_str);
+		if (ret < 0)
+			return ret;
+		cap->data = ret;
+	}
+
+	/* Get the preferred power role for a DRP */
+	if (cap->type == TYPEC_PORT_DRP) {
+		cap->prefer_role = TYPEC_NO_PREFERRED_ROLE;
+
+		ret = fwnode_property_read_string(fwnode, "try-power-role", &cap_str);
+		if (ret == 0) {
+			ret = typec_find_power_role(cap_str);
+			if (ret < 0)
+				return ret;
+			cap->prefer_role = ret;
+		}
+	}
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(typec_get_fw_cap);
+
 /**
  * typec_port_register_altmode - Register USB Type-C Port Alternate Mode
  * @port: USB Type-C Port that supports the alternate mode
diff --git a/drivers/usb/typec/tcpm/tcpm.c b/drivers/usb/typec/tcpm/tcpm.c
index 33aadc0a29ea..984a13a9efc2 100644
--- a/drivers/usb/typec/tcpm/tcpm.c
+++ b/drivers/usb/typec/tcpm/tcpm.c
@@ -5928,7 +5928,6 @@ static int tcpm_fw_get_caps(struct tcpm_port *port,
 			    struct fwnode_handle *fwnode)
 {
 	const char *opmode_str;
-	const char *cap_str;
 	int ret;
 	u32 mw, frs_current;
 
@@ -5944,23 +5943,10 @@ static int tcpm_fw_get_caps(struct tcpm_port *port,
 	 */
 	fw_devlink_purge_absent_suppliers(fwnode);
 
-	/* USB data support is optional */
-	ret = fwnode_property_read_string(fwnode, "data-role", &cap_str);
-	if (ret == 0) {
-		ret = typec_find_port_data_role(cap_str);
-		if (ret < 0)
-			return ret;
-		port->typec_caps.data = ret;
-	}
-
-	ret = fwnode_property_read_string(fwnode, "power-role", &cap_str);
+	ret = typec_get_fw_cap(&port->typec_caps, fwnode);
 	if (ret < 0)
 		return ret;
 
-	ret = typec_find_port_power_role(cap_str);
-	if (ret < 0)
-		return ret;
-	port->typec_caps.type = ret;
 	port->port_type = port->typec_caps.type;
 	port->pd_supported = !fwnode_property_read_bool(fwnode, "pd-disable");
 
@@ -5997,14 +5983,6 @@ static int tcpm_fw_get_caps(struct tcpm_port *port,
 	if (port->port_type == TYPEC_PORT_SRC)
 		return 0;
 
-	/* Get the preferred power role for DRP */
-	ret = fwnode_property_read_string(fwnode, "try-power-role", &cap_str);
-	if (ret < 0)
-		return ret;
-
-	port->typec_caps.prefer_role = typec_find_power_role(cap_str);
-	if (port->typec_caps.prefer_role < 0)
-		return -EINVAL;
 sink:
 	port->self_powered = fwnode_property_read_bool(fwnode, "self-powered");
 
diff --git a/include/linux/usb/typec.h b/include/linux/usb/typec.h
index e2e44bb1dad8..c1e5910809ad 100644
--- a/include/linux/usb/typec.h
+++ b/include/linux/usb/typec.h
@@ -295,6 +295,9 @@ int typec_set_mode(struct typec_port *port, int mode);
 
 void *typec_get_drvdata(struct typec_port *port);
 
+int typec_get_fw_cap(struct typec_capability *cap,
+		     struct fwnode_handle *fwnode);
+
 int typec_find_pwr_opmode(const char *name);
 int typec_find_orientation(const char *name);
 int typec_find_port_power_role(const char *name);
-- 
2.35.1



