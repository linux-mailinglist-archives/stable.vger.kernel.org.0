Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7F28C593576
	for <lists+stable@lfdr.de>; Mon, 15 Aug 2022 20:28:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241634AbiHOSY7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 14:24:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42504 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240383AbiHOSYR (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 14:24:17 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 854191036;
        Mon, 15 Aug 2022 11:18:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9A90160690;
        Mon, 15 Aug 2022 18:18:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 74EB0C433C1;
        Mon, 15 Aug 2022 18:18:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660587482;
        bh=FU1YbE1E2NkvVleTcRnvyZW61eUHNYJXk19HtY0RX9A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PSiGu9bjtU5QsVX29MGql6L7ePOj24bxBu1szZKRkLUIK3asH98L/U6OAxXwYPjOI
         Gpi8z6T5HqKig4FvGYcCIla/9c4G4isiLYo21m2szcyXxDJiBYKQnucj6HkbeWJ+v2
         w/tqy2KHLijlaCeCy/bZZ4WweJrNXT7RJKxtUlmQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jack Pham <quic_jackp@quicinc.com>,
        Linyu Yuan <quic_linyyuan@quicinc.com>
Subject: [PATCH 5.15 099/779] usb: typec: ucsi: Acknowledge the GET_ERROR_STATUS command completion
Date:   Mon, 15 Aug 2022 19:55:43 +0200
Message-Id: <20220815180341.534233954@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180337.130757997@linuxfoundation.org>
References: <20220815180337.130757997@linuxfoundation.org>
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


