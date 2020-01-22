Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DDC8E1456B0
	for <lists+stable@lfdr.de>; Wed, 22 Jan 2020 14:36:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731030AbgAVN2i (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Jan 2020 08:28:38 -0500
Received: from mail.kernel.org ([198.145.29.99]:50906 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729106AbgAVN2d (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 22 Jan 2020 08:28:33 -0500
Received: from localhost (unknown [84.241.205.26])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C5D2F2467A;
        Wed, 22 Jan 2020 13:28:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579699713;
        bh=Ts68ShsdzOG9Fa9chgZq5ppLdpZ2ie9mY1mXFf7rshs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RadIwp17JNhM8cx9IS+tEeP/q1+JVFSO7KqELEuUxpDhKfrgUYLUFcsyYVQm3mGOJ
         9TIdgysz97l/jjiByDoU8wW4J8sKTZAJxfkUqBzW2c8qmBI0CdeArjMrXMHcjekmXa
         NOSBJIqktrrY6zd3MUxHwu4Adjd1rHfSv5qxpAbI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>,
        Vignesh Raghavendra <vigneshr@ti.com>
Subject: [PATCH 5.4 194/222] mtd: cfi_cmdset_0002: only check errors when ready in cfi_check_err_status()
Date:   Wed, 22 Jan 2020 10:29:40 +0100
Message-Id: <20200122092847.592021002@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200122092833.339495161@linuxfoundation.org>
References: <20200122092833.339495161@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>

commit 72914a8cff7e1d910c58e125e15a0da409e3135f upstream.

Cypress S26K{L|S}P{128|256|512}S datasheet says that the error bits in
the status register are only valid when the "device ready" bit 7 is set.
Add the check for the device ready bit in cfi_check_err_status() as that
function isn't always called with this bit set.

Fixes: 4844ef80305d ("mtd: cfi_cmdset_0002: Add support for polling status register")
Signed-off-by: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Signed-off-by: Vignesh Raghavendra <vigneshr@ti.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/mtd/chips/cfi_cmdset_0002.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/drivers/mtd/chips/cfi_cmdset_0002.c
+++ b/drivers/mtd/chips/cfi_cmdset_0002.c
@@ -136,6 +136,10 @@ static void cfi_check_err_status(struct
 			 cfi->device_type, NULL);
 	status = map_read(map, adr);
 
+	/* The error bits are invalid while the chip's busy */
+	if (!map_word_bitsset(map, status, CMD(CFI_SR_DRB)))
+		return;
+
 	if (map_word_bitsset(map, status, CMD(0x3a))) {
 		unsigned long chipstatus = MERGESTATUS(status);
 


