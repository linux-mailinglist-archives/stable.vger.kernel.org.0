Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EE2BE47FF12
	for <lists+stable@lfdr.de>; Mon, 27 Dec 2021 16:35:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234587AbhL0PfL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Dec 2021 10:35:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36232 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237986AbhL0PfH (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Dec 2021 10:35:07 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D95BC06173E;
        Mon, 27 Dec 2021 07:35:07 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 70BFACE10C4;
        Mon, 27 Dec 2021 15:35:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F05DC36AEA;
        Mon, 27 Dec 2021 15:35:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1640619303;
        bh=jpEICLU7iA2vFFdDGmu6tR9+fBi/8YEagTm6fPwWY84=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MJuQHclA1LS1AncSN7PypKGl4uOCOB6Zh17Tm0iiCKRGqZKyBx/tkDMJLv8Flkha+
         IjD9UeELrMylyUXCkgyvH44tYvWDunXZG+gwhfv3UOxHipbd7h85WV3JIPDpIm1up1
         FuQk3zZ0EugOKrYKXTtDmwROK8tVVeXhppuVY1hs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Jos=C3=A9=20Exp=C3=B3sito?= <jose.exposito89@gmail.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 5.4 25/47] Input: atmel_mxt_ts - fix double free in mxt_read_info_block
Date:   Mon, 27 Dec 2021 16:31:01 +0100
Message-Id: <20211227151321.666144202@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211227151320.801714429@linuxfoundation.org>
References: <20211227151320.801714429@linuxfoundation.org>
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
@@ -1794,7 +1794,7 @@ static int mxt_read_info_block(struct mx
 	if (error) {
 		dev_err(&client->dev, "Error %d parsing object table\n", error);
 		mxt_free_object_table(data);
-		goto err_free_mem;
+		return error;
 	}
 
 	data->object_table = (struct mxt_object *)(id_buf + MXT_OBJECT_START);


