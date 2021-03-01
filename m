Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 263E43291D4
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 21:34:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237124AbhCAUdr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 15:33:47 -0500
Received: from mail.kernel.org ([198.145.29.99]:49318 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242720AbhCAU0z (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 15:26:55 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 849E465301;
        Mon,  1 Mar 2021 18:06:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614622008;
        bh=vbhUR/A4No+Gdh79vv14FfoQRNr1mpAYBxH2HMMg3h4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gxgkGqESc3wXwDgHkeZ950OEWCTip0vivsZuNBykvg6Au712wcSoIFhWQ9b/jGfu6
         uwq8WVW7UN9Im8OTlH1T84TdXQSBNzKpV9R7F6Pt7Bdp7IWACvyZTjTMg4mS50V59q
         ++aJ9wLX54TY/0iadLazcAAzS+Ed8EM1HoHjesQY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tim Harvey <tharvey@gateworks.com>,
        Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 5.11 722/775] mfd: gateworks-gsc: Fix interrupt type
Date:   Mon,  1 Mar 2021 17:14:50 +0100
Message-Id: <20210301161237.016411557@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161201.679371205@linuxfoundation.org>
References: <20210301161201.679371205@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tim Harvey <tharvey@gateworks.com>

commit 8d9bf3c3e1451fc8de7b590040a868ade26d6b22 upstream.

The Gateworks System Controller has an active-low interrupt.
Fix the interrupt request type.

Cc: <stable@vger.kernel.org>
Fixes: d85234994b2f ("mfd: Add Gateworks System Controller core driver")
Signed-off-by: Tim Harvey <tharvey@gateworks.com>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/mfd/gateworks-gsc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/mfd/gateworks-gsc.c
+++ b/drivers/mfd/gateworks-gsc.c
@@ -234,7 +234,7 @@ static int gsc_probe(struct i2c_client *
 
 	ret = devm_regmap_add_irq_chip(dev, gsc->regmap, client->irq,
 				       IRQF_ONESHOT | IRQF_SHARED |
-				       IRQF_TRIGGER_FALLING, 0,
+				       IRQF_TRIGGER_LOW, 0,
 				       &gsc_irq_chip, &irq_data);
 	if (ret)
 		return ret;


