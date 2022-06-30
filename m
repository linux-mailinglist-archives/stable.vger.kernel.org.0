Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1C110561CC4
	for <lists+stable@lfdr.de>; Thu, 30 Jun 2022 16:15:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236233AbiF3ODD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 Jun 2022 10:03:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45074 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236295AbiF3OBk (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 30 Jun 2022 10:01:40 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C9C844A2C;
        Thu, 30 Jun 2022 06:52:46 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2B0466204B;
        Thu, 30 Jun 2022 13:52:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3741FC34115;
        Thu, 30 Jun 2022 13:52:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1656597163;
        bh=3idDa8ATqAbwQApJrzgq1aI3YN9/sb++FYb3ppCmv3M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bo7bD4vq2zF/IK/txFbyz4gAXgK3Ri52mUaeCMjGAc39xOdDKJeIPeUFiF7Cbwg+x
         MfelusT0ZDPSjaAGXRD85vblQGLisF5eSyVXK1v6Sfhs+dxb7AVoRBnCfKSu7uZoAp
         HtyJThkByAx7MzbbyNmPy0uPC41xh0vMwo9UR8sk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Thorsten Glaser <tg@mirbsd.de>,
        Diederik de Haas <didi.debian@cknow.org>
Subject: [PATCH 4.19 48/49] net/sched: move NULL ptr check to qdisc_put() too
Date:   Thu, 30 Jun 2022 15:47:01 +0200
Message-Id: <20220630133235.289157437@linuxfoundation.org>
X-Mailer: git-send-email 2.37.0
In-Reply-To: <20220630133233.910803744@linuxfoundation.org>
References: <20220630133233.910803744@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Diederik de Haas <didi.debian@cknow.org>

In commit 92833e8b5db6c209e9311ac8c6a44d3bf1856659 titled
"net: sched: rename qdisc_destroy() to qdisc_put()" part of the
functionality of qdisc_destroy() was moved into a (for linux-4.19.y)
new function qdisk_put(), and the previous calls to qdisc_destroy()
were changed to qdisk_put().
This made it similar to f.e. 5.10.y and current master.

There was one part of qdisc_destroy() not moved over to qdisc_put() and
that was the check for a NULL pointer, causing oopses.
(See upstream commit: 6efb971ba8edfbd80b666f29de12882852f095ae)
This patch fixes that.

Fixes: 92833e8b5db6c209e9311ac8c6a44d3bf1856659
Reported-by: Thorsten Glaser <tg@mirbsd.de>
Link: https://bugs.debian.org/1013299
Signed-off-by: Diederik de Haas <didi.debian@cknow.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/sched/sch_generic.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/net/sched/sch_generic.c
+++ b/net/sched/sch_generic.c
@@ -970,8 +970,6 @@ static void qdisc_destroy(struct Qdisc *
 	const struct Qdisc_ops *ops;
 	struct sk_buff *skb, *tmp;
 
-	if (!qdisc)
-		return;
 	ops = qdisc->ops;
 
 #ifdef CONFIG_NET_SCHED
@@ -1003,6 +1001,9 @@ static void qdisc_destroy(struct Qdisc *
 
 void qdisc_put(struct Qdisc *qdisc)
 {
+	if (!qdisc)
+		return;
+
 	if (qdisc->flags & TCQ_F_BUILTIN ||
 	    !refcount_dec_and_test(&qdisc->refcnt))
 		return;


