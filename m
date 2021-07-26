Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 93C103D623F
	for <lists+stable@lfdr.de>; Mon, 26 Jul 2021 18:16:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234055AbhGZPfU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Jul 2021 11:35:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:51246 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234982AbhGZPeD (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 26 Jul 2021 11:34:03 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id EC7C460F6B;
        Mon, 26 Jul 2021 16:14:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1627316062;
        bh=c9KqsiROQkLfbsWiiF2qap+CKlpXrJoLvNGi0tK1ITs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tdL5y0eSNiZ8fHy8gkaorAtQz/085K4Bs+d4/BGuzVCnq4rQUki/4chJ5Z7laxb/W
         EnD9LaSdHGr+kp6XsLRhAua6DROqtZAYfxRCjQbZaTn7DISApKblCbUWa5uOHUQcnC
         bnCy/LVUcQWPWsVq88oqnk1FjfvQjNeiPaYQI2Oc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Martin Kepplinger <martin.kepplinger@puri.sm>
Subject: [PATCH 5.13 173/223] usb: typec: tipd: Dont block probing of consumer of "connector" nodes
Date:   Mon, 26 Jul 2021 17:39:25 +0200
Message-Id: <20210726153851.857400191@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210726153846.245305071@linuxfoundation.org>
References: <20210726153846.245305071@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Martin Kepplinger <martin.kepplinger@puri.sm>

commit 57560ee95cb7f91cf0bc31d4ae8276e0dcfe17aa upstream.

Similar as with tcpm this patch lets fw_devlink know not to wait on the
fwnode to be populated as a struct device.

Without this patch, USB functionality can be broken on some previously
supported boards.

Fixes: 28ec344bb891 ("usb: typec: tcpm: Don't block probing of consumers of "connector" nodes")
Cc: stable <stable@vger.kernel.org>
Acked-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
Signed-off-by: Martin Kepplinger <martin.kepplinger@puri.sm>
Link: https://lore.kernel.org/r/20210714061807.5737-1-martin.kepplinger@puri.sm
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/typec/tipd/core.c |    9 +++++++++
 1 file changed, 9 insertions(+)

--- a/drivers/usb/typec/tipd/core.c
+++ b/drivers/usb/typec/tipd/core.c
@@ -629,6 +629,15 @@ static int tps6598x_probe(struct i2c_cli
 	if (!fwnode)
 		return -ENODEV;
 
+	/*
+	 * This fwnode has a "compatible" property, but is never populated as a
+	 * struct device. Instead we simply parse it to read the properties.
+	 * This breaks fw_devlink=on. To maintain backward compatibility
+	 * with existing DT files, we work around this by deleting any
+	 * fwnode_links to/from this fwnode.
+	 */
+	fw_devlink_purge_absent_suppliers(fwnode);
+
 	tps->role_sw = fwnode_usb_role_switch_get(fwnode);
 	if (IS_ERR(tps->role_sw)) {
 		ret = PTR_ERR(tps->role_sw);


