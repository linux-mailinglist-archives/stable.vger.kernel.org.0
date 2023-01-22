Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 92131676E78
	for <lists+stable@lfdr.de>; Sun, 22 Jan 2023 16:10:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230332AbjAVPKz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 22 Jan 2023 10:10:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37376 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230325AbjAVPKy (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 22 Jan 2023 10:10:54 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D704B1F930
        for <stable@vger.kernel.org>; Sun, 22 Jan 2023 07:10:53 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 36543B80B11
        for <stable@vger.kernel.org>; Sun, 22 Jan 2023 15:10:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 82A9FC433EF;
        Sun, 22 Jan 2023 15:10:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1674400250;
        bh=WlFfczFIlYENFnoeaX0nqb3+KChMy5xjAj8EwgR9c4Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lmQpZJ3n4WEsrFeo7wo/u/nU0Ynedxtq4zgFXKTeMfv9piUvLV/y8Odq/Onrg3XQj
         Nfj/nau0gT/NhdxnGRripgdwHXyZhipD45/cm7osJLc474y5rS5Skby6scrWNgcjCX
         x6sBRMUuQj/XT0tBi9fAVLDiF4EYNd9/K/MpOO6E=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, stable <stable@kernel.org>,
        Khazhismel Kumykov <khazhy@google.com>
Subject: [PATCH 5.4 46/55] gsmi: fix null-deref in gsmi_get_variable
Date:   Sun, 22 Jan 2023 16:04:33 +0100
Message-Id: <20230122150224.072792610@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230122150222.210885219@linuxfoundation.org>
References: <20230122150222.210885219@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Khazhismel Kumykov <khazhy@chromium.org>

commit a769b05eeed7accc4019a1ed9799dd72067f1ce8 upstream.

We can get EFI variables without fetching the attribute, so we must
allow for that in gsmi.

commit 859748255b43 ("efi: pstore: Omit efivars caching EFI varstore
access layer") added a new get_variable call with attr=NULL, which
triggers panic in gsmi.

Fixes: 74c5b31c6618 ("driver: Google EFI SMI")
Cc: stable <stable@kernel.org>
Signed-off-by: Khazhismel Kumykov <khazhy@google.com>
Link: https://lore.kernel.org/r/20230118010212.1268474-1-khazhy@google.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/firmware/google/gsmi.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

--- a/drivers/firmware/google/gsmi.c
+++ b/drivers/firmware/google/gsmi.c
@@ -359,9 +359,10 @@ static efi_status_t gsmi_get_variable(ef
 		memcpy(data, gsmi_dev.data_buf->start, *data_size);
 
 		/* All variables are have the following attributes */
-		*attr = EFI_VARIABLE_NON_VOLATILE |
-			EFI_VARIABLE_BOOTSERVICE_ACCESS |
-			EFI_VARIABLE_RUNTIME_ACCESS;
+		if (attr)
+			*attr = EFI_VARIABLE_NON_VOLATILE |
+				EFI_VARIABLE_BOOTSERVICE_ACCESS |
+				EFI_VARIABLE_RUNTIME_ACCESS;
 	}
 
 	spin_unlock_irqrestore(&gsmi_dev.lock, flags);


