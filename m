Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5B4E347ABBE
	for <lists+stable@lfdr.de>; Mon, 20 Dec 2021 15:39:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234339AbhLTOit (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Dec 2021 09:38:49 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:47292 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234349AbhLTOiL (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Dec 2021 09:38:11 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id BF0D6B80EE8;
        Mon, 20 Dec 2021 14:38:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 14D39C36AE7;
        Mon, 20 Dec 2021 14:38:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1640011089;
        bh=kwyo+5H2bwLmPPOD0889sSiZ2d32mfQVKeSo/DaPyE0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=B5toaXWArN2isw9sWD1kFmzMBJdFz+fLDxwuXOJ9T2IxyJr2r65VGQYf0pPtUVJ3x
         aM/xICnjdwn/AKk25Ugn0CLKsxUmplqxf4nUZ1/5qlAlVMNEUMoOwid8/kHPTdvORK
         gxXKR9gjPQH466IJO/xwDAbVaUdY4n9f9tIX0pRk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Nathan Chancellor <natechancellor@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Anders Roxell <anders.roxell@linaro.org>
Subject: [PATCH 4.9 23/31] net: lan78xx: Avoid unnecessary self assignment
Date:   Mon, 20 Dec 2021 15:34:23 +0100
Message-Id: <20211220143020.717902594@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211220143019.974513085@linuxfoundation.org>
References: <20211220143019.974513085@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nathan Chancellor <natechancellor@gmail.com>

commit 94e7c844990f0db92418586b107be135b4963b66 upstream.

Clang warns when a variable is assigned to itself.

drivers/net/usb/lan78xx.c:940:11: warning: explicitly assigning value of
variable of type 'u32' (aka 'unsigned int') to itself [-Wself-assign]
                        offset = offset;
                        ~~~~~~ ^ ~~~~~~
1 warning generated.

Reorder the if statement to acheive the same result and avoid a self
assignment warning.

Link: https://github.com/ClangBuiltLinux/linux/issues/129
Signed-off-by: Nathan Chancellor <natechancellor@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Anders Roxell <anders.roxell@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/usb/lan78xx.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

--- a/drivers/net/usb/lan78xx.c
+++ b/drivers/net/usb/lan78xx.c
@@ -865,11 +865,9 @@ static int lan78xx_read_otp(struct lan78
 	ret = lan78xx_read_raw_otp(dev, 0, 1, &sig);
 
 	if (ret == 0) {
-		if (sig == OTP_INDICATOR_1)
-			offset = offset;
-		else if (sig == OTP_INDICATOR_2)
+		if (sig == OTP_INDICATOR_2)
 			offset += 0x100;
-		else
+		else if (sig != OTP_INDICATOR_1)
 			ret = -EINVAL;
 		if (!ret)
 			ret = lan78xx_read_raw_otp(dev, offset, length, data);


