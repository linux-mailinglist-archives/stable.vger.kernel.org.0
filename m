Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 110AC451EE4
	for <lists+stable@lfdr.de>; Tue, 16 Nov 2021 01:35:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348353AbhKPAhx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 19:37:53 -0500
Received: from mail.kernel.org ([198.145.29.99]:45126 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1344697AbhKOTZP (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 14:25:15 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8DF6C60F22;
        Mon, 15 Nov 2021 19:02:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637002952;
        bh=2rl5ivG3QskmxCfIrV4N2n94kntlAyg+m0GxxcbiwOM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HoOKEiJWSIawlKRpYG1j0s2GQtxz64GT8zfC5Sqpv09qq3jsRjkMaijEKtjTwsNXa
         mUJsYl0cI/U00UhkpFYCw8k6157d49qMxBejte9wmPvQeicAIkHoASc0tQ/6jff9Ih
         5U27Bl/fgmoHBKl7uQllcRC4PN4d9INrDkYAVFOk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jacob Pan <jacob.jun.pan@linux.intel.com>,
        Dave Jiang <dave.jiang@intel.com>,
        Vinod Koul <vkoul@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 756/917] dmaengine: idxd: fix resource leak on dmaengine driver disable
Date:   Mon, 15 Nov 2021 18:04:11 +0100
Message-Id: <20211115165454.543685456@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165428.722074685@linuxfoundation.org>
References: <20211115165428.722074685@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dave Jiang <dave.jiang@intel.com>

[ Upstream commit a3e340c1574b6679f5b333221284d0959095da52 ]

The wq resources needs to be released before the kernel type is reset by
__drv_disable_wq(). With dma channels unregistered and wq quiesced, all the
wq resources for dmaengine can be freed. There is no need to wait until wq
is disabled. With the wq->type being reset to "unknown", the driver is
skipping the freeing of the resources.

Fixes: 0cda4f6986a3 ("dmaengine: idxd: create dmaengine driver for wq 'device'")
Reported-by: Jacob Pan <jacob.jun.pan@linux.intel.com>
Tested-by: Jacob Pan <jacob.jun.pan@linux.intel.com>
Signed-off-by: Dave Jiang <dave.jiang@intel.com>
Link: https://lore.kernel.org/r/163517405099.3484556.12521975053711345244.stgit@djiang5-desk3.ch.intel.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dma/idxd/dma.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/dma/idxd/dma.c b/drivers/dma/idxd/dma.c
index b90b085d18cff..c39e9483206ad 100644
--- a/drivers/dma/idxd/dma.c
+++ b/drivers/dma/idxd/dma.c
@@ -329,10 +329,9 @@ static void idxd_dmaengine_drv_remove(struct idxd_dev *idxd_dev)
 	mutex_lock(&wq->wq_lock);
 	idxd_wq_quiesce(wq);
 	idxd_unregister_dma_channel(wq);
+	idxd_wq_free_resources(wq);
 	__drv_disable_wq(wq);
 	percpu_ref_exit(&wq->wq_active);
-	idxd_wq_free_resources(wq);
-	wq->type = IDXD_WQT_NONE;
 	mutex_unlock(&wq->wq_lock);
 }
 
-- 
2.33.0



