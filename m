Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E50A445222F
	for <lists+stable@lfdr.de>; Tue, 16 Nov 2021 02:08:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344141AbhKPBKR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 20:10:17 -0500
Received: from mail.kernel.org ([198.145.29.99]:44644 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S245064AbhKOTTI (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 14:19:08 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id EBC4C63500;
        Mon, 15 Nov 2021 18:27:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637000869;
        bh=zU4rPBiqFthSUjgIk5HQ8ztLDn7MoThQ1/ySetEX4hA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=guBteoRQD0eGSeiF7hhifxeNGmhGQc0R5dB6YWgkhL6f5SGy3srqWNdkVM7m38Vtp
         oPsdPeWaU3/BBqOP387uSlPeQQQmKgKy2LNv0tSiftQwH1JCWpp/362Y2YRpl8/QRx
         WAQhLaTeUa277yItGeYIeKGzTF2yaj6iTEf5aWkc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dong Aisheng <aisheng.dong@nxp.com>,
        Peng Fan <peng.fan@nxp.com>,
        Mathieu Poirier <mathieu.poirier@linaro.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>
Subject: [PATCH 5.14 824/849] remoteproc: imx_rproc: Fix ignoring mapping vdev regions
Date:   Mon, 15 Nov 2021 18:05:07 +0100
Message-Id: <20211115165448.111503453@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165419.961798833@linuxfoundation.org>
References: <20211115165419.961798833@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dong Aisheng <aisheng.dong@nxp.com>

commit afe670e23af91d8a74a8d7049f6e0984bbf6ea11 upstream.

vdev regions are typically named vdev0buffer, vdev0ring0, vdev0ring1 and
etc. Change to strncmp to cover them all.

Fixes: 8f2d8961640f ("remoteproc: imx_rproc: ignore mapping vdev regions")
Reviewed-and-tested-by: Peng Fan <peng.fan@nxp.com>
Signed-off-by: Dong Aisheng <aisheng.dong@nxp.com>
Signed-off-by: Peng Fan <peng.fan@nxp.com>
Cc: stable <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20210910090621.3073540-5-peng.fan@oss.nxp.com
Signed-off-by: Mathieu Poirier <mathieu.poirier@linaro.org>
Signed-off-by: Bjorn Andersson <bjorn.andersson@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/remoteproc/imx_rproc.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/remoteproc/imx_rproc.c
+++ b/drivers/remoteproc/imx_rproc.c
@@ -582,8 +582,8 @@ static int imx_rproc_addr_init(struct im
 		struct resource res;
 
 		node = of_parse_phandle(np, "memory-region", a);
-		/* Not map vdev region */
-		if (!strcmp(node->name, "vdev"))
+		/* Not map vdevbuffer, vdevring region */
+		if (!strncmp(node->name, "vdev", strlen("vdev")))
 			continue;
 		err = of_address_to_resource(node, 0, &res);
 		if (err) {


