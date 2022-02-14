Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AD38E4B4795
	for <lists+stable@lfdr.de>; Mon, 14 Feb 2022 10:54:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245236AbiBNJsJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Feb 2022 04:48:09 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:43386 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245188AbiBNJot (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Feb 2022 04:44:49 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 44B6E6A026;
        Mon, 14 Feb 2022 01:38:23 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0AECFB80DC6;
        Mon, 14 Feb 2022 09:38:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2BDEDC340EF;
        Mon, 14 Feb 2022 09:38:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1644831500;
        bh=iVVprejHhTHrKXydZFMArGB8nKpVGa/J/tekSOuOWgU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TaEEx2tkrA5QJk49m2ETgbooEsqJ+A89s3lK2PbjJqkK0Hpw6Nb5lLZX0VhU51YWt
         3StPKZMHvsVFyD2HQhnBMwWXPN33IRPxY3a/0Wvz76l6TLaCFo3ehC0uuBe3hLaqP+
         ViOkEy+1w9YEedgDO7E1rQF9vyClH4iZ5oBi0kik=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Szymon Heidrich <szymon.heidrich@gmail.com>, stable@kernel.org
Subject: [PATCH 5.4 60/71] usb: gadget: rndis: check size of RNDIS_MSG_SET command
Date:   Mon, 14 Feb 2022 10:26:28 +0100
Message-Id: <20220214092454.058631155@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220214092452.020713240@linuxfoundation.org>
References: <20220214092452.020713240@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

commit 38ea1eac7d88072bbffb630e2b3db83ca649b826 upstream.

Check the size of the RNDIS_MSG_SET command given to us before
attempting to respond to an invalid message size.

Reported-by: Szymon Heidrich <szymon.heidrich@gmail.com>
Cc: stable@kernel.org
Tested-by: Szymon Heidrich <szymon.heidrich@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/gadget/function/rndis.c |    9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

--- a/drivers/usb/gadget/function/rndis.c
+++ b/drivers/usb/gadget/function/rndis.c
@@ -637,14 +637,17 @@ static int rndis_set_response(struct rnd
 	rndis_set_cmplt_type *resp;
 	rndis_resp_t *r;
 
+	BufLength = le32_to_cpu(buf->InformationBufferLength);
+	BufOffset = le32_to_cpu(buf->InformationBufferOffset);
+	if ((BufLength > RNDIS_MAX_TOTAL_SIZE) ||
+	    (BufOffset + 8 >= RNDIS_MAX_TOTAL_SIZE))
+		    return -EINVAL;
+
 	r = rndis_add_response(params, sizeof(rndis_set_cmplt_type));
 	if (!r)
 		return -ENOMEM;
 	resp = (rndis_set_cmplt_type *)r->buf;
 
-	BufLength = le32_to_cpu(buf->InformationBufferLength);
-	BufOffset = le32_to_cpu(buf->InformationBufferOffset);
-
 #ifdef	VERBOSE_DEBUG
 	pr_debug("%s: Length: %d\n", __func__, BufLength);
 	pr_debug("%s: Offset: %d\n", __func__, BufOffset);


