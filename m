Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6902428B6A5
	for <lists+stable@lfdr.de>; Mon, 12 Oct 2020 15:37:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730943AbgJLNf7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Oct 2020 09:35:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:37900 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730281AbgJLNfU (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Oct 2020 09:35:20 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B15D222202;
        Mon, 12 Oct 2020 13:35:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602509719;
        bh=u04UTY/9Gc6U+pNEmqKBde2TzDcfYSXtBIjnN5RzrUk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UVWM70aQe+W0psP0DsLTIRUbRIL2ZFwpwp9r46/zXI1mfD4W81/Y71i4oxIey/g/h
         ml/f+BHIdIq0Ah8SdRU3FVxE7rIolDM6rQRlRKwWC0Y/uhdhkggPyc2CXXK/4Evk0M
         /N/fAkv2k0DPNM2bE5GPIJnybpsz02gXTZYOJu7Y=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Nicolas VINCENT <nicolas.vincent@vossloh.com>,
        Jochen Friedrich <jochen@scram.de>,
        Christophe Leroy <christophe.leroy@csgroup.eu>,
        Wolfram Sang <wsa@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 15/54] i2c: cpm: Fix i2c_ram structure
Date:   Mon, 12 Oct 2020 15:26:37 +0200
Message-Id: <20201012132630.299601074@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201012132629.585664421@linuxfoundation.org>
References: <20201012132629.585664421@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nicolas VINCENT <nicolas.vincent@vossloh.com>

[ Upstream commit a2bd970aa62f2f7f80fd0d212b1d4ccea5df4aed ]

the i2c_ram structure is missing the sdmatmp field mentionned in
datasheet for MPC8272 at paragraph 36.5. With this field missing, the
hardware would write past the allocated memory done through
cpm_muram_alloc for the i2c_ram structure and land in memory allocated
for the buffers descriptors corrupting the cbd_bufaddr field. Since this
field is only set during setup(), the first i2c transaction would work
and the following would send data read from an arbitrary memory
location.

Fixes: 61045dbe9d8d ("i2c: Add support for I2C bus on Freescale CPM1/CPM2 controllers")
Signed-off-by: Nicolas VINCENT <nicolas.vincent@vossloh.com>
Acked-by: Jochen Friedrich <jochen@scram.de>
Acked-by: Christophe Leroy <christophe.leroy@csgroup.eu>
Signed-off-by: Wolfram Sang <wsa@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/i2c/busses/i2c-cpm.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/i2c/busses/i2c-cpm.c b/drivers/i2c/busses/i2c-cpm.c
index d89bde2c5da25..cf285b97a6422 100644
--- a/drivers/i2c/busses/i2c-cpm.c
+++ b/drivers/i2c/busses/i2c-cpm.c
@@ -74,6 +74,9 @@ struct i2c_ram {
 	char    res1[4];	/* Reserved */
 	ushort  rpbase;		/* Relocation pointer */
 	char    res2[2];	/* Reserved */
+	/* The following elements are only for CPM2 */
+	char    res3[4];	/* Reserved */
+	uint    sdmatmp;	/* Internal */
 };
 
 #define I2COM_START	0x80
-- 
2.25.1



