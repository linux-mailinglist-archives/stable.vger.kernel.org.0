Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1393E26B749
	for <lists+stable@lfdr.de>; Wed, 16 Sep 2020 02:21:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727488AbgIPAUy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 15 Sep 2020 20:20:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:37096 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726873AbgIOOVf (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 15 Sep 2020 10:21:35 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2F4CD22265;
        Tue, 15 Sep 2020 14:17:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600179438;
        bh=4ABVsmh5jI5NnXO2oNl8UNhINhHcy7IXqkNT+Q5jG1g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Bd4+1E08akzBnpRyk/mBXSpxWFR5peJ+cnKlQVKQ9EYEL1vp1q1nSRwGknLyFbnO3
         HQYK0X8uUmDO0x2Ns20b38lhyNglfxjgPu134au4sjZPvrj4Lm9JalYMpGV1yLYmah
         y7jBsikGFOqGAEph15y9UJnuZdrDHSl4tWgR9Mlc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dinghao Liu <dinghao.liu@zju.edu.cn>,
        Jiri Kosina <jkosina@suse.cz>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 32/78] HID: elan: Fix memleak in elan_input_configured
Date:   Tue, 15 Sep 2020 16:12:57 +0200
Message-Id: <20200915140635.193813299@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200915140633.552502750@linuxfoundation.org>
References: <20200915140633.552502750@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dinghao Liu <dinghao.liu@zju.edu.cn>

[ Upstream commit b7429ea53d6c0936a0f10a5d64164f0aea440143 ]

When input_mt_init_slots() fails, input should be freed
to prevent memleak. When input_register_device() fails,
we should call input_mt_destroy_slots() to free memory
allocated by input_mt_init_slots().

Signed-off-by: Dinghao Liu <dinghao.liu@zju.edu.cn>
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/hid-elan.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/hid/hid-elan.c b/drivers/hid/hid-elan.c
index 07e26c3567eb9..6346282e0ff05 100644
--- a/drivers/hid/hid-elan.c
+++ b/drivers/hid/hid-elan.c
@@ -192,6 +192,7 @@ static int elan_input_configured(struct hid_device *hdev, struct hid_input *hi)
 	ret = input_mt_init_slots(input, ELAN_MAX_FINGERS, INPUT_MT_POINTER);
 	if (ret) {
 		hid_err(hdev, "Failed to init elan MT slots: %d\n", ret);
+		input_free_device(input);
 		return ret;
 	}
 
@@ -202,6 +203,7 @@ static int elan_input_configured(struct hid_device *hdev, struct hid_input *hi)
 	if (ret) {
 		hid_err(hdev, "Failed to register elan input device: %d\n",
 			ret);
+		input_mt_destroy_slots(input);
 		input_free_device(input);
 		return ret;
 	}
-- 
2.25.1



