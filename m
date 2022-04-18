Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5ABBF50553B
	for <lists+stable@lfdr.de>; Mon, 18 Apr 2022 15:24:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241268AbiDRNLo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Apr 2022 09:11:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46518 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242275AbiDRNIz (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 18 Apr 2022 09:08:55 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7784A3525B;
        Mon, 18 Apr 2022 05:48:26 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 076106128A;
        Mon, 18 Apr 2022 12:48:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F3DC3C385A7;
        Mon, 18 Apr 2022 12:48:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1650286104;
        bh=eKsyNOgDgUbv/IxsbppHvlC2vjtNL19xnUQ72S2luC8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wSKW66Sl02sksyfDJ8are+diEnkMgQVugNkrKpXeX3XktmnDleAhwOqf7doueEEsY
         5nUDwjZvjOCUOjGtjFbU505GDnK/wwto1ZghA95pzAJR4asEQujIY4lmOMAmXqcUap
         IRxv6p89417PR+yCQ2yvS5O9lqSGOzoe7SGUPPc4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yajun Deng <yajun.deng@linux.dev>,
        "David S. Miller" <davem@davemloft.net>,
        Pavel Machek <pavel@denx.de>
Subject: [PATCH 4.14 003/284] netdevice: add the case if dev is NULL
Date:   Mon, 18 Apr 2022 14:09:44 +0200
Message-Id: <20220418121210.791317858@linuxfoundation.org>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <20220418121210.689577360@linuxfoundation.org>
References: <20220418121210.689577360@linuxfoundation.org>
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
@@ -3378,7 +3378,8 @@ void netdev_run_todo(void);
  */
 static inline void dev_put(struct net_device *dev)
 {
-	this_cpu_dec(*dev->pcpu_refcnt);
+	if (dev)
+		this_cpu_dec(*dev->pcpu_refcnt);
 }
 
 /**
@@ -3389,7 +3390,8 @@ static inline void dev_put(struct net_de
  */
 static inline void dev_hold(struct net_device *dev)
 {
-	this_cpu_inc(*dev->pcpu_refcnt);
+	if (dev)
+		this_cpu_inc(*dev->pcpu_refcnt);
 }
 
 /* Carrier loss detection, dial on demand. The functions netif_carrier_on


