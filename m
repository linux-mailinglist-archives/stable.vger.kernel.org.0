Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 013B4300D2C
	for <lists+stable@lfdr.de>; Fri, 22 Jan 2021 21:01:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730904AbhAVT67 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 22 Jan 2021 14:58:59 -0500
Received: from mail.kernel.org ([198.145.29.99]:37508 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728441AbhAVOQc (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 22 Jan 2021 09:16:32 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id C79CD23B03;
        Fri, 22 Jan 2021 14:12:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1611324730;
        bh=SlH2NzCoujiSem3sba2v272mEhlltaaiVc1Vd3kqLS0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0R1Cfa3vlroVNNleN3r0vLKyPhL9mDYTn9WU5oyH6mmiIQf0AljaY7gxvqOHTIZAr
         bvmwWFdwfosNr3b/Mck+/vo8RHXzAMKa5sLS+1mV5s6vAbynm0hxW4F8KqBWGaMgGA
         2paN1KumHcv/s56GetegK9TI9Ze1BW48P9xMzwm4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Andrey Zhizhikin <andrey.zhizhikin@leica-geosystems.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 4.9 28/35] rndis_host: set proper input size for OID_GEN_PHYSICAL_MEDIUM request
Date:   Fri, 22 Jan 2021 15:10:30 +0100
Message-Id: <20210122135733.436641742@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210122135732.357969201@linuxfoundation.org>
References: <20210122135732.357969201@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Andrey Zhizhikin <andrey.zhizhikin@leica-geosystems.com>

[ Upstream commit e56b3d94d939f52d46209b9e1b6700c5bfff3123 ]

MSFT ActiveSync implementation requires that the size of the response for
incoming query is to be provided in the request input length. Failure to
set the input size proper results in failed request transfer, where the
ActiveSync counterpart reports the NDIS_STATUS_INVALID_LENGTH (0xC0010014L)
error.

Set the input size for OID_GEN_PHYSICAL_MEDIUM query to the expected size
of the response in order for the ActiveSync to properly respond to the
request.

Fixes: 039ee17d1baa ("rndis_host: Add RNDIS physical medium checking into generic_rndis_bind()")
Signed-off-by: Andrey Zhizhikin <andrey.zhizhikin@leica-geosystems.com>
Link: https://lore.kernel.org/r/20210108095839.3335-1-andrey.zhizhikin@leica-geosystems.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/usb/rndis_host.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/net/usb/rndis_host.c
+++ b/drivers/net/usb/rndis_host.c
@@ -398,7 +398,7 @@ generic_rndis_bind(struct usbnet *dev, s
 	reply_len = sizeof *phym;
 	retval = rndis_query(dev, intf, u.buf,
 			     RNDIS_OID_GEN_PHYSICAL_MEDIUM,
-			     0, (void **) &phym, &reply_len);
+			     reply_len, (void **)&phym, &reply_len);
 	if (retval != 0 || !phym) {
 		/* OID is optional so don't fail here. */
 		phym_unspec = cpu_to_le32(RNDIS_PHYSICAL_MEDIUM_UNSPECIFIED);


