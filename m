Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D464F3E81E3
	for <lists+stable@lfdr.de>; Tue, 10 Aug 2021 20:05:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236709AbhHJSDe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Aug 2021 14:03:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:60848 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236463AbhHJSBe (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Aug 2021 14:01:34 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E4D6F61245;
        Tue, 10 Aug 2021 17:47:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1628617630;
        bh=F4A9PqwaoJtM8yd3sXAT9iKlCaJnPlx0f98tbF5WRgE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vn/5Wprrr3XWDDcZS/Wpz6Z5BoTMZmB7bSIjiiO0ixGlbe74XzwEPqIGL4fO3gnko
         OGssaN08UCQu8FTCnfhb/Hmg33KCRzGTfw1ZbP2819Pv1wQW2QLellz8VBbapCi8hK
         OP2oUlX9j+DMNL+v9FzFyBZPTad9DcHZyRk+kJXU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Wei Shuyu <wsy@dogben.com>,
        Guoqing Jiang <jiangguoqing@kylinos.cn>,
        Song Liu <song@kernel.org>
Subject: [PATCH 5.13 144/175] md/raid10: properly indicate failure when ending a failed write request
Date:   Tue, 10 Aug 2021 19:30:52 +0200
Message-Id: <20210810173005.704180090@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210810173000.928681411@linuxfoundation.org>
References: <20210810173000.928681411@linuxfoundation.org>
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
@@ -469,12 +469,12 @@ static void raid10_end_write_request(str
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


