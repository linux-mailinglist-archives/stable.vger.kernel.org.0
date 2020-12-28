Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2D2E72E65E6
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 17:08:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393226AbgL1QG4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 11:06:56 -0500
Received: from mail.kernel.org ([198.145.29.99]:54984 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389468AbgL1N00 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 08:26:26 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 56AAD22472;
        Mon, 28 Dec 2020 13:26:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609161970;
        bh=R4HCVuJckncNo86rai/qnKyc5qFsGtAwEsI37fni8L8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=J0xcdKx3Uc38BZH7sDHLsjMtjgXH3qoikyZsIdLYJU4OBWJUhuxAp/APm1StNsI6A
         AYu9y74bZkr8KpNbccSmMnnD5jR6ayemVsWcP76YmbS3ZDZDM33EZ7dwSt9V/hf6hs
         Tf2F/U/8VGO0i+nM61wOTwoTFuX0LBImGCRI71aM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hulk Robot <hulkci@huawei.com>,
        Qinglang Miao <miaoqinglang@huawei.com>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 144/346] media: solo6x10: fix missing snd_card_free in error handling case
Date:   Mon, 28 Dec 2020 13:47:43 +0100
Message-Id: <20201228124926.748333114@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228124919.745526410@linuxfoundation.org>
References: <20201228124919.745526410@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Qinglang Miao <miaoqinglang@huawei.com>

[ Upstream commit dcdff74fa6bc00c32079d0bebd620764c26f2d89 ]

Fix to goto snd_error in error handling case when fails
to do snd_ctl_add, as done elsewhere in this function.

Fixes: 28cae868cd24 ("[media] solo6x10: move out of staging into drivers/media/pci.")
Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Qinglang Miao <miaoqinglang@huawei.com>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/pci/solo6x10/solo6x10-g723.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/pci/solo6x10/solo6x10-g723.c b/drivers/media/pci/solo6x10/solo6x10-g723.c
index 2ac33b5cc4546..f06e6d35d846c 100644
--- a/drivers/media/pci/solo6x10/solo6x10-g723.c
+++ b/drivers/media/pci/solo6x10/solo6x10-g723.c
@@ -410,7 +410,7 @@ int solo_g723_init(struct solo_dev *solo_dev)
 
 	ret = snd_ctl_add(card, snd_ctl_new1(&kctl, solo_dev));
 	if (ret < 0)
-		return ret;
+		goto snd_error;
 
 	ret = solo_snd_pcm_init(solo_dev);
 	if (ret < 0)
-- 
2.27.0



