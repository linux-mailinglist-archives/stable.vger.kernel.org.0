Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DEA8F68D8D6
	for <lists+stable@lfdr.de>; Tue,  7 Feb 2023 14:13:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232477AbjBGNNe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Feb 2023 08:13:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59468 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232291AbjBGNNR (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Feb 2023 08:13:17 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD5743D092
        for <stable@vger.kernel.org>; Tue,  7 Feb 2023 05:12:36 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 81966CE1DB0
        for <stable@vger.kernel.org>; Tue,  7 Feb 2023 13:12:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6CAADC433EF;
        Tue,  7 Feb 2023 13:12:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1675775531;
        bh=Bps+J6UDRFPS9Wp2ZEWdaBrTanEGPs8en/1gsdXGfy0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IcRfyS42YV7/KJgcdun+ankhlWdtsAgac0EfF7tUB5dqgAGnTd5uKLlwhhV6RqGEf
         gfrvJrXQlL0I9iAzw8eXUYUjNVAlWF24Rr46bknKKqtVdVAxSzlsRGFGjGy2hWTuv3
         PJ6UJsNqNzLs1YrwpFyH4bF2/yZMKyATV6h7j5Ew=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Alexander Egorenkov <egorenar@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>
Subject: [PATCH 5.15 070/120] watchdog: diag288_wdt: fix __diag288() inline assembly
Date:   Tue,  7 Feb 2023 13:57:21 +0100
Message-Id: <20230207125621.733170263@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230207125618.699726054@linuxfoundation.org>
References: <20230207125618.699726054@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alexander Egorenkov <egorenar@linux.ibm.com>

commit 32e40f9506b9e32917eb73154f93037b443124d1 upstream.

The DIAG 288 statement consumes an EBCDIC string the address of which is
passed in a register. Use a "memory" clobber to tell the compiler that
memory is accessed within the inline assembly.

Signed-off-by: Alexander Egorenkov <egorenar@linux.ibm.com>
Reviewed-by: Heiko Carstens <hca@linux.ibm.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Heiko Carstens <hca@linux.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/watchdog/diag288_wdt.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/watchdog/diag288_wdt.c
+++ b/drivers/watchdog/diag288_wdt.c
@@ -86,7 +86,7 @@ static int __diag288(unsigned int func,
 		"1:\n"
 		EX_TABLE(0b, 1b)
 		: "+d" (err) : "d"(__func), "d"(__timeout),
-		  "d"(__action), "d"(__len) : "1", "cc");
+		  "d"(__action), "d"(__len) : "1", "cc", "memory");
 	return err;
 }
 


