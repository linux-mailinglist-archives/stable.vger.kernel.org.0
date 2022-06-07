Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 007A6541DD3
	for <lists+stable@lfdr.de>; Wed,  8 Jun 2022 00:22:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1381227AbiFGWVv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 18:21:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49782 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1384810AbiFGWUs (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 18:20:48 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A8FF9263286;
        Tue,  7 Jun 2022 12:20:44 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7361060A21;
        Tue,  7 Jun 2022 19:20:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 81A46C385A2;
        Tue,  7 Jun 2022 19:20:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654629643;
        bh=qVgSGNTA10yoXOmVS9eSdEfnCYfxg4a9wPi4RdE+Q6o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NLugf7DGnePok2QMzFSSwdUzIF+2y/G4UhWIJ+cMJUD/de0Ua8EJYrgvgeizkiedy
         GfTcRGDtVAbVUl3iujvrBTtxMe9o35HE8TXzowhBR9isdHtSduHjjfblO69PubLp8s
         fXl7K6QIHFBBo0zdcG5NujhraNsOYefEWrtDvw5A=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Miaoqian Lin <linmq006@gmail.com>,
        Corey Minyard <cminyard@mvista.com>
Subject: [PATCH 5.18 724/879] ipmi:ipmb: Fix refcount leak in ipmi_ipmb_probe
Date:   Tue,  7 Jun 2022 19:04:02 +0200
Message-Id: <20220607165023.869056542@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607165002.659942637@linuxfoundation.org>
References: <20220607165002.659942637@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Miaoqian Lin <linmq006@gmail.com>

commit a508e33956b538e034ed5df619a73ec7c15bda72 upstream.

of_parse_phandle() returns a node pointer with refcount
incremented, we should use of_node_put() on it when done.
Add missing of_node_put() to avoid refcount leak.

Fixes: 00d93611f002 ("ipmi:ipmb: Add the ability to have a separate slave and master device")
Signed-off-by: Miaoqian Lin <linmq006@gmail.com>
Message-Id: <20220512044445.3102-1-linmq006@gmail.com>
Cc: stable@vger.kernel.org # v5.17+
Signed-off-by: Corey Minyard <cminyard@mvista.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/char/ipmi/ipmi_ipmb.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/char/ipmi/ipmi_ipmb.c
+++ b/drivers/char/ipmi/ipmi_ipmb.c
@@ -476,6 +476,7 @@ static int ipmi_ipmb_probe(struct i2c_cl
 	slave_np = of_parse_phandle(dev->of_node, "slave-dev", 0);
 	if (slave_np) {
 		slave_adap = of_get_i2c_adapter_by_node(slave_np);
+		of_node_put(slave_np);
 		if (!slave_adap) {
 			dev_notice(&client->dev,
 				   "Could not find slave adapter\n");


