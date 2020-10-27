Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BFE5C29C531
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 19:08:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1824787AbgJ0SFt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 14:05:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:38704 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1757173AbgJ0OQf (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 10:16:35 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A5BDE206F7;
        Tue, 27 Oct 2020 14:16:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603808195;
        bh=kU9Xop77amRLsEkT7VK/VZIhvq0AgyygKy9meogzjD4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jTZR86mmn1TJKye60DXb8Y67OzOlau1gBvcEcqU8xa5EhoUhOAzQfJ4BoWqSeWSL5
         /i6hdQ5UiRXOkoJihcm5ajVxzjmIOL3V2esiI5ng/9j+xMrJZ8Wv8jHGYk/OAylTCU
         RiDpj6Auhfvyzk0wkB2VrTYXq65uUqcZW/995Xno=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Maciej=20=C5=BBenczykowski?= <maze@google.com>,
        Lorenzo Colitti <lorenzo@google.com>,
        Felipe Balbi <balbi@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 191/191] usb: gadget: f_ncm: allow using NCM in SuperSpeed Plus gadgets.
Date:   Tue, 27 Oct 2020 14:50:46 +0100
Message-Id: <20201027134918.911480572@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027134909.701581493@linuxfoundation.org>
References: <20201027134909.701581493@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lorenzo Colitti <lorenzo@google.com>

[ Upstream commit 7974ecd7d3c0f42a98566f281e44ea8573a2ad88 ]

Currently, enabling f_ncm at SuperSpeed Plus speeds results in an
oops in config_ep_by_speed because ncm_set_alt passes in NULL
ssp_descriptors. Fix this by re-using the SuperSpeed descriptors.
This is safe because usb_assign_descriptors calls
usb_copy_descriptors.

Tested: enabled f_ncm on a dwc3 gadget and 10Gbps link, ran iperf
Reviewed-by: Maciej Żenczykowski <maze@google.com>
Signed-off-by: Lorenzo Colitti <lorenzo@google.com>
Signed-off-by: Felipe Balbi <balbi@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/gadget/function/f_ncm.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/usb/gadget/function/f_ncm.c b/drivers/usb/gadget/function/f_ncm.c
index fbf15ab700f49..61c0bc7c985f4 100644
--- a/drivers/usb/gadget/function/f_ncm.c
+++ b/drivers/usb/gadget/function/f_ncm.c
@@ -1541,7 +1541,7 @@ static int ncm_bind(struct usb_configuration *c, struct usb_function *f)
 		fs_ncm_notify_desc.bEndpointAddress;
 
 	status = usb_assign_descriptors(f, ncm_fs_function, ncm_hs_function,
-			ncm_ss_function, NULL);
+			ncm_ss_function, ncm_ss_function);
 	if (status)
 		goto fail;
 
-- 
2.25.1



