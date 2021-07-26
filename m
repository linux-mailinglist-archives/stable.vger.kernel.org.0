Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1E3CE3D6235
	for <lists+stable@lfdr.de>; Mon, 26 Jul 2021 18:16:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236711AbhGZPfH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Jul 2021 11:35:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:51044 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235024AbhGZPeE (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 26 Jul 2021 11:34:04 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4E7B960C40;
        Mon, 26 Jul 2021 16:14:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1627316069;
        bh=8yugBpXtiHbW0IHUy3U3C4SeJTTZi2HmiKcDjHO1arY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xvSHXEHQoK1MBOp2mTx13JhXWyOxaEVq1/wAa5baWxVgVllP3dq8p0BYZ+foeS8kI
         uJxk5mzhx9oStTrZwCPMU3jSpPCbA8TNseE6Bf81yB+arWtCmMN5MlgpUgUCwOmt/V
         +Tm5t2mWny53Gupfqv0wlFb/8mq4RZzTJEpASwHA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Amelie Delaunay <amelie.delaunay@foss.st.com>
Subject: [PATCH 5.13 175/223] usb: typec: stusb160x: Dont block probing of consumer of "connector" nodes
Date:   Mon, 26 Jul 2021 17:39:27 +0200
Message-Id: <20210726153851.921391987@linuxfoundation.org>
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

From: Amelie Delaunay <amelie.delaunay@foss.st.com>

commit 6b63376722d9e1b915a2948e9b30f4ba2712e3f5 upstream.

Similar as with tcpm this patch lets fw_devlink know not to wait on the
fwnode to be populated as a struct device.

Without this patch, USB functionality can be broken on some previously
supported boards.

Fixes: 28ec344bb891 ("usb: typec: tcpm: Don't block probing of consumers of "connector" nodes")
Cc: stable <stable@vger.kernel.org>
Signed-off-by: Amelie Delaunay <amelie.delaunay@foss.st.com>
Link: https://lore.kernel.org/r/20210716120718.20398-3-amelie.delaunay@foss.st.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/typec/stusb160x.c |    9 +++++++++
 1 file changed, 9 insertions(+)

--- a/drivers/usb/typec/stusb160x.c
+++ b/drivers/usb/typec/stusb160x.c
@@ -686,6 +686,15 @@ static int stusb160x_probe(struct i2c_cl
 		return -ENODEV;
 
 	/*
+	 * This fwnode has a "compatible" property, but is never populated as a
+	 * struct device. Instead we simply parse it to read the properties.
+	 * This it breaks fw_devlink=on. To maintain backward compatibility
+	 * with existing DT files, we work around this by deleting any
+	 * fwnode_links to/from this fwnode.
+	 */
+	fw_devlink_purge_absent_suppliers(fwnode);
+
+	/*
 	 * When both VDD and VSYS power supplies are present, the low power
 	 * supply VSYS is selected when VSYS voltage is above 3.1 V.
 	 * Otherwise VDD is selected.


