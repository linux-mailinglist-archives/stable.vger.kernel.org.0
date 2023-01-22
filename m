Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 099D1676F3A
	for <lists+stable@lfdr.de>; Sun, 22 Jan 2023 16:19:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231202AbjAVPTJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 22 Jan 2023 10:19:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46380 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231190AbjAVPTH (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 22 Jan 2023 10:19:07 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 06EDD20057
        for <stable@vger.kernel.org>; Sun, 22 Jan 2023 07:19:07 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id AE6A9B80B1B
        for <stable@vger.kernel.org>; Sun, 22 Jan 2023 15:19:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0FBB8C433EF;
        Sun, 22 Jan 2023 15:19:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1674400744;
        bh=OjhUCj+cDgnJrUFzW7fHqCeqHv+FYOQt9muNO0rKAKc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yy+AkA88RKv10eNOl1inQVhmxSpetFU2pL9vfoy+UFgNx3AQKsoOOJ5L68tvOGTSH
         Vy9AS11dxX6A2feNYwVyOD5RlAL2OMy7m/7ONU/PzWzRSRVpcq81UssArCbtp6j1ja
         WqROicrDi5L8wC6hxtgCPEnYOBeuskc48Cqpuw5I=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, stable <stable@kernel.org>,
        Khazhismel Kumykov <khazhy@google.com>
Subject: [PATCH 5.15 092/117] gsmi: fix null-deref in gsmi_get_variable
Date:   Sun, 22 Jan 2023 16:04:42 +0100
Message-Id: <20230122150236.627178027@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230122150232.736358800@linuxfoundation.org>
References: <20230122150232.736358800@linuxfoundation.org>
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
@@ -361,9 +361,10 @@ static efi_status_t gsmi_get_variable(ef
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


