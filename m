Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5E44449A4AB
	for <lists+stable@lfdr.de>; Tue, 25 Jan 2022 03:10:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2371633AbiAYAJY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 19:09:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57812 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2364663AbiAXXsq (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 18:48:46 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C6853C0419C7;
        Mon, 24 Jan 2022 13:43:55 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 67C5061502;
        Mon, 24 Jan 2022 21:43:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 28B8DC340E4;
        Mon, 24 Jan 2022 21:43:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643060634;
        bh=dKelhVWUvz4ApohNdesXTvFVNa5aDTyUP3bnUOpRi+0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KBJp4gea+PDzTs9nJF/widWMElGhbfQikLF0ki5vMyMtevaoxmI8PhTHmZNydpg8f
         xkyqMWnsmfI+NSHYt+zAUvPoWLYtb8WGMQTLWWti0zASb1oMkH1WHwSGPjPToSRbir
         SXBAXDwEZxLx3FGXmkZwv42J1fMNcbs0iRG/8uyY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kees Cook <keescook@chromium.org>,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>
Subject: [PATCH 5.16 0980/1039] rtc: Move variable into switch case statement
Date:   Mon, 24 Jan 2022 19:46:09 +0100
Message-Id: <20220124184158.226111508@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184125.121143506@linuxfoundation.org>
References: <20220124184125.121143506@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kees Cook <keescook@chromium.org>

commit ba52eac083e1598e748811ff58d259f77e4c5c4d upstream.

When building with automatic stack variable initialization, GCC 12
complains about variables defined outside of switch case statements.
Move the variable into the case that uses it, which silences the warning:

drivers/rtc/dev.c: In function 'rtc_dev_ioctl':
drivers/rtc/dev.c:394:30: warning: statement will never be executed [-Wswitch-unreachable]
  394 |                         long offset;
      |                              ^~~~~~

Fixes: 6a8af1b6568a ("rtc: add parameter ioctl")
Signed-off-by: Kees Cook <keescook@chromium.org>
Reviewed-by: Gustavo A. R. Silva <gustavoars@kernel.org>
Signed-off-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
Link: https://lore.kernel.org/r/20211209043915.1378393-1-keescook@chromium.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/rtc/dev.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/drivers/rtc/dev.c
+++ b/drivers/rtc/dev.c
@@ -391,14 +391,14 @@ static long rtc_dev_ioctl(struct file *f
 		}
 
 		switch(param.param) {
-			long offset;
 		case RTC_PARAM_FEATURES:
 			if (param.index != 0)
 				err = -EINVAL;
 			param.uvalue = rtc->features[0];
 			break;
 
-		case RTC_PARAM_CORRECTION:
+		case RTC_PARAM_CORRECTION: {
+			long offset;
 			mutex_unlock(&rtc->ops_lock);
 			if (param.index != 0)
 				return -EINVAL;
@@ -407,7 +407,7 @@ static long rtc_dev_ioctl(struct file *f
 			if (err == 0)
 				param.svalue = offset;
 			break;
-
+		}
 		default:
 			if (rtc->ops->param_get)
 				err = rtc->ops->param_get(rtc->dev.parent, &param);


