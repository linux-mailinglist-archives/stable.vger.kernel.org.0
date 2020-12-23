Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8E2F82E122B
	for <lists+stable@lfdr.de>; Wed, 23 Dec 2020 03:21:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728725AbgLWCTl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 22 Dec 2020 21:19:41 -0500
Received: from mail.kernel.org ([198.145.29.99]:46424 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728722AbgLWCTk (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 22 Dec 2020 21:19:40 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id E539622A99;
        Wed, 23 Dec 2020 02:19:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1608689950;
        bh=oTkdwe/HtLkDFjopoFjvh7xHmrD822H3xtWYFnLOq6Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mpIxK0qjpP2L9iaznp9QrGkKunjToXxvapTw7RDN4Nfl4co4+/q+jKHB83jRIBt7Y
         uUU60GRLT7eXLzMD5TBSJIME1KyvhKBzcqASLB9MVj3j4blTTXb2ZDmKFuttlJv4+S
         HEeSgghoQ/tPQu3Cw4+jMpawWYPm5rb3wg2/cILN96Ba4ZFaTJAcHWf2RIfgVtcqwW
         fjZbxs1BMbbgtW0Ck7rUT/jiThlyWaXEEvIl6psgCfNxWVfNq0fBEEehriDWVjngxO
         aTfFQiieWYN7QQscBjPPuThFeVwmbJKrtwFmSy9WOrZTz8tXTEuDV4Pul973ZIUQ41
         6oUO00VBnjH2A==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Dinghao Liu <dinghao.liu@zju.edu.cn>, Sean Young <sean@mess.org>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Sasha Levin <sashal@kernel.org>, linux-media@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 044/130] media: dvbdev: Fix memleak in dvb_register_device
Date:   Tue, 22 Dec 2020 21:16:47 -0500
Message-Id: <20201223021813.2791612-44-sashal@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20201223021813.2791612-1-sashal@kernel.org>
References: <20201223021813.2791612-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dinghao Liu <dinghao.liu@zju.edu.cn>

[ Upstream commit 167faadfcf9339088910e9e85a1b711fcbbef8e9 ]

When device_create() fails, dvbdev and dvbdevfops should
be freed just like when dvb_register_media_device() fails.

Signed-off-by: Dinghao Liu <dinghao.liu@zju.edu.cn>
Signed-off-by: Sean Young <sean@mess.org>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/dvb-core/dvbdev.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/media/dvb-core/dvbdev.c b/drivers/media/dvb-core/dvbdev.c
index 032b6d7dd5821..cfe983e78102f 100644
--- a/drivers/media/dvb-core/dvbdev.c
+++ b/drivers/media/dvb-core/dvbdev.c
@@ -539,6 +539,9 @@ int dvb_register_device(struct dvb_adapter *adap, struct dvb_device **pdvbdev,
 	if (IS_ERR(clsdev)) {
 		pr_err("%s: failed to create device dvb%d.%s%d (%ld)\n",
 		       __func__, adap->num, dnames[type], id, PTR_ERR(clsdev));
+		dvb_media_device_free(dvbdev);
+		kfree(dvbdevfops);
+		kfree(dvbdev);
 		return PTR_ERR(clsdev);
 	}
 	dprintk("DVB: register adapter%d/%s%d @ minor: %i (0x%02x)\n",
-- 
2.27.0

