Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5F92247FF43
	for <lists+stable@lfdr.de>; Mon, 27 Dec 2021 16:37:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234922AbhL0Pgg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Dec 2021 10:36:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35758 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238249AbhL0PeS (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Dec 2021 10:34:18 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AC9E2C061191;
        Mon, 27 Dec 2021 07:34:15 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 2E54FCE10B3;
        Mon, 27 Dec 2021 15:34:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D337C36AEB;
        Mon, 27 Dec 2021 15:34:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1640619252;
        bh=4UxwKs05ZENW8YKd8u/Cp9gnBHP4AbZtqfYy6+4bKaY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PMoU9K7hGKSp5g7XOePxNK7e3g0CPc8TKric8ap2FI2ZJ5YR/0aMF754/icmidlKw
         7JxSkM+Zk153XntpUF54FsfcI93baSZwk2DTz57XnuyXlCkRNpuUnf/64e1vg0QMLL
         xMay9sC1E4HbXbRcEoEsSFV5nCS4ETith30fLJTY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Jos=C3=A9=20Exp=C3=B3sito?= <jose.exposito89@gmail.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 4.19 23/38] Input: atmel_mxt_ts - fix double free in mxt_read_info_block
Date:   Mon, 27 Dec 2021 16:31:00 +0100
Message-Id: <20211227151320.155814190@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211227151319.379265346@linuxfoundation.org>
References: <20211227151319.379265346@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: José Expósito <jose.exposito89@gmail.com>

commit 12f247ab590a08856441efdbd351cf2cc8f60a2d upstream.

The "id_buf" buffer is stored in "data->raw_info_block" and freed by
"mxt_free_object_table" in case of error.

Return instead of jumping to avoid a double free.

Addresses-Coverity-ID: 1474582 ("Double free")
Fixes: 068bdb67ef74 ("Input: atmel_mxt_ts - fix the firmware update")
Signed-off-by: José Expósito <jose.exposito89@gmail.com>
Link: https://lore.kernel.org/r/20211212194257.68879-1-jose.exposito89@gmail.com
Cc: stable@vger.kernel.org
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/input/touchscreen/atmel_mxt_ts.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/input/touchscreen/atmel_mxt_ts.c
+++ b/drivers/input/touchscreen/atmel_mxt_ts.c
@@ -1809,7 +1809,7 @@ static int mxt_read_info_block(struct mx
 	if (error) {
 		dev_err(&client->dev, "Error %d parsing object table\n", error);
 		mxt_free_object_table(data);
-		goto err_free_mem;
+		return error;
 	}
 
 	data->object_table = (struct mxt_object *)(id_buf + MXT_OBJECT_START);


