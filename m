Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 44C2137C30D
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 17:18:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232160AbhELPRJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 11:17:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:50812 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233159AbhELPOG (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 11:14:06 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7D4266144A;
        Wed, 12 May 2021 15:04:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620831873;
        bh=0010i4RCcXxKJiJqPJqva1zlyAkPgNHeaAQA1qXlQG4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZfpsFudK8M1H51mPHm1HW++x+6ZQn3IOaUVGEQSAOYjjKgspQ0Uj3L5VT+jKZ7f4b
         NxBl0+e4GHaJIdzF6tLWTfba72BmVD8oGUSNxSeuPv0f7RU3wN6SsMfOXatCHYkWu8
         Zr9DnG++vFbPxrmNIKNjepA4GCbCOgbMMbAseKP8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lukasz Luba <lukasz.luba@arm.com>,
        Chanwoo Choi <cw00.choi@samsung.com>
Subject: [PATCH 5.10 032/530] PM / devfreq: Unlock mutex and free devfreq struct in error path
Date:   Wed, 12 May 2021 16:42:22 +0200
Message-Id: <20210512144820.787876754@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210512144819.664462530@linuxfoundation.org>
References: <20210512144819.664462530@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lukasz Luba <lukasz.luba@arm.com>

commit 8b50a7995770d41a2e8d9c422cd2882aca0dedd2 upstream.

The devfreq->lock is held for time of setup. Release the lock in the
error path, before jumping to the end of the function.

Change the goto destination which frees the allocated memory.

Cc: v5.9+ <stable@vger.kernel.org> # v5.9+
Fixes: 4dc3bab8687f ("PM / devfreq: Add support delayed timer for polling mode")
Signed-off-by: Lukasz Luba <lukasz.luba@arm.com>
Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/devfreq/devfreq.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/devfreq/devfreq.c
+++ b/drivers/devfreq/devfreq.c
@@ -788,7 +788,8 @@ struct devfreq *devfreq_add_device(struc
 
 	if (devfreq->profile->timer < 0
 		|| devfreq->profile->timer >= DEVFREQ_TIMER_NUM) {
-		goto err_out;
+		mutex_unlock(&devfreq->lock);
+		goto err_dev;
 	}
 
 	if (!devfreq->profile->max_state && !devfreq->profile->freq_table) {


