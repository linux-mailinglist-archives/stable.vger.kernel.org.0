Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A3AB61EF1C
	for <lists+stable@lfdr.de>; Wed, 15 May 2019 13:30:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732344AbfEOLaF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 May 2019 07:30:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:41548 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732166AbfEOLaF (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 15 May 2019 07:30:05 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4588D206BF;
        Wed, 15 May 2019 11:30:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557919804;
        bh=27o0n0tSSQ4ROIQfDrmsXsWggqIdruEl+279LB0TF+k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IFvyisip33+i5RlxfVdAHSm42NKd4XcaIAmqh1nfWWQhwTVOFEL2tklgV/W4kkB8b
         jt3Q8njUR5SEQ/aIoFDgU3YuhDNTsI2f0fCR+tJvvR7m/vfMIMAEKOz9U89mfBJBr+
         EzY/oe3OwSaT9yPecJw7jh1bgwYt5vEzcq9Y//VI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Damian Kos <dkos@cadence.com>,
        Heiko Stuebner <heiko@sntech.de>,
        Sasha Levin <alexander.levin@microsoft.com>
Subject: [PATCH 5.0 100/137] drm/rockchip: fix for mailbox read validation.
Date:   Wed, 15 May 2019 12:56:21 +0200
Message-Id: <20190515090700.786125615@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190515090651.633556783@linuxfoundation.org>
References: <20190515090651.633556783@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit e4056bbb6719fe713bfc4030ac78e8e97ddf7574 ]

This is basically the same fix as in
commit fa68d4f8476b ("drm/rockchip: fix for mailbox read size")
but for cdn_dp_mailbox_validate_receive function.

See patchwork.kernel.org/patch/10671981/ for details.

Signed-off-by: Damian Kos <dkos@cadence.com>
Signed-off-by: Heiko Stuebner <heiko@sntech.de>
Link: https://patchwork.freedesktop.org/patch/msgid/1542640463-18332-1-git-send-email-dkos@cadence.com
Signed-off-by: Sasha Levin <alexander.levin@microsoft.com>
---
 drivers/gpu/drm/rockchip/cdn-dp-reg.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/rockchip/cdn-dp-reg.c b/drivers/gpu/drm/rockchip/cdn-dp-reg.c
index 5a485489a1e23..6c8b14fb1d2f3 100644
--- a/drivers/gpu/drm/rockchip/cdn-dp-reg.c
+++ b/drivers/gpu/drm/rockchip/cdn-dp-reg.c
@@ -113,7 +113,7 @@ static int cdp_dp_mailbox_write(struct cdn_dp_device *dp, u8 val)
 
 static int cdn_dp_mailbox_validate_receive(struct cdn_dp_device *dp,
 					   u8 module_id, u8 opcode,
-					   u8 req_size)
+					   u16 req_size)
 {
 	u32 mbox_size, i;
 	u8 header[4];
-- 
2.20.1



