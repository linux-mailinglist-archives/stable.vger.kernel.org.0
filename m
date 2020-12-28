Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7346F2E3B1A
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 14:46:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404920AbgL1Npq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 08:45:46 -0500
Received: from mail.kernel.org ([198.145.29.99]:46702 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404815AbgL1Npp (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 08:45:45 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 84A77205CB;
        Mon, 28 Dec 2020 13:45:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609163105;
        bh=VgGTA3YBcPeLWz/loPK6cMlvtof5eB9sJVEDR0K/xkw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZqR66Z/b5AniAlBISDRv1prEaYsXfO0Vt71D2BZy7dlBRcDPreZO2BREixdzypaXk
         ZSuSFF8CNr/z/xHoP+U38d029/DG/ZTMJh/TnVbFKWM4DgDq6Bf+5mWtcjlYr0/UQA
         lcR7Eybc2nDvCH4OkCuXLaQkxZRr3YYZxV2v8l4s=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hulk Robot <hulkci@huawei.com>,
        Qinglang Miao <miaoqinglang@huawei.com>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 139/453] media: solo6x10: fix missing snd_card_free in error handling case
Date:   Mon, 28 Dec 2020 13:46:15 +0100
Message-Id: <20201228124943.896603070@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228124937.240114599@linuxfoundation.org>
References: <20201228124937.240114599@linuxfoundation.org>
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
index 30c8f2ec9c3cc..809e4e65bb6e7 100644
--- a/drivers/media/pci/solo6x10/solo6x10-g723.c
+++ b/drivers/media/pci/solo6x10/solo6x10-g723.c
@@ -399,7 +399,7 @@ int solo_g723_init(struct solo_dev *solo_dev)
 
 	ret = snd_ctl_add(card, snd_ctl_new1(&kctl, solo_dev));
 	if (ret < 0)
-		return ret;
+		goto snd_error;
 
 	ret = solo_snd_pcm_init(solo_dev);
 	if (ret < 0)
-- 
2.27.0



