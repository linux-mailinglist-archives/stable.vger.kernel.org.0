Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A3FD7450C70
	for <lists+stable@lfdr.de>; Mon, 15 Nov 2021 18:35:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237826AbhKORis (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 12:38:48 -0500
Received: from mail.kernel.org ([198.145.29.99]:52664 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237874AbhKORhb (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 12:37:31 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id B78AB632D6;
        Mon, 15 Nov 2021 17:24:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1636997100;
        bh=xVhAAYW/y8QSF3uEjAXUZDZTXOFpSn0h1Gjfcsgw4SI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bgfZN3wg1b/kkMY6EnpY3EhXF1vI01HJTrT2UBwGGuqPwopyzNQ2cY4cE95fip8rd
         P0ut6PgYomQXRnt2jWcHInd3SDY3ErB2vR3//bMssJGiURPEbr/n31YXupMbhge0Qu
         R2VnPhGurD2SDXMXkj3fFrG+mByG3dWvlNLaKx9g=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Joaqu=C3=ADn=20Alberto=20Calder=C3=B3n=20Pozo?= 
        <kini_calderon@hotmail.com>, Sean Young <sean@mess.org>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Subject: [PATCH 5.10 025/575] media: ir-kbd-i2c: improve responsiveness of hauppauge zilog receivers
Date:   Mon, 15 Nov 2021 17:55:50 +0100
Message-Id: <20211115165344.484674704@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165343.579890274@linuxfoundation.org>
References: <20211115165343.579890274@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sean Young <sean@mess.org>

commit c73ba202a851c0b611ef2c25e568fadeff5e667f upstream.

The IR receiver has two issues:

 - Sometimes there is no response to a button press
 - Sometimes a button press is repeated when it should not have been

Hanging the polling interval fixes this behaviour.

Link: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=994050

Cc: stable@vger.kernel.org
Suggested-by: Joaquín Alberto Calderón Pozo <kini_calderon@hotmail.com>
Signed-off-by: Sean Young <sean@mess.org>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/i2c/ir-kbd-i2c.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/media/i2c/ir-kbd-i2c.c
+++ b/drivers/media/i2c/ir-kbd-i2c.c
@@ -791,6 +791,7 @@ static int ir_probe(struct i2c_client *c
 		rc_proto    = RC_PROTO_BIT_RC5 | RC_PROTO_BIT_RC6_MCE |
 							RC_PROTO_BIT_RC6_6A_32;
 		ir_codes    = RC_MAP_HAUPPAUGE;
+		ir->polling_interval = 125;
 		probe_tx = true;
 		break;
 	}


