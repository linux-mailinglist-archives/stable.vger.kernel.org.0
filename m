Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4DC5849989D
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 22:38:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1449169AbiAXV2L (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 16:28:11 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:39510 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1389657AbiAXVQp (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 16:16:45 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B4CBC612E9;
        Mon, 24 Jan 2022 21:16:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B0E13C340E4;
        Mon, 24 Jan 2022 21:16:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643059000;
        bh=0KD1eiKFQZ+15lvlwGjcpA2CZ9608oocxiXbhgHw+rM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=G0GTUC07Rmybk5wv02//X2Inmzn27CN5fQvh6j5UiGhXzhJj5BWn78gqXmOq3nUyU
         sONXiDH//x35cG+CigXPfbY5gtvvp+NxcrlHvq4R6V1MCKCr9bNfMQ1W64Kyc44xBR
         akJYWKbN9Zn2BDd7RhlVEIoOeRysLMywqYjrvBeI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kees Cook <keescook@chromium.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 0470/1039] char/mwave: Adjust io port register size
Date:   Mon, 24 Jan 2022 19:37:39 +0100
Message-Id: <20220124184141.076124919@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184125.121143506@linuxfoundation.org>
References: <20220124184125.121143506@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kees Cook <keescook@chromium.org>

[ Upstream commit f5912cc19acd7c24b2dbf65a6340bf194244f085 ]

Using MKWORD() on a byte-sized variable results in OOB read. Expand the
size of the reserved area so both MKWORD and MKBYTE continue to work
without overflow. Silences this warning on a -Warray-bounds build:

drivers/char/mwave/3780i.h:346:22: error: array subscript 'short unsigned int[0]' is partly outside array bounds of 'DSP_ISA_SLAVE_CONTROL[1]' [-Werror=array-bounds]
  346 | #define MKWORD(var) (*((unsigned short *)(&var)))
      |                     ~^~~~~~~~~~~~~~~~~~~~~~~~~~~~
drivers/char/mwave/3780i.h:356:40: note: in definition of macro 'OutWordDsp'
  356 | #define OutWordDsp(index,value)   outw(value,usDspBaseIO+index)
      |                                        ^~~~~
drivers/char/mwave/3780i.c:373:41: note: in expansion of macro 'MKWORD'
  373 |         OutWordDsp(DSP_IsaSlaveControl, MKWORD(rSlaveControl));
      |                                         ^~~~~~
drivers/char/mwave/3780i.c:358:31: note: while referencing 'rSlaveControl'
  358 |         DSP_ISA_SLAVE_CONTROL rSlaveControl;
      |                               ^~~~~~~~~~~~~

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Kees Cook <keescook@chromium.org>
Link: https://lore.kernel.org/r/20211203084206.3104326-1-keescook@chromium.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/char/mwave/3780i.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/char/mwave/3780i.h b/drivers/char/mwave/3780i.h
index 9ccb6b270b071..95164246afd1a 100644
--- a/drivers/char/mwave/3780i.h
+++ b/drivers/char/mwave/3780i.h
@@ -68,7 +68,7 @@ typedef struct {
 	unsigned char ClockControl:1;	/* RW: Clock control: 0=normal, 1=stop 3780i clocks */
 	unsigned char SoftReset:1;	/* RW: Soft reset 0=normal, 1=soft reset active */
 	unsigned char ConfigMode:1;	/* RW: Configuration mode, 0=normal, 1=config mode */
-	unsigned char Reserved:5;	/* 0: Reserved */
+	unsigned short Reserved:13;	/* 0: Reserved */
 } DSP_ISA_SLAVE_CONTROL;
 
 
-- 
2.34.1



