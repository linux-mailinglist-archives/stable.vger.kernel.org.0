Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 357F32F7AC1
	for <lists+stable@lfdr.de>; Fri, 15 Jan 2021 13:55:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388033AbhAOMyQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 15 Jan 2021 07:54:16 -0500
Received: from mail.kernel.org ([198.145.29.99]:42628 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387704AbhAOMff (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 15 Jan 2021 07:35:35 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0A01223339;
        Fri, 15 Jan 2021 12:34:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1610714094;
        bh=BSxJlYx/6c1s9QaRy1D+m8lDjzEWG/SvyAfpM9EsMyY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=q7iFy6Qk84TvvY49tqvhns001dq109aGwT7CV+xNt2golpSEjbKf3FTIafX7zctbq
         TndIxJSGvjotCnfGobWfRBZtiw1v4+jhjsiHUsWUgGiI3z0XaC86tCTd0dXnX1tvfK
         pG4oDLi1/365l6URRgLarqEwFCDFIYdKczA84jVM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hans de Goede <hdegoede@redhat.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Jean Delvare <jdelvare@suse.de>,
        Linus Walleij <linus.walleij@linaro.org>,
        Wolfram Sang <wsa@kernel.org>
Subject: [PATCH 5.4 42/62] i2c: i801: Fix the i2c-mux gpiod_lookup_table not being properly terminated
Date:   Fri, 15 Jan 2021 13:28:04 +0100
Message-Id: <20210115122000.430414543@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210115121958.391610178@linuxfoundation.org>
References: <20210115121958.391610178@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hans de Goede <hdegoede@redhat.com>

commit 0b3ea2a06de1f52ea30865e227e109a5fd3b6214 upstream.

gpiod_add_lookup_table() expects the gpiod_lookup_table->table passed to
it to be terminated with a zero-ed out entry.

So we need to allocate one more entry then we will use.

Fixes: d308dfbf62ef ("i2c: mux/i801: Switch to use descriptor passing")
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Reviewed-by: Mika Westerberg <mika.westerberg@linux.intel.com>
Acked-by: Jean Delvare <jdelvare@suse.de>
Reviewed-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Wolfram Sang <wsa@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/i2c/busses/i2c-i801.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/i2c/busses/i2c-i801.c
+++ b/drivers/i2c/busses/i2c-i801.c
@@ -1424,7 +1424,7 @@ static int i801_add_mux(struct i801_priv
 
 	/* Register GPIO descriptor lookup table */
 	lookup = devm_kzalloc(dev,
-			      struct_size(lookup, table, mux_config->n_gpios),
+			      struct_size(lookup, table, mux_config->n_gpios + 1),
 			      GFP_KERNEL);
 	if (!lookup)
 		return -ENOMEM;


