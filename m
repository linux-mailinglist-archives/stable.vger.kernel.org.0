Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4EB1D25927C
	for <lists+stable@lfdr.de>; Tue,  1 Sep 2020 17:13:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728826AbgIAPMz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Sep 2020 11:12:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:55550 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728820AbgIAPMx (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 1 Sep 2020 11:12:53 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 354D42078B;
        Tue,  1 Sep 2020 15:12:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598973172;
        bh=BWK2hS0GdXLTqvn3LCDebg7pXZphF7c3VLKfxq34sFk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zbZBpOFbvapX3/RF5Q+n2i6d4h8YGkxCuXQWDKWtP+xqRa1dQE2hh4xkg5KXCFXFL
         YWoPOJfahju9kLjR8OkAl73hn//8lm+iyUOQ6tWi1TjEz/rDV+BS2CDbPytsG3xUJw
         QiQxvLJtRJkXIUpES2r/h6LR4zIaikq8ahvhzFec=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Peter Oberparleiter <oberpar@linux.ibm.com>,
        Vineeth Vijayan <vneethv@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 36/62] s390/cio: add cond_resched() in the slow_eval_known_fn() loop
Date:   Tue,  1 Sep 2020 17:10:19 +0200
Message-Id: <20200901150922.532967816@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200901150920.697676718@linuxfoundation.org>
References: <20200901150920.697676718@linuxfoundation.org>
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
index 8ecc956ecb59c..370a3a2c6de73 100644
--- a/drivers/s390/cio/css.c
+++ b/drivers/s390/cio/css.c
@@ -529,6 +529,11 @@ static int slow_eval_known_fn(struct subchannel *sch, void *data)
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



