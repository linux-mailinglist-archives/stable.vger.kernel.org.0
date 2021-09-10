Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BE770406171
	for <lists+stable@lfdr.de>; Fri, 10 Sep 2021 02:41:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240661AbhIJAmy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Sep 2021 20:42:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:43506 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232178AbhIJASo (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 9 Sep 2021 20:18:44 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3B839611C5;
        Fri, 10 Sep 2021 00:17:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631233035;
        bh=8UHya4BeRSSQoQtCkxlbxEoRKENCHenX+bLVQL2y0dk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mbBhkJeVjnR4xKKgHlWLUvbfIqFxzQLfm6p9sMsWECqH8FgPQ1kzBoKLWjcfKYfrs
         hyr+yCaViGNZ4dWmAFciShchO2uJxTYuX1yIEZDYPzL1AU1xo6S4x5jeTbylRRh7ah
         uQZJGud3uGdtWeKi5MIbzngv9Oiid8X3sygaar5v/36l0fizsfIINKp/o2lfM7S6ql
         gjn9oNNJmrF42qUCGDzc2Jg/5hKzvyKuZrRntSSlA73naCDUzHi4e6NULrXN6eJdMV
         cqnN75W7eRQncA05C3SOP9ex53FBT2xmrXklJsRvkqrFWAp2zQB62BJFYGcon1Br/e
         Dq7w4WWUD+6iQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Evgeny Novikov <novikov@ispras.ru>, Jiri Kosina <jkosina@suse.cz>,
        Sasha Levin <sashal@kernel.org>, linux-input@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 5.14 55/99] HID: thrustmaster: Fix memory leak in thrustmaster_interrupts()
Date:   Thu,  9 Sep 2021 20:15:14 -0400
Message-Id: <20210910001558.173296-55-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210910001558.173296-1-sashal@kernel.org>
References: <20210910001558.173296-1-sashal@kernel.org>
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
index 9cb4248f95af..d44550aa8805 100644
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

