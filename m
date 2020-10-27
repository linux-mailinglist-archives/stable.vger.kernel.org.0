Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 643E629AF78
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 15:12:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1755079AbgJ0OIP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 10:08:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:57224 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755072AbgJ0OIO (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 10:08:14 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 34E9B206D4;
        Tue, 27 Oct 2020 14:08:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603807693;
        bh=PpIeX+5Ph4pbtnexxRypXDCPdi+ONbZuxlHxVvwX5mk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gbZOn0/bk1KTj1RZseM/WuTX/K9STZ7jl+ozbPxMSmAGrwKDqqKrztm4dIpPZv13i
         RQWzym+6mYLOyJP2ysoGQcWvsywDI/mTq7glokq0NgviIn6CKrTKcSGQaKPHTfuJsT
         /mdk/p6vJ9OcIa3revs3B9uoEL7xLfjJgNq6p/L8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Maciej=20=C5=BBenczykowski?= <maze@google.com>,
        Lorenzo Colitti <lorenzo@google.com>,
        Felipe Balbi <balbi@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 139/139] usb: gadget: f_ncm: allow using NCM in SuperSpeed Plus gadgets.
Date:   Tue, 27 Oct 2020 14:50:33 +0100
Message-Id: <20201027134908.757650990@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027134902.130312227@linuxfoundation.org>
References: <20201027134902.130312227@linuxfoundation.org>
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
index ba8fa97a62cfd..4395ea07c1bb4 100644
--- a/drivers/usb/gadget/function/f_ncm.c
+++ b/drivers/usb/gadget/function/f_ncm.c
@@ -1548,7 +1548,7 @@ static int ncm_bind(struct usb_configuration *c, struct usb_function *f)
 		fs_ncm_notify_desc.bEndpointAddress;
 
 	status = usb_assign_descriptors(f, ncm_fs_function, ncm_hs_function,
-			ncm_ss_function, NULL);
+			ncm_ss_function, ncm_ss_function);
 	if (status)
 		goto fail;
 
-- 
2.25.1



