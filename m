Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5882D4A4148
	for <lists+stable@lfdr.de>; Mon, 31 Jan 2022 12:03:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358379AbiAaLDW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 Jan 2022 06:03:22 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:50160 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358918AbiAaLCK (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 31 Jan 2022 06:02:10 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0439BB82A63;
        Mon, 31 Jan 2022 11:02:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 18676C340E8;
        Mon, 31 Jan 2022 11:02:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643626927;
        bh=roTSABubN/Wi/NZrtktszAYxy/Lk9Du0dr9/MHsZBl4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eYFrd1U3FFANIpgpYn81v8KfRWbfa4LDTav8UjwzL83JVbvM8yZr7okldw7HXaPy1
         XMu8XKT+Vb74LI0c0mepfZ+X/FLlsRl9bjDlzIb+7L5+6o86f+GD4qndpcqVu8Sgfy
         VueXcp4bR+K3I5UxBlvNoHKbbMtn9nnzabbr0Gqc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Stanimir Varbanov <stanimir.varbanov@linaro.org>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Martin Faltesek <mfaltesek@google.com>,
        Guenter Roeck <groeck@google.com>,
        Bryan ODonoghue <bryan.odonoghue@linaro.org>
Subject: [PATCH 5.10 002/100] media: venus: core: Drop second v4l2 device unregister
Date:   Mon, 31 Jan 2022 11:55:23 +0100
Message-Id: <20220131105220.504209945@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220131105220.424085452@linuxfoundation.org>
References: <20220131105220.424085452@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Stanimir Varbanov <stanimir.varbanov@linaro.org>

commit ddbcd0c58a6a53e2f1600b9de0ce6a20667c031c upstream.

Wrong solution of rebase conflict leads to calling twice
v4l2_device_unregister in .venus_remove. Delete the second one.

Signed-off-by: Stanimir Varbanov <stanimir.varbanov@linaro.org>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Cc: Martin Faltesek <mfaltesek@google.com>
Cc: Guenter Roeck <groeck@google.com>
Cc: Bryan O'Donoghue <bryan.odonoghue@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/platform/qcom/venus/core.c |    2 --
 1 file changed, 2 deletions(-)

--- a/drivers/media/platform/qcom/venus/core.c
+++ b/drivers/media/platform/qcom/venus/core.c
@@ -375,8 +375,6 @@ static int venus_remove(struct platform_
 
 	hfi_destroy(core);
 
-	v4l2_device_unregister(&core->v4l2_dev);
-
 	mutex_destroy(&core->pm_lock);
 	mutex_destroy(&core->lock);
 	venus_dbgfs_deinit(core);


