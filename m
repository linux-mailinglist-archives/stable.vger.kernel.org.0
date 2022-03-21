Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 14FFD4E2A20
	for <lists+stable@lfdr.de>; Mon, 21 Mar 2022 15:13:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348827AbiCUONy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Mar 2022 10:13:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38222 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349134AbiCUOH7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 21 Mar 2022 10:07:59 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 147DBC12DC;
        Mon, 21 Mar 2022 07:02:26 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 70D38613F5;
        Mon, 21 Mar 2022 14:02:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 86FAAC36AE3;
        Mon, 21 Mar 2022 14:02:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1647871344;
        bh=JBwT2FpWuW+DXrzrhNxMCQ2pX1GZUCBphhPILV5OTbU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=w12dDXJsShb4DQn2QFtgl1JjnEa5Ba8sr6oeGJQij7eH2VClaUrkOQosZH5yrM3+f
         i+PefE/0hMshOGAkaCRjmzKnnjgUCU10kfd9ogyBFoTecZQSkWTwv4fnQz3rvbH1Os
         p2y1vylMVx/hTPey4uEbpLr4qLeglsChThJ4kKdY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, stable@kernel.org,
        Dan Carpenter <dan.carpenter@oracle.com>
Subject: [PATCH 5.16 28/37] usb: gadget: rndis: prevent integer overflow in rndis_set_response()
Date:   Mon, 21 Mar 2022 14:53:10 +0100
Message-Id: <20220321133222.109841423@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220321133221.290173884@linuxfoundation.org>
References: <20220321133221.290173884@linuxfoundation.org>
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
 


