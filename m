Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8E9134E2829
	for <lists+stable@lfdr.de>; Mon, 21 Mar 2022 14:52:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348123AbiCUNxh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Mar 2022 09:53:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37008 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348119AbiCUNxf (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 21 Mar 2022 09:53:35 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA1B015DAA6;
        Mon, 21 Mar 2022 06:52:09 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3326061261;
        Mon, 21 Mar 2022 13:52:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 42E13C340E8;
        Mon, 21 Mar 2022 13:52:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1647870728;
        bh=N+NlLnEfVlFkeG3akY42dpb6DERXaGMYwvWEpiWjiMQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=b7z41JgXt/OC0XGrjC9rHFZzoy4Yj4VvDbqZZCcWztP6/nwNmFXHD/omdPL9jElaz
         pFRRMyPzASIKvqd5fE5dXiQNXeKR2/fVvk8nf6bUtDzGwD0ZSP9KIpUKv2ADwwme8l
         O4kLQmzydg5h+H+FDkbUJmofO+Reozxc32T5zPpo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, stable@kernel.org,
        Dan Carpenter <dan.carpenter@oracle.com>
Subject: [PATCH 4.9 14/16] usb: gadget: rndis: prevent integer overflow in rndis_set_response()
Date:   Mon, 21 Mar 2022 14:51:44 +0100
Message-Id: <20220321133217.072447221@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220321133216.648316863@linuxfoundation.org>
References: <20220321133216.648316863@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dan Carpenter <dan.carpenter@oracle.com>

commit 65f3324f4b6fed78b8761c3b74615ecf0ffa81fa upstream.

If "BufOffset" is very large the "BufOffset + 8" operation can have an
integer overflow.

Cc: stable@kernel.org
Fixes: 38ea1eac7d88 ("usb: gadget: rndis: check size of RNDIS_MSG_SET command")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Link: https://lore.kernel.org/r/20220301080424.GA17208@kili
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/gadget/function/rndis.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/usb/gadget/function/rndis.c
+++ b/drivers/usb/gadget/function/rndis.c
@@ -645,6 +645,7 @@ static int rndis_set_response(struct rnd
 	BufLength = le32_to_cpu(buf->InformationBufferLength);
 	BufOffset = le32_to_cpu(buf->InformationBufferOffset);
 	if ((BufLength > RNDIS_MAX_TOTAL_SIZE) ||
+	    (BufOffset > RNDIS_MAX_TOTAL_SIZE) ||
 	    (BufOffset + 8 >= RNDIS_MAX_TOTAL_SIZE))
 		    return -EINVAL;
 


