Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 944042010AD
	for <lists+stable@lfdr.de>; Fri, 19 Jun 2020 17:36:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393889AbgFSPcb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Jun 2020 11:32:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:36462 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2392989AbgFSPca (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 19 Jun 2020 11:32:30 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6EFF020757;
        Fri, 19 Jun 2020 15:32:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592580749;
        bh=3DVZfoouxhWOLjo4607NGqYfDhv6wvbMfkHVsdTUhTc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=p4sC7Zt6wZYve2vlXXqCHd5B24Xd1kSKqaBikuE3t6pHioRxQjSGGTHmPGrDW1QI9
         msot+wgGIykhLeJgqvQNyZzloJOGutXNAEDx7hmxcPWE5cBFioHXKMfUdPk+UzVCD7
         ZR/1yZDpmsEWpqUnFL/6g7aHuqjmoaem1DhsRmzY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tony Lindgren <tony@atomide.com>,
        "H. Nikolaus Schaller" <hns@goldelico.com>
Subject: [PATCH 5.7 368/376] w1: omap-hdq: fix return value to be -1 if there is a timeout
Date:   Fri, 19 Jun 2020 16:34:46 +0200
Message-Id: <20200619141727.724459819@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200619141710.350494719@linuxfoundation.org>
References: <20200619141710.350494719@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: H. Nikolaus Schaller <hns@goldelico.com>

commit 2d4100632fa1947bf3e8d7a091e94e2cf21923af upstream.

omap_w1_read_byte() should return -1 (or 0xff) in case of
error (e.g. missing battery).

The code accidentially overwrites the variable ret and not val,
which is returned. So it will return the initial value 0 instead
of -1.

Fixes: 27d13da8782a ("w1: omap-hdq: Simplify driver with PM runtime autosuspend")
Cc: stable@vger.kernel.org # v5.6+
Acked-by: Tony Lindgren <tony@atomide.com>
Signed-off-by: H. Nikolaus Schaller <hns@goldelico.com>
Link: https://lore.kernel.org/r/b2c2192b461fbb9b8e9bea4ad514a49557a7210b.1590255176.git.hns@goldelico.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/w1/masters/omap_hdq.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/w1/masters/omap_hdq.c
+++ b/drivers/w1/masters/omap_hdq.c
@@ -464,7 +464,7 @@ static u8 omap_w1_read_byte(void *_hdq)
 
 	ret = hdq_read_byte(hdq_data, &val);
 	if (ret)
-		ret = -1;
+		val = -1;
 
 	pm_runtime_mark_last_busy(hdq_data->dev);
 	pm_runtime_put_autosuspend(hdq_data->dev);


