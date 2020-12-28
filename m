Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 207D42E40C3
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 15:57:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2441316AbgL1OQ7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 09:16:59 -0500
Received: from mail.kernel.org ([198.145.29.99]:51890 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2441309AbgL1OQ6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 09:16:58 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8C525224D2;
        Mon, 28 Dec 2020 14:16:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609165003;
        bh=u7U7ZDOaWHRgLeeX7erQMopLpmQycItBIAlMY5QEK9M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=g9WeqvAlaYVKzv51p6dQB0SiksxayVxaKOO91hl0vcbSzPV9nVl2huoCUPw2nts36
         aUT2O4SR94S6xn/lPR4XtOEagVoQi9nacFps8bpExLBYnsPrQGACS+Fa2yM3fL3CSU
         0jHv21ms98WL21h9kE4Pl2hF3PoO976iifFR/LEE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hulk Robot <hulkci@huawei.com>,
        Samuel Thibault <samuel.thibault@ens-lyon.org>,
        Yang Yingliang <yangyingliang@huawei.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 374/717] speakup: fix uninitialized flush_lock
Date:   Mon, 28 Dec 2020 13:46:12 +0100
Message-Id: <20201228125038.927642989@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228125020.963311703@linuxfoundation.org>
References: <20201228125020.963311703@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yang Yingliang <yangyingliang@huawei.com>

[ Upstream commit d1b928ee1cfa965a3327bbaa59bfa005d97fa0fe ]

The flush_lock is uninitialized, use DEFINE_SPINLOCK
to define and initialize flush_lock.

Fixes: c6e3fd22cd53 ("Staging: add speakup to the staging directory")
Reported-by: Hulk Robot <hulkci@huawei.com>
Reviewed-by: Samuel Thibault <samuel.thibault@ens-lyon.org>
Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
Link: https://lore.kernel.org/r/20201117012229.3395186-1-yangyingliang@huawei.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/accessibility/speakup/speakup_dectlk.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/accessibility/speakup/speakup_dectlk.c b/drivers/accessibility/speakup/speakup_dectlk.c
index 780214b5ca16e..ab6d61e80b1cb 100644
--- a/drivers/accessibility/speakup/speakup_dectlk.c
+++ b/drivers/accessibility/speakup/speakup_dectlk.c
@@ -37,7 +37,7 @@ static unsigned char get_index(struct spk_synth *synth);
 static int in_escape;
 static int is_flushing;
 
-static spinlock_t flush_lock;
+static DEFINE_SPINLOCK(flush_lock);
 static DECLARE_WAIT_QUEUE_HEAD(flush);
 
 static struct var_t vars[] = {
-- 
2.27.0



