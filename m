Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DC2F84E28FC
	for <lists+stable@lfdr.de>; Mon, 21 Mar 2022 14:59:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348573AbiCUOBB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Mar 2022 10:01:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44092 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349041AbiCUN6t (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 21 Mar 2022 09:58:49 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF5D91777F8;
        Mon, 21 Mar 2022 06:57:08 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9B1DBB81674;
        Mon, 21 Mar 2022 13:57:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 15CF4C340F2;
        Mon, 21 Mar 2022 13:57:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1647871026;
        bh=JBwT2FpWuW+DXrzrhNxMCQ2pX1GZUCBphhPILV5OTbU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DFngkhzieF3ZQp/I5AMKG/rBhmzQC8G18SEAgLfv2z9CRALApJfQ3J6zelaGhC/tS
         U+4qmITblVukjv5B0bwgUEjIz/mLtF6tf4ZbQvdSVp3SfMiwl/qBlbW/BhfW6pBcz6
         Q5l1Q7HNs21mT7aCQbSu5D1ugCUMo8cPPDNGRzPw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, stable@kernel.org,
        Dan Carpenter <dan.carpenter@oracle.com>
Subject: [PATCH 4.19 54/57] usb: gadget: rndis: prevent integer overflow in rndis_set_response()
Date:   Mon, 21 Mar 2022 14:52:35 +0100
Message-Id: <20220321133223.547619657@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220321133221.984120927@linuxfoundation.org>
References: <20220321133221.984120927@linuxfoundation.org>
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
@@ -640,6 +640,7 @@ static int rndis_set_response(struct rnd
 	BufLength = le32_to_cpu(buf->InformationBufferLength);
 	BufOffset = le32_to_cpu(buf->InformationBufferOffset);
 	if ((BufLength > RNDIS_MAX_TOTAL_SIZE) ||
+	    (BufOffset > RNDIS_MAX_TOTAL_SIZE) ||
 	    (BufOffset + 8 >= RNDIS_MAX_TOTAL_SIZE))
 		    return -EINVAL;
 


