Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1EE26450EE5
	for <lists+stable@lfdr.de>; Mon, 15 Nov 2021 19:18:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237888AbhKOSVU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 13:21:20 -0500
Received: from mail.kernel.org ([198.145.29.99]:56272 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241130AbhKOSSa (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 13:18:30 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id F1F3A633F4;
        Mon, 15 Nov 2021 17:51:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1636998667;
        bh=tMShxtJVAtxPL6k7DwggB9SbQYjZfAmOySRFLhJ0XzY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rrfkQagF5tAvcbnTPqV3dknEjM2OXokl1kznLNZWEP760qGH2JDQ1df8tgx+JluKe
         dbZhmG/zXRwVAmmF4wU5BBsjt1C4v8DaZ1gun47R7keroMgA9Fpjc8pP1eRxQHAOyg
         M2CBKzkL38MbxtLVCmEspfBZbd/s+L2KImW28oPo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Christian Loehle <cloehle@hyperstone.com>,
        Jaehoon Chung <jh80.chung@samsung.com>,
        Ulf Hansson <ulf.hansson@linaro.org>
Subject: [PATCH 5.14 017/849] mmc: dw_mmc: Dont wait for DRTO on Write RSP error
Date:   Mon, 15 Nov 2021 17:51:40 +0100
Message-Id: <20211115165420.585133303@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165419.961798833@linuxfoundation.org>
References: <20211115165419.961798833@linuxfoundation.org>
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
@@ -2014,7 +2014,8 @@ static void dw_mci_tasklet_func(struct t
 				 * delayed. Allowing the transfer to take place
 				 * avoids races and keeps things simple.
 				 */
-				if (err != -ETIMEDOUT) {
+				if (err != -ETIMEDOUT &&
+				    host->dir_status == DW_MCI_RECV_STATUS) {
 					state = STATE_SENDING_DATA;
 					continue;
 				}


