Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E906845BAC6
	for <lists+stable@lfdr.de>; Wed, 24 Nov 2021 13:12:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243633AbhKXMOl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Nov 2021 07:14:41 -0500
Received: from mail.kernel.org ([198.145.29.99]:47096 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243332AbhKXMN4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Nov 2021 07:13:56 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8D56C6101D;
        Wed, 24 Nov 2021 12:08:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637755696;
        bh=i+Vc6ZI0mQYMNu7f0xZpNAgW7Bx+HwM4CjnCvlnsTdM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nsYPVxBeBVvkdcKpZCkuqsZTPT64K5j6SvZ2bOtURhKoKqmHlDW5kW4GjSZxkQpqo
         LkMfMwIv5GUFQs6ZpeuF3+XT6HfqjrlwGEs0CoN9GA2SL1KHZf0lUx6ajU7CHFnfP+
         oooAskIA2HxrNyz0MTPDrPs7JFdo/rq4UvsXwmRM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Christian Loehle <cloehle@hyperstone.com>,
        Jaehoon Chung <jh80.chung@samsung.com>,
        Ulf Hansson <ulf.hansson@linaro.org>
Subject: [PATCH 4.9 008/207] mmc: dw_mmc: Dont wait for DRTO on Write RSP error
Date:   Wed, 24 Nov 2021 12:54:39 +0100
Message-Id: <20211124115704.226341309@linuxfoundation.org>
X-Mailer: git-send-email 2.34.0
In-Reply-To: <20211124115703.941380739@linuxfoundation.org>
References: <20211124115703.941380739@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christian Löhle <CLoehle@hyperstone.com>

commit 43592c8736e84025d7a45e61a46c3fa40536a364 upstream.

Only wait for DRTO on reads, otherwise the driver hangs.

The driver prevents sending CMD12 on response errors like CRCs. According
to the comment this is because some cards have problems with this during
the UHS tuning sequence. Unfortunately this workaround currently also
applies for any command with data. On reads this will set the drto timer,
which then triggers after a while. On writes this will not set any timer
and the tasklet will not be scheduled again.

I cannot test for the UHS workarounds need, but even if so, it should at
most apply to reads. I have observed many hangs when CMD25 response
contained a CRC error. This patch fixes this without touching the actual
UHS tuning workaround.

Signed-off-by: Christian Loehle <cloehle@hyperstone.com>
Reviewed-by: Jaehoon Chung <jh80.chung@samsung.com>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/af8f8b8674ba4fcc9a781019e4aeb72c@hyperstone.com
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/mmc/host/dw_mmc.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/mmc/host/dw_mmc.c
+++ b/drivers/mmc/host/dw_mmc.c
@@ -1862,7 +1862,8 @@ static void dw_mci_tasklet_func(unsigned
 				 * delayed. Allowing the transfer to take place
 				 * avoids races and keeps things simple.
 				 */
-				if (err != -ETIMEDOUT) {
+				if (err != -ETIMEDOUT &&
+				    host->dir_status == DW_MCI_RECV_STATUS) {
 					state = STATE_SENDING_DATA;
 					continue;
 				}


