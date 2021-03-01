Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1524E32848E
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 17:42:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233669AbhCAQh4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 11:37:56 -0500
Received: from mail.kernel.org ([198.145.29.99]:39700 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232529AbhCAQcM (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 11:32:12 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 369F864F21;
        Mon,  1 Mar 2021 16:24:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614615856;
        bh=dZDuYGpAecR4SZKdufLNZDrBQ7R3UW6Uz7HS7zGTTVE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Xp9ZLCbhs2M1BK1xg1yO9+g5cR4gA66id6MzaUyuoi1zF3MEdYwtCGuEfpxcVmZIY
         fuwvg7FPqlWrC3ey3WlLX8Kb77ne7SjBanavcIcrhEELGjrf7Bt6Lp8C+euSxKed1w
         rTl5IGxPA0KutC1U5q4LtGJJ9jfTwTDxep/UnwfQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        Charles Keepax <ckeepax@opensource.cirrus.com>,
        Lee Jones <lee.jones@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 067/134] mfd: wm831x-auxadc: Prevent use after free in wm831x_auxadc_read_irq()
Date:   Mon,  1 Mar 2021 17:12:48 +0100
Message-Id: <20210301161016.852331865@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161013.585393984@linuxfoundation.org>
References: <20210301161013.585393984@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dan Carpenter <dan.carpenter@oracle.com>

[ Upstream commit 26783d74cc6a440ee3ef9836a008a697981013d0 ]

The "req" struct is always added to the "wm831x->auxadc_pending" list,
but it's only removed from the list on the success path.  If a failure
occurs then the "req" struct is freed but it's still on the list,
leading to a use after free.

Fixes: 78bb3688ea18 ("mfd: Support multiple active WM831x AUXADC conversions")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Acked-by: Charles Keepax <ckeepax@opensource.cirrus.com>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mfd/wm831x-auxadc.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/mfd/wm831x-auxadc.c b/drivers/mfd/wm831x-auxadc.c
index fd789d2eb0f52..9f7ae1e1ebcd6 100644
--- a/drivers/mfd/wm831x-auxadc.c
+++ b/drivers/mfd/wm831x-auxadc.c
@@ -98,11 +98,10 @@ static int wm831x_auxadc_read_irq(struct wm831x *wm831x,
 	wait_for_completion_timeout(&req->done, msecs_to_jiffies(500));
 
 	mutex_lock(&wm831x->auxadc_lock);
-
-	list_del(&req->list);
 	ret = req->val;
 
 out:
+	list_del(&req->list);
 	mutex_unlock(&wm831x->auxadc_lock);
 
 	kfree(req);
-- 
2.27.0



