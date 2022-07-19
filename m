Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2E401579CFF
	for <lists+stable@lfdr.de>; Tue, 19 Jul 2022 14:46:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241681AbiGSMqq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Jul 2022 08:46:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38556 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241679AbiGSMpp (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 19 Jul 2022 08:45:45 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 46A988AED4;
        Tue, 19 Jul 2022 05:18:22 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9941061772;
        Tue, 19 Jul 2022 12:17:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7BE47C341C6;
        Tue, 19 Jul 2022 12:17:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1658233070;
        bh=WIQF5vxdOZ2KF4yk/EEVlLDaVI0fgt+mpRIAAVOSRjk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Y7ssVWdy9qVZPk3+DkpHBQ7qUa/iqUSsUoPNP9LFdryTOUm9LPePJH9PlWYkgaT0j
         o7bzIXlXyFriiFfm0jIN1RI97eEs3klBNP1cHT3602pGZFeDqXTcb+Rjw29IgzJVP8
         R+E/L7wsjzEqlcuRX1U7CISUdeDJNSwoZmgkPNAg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yi Yang <yiyang13@huawei.com>,
        stable <stable@kernel.org>
Subject: [PATCH 5.15 163/167] serial: 8250: fix return error code in serial8250_request_std_resource()
Date:   Tue, 19 Jul 2022 13:54:55 +0200
Message-Id: <20220719114712.236443969@linuxfoundation.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220719114656.750574879@linuxfoundation.org>
References: <20220719114656.750574879@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yi Yang <yiyang13@huawei.com>

commit 6e690d54cfa802f939cefbd2fa2c91bd0b8bd1b6 upstream.

If port->mapbase = NULL in serial8250_request_std_resource() , it need
return a error code instead of 0. If uart_set_info() fail to request new
regions by serial8250_request_std_resource() but the return value of
serial8250_request_std_resource() is 0, The system incorrectly considers
that the resource application is successful and does not attempt to
restore the old setting. A null pointer reference is triggered when the
port resource is later invoked.

Signed-off-by: Yi Yang <yiyang13@huawei.com>
Cc: stable <stable@kernel.org>
Link: https://lore.kernel.org/r/20220628083515.64138-1-yiyang13@huawei.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/tty/serial/8250/8250_port.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/tty/serial/8250/8250_port.c
+++ b/drivers/tty/serial/8250/8250_port.c
@@ -2982,8 +2982,10 @@ static int serial8250_request_std_resour
 	case UPIO_MEM32BE:
 	case UPIO_MEM16:
 	case UPIO_MEM:
-		if (!port->mapbase)
+		if (!port->mapbase) {
+			ret = -EINVAL;
 			break;
+		}
 
 		if (!request_mem_region(port->mapbase, size, "serial")) {
 			ret = -EBUSY;


