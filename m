Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0747B27C6E3
	for <lists+stable@lfdr.de>; Tue, 29 Sep 2020 13:49:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731001AbgI2Ltg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 29 Sep 2020 07:49:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:52990 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731233AbgI2Ltd (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 29 Sep 2020 07:49:33 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 799392083B;
        Tue, 29 Sep 2020 11:49:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601380173;
        bh=dxPpxSbDhDVP+tBuEJq8inmYWdynhbHXvHJzggsHjJ0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Nfnrdkh5/iUHb4DSlBkD2fgDC+4fQ4SFdbyEZltwwnbLfRSRa3BNgDYBchdND994w
         monMI6fyLENl3wRAZD+ZcPW/eo653kPe/6WlnxXDIyu2lJWI4TpCf+j1mDiwd55mUs
         RvZYW7Ii24E4DjX1LEHmlqj3tacwvUzJfvi2xCRU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Subject: [PATCH 5.8 88/99] media: cec-adap.c: dont use flush_scheduled_work()
Date:   Tue, 29 Sep 2020 13:02:11 +0200
Message-Id: <20200929105934.069653553@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200929105929.719230296@linuxfoundation.org>
References: <20200929105929.719230296@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hans Verkuil <hverkuil-cisco@xs4all.nl>

commit 288eceb0858323d66bff03cf386630a797b248ad upstream.

For some inexplicable reason I decided to call flush_scheduled_work()
instead of cancel_delayed_work_sync(). The problem with that is that
flush_scheduled_work() waits for *all* queued scheduled work to be
completed instead of just the work itself.

This can cause a deadlock if a CEC driver also schedules work that
takes the same lock. See the comments for flush_scheduled_work() in
linux/workqueue.h.

This is exactly what has been observed a few times.

This patch simply replaces flush_scheduled_work() by
cancel_delayed_work_sync().

Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Cc: <stable@vger.kernel.org>      # for v5.8 and up
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/media/cec/core/cec-adap.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/media/cec/core/cec-adap.c
+++ b/drivers/media/cec/core/cec-adap.c
@@ -1199,7 +1199,7 @@ void cec_received_msg_ts(struct cec_adap
 			/* Cancel the pending timeout work */
 			if (!cancel_delayed_work(&data->work)) {
 				mutex_unlock(&adap->lock);
-				flush_scheduled_work();
+				cancel_delayed_work_sync(&data->work);
 				mutex_lock(&adap->lock);
 			}
 			/*


