Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4FDE425936B
	for <lists+stable@lfdr.de>; Tue,  1 Sep 2020 17:26:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730027AbgIAPZT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Sep 2020 11:25:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:49668 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729446AbgIAPZR (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 1 Sep 2020 11:25:17 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C3FB920FC3;
        Tue,  1 Sep 2020 15:25:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598973917;
        bh=9WsD+M7msmhvOrmHNhbANDUr/qQT8t+aOQRv8aa9ybg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xOmRR5UtgPqNWZJ/+y/PLwlB5uBHwxX48in7LPS812NbnbR+USiITowsJ5UaCBA19
         qkJvYT3WI9hFLV5r40AfWYE8P+y8DK6ShneUJbv8FMzwwL1sY+8b6Vfm8T92w/+eXe
         WqBhb7QomJ71u1x1smChmQ1sGn7cfaFwFEnTWC1k=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Peter Oberparleiter <oberpar@linux.ibm.com>,
        Vineeth Vijayan <vneethv@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 068/125] s390/cio: add cond_resched() in the slow_eval_known_fn() loop
Date:   Tue,  1 Sep 2020 17:10:23 +0200
Message-Id: <20200901150937.911488032@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200901150934.576210879@linuxfoundation.org>
References: <20200901150934.576210879@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vineeth Vijayan <vneethv@linux.ibm.com>

[ Upstream commit 0b8eb2ee9da1e8c9b8082f404f3948aa82a057b2 ]

The scanning through subchannels during the time of an event could
take significant amount of time in case of platforms with lots of
known subchannels. This might result in higher scheduling latencies
for other tasks especially on systems with a single CPU. Add
cond_resched() call, as the loop in slow_eval_known_fn() can be
executed for a longer duration.

Reviewed-by: Peter Oberparleiter <oberpar@linux.ibm.com>
Signed-off-by: Vineeth Vijayan <vneethv@linux.ibm.com>
Signed-off-by: Heiko Carstens <hca@linux.ibm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/s390/cio/css.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/s390/cio/css.c b/drivers/s390/cio/css.c
index df09ed53ab459..825a8f2703b4f 100644
--- a/drivers/s390/cio/css.c
+++ b/drivers/s390/cio/css.c
@@ -615,6 +615,11 @@ static int slow_eval_known_fn(struct subchannel *sch, void *data)
 		rc = css_evaluate_known_subchannel(sch, 1);
 		if (rc == -EAGAIN)
 			css_schedule_eval(sch->schid);
+		/*
+		 * The loop might take long time for platforms with lots of
+		 * known devices. Allow scheduling here.
+		 */
+		cond_resched();
 	}
 	return 0;
 }
-- 
2.25.1



