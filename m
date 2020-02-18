Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F172F1631AE
	for <lists+stable@lfdr.de>; Tue, 18 Feb 2020 21:05:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728681AbgBRUCH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Feb 2020 15:02:07 -0500
Received: from mail.kernel.org ([198.145.29.99]:42152 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727785AbgBRUCG (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 18 Feb 2020 15:02:06 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 92A4A2465D;
        Tue, 18 Feb 2020 20:02:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582056126;
        bh=ThgjNCU+8MS+eBKTclwmfynFRyuPnapydKLL6JZ7fXs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=i9TPnexnLOjecV3Ene+xaO3XC0HCYzuKSDMt7bkwwnVy5HbDptpalW2U2/7kDMhBG
         TQY3TpsD8oeoQ29v8dEL908KqRz/teOVgGbbiP9jo+myLeBbqKqULD1Eo0s+kfMd38
         6YsD0xemDiznn0vQfy0maxVSaRX6Fc0w4q1nesZY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Marek=20Beh=C3=BAn?= <marek.behun@nic.cz>,
        sohu0106 <sohu0106@126.com>, Olof Johansson <olof@lixom.net>
Subject: [PATCH 5.5 45/80] bus: moxtet: fix potential stack buffer overflow
Date:   Tue, 18 Feb 2020 20:55:06 +0100
Message-Id: <20200218190436.649116364@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200218190432.043414522@linuxfoundation.org>
References: <20200218190432.043414522@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Marek Behún <marek.behun@nic.cz>

commit 3bf3c9744694803bd2d6f0ee70a6369b980530fd upstream.

The input_read function declares the size of the hex array relative to
sizeof(buf), but buf is a pointer argument of the function. The hex
array is meant to contain hexadecimal representation of the bin array.

Link: https://lore.kernel.org/r/20200215142130.22743-1-marek.behun@nic.cz
Fixes: 5bc7f990cd98 ("bus: Add support for Moxtet bus")
Signed-off-by: Marek Behún <marek.behun@nic.cz>
Reported-by: sohu0106 <sohu0106@126.com>
Signed-off-by: Olof Johansson <olof@lixom.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/bus/moxtet.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/bus/moxtet.c
+++ b/drivers/bus/moxtet.c
@@ -466,7 +466,7 @@ static ssize_t input_read(struct file *f
 {
 	struct moxtet *moxtet = file->private_data;
 	u8 bin[TURRIS_MOX_MAX_MODULES];
-	u8 hex[sizeof(buf) * 2 + 1];
+	u8 hex[sizeof(bin) * 2 + 1];
 	int ret, n;
 
 	ret = moxtet_spi_read(moxtet, bin);


