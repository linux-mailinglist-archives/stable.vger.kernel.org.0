Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C9EF6378583
	for <lists+stable@lfdr.de>; Mon, 10 May 2021 13:28:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235301AbhEJLAi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 May 2021 07:00:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:52738 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234297AbhEJK4J (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 May 2021 06:56:09 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 45ECC61482;
        Mon, 10 May 2021 10:45:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620643513;
        bh=l9NlGs+WrWkWkP50pal1oVEQ6Gaug3majrHyfjRKi2g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=e5thVzP8uSCGOQGrIuoEpx1JGn4DtjZsB3O4zhCSyKp9MsE4c9ajesD++d9kdojm0
         X2N3rmJU1uEIo1VUjE0CZYZ1wiffOrDyvm9kRK1mfVoTkOC7yhRYHPbA25fm2x1LiP
         Xx4jVgWjs/O4n2G+L1kXWhOVUHLWB3ln+c7VGVjw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, DooHyun Hwang <dh0421.hwang@samsung.com>,
        Ulf Hansson <ulf.hansson@linaro.org>
Subject: [PATCH 5.11 045/342] mmc: core: Do a power cycle when the CMD11 fails
Date:   Mon, 10 May 2021 12:17:15 +0200
Message-Id: <20210510102011.616859851@linuxfoundation.org>
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

From: DooHyun Hwang <dh0421.hwang@samsung.com>

commit 147186f531ae49c18b7a9091a2c40e83b3d95649 upstream.

A CMD11 is sent to the SD/SDIO card to start the voltage switch procedure
into 1.8V I/O. According to the SD spec a power cycle is needed of the
card, if it turns out that the CMD11 fails. Let's fix this, to allow a
retry of the initialization without the voltage switch, to succeed.

Note that, whether it makes sense to also retry with the voltage switch
after the power cycle is a bit more difficult to know. At this point, we
treat it like the CMD11 isn't supported and therefore we skip it when
retrying.

Signed-off-by: DooHyun Hwang <dh0421.hwang@samsung.com>
Link: https://lore.kernel.org/r/20210210045936.7809-1-dh0421.hwang@samsung.com
Cc: stable@vger.kernel.org
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/mmc/core/core.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/mmc/core/core.c
+++ b/drivers/mmc/core/core.c
@@ -1204,7 +1204,7 @@ int mmc_set_uhs_voltage(struct mmc_host
 
 	err = mmc_wait_for_cmd(host, &cmd, 0);
 	if (err)
-		return err;
+		goto power_cycle;
 
 	if (!mmc_host_is_spi(host) && (cmd.resp[0] & R1_ERROR))
 		return -EIO;


