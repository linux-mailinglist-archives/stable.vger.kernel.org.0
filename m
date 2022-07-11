Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 96E5056FAE7
	for <lists+stable@lfdr.de>; Mon, 11 Jul 2022 11:23:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231877AbiGKJXe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Jul 2022 05:23:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46610 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232001AbiGKJW7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 11 Jul 2022 05:22:59 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF863F34;
        Mon, 11 Jul 2022 02:13:38 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 357E0610A5;
        Mon, 11 Jul 2022 09:13:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 47ECCC34115;
        Mon, 11 Jul 2022 09:13:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1657530817;
        bh=lh7AYL4Z8YvuRd3eo1vbbmlhCCo0hOo/6FSah1I1Stk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qo66wcQZwr1+ewOUr4ARbbfBGH3ihBv0TlT56VyncBe9xt/TYp2XfQsCnA10GTUOr
         itAMJ2wZeHX1ydEHl11i2NZQguMAS+IPDEwP5E8xyPvx3I97sqSWo5rj64TtCquhMl
         QAaD/LY4FnFpMkzbMJb9w7BBj83xVNc7Rc5dJceQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, kernel test robot <lkp@intel.com>,
        stable <stable@kernel.org>,
        Shuah Khan <skhan@linuxfoundation.org>
Subject: [PATCH 5.10 49/55] misc: rtsx_usb: set return value in rsp_buf alloc err path
Date:   Mon, 11 Jul 2022 11:07:37 +0200
Message-Id: <20220711090543.200546951@linuxfoundation.org>
X-Mailer: git-send-email 2.37.0
In-Reply-To: <20220711090541.764895984@linuxfoundation.org>
References: <20220711090541.764895984@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Shuah Khan <skhan@linuxfoundation.org>

commit 2cd37c2e72449a7add6da1183d20a6247d6db111 upstream.

Set return value in rsp_buf alloc error path before going to
error handling.

drivers/misc/cardreader/rtsx_usb.c:639:6: warning: variable 'ret' is used uninitialized whenever 'if' condition is true [-Wsometimes-uninitialized]
           if (!ucr->rsp_buf)
               ^~~~~~~~~~~~~
   drivers/misc/cardreader/rtsx_usb.c:678:9: note: uninitialized use occurs here
           return ret;
                  ^~~
   drivers/misc/cardreader/rtsx_usb.c:639:2: note: remove the 'if' if its condition is always false
           if (!ucr->rsp_buf)
           ^~~~~~~~~~~~~~~~~~
   drivers/misc/cardreader/rtsx_usb.c:622:9: note: initialize the variable 'ret' to silence this warning
           int ret;
                  ^
                   = 0

Fixes: 3776c7855985 ("misc: rtsx_usb: use separate command and response buffers")
Reported-by: kernel test robot <lkp@intel.com>
Cc: stable <stable@kernel.org>
Signed-off-by: Shuah Khan <skhan@linuxfoundation.org>
Link: https://lore.kernel.org/r/20220701165352.15687-1-skhan@linuxfoundation.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/misc/cardreader/rtsx_usb.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/misc/cardreader/rtsx_usb.c
+++ b/drivers/misc/cardreader/rtsx_usb.c
@@ -636,8 +636,10 @@ static int rtsx_usb_probe(struct usb_int
 		return -ENOMEM;
 
 	ucr->rsp_buf = kmalloc(IOBUF_SIZE, GFP_KERNEL);
-	if (!ucr->rsp_buf)
+	if (!ucr->rsp_buf) {
+		ret = -ENOMEM;
 		goto out_free_cmd_buf;
+	}
 
 	usb_set_intfdata(intf, ucr);
 


