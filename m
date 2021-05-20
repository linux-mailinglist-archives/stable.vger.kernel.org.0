Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6E57938A5E2
	for <lists+stable@lfdr.de>; Thu, 20 May 2021 12:20:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235764AbhETKVG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 May 2021 06:21:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:51948 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235448AbhETKTO (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 May 2021 06:19:14 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4F18D613F2;
        Thu, 20 May 2021 09:47:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621504020;
        bh=sAYr0DJapOyVriQnr9pgTvIoXm2ab43QKaLcBLu4Gtw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=betnyyTvKIdtnS9u+NdCpbQn8y7K8gUpqU4tY6lwdy4pTiMY3ZPj6Oe9g28UuYdN2
         PlbpqKK4P4ul8uBoqE07Jt/+OJ5phkZzg2ZBNqO7SpIL0sCxRD74KagBsnvWqY43rI
         gyWWSPwp4hwqRYOELtrpN5gEi+elfriec/GfpxRI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, DooHyun Hwang <dh0421.hwang@samsung.com>,
        Ulf Hansson <ulf.hansson@linaro.org>
Subject: [PATCH 4.14 024/323] mmc: core: Do a power cycle when the CMD11 fails
Date:   Thu, 20 May 2021 11:18:36 +0200
Message-Id: <20210520092120.941589677@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210520092120.115153432@linuxfoundation.org>
References: <20210520092120.115153432@linuxfoundation.org>
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
@@ -1506,7 +1506,7 @@ int mmc_set_uhs_voltage(struct mmc_host
 
 	err = mmc_wait_for_cmd(host, &cmd, 0);
 	if (err)
-		return err;
+		goto power_cycle;
 
 	if (!mmc_host_is_spi(host) && (cmd.resp[0] & R1_ERROR))
 		return -EIO;


