Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0C5743E809F
	for <lists+stable@lfdr.de>; Tue, 10 Aug 2021 19:51:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235456AbhHJRvC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Aug 2021 13:51:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:55516 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236623AbhHJRtd (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Aug 2021 13:49:33 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 994E66124B;
        Tue, 10 Aug 2021 17:41:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1628617306;
        bh=oB0hprW6J5hYBJxtKmiWG+da6M0HtAcv804jgpvC75U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Pi0+njE8xnkPSAI5CFLYeKwZe94HhvdLMUP/d5LXog81M7AQWQFZHxwwxV/vX5Nhe
         qVC7ivslcdGnKC9tAw0Bk02LRNbZYtuONPOCJsnHDcif0/+CsPK6lJx1/CVzWzJdiy
         9w1xrPR1n4AXVNy4PUXDz+lZkoiDoN3Q7CZuI6dE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Wei Shuyu <wsy@dogben.com>,
        Guoqing Jiang <jiangguoqing@kylinos.cn>,
        Song Liu <song@kernel.org>
Subject: [PATCH 5.10 109/135] md/raid10: properly indicate failure when ending a failed write request
Date:   Tue, 10 Aug 2021 19:30:43 +0200
Message-Id: <20210810172959.477804309@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210810172955.660225700@linuxfoundation.org>
References: <20210810172955.660225700@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Wei Shuyu <wsy@dogben.com>

commit 5ba03936c05584b6f6f79be5ebe7e5036c1dd252 upstream.

Similar to [1], this patch fixes the same bug in raid10. Also cleanup the
comments.

[1] commit 2417b9869b81 ("md/raid1: properly indicate failure when ending
                         a failed write request")
Cc: stable@vger.kernel.org
Fixes: 7cee6d4e6035 ("md/raid10: end bio when the device faulty")
Signed-off-by: Wei Shuyu <wsy@dogben.com>
Acked-by: Guoqing Jiang <jiangguoqing@kylinos.cn>
Signed-off-by: Song Liu <song@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/md/raid1.c  |    2 --
 drivers/md/raid10.c |    4 ++--
 2 files changed, 2 insertions(+), 4 deletions(-)

--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -472,8 +472,6 @@ static void raid1_end_write_request(stru
 		/*
 		 * When the device is faulty, it is not necessary to
 		 * handle write error.
-		 * For failfast, this is the only remaining device,
-		 * We need to retry the write without FailFast.
 		 */
 		if (!test_bit(Faulty, &rdev->flags))
 			set_bit(R1BIO_WriteError, &r1_bio->state);
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -470,12 +470,12 @@ static void raid10_end_write_request(str
 			/*
 			 * When the device is faulty, it is not necessary to
 			 * handle write error.
-			 * For failfast, this is the only remaining device,
-			 * We need to retry the write without FailFast.
 			 */
 			if (!test_bit(Faulty, &rdev->flags))
 				set_bit(R10BIO_WriteError, &r10_bio->state);
 			else {
+				/* Fail the request */
+				set_bit(R10BIO_Degraded, &r10_bio->state);
 				r10_bio->devs[slot].bio = NULL;
 				to_put = bio;
 				dec_rdev = 1;


