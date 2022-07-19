Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D9860579B34
	for <lists+stable@lfdr.de>; Tue, 19 Jul 2022 14:25:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239743AbiGSMZb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Jul 2022 08:25:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40570 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240366AbiGSMYy (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 19 Jul 2022 08:24:54 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0DA0250719;
        Tue, 19 Jul 2022 05:09:45 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6C9CC616DB;
        Tue, 19 Jul 2022 12:09:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3BCC1C341C6;
        Tue, 19 Jul 2022 12:09:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1658232584;
        bh=7deDS6NCBIIKmRfnBPGe+kGE6hQ5eD5poALJ+U+mWdI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=I+oZi5N2xu9T6X3e6xqvyWc0M4sG705vjNDmZA9P/G5L/ZQvytDEv6gepCWj4aEZH
         Iju7NrZHxpjR7gPV06ycCDow5USsnfAi3zPlFaoymT/bp1MbkUbZjaAa8ueFPcqVOH
         iRX+ub7B486+AkGsVABFYgWxqdVwnb6h66dn3vmM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yi Yang <yiyang13@huawei.com>,
        stable <stable@kernel.org>
Subject: [PATCH 5.10 108/112] serial: 8250: fix return error code in serial8250_request_std_resource()
Date:   Tue, 19 Jul 2022 13:54:41 +0200
Message-Id: <20220719114637.619381330@linuxfoundation.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220719114626.156073229@linuxfoundation.org>
References: <20220719114626.156073229@linuxfoundation.org>
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
@@ -2953,8 +2953,10 @@ static int serial8250_request_std_resour
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


