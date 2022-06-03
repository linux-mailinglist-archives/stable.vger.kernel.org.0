Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2D24F53CFA0
	for <lists+stable@lfdr.de>; Fri,  3 Jun 2022 19:55:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345826AbiFCRzI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 Jun 2022 13:55:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58248 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345501AbiFCRxD (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 3 Jun 2022 13:53:03 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1833D1F624;
        Fri,  3 Jun 2022 10:52:25 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7411460F7F;
        Fri,  3 Jun 2022 17:52:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 693AEC385B8;
        Fri,  3 Jun 2022 17:52:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654278743;
        bh=K6tYsH8bSgs3PfSjUaakxOh0TLf3zeJAhtERYiKfyYg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=m65Z/RwzF2D+ojxP/aDMAJY6kqAGddAJf8P6tTfTqYKeIFPLk1Ojkb7I3v5kRqdhm
         1ivq8nc0D/aAMxDNrBReOAxc7G7dzKmYJT4fq/rkmHQeVnH3IPzVqbL1CmyD2Om86o
         SEd5sde/vWfkZjchRx7cMQp/YAj/k9IooGaSLZlI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Zheyu Ma <zheyuma97@gmail.com>
Subject: [PATCH 5.17 13/75] i2c: ismt: prevent memory corruption in ismt_access()
Date:   Fri,  3 Jun 2022 19:42:57 +0200
Message-Id: <20220603173822.125311085@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220603173821.749019262@linuxfoundation.org>
References: <20220603173821.749019262@linuxfoundation.org>
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

commit 690b2549b19563ec5ad53e5c82f6a944d910086e upstream.

The "data->block[0]" variable comes from the user and is a number
between 0-255.  It needs to be capped to prevent writing beyond the end
of dma_buffer[].

Fixes: 5e9a97b1f449 ("i2c: ismt: Adding support for I2C_SMBUS_BLOCK_PROC_CALL")
Reported-and-tested-by: Zheyu Ma <zheyuma97@gmail.com>
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Reviewed-by: Mika Westerberg <mika.westerberg@linux.intel.com>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/i2c/busses/i2c-ismt.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/i2c/busses/i2c-ismt.c
+++ b/drivers/i2c/busses/i2c-ismt.c
@@ -528,6 +528,9 @@ static int ismt_access(struct i2c_adapte
 
 	case I2C_SMBUS_BLOCK_PROC_CALL:
 		dev_dbg(dev, "I2C_SMBUS_BLOCK_PROC_CALL\n");
+		if (data->block[0] > I2C_SMBUS_BLOCK_MAX)
+			return -EINVAL;
+
 		dma_size = I2C_SMBUS_BLOCK_MAX;
 		desc->tgtaddr_rw = ISMT_DESC_ADDR_RW(addr, 1);
 		desc->wr_len_cmd = data->block[0] + 1;


