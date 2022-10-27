Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A1B7860FE62
	for <lists+stable@lfdr.de>; Thu, 27 Oct 2022 19:04:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236928AbiJ0RE6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 Oct 2022 13:04:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60024 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236950AbiJ0REw (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 27 Oct 2022 13:04:52 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DEDC58113A
        for <stable@vger.kernel.org>; Thu, 27 Oct 2022 10:04:50 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9B05BB824DB
        for <stable@vger.kernel.org>; Thu, 27 Oct 2022 17:04:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E48EBC433C1;
        Thu, 27 Oct 2022 17:04:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666890288;
        bh=ei+uedMaTOIPuxjpu6diHqgY1TRnnG9bfnjO2qXCiQs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DaCiy0GCHK5NPU1jV++7ksIT73p2+DcUArS+TNJKqDt+NMuSV9F6pFciNtPgYXTgf
         WL2G7ZS6JejRbxGRsUyNSmRqsi/eJz5A7x91il0TsBnVrRlgtBzzKuImdE+r4n8mkh
         I+DnDLowCfGQDCLmhKfXaqqN54pMsqJb8ufvtDWo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Sean Young <sean@mess.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Subject: [PATCH 5.10 14/79] media: mceusb: set timeout to at least timeout provided
Date:   Thu, 27 Oct 2022 18:55:24 +0200
Message-Id: <20221027165054.818111873@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221027165054.270676357@linuxfoundation.org>
References: <20221027165054.270676357@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sean Young <sean@mess.org>

commit 20b794ddce475ed012deb365000527c17b3e93e6 upstream.

By rounding down, the actual timeout can be lower than requested. As a
result, long spaces just below the requested timeout can be incorrectly
reported as timeout and truncated.

Fixes: 877f1a7cee3f ("media: rc: mceusb: allow the timeout to be configurable")
Cc: stable@vger.kernel.org
Signed-off-by: Sean Young <sean@mess.org>
Signed-off-by: Mauro Carvalho Chehab <mchehab@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/rc/mceusb.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/media/rc/mceusb.c
+++ b/drivers/media/rc/mceusb.c
@@ -1077,7 +1077,7 @@ static int mceusb_set_timeout(struct rc_
 	struct mceusb_dev *ir = dev->priv;
 	unsigned int units;
 
-	units = DIV_ROUND_CLOSEST(timeout, MCE_TIME_UNIT);
+	units = DIV_ROUND_UP(timeout, MCE_TIME_UNIT);
 
 	cmdbuf[2] = units >> 8;
 	cmdbuf[3] = units;


