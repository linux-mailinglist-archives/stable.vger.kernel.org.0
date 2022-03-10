Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5B4CC4D4B93
	for <lists+stable@lfdr.de>; Thu, 10 Mar 2022 16:00:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244082AbiCJOcp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Mar 2022 09:32:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50106 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343933AbiCJOba (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 10 Mar 2022 09:31:30 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C9EDAEA74F;
        Thu, 10 Mar 2022 06:28:48 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 64B6B61C0A;
        Thu, 10 Mar 2022 14:28:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4FC41C340E8;
        Thu, 10 Mar 2022 14:28:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1646922527;
        bh=YnxLeomZr+WCm3j3/G5Xk8FKG/OO3SIXhb//3Tp3bvQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=G+eW0QO2bPR656P8Y+uRlJygyhH/nkTtfjA/3lLOTfWCOF0Gwyp4Cu/CseVI1vpDF
         0DC2guGrM4llXW5/4Q+CGJTp3VCM4YP4iAA15RD5q+jdksfve4hnyzlbFBgKT1QYmp
         Ii1U5XQrhXFyvdvDvtib0OCEFPTBnrGCU5AsBBgQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, lkp@intel.com,
        Huang Pei <huangpei@loongson.cn>,
        "David S. Miller" <davem@davemloft.net>,
        Guenter Roeck <linux@roeck-us.net>
Subject: [PATCH 5.15 01/58] slip: fix macro redefine warning
Date:   Thu, 10 Mar 2022 15:18:50 +0100
Message-Id: <20220310140813.027135161@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220310140812.983088611@linuxfoundation.org>
References: <20220310140812.983088611@linuxfoundation.org>
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Huang Pei <huangpei@loongson.cn>

commit e5b40668e930979bd1e82c7ed7c9029db635f0e4 upstream.

MIPS/IA64 define END as assembly function ending, which conflict
with END definition in slip.h, just undef it at first

Reported-by: lkp@intel.com
Signed-off-by: Huang Pei <huangpei@loongson.cn>
Signed-off-by: David S. Miller <davem@davemloft.net>
Cc: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/slip/slip.h |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/net/slip/slip.h
+++ b/drivers/net/slip/slip.h
@@ -40,6 +40,8 @@
 					   insmod -oslip_maxdev=nnn	*/
 #define SL_MTU		296		/* 296; I am used to 600- FvK	*/
 
+/* some arch define END as assembly function ending, just undef it */
+#undef	END
 /* SLIP protocol characters. */
 #define END             0300		/* indicates end of frame	*/
 #define ESC             0333		/* indicates byte stuffing	*/


