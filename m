Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 22806287DD
	for <lists+stable@lfdr.de>; Thu, 23 May 2019 21:26:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390864AbfEWTYT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 May 2019 15:24:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:35190 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389827AbfEWTYR (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 23 May 2019 15:24:17 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DC5C02184E;
        Thu, 23 May 2019 19:24:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1558639457;
        bh=tYOK5UjmDOen6D4s1GWJrMLr3jUVp3wk9PRppDv5W7Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=h0nmkJKePFW96EyhPG0PgTWSi4UzeC0+e3EM5mBQt9Dp6i+JYJp2IbKtxJJLPVfMr
         zJ4XTjbr+Y1H2WZtDRzQUkrCiqKsv6UOf9c5a1TtokC3dnbbw4m7KQwy5EotqHCKtg
         u+sPRwRZOiqY1NJ3TeApQGUztB+xSDZnkqLLligI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Mikulas Patocka <mpatocka@redhat.com>,
        Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH 5.0 095/139] dm delay: fix a crash when invalid device is specified
Date:   Thu, 23 May 2019 21:06:23 +0200
Message-Id: <20190523181732.964946960@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190523181720.120897565@linuxfoundation.org>
References: <20190523181720.120897565@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mikulas Patocka <mpatocka@redhat.com>

commit 81bc6d150ace6250503b825d9d0c10f7bbd24095 upstream.

When the target line contains an invalid device, delay_ctr() will call
delay_dtr() with NULL workqueue.  Attempting to destroy the NULL
workqueue causes a crash.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Cc: stable@vger.kernel.org
Signed-off-by: Mike Snitzer <snitzer@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/md/dm-delay.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/md/dm-delay.c
+++ b/drivers/md/dm-delay.c
@@ -121,7 +121,8 @@ static void delay_dtr(struct dm_target *
 {
 	struct delay_c *dc = ti->private;
 
-	destroy_workqueue(dc->kdelayd_wq);
+	if (dc->kdelayd_wq)
+		destroy_workqueue(dc->kdelayd_wq);
 
 	if (dc->read.dev)
 		dm_put_device(ti, dc->read.dev);


