Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 78CB2406220
	for <lists+stable@lfdr.de>; Fri, 10 Sep 2021 02:43:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241499AbhIJAou (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Sep 2021 20:44:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:46756 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233706AbhIJAUk (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 9 Sep 2021 20:20:40 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B373E610E9;
        Fri, 10 Sep 2021 00:19:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631233170;
        bh=KLd+OUWee6OE1PGCgCqHKf9kavtJESIJfNBfnauKDN0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=l73uTNJoZWCd9Pb/cwkkmCZJ3FkpK0i5qRGFXXGsQiYI6WGnzGfNnndmiaO/07Peh
         TB6E5dkwmnDNyfNzF9izkhVnuG02I+VXL58Quc1NrNmAA4hCbpf1b7K+d+A8LTn2BC
         rDSrRROI3CPYctHuF+xss0Pyx1234EkrUff9PyDdUCMLEHjcd8TyPrh/2IblLmpAAR
         foK2lNN1IZ0zXt7IycyoZd6Dh4VQyEDXW8dK9SGN9n2YL2zVD98m2pCCDYP+0I6H6v
         rX+c+WwShL/KfoqMhRbGfvsfTwumjRLcC9LFFMrGumAuG1FVJP9Bw0oSFySHyz3JKd
         f+CQNECIKRd2A==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Evgeny Novikov <novikov@ispras.ru>, Jiri Kosina <jkosina@suse.cz>,
        Sasha Levin <sashal@kernel.org>, linux-input@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 5.13 49/88] HID: thrustmaster: Fix memory leak in thrustmaster_interrupts()
Date:   Thu,  9 Sep 2021 20:17:41 -0400
Message-Id: <20210910001820.174272-49-sashal@kernel.org>
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

[ Upstream commit c3800eed22d21c66912b4461a403b4448ed88d95 ]

thrustmaster_interrupts() does not free memory for send_buf when
usb_interrupt_msg() fails. This is fixed by the given patch.

Found by Linux Driver Verification project (linuxtesting.org).

Signed-off-by: Evgeny Novikov <novikov@ispras.ru>
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/hid-thrustmaster.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/hid/hid-thrustmaster.c b/drivers/hid/hid-thrustmaster.c
index 3d49f22a9368..7c00c48cc20b 100644
--- a/drivers/hid/hid-thrustmaster.c
+++ b/drivers/hid/hid-thrustmaster.c
@@ -173,6 +173,7 @@ static void thrustmaster_interrupts(struct hid_device *hdev)
 
 		if (ret) {
 			hid_err(hdev, "setup data couldn't be sent\n");
+			kfree(send_buf);
 			return;
 		}
 	}
-- 
2.30.2

