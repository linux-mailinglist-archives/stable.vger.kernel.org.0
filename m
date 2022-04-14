Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AFCEA501562
	for <lists+stable@lfdr.de>; Thu, 14 Apr 2022 17:41:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243556AbiDNNwD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 14 Apr 2022 09:52:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34966 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245051AbiDNNiJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 14 Apr 2022 09:38:09 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E66699ED9;
        Thu, 14 Apr 2022 06:31:34 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D918C61BB3;
        Thu, 14 Apr 2022 13:31:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E6DE3C385AB;
        Thu, 14 Apr 2022 13:31:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649943093;
        bh=2mXHrAj04KtaHylAldGkgnozw1wbrx2qEfheCDOgjVw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=f5PsMA4DV+2KmpF0BOu+Dc2LIkmqCJNnQmodMH8IPwTANOh4AO00aVhtVzx+jE2DC
         V0WlY/BSGvrfyE7Q68A60zHxIXC/0vWFJWrT6vRrD+2grb33QzucWBJTLAKRV3LQbL
         N4sksy5E0R9J/8TQUa+0r7HIDKdj9n0+eY5/N71Q=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yajun Deng <yajun.deng@linux.dev>,
        "David S. Miller" <davem@davemloft.net>,
        Pavel Machek <pavel@denx.de>
Subject: [PATCH 5.4 005/475] netdevice: add the case if dev is NULL
Date:   Thu, 14 Apr 2022 15:06:30 +0200
Message-Id: <20220414110855.302424208@linuxfoundation.org>
X-Mailer: git-send-email 2.35.2
In-Reply-To: <20220414110855.141582785@linuxfoundation.org>
References: <20220414110855.141582785@linuxfoundation.org>
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

From: Yajun Deng <yajun.deng@linux.dev>

commit b37a466837393af72fe8bcb8f1436410f3f173f3 upstream.

Add the case if dev is NULL in dev_{put, hold}, so the caller doesn't
need to care whether dev is NULL or not.

Signed-off-by: Yajun Deng <yajun.deng@linux.dev>
Signed-off-by: David S. Miller <davem@davemloft.net>
Cc: Pavel Machek <pavel@denx.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/netdevice.h |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -3777,7 +3777,8 @@ void netdev_run_todo(void);
  */
 static inline void dev_put(struct net_device *dev)
 {
-	this_cpu_dec(*dev->pcpu_refcnt);
+	if (dev)
+		this_cpu_dec(*dev->pcpu_refcnt);
 }
 
 /**
@@ -3788,7 +3789,8 @@ static inline void dev_put(struct net_de
  */
 static inline void dev_hold(struct net_device *dev)
 {
-	this_cpu_inc(*dev->pcpu_refcnt);
+	if (dev)
+		this_cpu_inc(*dev->pcpu_refcnt);
 }
 
 /* Carrier loss detection, dial on demand. The functions netif_carrier_on


