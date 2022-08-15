Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E7519593B61
	for <lists+stable@lfdr.de>; Mon, 15 Aug 2022 22:35:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230502AbiHOUTG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 16:19:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34278 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240593AbiHOURE (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 16:17:04 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 24A40F48;
        Mon, 15 Aug 2022 12:00:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id BD2F2B8110B;
        Mon, 15 Aug 2022 19:00:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 25208C433B5;
        Mon, 15 Aug 2022 19:00:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660590013;
        bh=FU1YbE1E2NkvVleTcRnvyZW61eUHNYJXk19HtY0RX9A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bR9ieCzQucUwbzRG2hTXlxUYajypsp2tviRcVGbNG5VtJXm0stsxlc4UCnlfU9Mwf
         TdAAmFsgI9urgWZzFjZ/xnryuvenrVHAp5GaLwJqTksYr1qZ7qKg7/mIbrKQdvW662
         +CjFroXSdGLVj+nEC4u8IyC+5en07boZh+nXTRqI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jack Pham <quic_jackp@quicinc.com>,
        Linyu Yuan <quic_linyyuan@quicinc.com>
Subject: [PATCH 5.18 0122/1095] usb: typec: ucsi: Acknowledge the GET_ERROR_STATUS command completion
Date:   Mon, 15 Aug 2022 19:52:01 +0200
Message-Id: <20220815180434.641471278@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180429.240518113@linuxfoundation.org>
References: <20220815180429.240518113@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Linyu Yuan <quic_linyyuan@quicinc.com>

commit a7dc438b5e446afcd1b3b6651da28271400722f2 upstream.

We found PPM will not send any notification after it report error status
and OPM issue GET_ERROR_STATUS command to read the details about error.

According UCSI spec, PPM may clear the Error Status Data after the OPM
has acknowledged the command completion.

This change add operation to acknowledge the command completion from PPM.

Fixes: bdc62f2bae8f (usb: typec: ucsi: Simplified registration and I/O API)
Cc: <stable@vger.kernel.org> # 5.10
Signed-off-by: Jack Pham <quic_jackp@quicinc.com>
Signed-off-by: Linyu Yuan <quic_linyyuan@quicinc.com>
Link: https://lore.kernel.org/r/1658817949-4632-1-git-send-email-quic_linyyuan@quicinc.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/typec/ucsi/ucsi.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/drivers/usb/typec/ucsi/ucsi.c
+++ b/drivers/usb/typec/ucsi/ucsi.c
@@ -76,6 +76,10 @@ static int ucsi_read_error(struct ucsi *
 	if (ret)
 		return ret;
 
+	ret = ucsi_acknowledge_command(ucsi);
+	if (ret)
+		return ret;
+
 	switch (error) {
 	case UCSI_ERROR_INCOMPATIBLE_PARTNER:
 		return -EOPNOTSUPP;


