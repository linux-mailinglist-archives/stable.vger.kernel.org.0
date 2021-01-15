Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 14E012F79C5
	for <lists+stable@lfdr.de>; Fri, 15 Jan 2021 13:42:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733204AbhAOMkR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 15 Jan 2021 07:40:17 -0500
Received: from mail.kernel.org ([198.145.29.99]:47714 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388468AbhAOMkG (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 15 Jan 2021 07:40:06 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id EDF11239D1;
        Fri, 15 Jan 2021 12:39:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1610714366;
        bh=mUDAjhemMD0Xkai0u/87dRpTPEGEpcxm0RV8S8pQOTU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iXnfLy8c3JTyAz/NVVQ4tEFEVsS3dqNYAj7hZecBjf48Gd+odssS7NV+xvro5D2W1
         UoHGWsGgMEN5H7q7YjEy+D1rFzJCWZxhcOLT8os92/hX5cp1voZ8jFyC37/ycma7Nu
         Btg9LYs3gNb2E91g1RUtEHtWIBFRvGqMq5Qo15ZQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hans de Goede <hdegoede@redhat.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Jean Delvare <jdelvare@suse.de>,
        Linus Walleij <linus.walleij@linaro.org>,
        Wolfram Sang <wsa@kernel.org>
Subject: [PATCH 5.10 063/103] i2c: i801: Fix the i2c-mux gpiod_lookup_table not being properly terminated
Date:   Fri, 15 Jan 2021 13:27:56 +0100
Message-Id: <20210115122009.093046549@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210115122006.047132306@linuxfoundation.org>
References: <20210115122006.047132306@linuxfoundation.org>
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
@@ -1449,7 +1449,7 @@ static int i801_add_mux(struct i801_priv
 
 	/* Register GPIO descriptor lookup table */
 	lookup = devm_kzalloc(dev,
-			      struct_size(lookup, table, mux_config->n_gpios),
+			      struct_size(lookup, table, mux_config->n_gpios + 1),
 			      GFP_KERNEL);
 	if (!lookup)
 		return -ENOMEM;


