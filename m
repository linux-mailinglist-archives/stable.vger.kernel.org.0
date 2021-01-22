Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 87A14300509
	for <lists+stable@lfdr.de>; Fri, 22 Jan 2021 15:15:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728332AbhAVOM6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 22 Jan 2021 09:12:58 -0500
Received: from mail.kernel.org ([198.145.29.99]:34332 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728062AbhAVOLQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 22 Jan 2021 09:11:16 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 48AAB23A7D;
        Fri, 22 Jan 2021 14:09:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1611324573;
        bh=SlH2NzCoujiSem3sba2v272mEhlltaaiVc1Vd3kqLS0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vFi0oEN5xQL905XI2SYGytcVNE8/rR18S75cYVroNb67bkiwRStS/7ui8ckTys6nK
         osrItJbiSIrYgplWvBt8orTR6KMn39dJlETB4ZZfOrNAF7xepeSNAKP1kwGmPLRkS3
         JFPvYUN9CMURFec5GXdhpEJ004RzSWbswnp/H02k=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Andrey Zhizhikin <andrey.zhizhikin@leica-geosystems.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 4.4 25/31] rndis_host: set proper input size for OID_GEN_PHYSICAL_MEDIUM request
Date:   Fri, 22 Jan 2021 15:08:39 +0100
Message-Id: <20210122135732.874271091@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210122135731.873346566@linuxfoundation.org>
References: <20210122135731.873346566@linuxfoundation.org>
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


