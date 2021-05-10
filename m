Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 880C63786DF
	for <lists+stable@lfdr.de>; Mon, 10 May 2021 13:32:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232498AbhEJLLy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 May 2021 07:11:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:36378 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234842AbhEJLFV (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 May 2021 07:05:21 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id DC48B610C9;
        Mon, 10 May 2021 10:55:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620644112;
        bh=29DoPG3qtHfvm9IGlve0Xe329ZBTFbZ0k6Oc7+oTeas=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HshRNBvdC2NI8dLP7DiBySPUAmDwnEwzK1OqOe05zn+/asiseQi4+krWmZ6HwA7kt
         jMDUJWr8L5jcPz2IIMAF5R5eIr6Scymj1hzixLVBcZgIUIg1WrNMXtB9BfjF77z9qJ
         H0L1WqPqPIRD7wTUDareLyT+6QiveojvAx8GOWXs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Paul Clements <paul.clements@us.sios.com>,
        Song Liu <song@kernel.org>
Subject: [PATCH 5.11 285/342] md/raid1: properly indicate failure when ending a failed write request
Date:   Mon, 10 May 2021 12:21:15 +0200
Message-Id: <20210510102019.518986592@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210510102010.096403571@linuxfoundation.org>
References: <20210510102010.096403571@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Paul Clements <paul.clements@us.sios.com>

commit 2417b9869b81882ab90fd5ed1081a1cb2d4db1dd upstream.

This patch addresses a data corruption bug in raid1 arrays using bitmaps.
Without this fix, the bitmap bits for the failed I/O end up being cleared.

Since we are in the failure leg of raid1_end_write_request, the request
either needs to be retried (R1BIO_WriteError) or failed (R1BIO_Degraded).

Fixes: eeba6809d8d5 ("md/raid1: end bio when the device faulty")
Cc: stable@vger.kernel.org # v5.2+
Signed-off-by: Paul Clements <paul.clements@us.sios.com>
Signed-off-by: Song Liu <song@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/md/raid1.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -478,6 +478,8 @@ static void raid1_end_write_request(stru
 		if (!test_bit(Faulty, &rdev->flags))
 			set_bit(R1BIO_WriteError, &r1_bio->state);
 		else {
+			/* Fail the request */
+			set_bit(R1BIO_Degraded, &r1_bio->state);
 			/* Finished with this branch */
 			r1_bio->bios[mirror] = NULL;
 			to_put = bio;


