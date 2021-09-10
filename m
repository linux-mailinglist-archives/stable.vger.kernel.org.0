Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B1B7A40621E
	for <lists+stable@lfdr.de>; Fri, 10 Sep 2021 02:43:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233065AbhIJAot (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Sep 2021 20:44:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:46744 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229903AbhIJAUj (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 9 Sep 2021 20:20:39 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 51EAA6023D;
        Fri, 10 Sep 2021 00:19:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631233169;
        bh=LHcZQSaHgNN7sDIepppGczWEyEcJELRwPPy6HqdLElY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QYLTa0+7ZNXZEJBVXPoTl/sabHS+WqnyCm4qF3hJLJTPZIZXl8mWVZj5/OLVniElm
         92Ly/WKE4cl86to1fFSyDSef8an1N7CRixpuXyg75dspZ88aQ0Zyr0Tbx8k2WalH6C
         tUyHSgGBIKsfJZ66S0+P5AgVV4Jlg/RmJugPOTj+TUyUeb6z+l8WNF+/LrbGUwQ9c1
         oi/NpfiIN7S506lBe+c8bnxOri7YlIciwX/mkeNflB/JwdqS5kA8yk+i01AZOkArre
         JHau5kXM0L0+vsu687ybM47HkAJBAdnhd5vbTaqXrImu/vhPBfH0hNNkFPO5O/h8Id
         7CBWvH+UIi+Mg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Evgeny Novikov <novikov@ispras.ru>, Jiri Kosina <jkosina@suse.cz>,
        Sasha Levin <sashal@kernel.org>, linux-input@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 5.13 48/88] HID: thrustmaster: Fix memory leak in remove
Date:   Thu,  9 Sep 2021 20:17:40 -0400
Message-Id: <20210910001820.174272-48-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210910001820.174272-1-sashal@kernel.org>
References: <20210910001820.174272-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Evgeny Novikov <novikov@ispras.ru>

[ Upstream commit df3a97bdbc252d3421f1c5d6d713ad6e4f36a469 ]

thrustmaster_remove() does not release memory for
tm_wheel->change_request. This is fixed by the patch.

Found by Linux Driver Verification project (linuxtesting.org).

Signed-off-by: Evgeny Novikov <novikov@ispras.ru>
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/hid-thrustmaster.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/hid/hid-thrustmaster.c b/drivers/hid/hid-thrustmaster.c
index eede9d676bd4..3d49f22a9368 100644
--- a/drivers/hid/hid-thrustmaster.c
+++ b/drivers/hid/hid-thrustmaster.c
@@ -253,6 +253,7 @@ static void thrustmaster_remove(struct hid_device *hdev)
 
 	usb_kill_urb(tm_wheel->urb);
 
+	kfree(tm_wheel->change_request);
 	kfree(tm_wheel->response);
 	kfree(tm_wheel->model_request);
 	usb_free_urb(tm_wheel->urb);
-- 
2.30.2

