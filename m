Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2B0B860A47B
	for <lists+stable@lfdr.de>; Mon, 24 Oct 2022 14:11:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232885AbiJXML0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Oct 2022 08:11:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41996 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229782AbiJXMKD (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Oct 2022 08:10:03 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2CAD12BB0A;
        Mon, 24 Oct 2022 04:53:36 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 29C516129E;
        Mon, 24 Oct 2022 11:46:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 37632C433D6;
        Mon, 24 Oct 2022 11:46:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666611972;
        bh=iafMQX0LLGAsrS6c7Ds92V5u8tPAuViCsplCLjBiFQs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=l8tpyBib/eObZuC/jQB6lR2lLm8XFJGAIYMhB1b2UJ6Zo/89GV3IdLQu/H47YsJw9
         8I25WGivDCfCoaGnGxnovfKe5mC5nHJrwHQ+tx/Rm0WNdHLzY0R4CDgU8pu9S9VQF1
         m9GJcLL3RjnbfLG+wiCl9Oe5wJ8eYMuuqtlpHulk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Alexander Popov <alex.popov@linux.com>,
        =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
        <u.kleine-koenig@pengutronix.de>, Wolfram Sang <wsa@the-dreams.de>,
        Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
Subject: [PATCH 4.14 021/210] i2c: dev: prevent ZERO_SIZE_PTR deref in i2cdev_ioctl_rdwr()
Date:   Mon, 24 Oct 2022 13:28:58 +0200
Message-Id: <20221024112957.648694176@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221024112956.797777597@linuxfoundation.org>
References: <20221024112956.797777597@linuxfoundation.org>
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

From: Alexander Popov <alex.popov@linux.com>

commit 23a27722b5292ef0b27403c87a109feea8296a5c upstream.

i2cdev_ioctl_rdwr() allocates i2c_msg.buf using memdup_user(), which
returns ZERO_SIZE_PTR if i2c_msg.len is zero.

Currently i2cdev_ioctl_rdwr() always dereferences the buf pointer in case
of I2C_M_RD | I2C_M_RECV_LEN transfer. That causes a kernel oops in
case of zero len.

Let's check the len against zero before dereferencing buf pointer.

This issue was triggered by syzkaller.

Signed-off-by: Alexander Popov <alex.popov@linux.com>
Reviewed-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
[wsa: use '< 1' instead of '!' for easier readability]
Signed-off-by: Wolfram Sang <wsa@the-dreams.de>
[Harshit: backport to 4.14.y, use rdwr_pa[i].len instead of msgs[i].len
as the 4.14.y  code uses rdwr_pa.]
Signed-off-by: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/i2c/i2c-dev.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/i2c/i2c-dev.c
+++ b/drivers/i2c/i2c-dev.c
@@ -297,7 +297,7 @@ static noinline int i2cdev_ioctl_rdwr(st
 		 */
 		if (rdwr_pa[i].flags & I2C_M_RECV_LEN) {
 			if (!(rdwr_pa[i].flags & I2C_M_RD) ||
-			    rdwr_pa[i].buf[0] < 1 ||
+			    rdwr_pa[i].len < 1 || rdwr_pa[i].buf[0] < 1 ||
 			    rdwr_pa[i].len < rdwr_pa[i].buf[0] +
 					     I2C_SMBUS_BLOCK_MAX) {
 				i++;


