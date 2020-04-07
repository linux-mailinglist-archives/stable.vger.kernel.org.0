Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2C7D61A0B47
	for <lists+stable@lfdr.de>; Tue,  7 Apr 2020 12:26:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728882AbgDGKZI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Apr 2020 06:25:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:35592 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728880AbgDGKZI (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 7 Apr 2020 06:25:08 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 010182074B;
        Tue,  7 Apr 2020 10:25:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1586255107;
        bh=sKbjwMLJiBOphC69hyUcwuxnGfiE7NbpZaWocYhiKBI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IVdc99VgMFf76EWBozzgWB856yo84dwI3/Nf9OLFVAOaj9uXZeF3bxu5YViMECGD+
         7/m2oY+W+EXrpmhjBWszAbw85PpZ0PNN+SXd0RXVIsGrGmEHRCSuBjLR5IGRWmzrPa
         GffIvQeXbmdfl7jvQZOGu/PhKY+IZVp2ZPwnfCrs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?J=C3=A9r=C3=B4me=20Pouiller?= 
        <jerome.pouiller@silabs.com>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.5 08/46] staging: wfx: fix warning about freeing in-use mutex during device unregister
Date:   Tue,  7 Apr 2020 12:21:39 +0200
Message-Id: <20200407101500.370794039@linuxfoundation.org>
X-Mailer: git-send-email 2.26.0
In-Reply-To: <20200407101459.502593074@linuxfoundation.org>
References: <20200407101459.502593074@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jérôme Pouiller <jerome.pouiller@silabs.com>

[ Upstream commit bab0a0b03442a62fe3abefcb2169e0b9ff95990c ]

After hif_shutdown(), communication with the chip is no more possible.
It the only request that never reply. Therefore, hif_cmd.lock is never
unlocked. hif_shutdown() unlock itself hif_cmd.lock to avoid a potential
warning during disposal of device. hif_cmd.key_renew_lock should also
been unlocked for the same reason.

Signed-off-by: Jérôme Pouiller <jerome.pouiller@silabs.com>
Link: https://lore.kernel.org/r/20200310101356.182818-2-Jerome.Pouiller@silabs.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/staging/wfx/hif_tx.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/staging/wfx/hif_tx.c b/drivers/staging/wfx/hif_tx.c
index cb7cddcb98159..16e7d190430f3 100644
--- a/drivers/staging/wfx/hif_tx.c
+++ b/drivers/staging/wfx/hif_tx.c
@@ -141,6 +141,7 @@ int hif_shutdown(struct wfx_dev *wdev)
 	else
 		control_reg_write(wdev, 0);
 	mutex_unlock(&wdev->hif_cmd.lock);
+	mutex_unlock(&wdev->hif_cmd.key_renew_lock);
 	kfree(hif);
 	return ret;
 }
-- 
2.20.1



