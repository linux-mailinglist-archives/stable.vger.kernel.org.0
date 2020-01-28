Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 509ED14B8CB
	for <lists+stable@lfdr.de>; Tue, 28 Jan 2020 15:27:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733293AbgA1O12 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Jan 2020 09:27:28 -0500
Received: from mail.kernel.org ([198.145.29.99]:55158 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1733171AbgA1O1Z (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 28 Jan 2020 09:27:25 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A807824690;
        Tue, 28 Jan 2020 14:27:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1580221645;
        bh=MO0ELrj1KzxjSS2xdC5JTxinYO/0bCr9wfQgQ9rxuBI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iqkTxVjhMeNXKk5odrrMCu1kMF8CRgXxaM3MQHAkM2NTRGfXEwv58NG7Ame57JZG1
         EdW/Yc/glw4Y28WAG89HGxojVFYW6rCM3MjBsjvFa/D8e1zq5IbZlvxzm+8CpgpS9k
         Ts3sdO9a1rOUHTEFhuhme9g9ympwdOO0eHRqrix8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Stephan Gerhold <stephan@gerhold.net>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 4.19 33/92] Input: pm8xxx-vib - fix handling of separate enable register
Date:   Tue, 28 Jan 2020 15:08:01 +0100
Message-Id: <20200128135813.321985774@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200128135809.344954797@linuxfoundation.org>
References: <20200128135809.344954797@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Stephan Gerhold <stephan@gerhold.net>

commit 996d5d5f89a558a3608a46e73ccd1b99f1b1d058 upstream.

Setting the vibrator enable_mask is not implemented correctly:

For regmap_update_bits(map, reg, mask, val) we give in either
regs->enable_mask or 0 (= no-op) as mask and "val" as value.
But "val" actually refers to the vibrator voltage control register,
which has nothing to do with the enable_mask.

So we usually end up doing nothing when we really wanted
to enable the vibrator.

We want to set or clear the enable_mask (to enable/disable the vibrator).
Therefore, change the call to always modify the enable_mask
and set the bits only if we want to enable the vibrator.

Fixes: d4c7c5c96c92 ("Input: pm8xxx-vib - handle separate enable register")
Signed-off-by: Stephan Gerhold <stephan@gerhold.net>
Link: https://lore.kernel.org/r/20200114183442.45720-1-stephan@gerhold.net
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/input/misc/pm8xxx-vibrator.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/input/misc/pm8xxx-vibrator.c
+++ b/drivers/input/misc/pm8xxx-vibrator.c
@@ -98,7 +98,7 @@ static int pm8xxx_vib_set(struct pm8xxx_
 
 	if (regs->enable_mask)
 		rc = regmap_update_bits(vib->regmap, regs->enable_addr,
-					on ? regs->enable_mask : 0, val);
+					regs->enable_mask, on ? ~0 : 0);
 
 	return rc;
 }


