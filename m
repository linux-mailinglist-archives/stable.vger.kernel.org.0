Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 67DF237CB1A
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 18:56:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241668AbhELQef (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 12:34:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:42392 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241453AbhELQ1T (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 12:27:19 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E1F2261425;
        Wed, 12 May 2021 15:52:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620834758;
        bh=Z838IHtBSpy4vVydyniDB94gXihDeP/mBoJnq9tmU0M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CiBoyWPBgCX/fAomnpFahmNYsZQudZ0RH0Tb2PKF/tLoqZsl3DlmZPm1sEAEjCtSW
         36r+qNUy/53qbqPWnZ4UZbUSbR+aMzEGO27h6Sk8RgA5RHy6HKHfuvvOhHITCTpqd6
         oSacFC50U6VSAv1xyx50bm6TC0cuo9wtJi/os3n8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lukasz Luba <lukasz.luba@arm.com>,
        Chanwoo Choi <cw00.choi@samsung.com>
Subject: [PATCH 5.12 037/677] PM / devfreq: Unlock mutex and free devfreq struct in error path
Date:   Wed, 12 May 2021 16:41:23 +0200
Message-Id: <20210512144838.447631168@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210512144837.204217980@linuxfoundation.org>
References: <20210512144837.204217980@linuxfoundation.org>
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
@@ -821,7 +821,8 @@ struct devfreq *devfreq_add_device(struc
 
 	if (devfreq->profile->timer < 0
 		|| devfreq->profile->timer >= DEVFREQ_TIMER_NUM) {
-		goto err_out;
+		mutex_unlock(&devfreq->lock);
+		goto err_dev;
 	}
 
 	if (!devfreq->profile->max_state && !devfreq->profile->freq_table) {


