Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 62BB030054A
	for <lists+stable@lfdr.de>; Fri, 22 Jan 2021 15:25:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728667AbhAVOYt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 22 Jan 2021 09:24:49 -0500
Received: from mail.kernel.org ([198.145.29.99]:40662 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728492AbhAVOYA (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 22 Jan 2021 09:24:00 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9AADA23B7F;
        Fri, 22 Jan 2021 14:17:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1611325068;
        bh=CnK54VVmj9CQnTdkY4M0XHyFmyMt4Oe32pQge64ot8Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=k4LJxxkfCA4hRXLLtKTXvyStii8UDgMynTDq0jEWg+erBbImlMy0BRkdqqTT00wKk
         XeJicqGzeTEdX68x5pVJqrpGVCDBD9lehWzkcvg5q7vqUBN8YEMxwKEkqxB4vaN6R7
         y3Y6inB2EsvgZKjMuUl/ewousm+rjtdg8p187ayQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Andrey Zhizhikin <andrey.zhizhikin@leica-geosystems.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.4 20/33] rndis_host: set proper input size for OID_GEN_PHYSICAL_MEDIUM request
Date:   Fri, 22 Jan 2021 15:12:36 +0100
Message-Id: <20210122135734.399344627@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210122135733.565501039@linuxfoundation.org>
References: <20210122135733.565501039@linuxfoundation.org>
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
@@ -387,7 +387,7 @@ generic_rndis_bind(struct usbnet *dev, s
 	reply_len = sizeof *phym;
 	retval = rndis_query(dev, intf, u.buf,
 			     RNDIS_OID_GEN_PHYSICAL_MEDIUM,
-			     0, (void **) &phym, &reply_len);
+			     reply_len, (void **)&phym, &reply_len);
 	if (retval != 0 || !phym) {
 		/* OID is optional so don't fail here. */
 		phym_unspec = cpu_to_le32(RNDIS_PHYSICAL_MEDIUM_UNSPECIFIED);


