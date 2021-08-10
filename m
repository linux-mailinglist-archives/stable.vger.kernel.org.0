Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ED4843E7F4B
	for <lists+stable@lfdr.de>; Tue, 10 Aug 2021 19:41:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234065AbhHJRjs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Aug 2021 13:39:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:37254 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234257AbhHJRhK (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Aug 2021 13:37:10 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6758F60295;
        Tue, 10 Aug 2021 17:35:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1628616959;
        bh=K42bGWNxHrgDLBVJIrAu0dnTY4Fm2tfgkVSEZ0fd0xk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ugevDNuCqy/Va3ZgtmDLc1qdsNbU32nkrA3898OCX4xIReRPz631fH6OJb9UT5sXu
         MjdQ/3lxDYbT9IUQuVC+aeLdR2qmJgDDjyxM0ryqdYpR3MUxn1s0JxZI2+3bXqbOnO
         Uho+l9fbyvSrcc1Dm+/tPbmcqoyo+WP3i25N7rEk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Wei Shuyu <wsy@dogben.com>,
        Guoqing Jiang <jiangguoqing@kylinos.cn>,
        Song Liu <song@kernel.org>
Subject: [PATCH 5.4 69/85] md/raid10: properly indicate failure when ending a failed write request
Date:   Tue, 10 Aug 2021 19:30:42 +0200
Message-Id: <20210810172950.576307848@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210810172948.192298392@linuxfoundation.org>
References: <20210810172948.192298392@linuxfoundation.org>
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
@@ -452,8 +452,6 @@ static void raid1_end_write_request(stru
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


