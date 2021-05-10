Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CAFBF378504
	for <lists+stable@lfdr.de>; Mon, 10 May 2021 13:21:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232137AbhEJK6I (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 May 2021 06:58:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:41986 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232403AbhEJKw3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 May 2021 06:52:29 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0A9A261C19;
        Mon, 10 May 2021 10:41:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620643273;
        bh=29DoPG3qtHfvm9IGlve0Xe329ZBTFbZ0k6Oc7+oTeas=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oXr5/D/ZMX0EbHPEdMGB6dwAMDhqFHkVJjRpB7enchlrnpCwmsyhcqaTm3k3vbE1t
         /EVWbO8etICDocaAzCHEOWPfWNrf6lVcHsQGzAVba/Kyc29FzSYS7iq6GYf9G8t7Y2
         LoN/a2ee8YKtZOC94g//fxeUBZbw/zpVD1KzomUU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Paul Clements <paul.clements@us.sios.com>,
        Song Liu <song@kernel.org>
Subject: [PATCH 5.10 249/299] md/raid1: properly indicate failure when ending a failed write request
Date:   Mon, 10 May 2021 12:20:46 +0200
Message-Id: <20210510102013.184628598@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210510102004.821838356@linuxfoundation.org>
References: <20210510102004.821838356@linuxfoundation.org>
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


