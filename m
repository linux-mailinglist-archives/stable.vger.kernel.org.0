Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2AA904F24D4
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 09:39:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231773AbiDEHlg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 03:41:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52118 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231761AbiDEHlJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 03:41:09 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9140D4B436;
        Tue,  5 Apr 2022 00:39:11 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DC46461690;
        Tue,  5 Apr 2022 07:39:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E5A6CC340EE;
        Tue,  5 Apr 2022 07:39:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649144350;
        bh=up/dd1x1ze4xIvI4L8PDVed9sHZe0DHRytKUsawlFDw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rPqzGh+U9EOLfwfFALNdWNBIiR8L3COGobPcedCLjKvpCnzmLYMQ/RlULUqKFDZJ6
         wkUEDZBIWx6RnlmENn9aelElUGggwVqh4FlmP7ykRtyfj2Va37lyiUbKkjmnRKngp4
         TThMWn6REbRr9ne423ft6bas0ooOsz8e/ngRKEhY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Maty=C3=A1=C5=A1=20Kroupa?= <kroupa.matyas@gmail.com>,
        Johan Hovold <johan@kernel.org>
Subject: [PATCH 5.17 0004/1126] USB: serial: pl2303: fix GS type detection
Date:   Tue,  5 Apr 2022 09:12:31 +0200
Message-Id: <20220405070407.656792714@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070407.513532867@linuxfoundation.org>
References: <20220405070407.513532867@linuxfoundation.org>
User-Agent: quilt/0.66
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

From: Johan Hovold <johan@kernel.org>

commit 5b6ab28d06780c87320ceade61698bb6719c85db upstream.

At least some PL2303GS have a bcdDevice of 0x605 instead of 0x100 as the
datasheet claims. Add it to the list of known release numbers for the
HXN (G) type.

Fixes: 894758d0571d ("USB: serial: pl2303: tighten type HXN (G) detection")
Reported-by: Matyáš Kroupa <kroupa.matyas@gmail.com>
Link: https://lore.kernel.org/r/165de6a0-43e9-092c-2916-66b115c7fbf4@gmail.com
Cc: stable@vger.kernel.org	# 5.13
Signed-off-by: Johan Hovold <johan@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/serial/pl2303.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/usb/serial/pl2303.c
+++ b/drivers/usb/serial/pl2303.c
@@ -436,6 +436,7 @@ static int pl2303_detect_type(struct usb
 		case 0x105:
 		case 0x305:
 		case 0x405:
+		case 0x605:
 			/*
 			 * Assume it's an HXN-type if the device doesn't
 			 * support the old read request value.


