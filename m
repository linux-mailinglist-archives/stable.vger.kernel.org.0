Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A68EC4A4281
	for <lists+stable@lfdr.de>; Mon, 31 Jan 2022 12:12:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1359791AbiAaLMI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 Jan 2022 06:12:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44684 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377328AbiAaLJ4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 31 Jan 2022 06:09:56 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5BE09C0604DC;
        Mon, 31 Jan 2022 03:07:24 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1CFD9B82A31;
        Mon, 31 Jan 2022 11:07:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 613CAC340E8;
        Mon, 31 Jan 2022 11:07:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643627241;
        bh=aNFs42xQbWeVHlU591NmPk9cEXwa3Dh+sxOSlJyGGKI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oVM5APjdRYnACFdIWz/xHjYmJX+Te8CV7kdSpbIWMfdzjT8E7ygUEyB/gLPwMadXs
         Sa3PiNJiLFetkhSYlJ4ooiAxyTCNaT01COWVOriSmsE7GyncX3yev1XbEdgF+BPza+
         cQ0CIrFGiM4PJlvC5J70OiLWKRgCfCuIOTDoRc00=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.15 002/171] net: sfp: ignore disabled SFP node
Date:   Mon, 31 Jan 2022 11:54:27 +0100
Message-Id: <20220131105230.052911627@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220131105229.959216821@linuxfoundation.org>
References: <20220131105229.959216821@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Marek Behún <kabel@kernel.org>

commit 2148927e6ed43a1667baf7c2ae3e0e05a44b51a0 upstream.

Commit ce0aa27ff3f6 ("sfp: add sfp-bus to bridge between network devices
and sfp cages") added code which finds SFP bus DT node even if the node
is disabled with status = "disabled". Because of this, when phylink is
created, it ends with non-null .sfp_bus member, even though the SFP
module is not probed (because the node is disabled).

We need to ignore disabled SFP bus node.

Fixes: ce0aa27ff3f6 ("sfp: add sfp-bus to bridge between network devices and sfp cages")
Signed-off-by: Marek Behún <kabel@kernel.org>
Cc: stable@vger.kernel.org # 2203cbf2c8b5 ("net: sfp: move fwnode parsing into sfp-bus layer")
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/phy/sfp-bus.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/drivers/net/phy/sfp-bus.c
+++ b/drivers/net/phy/sfp-bus.c
@@ -651,6 +651,11 @@ struct sfp_bus *sfp_bus_find_fwnode(stru
 	else if (ret < 0)
 		return ERR_PTR(ret);
 
+	if (!fwnode_device_is_available(ref.fwnode)) {
+		fwnode_handle_put(ref.fwnode);
+		return NULL;
+	}
+
 	bus = sfp_bus_get(ref.fwnode);
 	fwnode_handle_put(ref.fwnode);
 	if (!bus)


