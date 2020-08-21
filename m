Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AD64324DE41
	for <lists+stable@lfdr.de>; Fri, 21 Aug 2020 19:29:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728208AbgHUR2N (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 21 Aug 2020 13:28:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:46686 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727024AbgHUQOr (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 21 Aug 2020 12:14:47 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 297DD20855;
        Fri, 21 Aug 2020 16:14:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598026483;
        bh=6AiJeu8UD5jdIPklU0UJ85alxQ5UPRtJBuOG4bUtfxI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=aunaR5FBdgQt5wL42NKzGamqwzNXUyi6DEPTvvWE1Dy9It7NKiCigUYdVlX7FmQ7S
         LCg/cylpYLQ4Hwdu9QblneSmZ9OyNQ2WOECr3Qu6pp4N0jJv184wHz233y/sNsgEMV
         VSszcKZYfstI0+vuTXEGxSMDgn6CKaQZgUVlk940=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Evgeny Novikov <novikov@ispras.ru>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>, devel@driverdev.osuosl.org
Subject: [PATCH AUTOSEL 5.8 16/62] staging: rts5208: fix memleaks on error handling paths in probe
Date:   Fri, 21 Aug 2020 12:13:37 -0400
Message-Id: <20200821161423.347071-16-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200821161423.347071-1-sashal@kernel.org>
References: <20200821161423.347071-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Evgeny Novikov <novikov@ispras.ru>

[ Upstream commit 11507bf9a8832741db69efd32bf09a2ab26426bf ]

rtsx_probe() allocates host, but does not free it on error handling
paths. The patch adds missed scsi_host_put().

Found by Linux Driver Verification project (linuxtesting.org).

Signed-off-by: Evgeny Novikov <novikov@ispras.ru>
Link: https://lore.kernel.org/r/20200623141230.7258-1-novikov@ispras.ru
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/staging/rts5208/rtsx.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/staging/rts5208/rtsx.c b/drivers/staging/rts5208/rtsx.c
index be0053c795b7a..937f4e732a75c 100644
--- a/drivers/staging/rts5208/rtsx.c
+++ b/drivers/staging/rts5208/rtsx.c
@@ -972,6 +972,7 @@ static int rtsx_probe(struct pci_dev *pci,
 	kfree(dev->chip);
 chip_alloc_fail:
 	dev_err(&pci->dev, "%s failed\n", __func__);
+	scsi_host_put(host);
 scsi_host_alloc_fail:
 	pci_release_regions(pci);
 	return err;
-- 
2.25.1

