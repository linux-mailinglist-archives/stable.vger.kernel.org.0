Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 212EC2666D8
	for <lists+stable@lfdr.de>; Fri, 11 Sep 2020 19:34:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726387AbgIKRcq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 11 Sep 2020 13:32:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:49240 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726018AbgIKMzK (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 11 Sep 2020 08:55:10 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0C2962222D;
        Fri, 11 Sep 2020 12:54:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599828852;
        bh=ks8FBRzzE0qli1nkpe2h0FyERehMi7N5X63Tf043nKE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=f9Ry2WnfRW0mrjuEH9qCDadX/JQJuTn3XliQ/iiDtDXuO8UBFjLVJHr/3M6fkd236
         Dr0x0+tuoxpVQYfpE36igcAn3+1Ppv7+rwa9LyTOzsaVmi4geXNAqNZ8QP1uShkj7Q
         3dF+051x2Igr5IHRg5as1/mgHhoF5zDcd1kHkb6U=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kanerva Topi <Topi.Kanerva@cinia.fi>,
        =?UTF-8?q?Bj=C3=B8rn=20Mork?= <bjorn@mork.no>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 32/62] net: qmi_wwan: ignore bogus CDC Union descriptors
Date:   Fri, 11 Sep 2020 14:46:15 +0200
Message-Id: <20200911122503.996071501@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200911122502.395450276@linuxfoundation.org>
References: <20200911122502.395450276@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Bjørn Mork <bjorn@mork.no>

[ Upstream commit 34a55d5e858e81a20d33fd9490149d6a1058be0c ]

The CDC descriptors found on these vendor specific functions should
not be considered authoritative.  They seem to be ignored by drivers
for other systems, and the quality is therefore low.

One device (1e0e:9001) has been reported to have such a bogus union
descriptor on the QMI function, making it fail probing even if the
device id was dynamically added.  The report was not complete enough
to allow adding a device entry for this modem. But this should at
least fix the dynamic id probing problem.

Reported-by: Kanerva Topi <Topi.Kanerva@cinia.fi>
Signed-off-by: Bjørn Mork <bjorn@mork.no>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/usb/qmi_wwan.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/net/usb/qmi_wwan.c b/drivers/net/usb/qmi_wwan.c
index e75e984483bc5..f8d00846b4a59 100644
--- a/drivers/net/usb/qmi_wwan.c
+++ b/drivers/net/usb/qmi_wwan.c
@@ -374,7 +374,10 @@ static int qmi_wwan_bind(struct usbnet *dev, struct usb_interface *intf)
 				"bogus CDC Union: master=%u, slave=%u\n",
 				cdc_union->bMasterInterface0,
 				cdc_union->bSlaveInterface0);
-			goto err;
+
+			/* ignore and continue... */
+			cdc_union = NULL;
+			info->data = intf;
 		}
 	}
 
-- 
2.25.1



