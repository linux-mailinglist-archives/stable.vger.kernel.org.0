Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D4BA251AA3A
	for <lists+stable@lfdr.de>; Wed,  4 May 2022 19:19:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356986AbiEDRWX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 May 2022 13:22:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56752 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357190AbiEDROy (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 4 May 2022 13:14:54 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C2DB4541B3;
        Wed,  4 May 2022 09:58:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 04504B8279A;
        Wed,  4 May 2022 16:58:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A56ACC385B5;
        Wed,  4 May 2022 16:57:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1651683479;
        bh=TuLouNdS92eCxvqd/mAyGX1SxJHvxX+sIgxL3M1XSO4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=G62G4zeN7TIF5Yf5BFoSWotN1AMmuROaUpEXpC2vG+QMc7sVG7MMI3WBEdwFRYA+1
         Rn9ZcUB9uk0vvMG+g5xaVeBMAHvtKFsxgw4X4DiSv9ozT3gfau39lJE33KVy2GFuH0
         2a+kZIw46IdjoWXHDe0kvmGyVZmZ0rCe/bO4YCOs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        Hans de Goede <hdegoede@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 141/225] platform/x86: asus-wmi: Potential buffer overflow in asus_wmi_evaluate_method_buf()
Date:   Wed,  4 May 2022 18:46:19 +0200
Message-Id: <20220504153122.795402848@linuxfoundation.org>
X-Mailer: git-send-email 2.36.0
In-Reply-To: <20220504153110.096069935@linuxfoundation.org>
References: <20220504153110.096069935@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dan Carpenter <dan.carpenter@oracle.com>

[ Upstream commit 4345ece8f0bcc682f1fb3b648922c9be5f7dbe6c ]

This code tests for if the obj->buffer.length is larger than the buffer
but then it just does the memcpy() anyway.

Fixes: 0f0ac158d28f ("platform/x86: asus-wmi: Add support for custom fan curves")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Link: https://lore.kernel.org/r/20220413073744.GB8812@kili
Reviewed-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/asus-wmi.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/platform/x86/asus-wmi.c b/drivers/platform/x86/asus-wmi.c
index adab31b52f2a..399a4a345224 100644
--- a/drivers/platform/x86/asus-wmi.c
+++ b/drivers/platform/x86/asus-wmi.c
@@ -371,10 +371,14 @@ static int asus_wmi_evaluate_method_buf(u32 method_id,
 
 	switch (obj->type) {
 	case ACPI_TYPE_BUFFER:
-		if (obj->buffer.length > size)
+		if (obj->buffer.length > size) {
 			err = -ENOSPC;
-		if (obj->buffer.length == 0)
+			break;
+		}
+		if (obj->buffer.length == 0) {
 			err = -ENODATA;
+			break;
+		}
 
 		memcpy(ret_buffer, obj->buffer.pointer, obj->buffer.length);
 		break;
-- 
2.35.1



