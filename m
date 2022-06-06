Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E6B9553E8E4
	for <lists+stable@lfdr.de>; Mon,  6 Jun 2022 19:08:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235633AbiFFLre (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Jun 2022 07:47:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40946 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235652AbiFFLrd (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Jun 2022 07:47:33 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 33DF219C15
        for <stable@vger.kernel.org>; Mon,  6 Jun 2022 04:47:32 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id CD66EB8180E
        for <stable@vger.kernel.org>; Mon,  6 Jun 2022 11:47:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 389E8C385A9;
        Mon,  6 Jun 2022 11:47:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654516049;
        bh=aVLLN4GIOVHq46FmbJaivndb2qhk0uwLwgu44mccoeI=;
        h=Subject:To:Cc:From:Date:From;
        b=V7ISeCOEb/OYKvKJbuP0mr/bTftP9uMQGW75DBsitwAHYACTqcOWGezSln465enBF
         kqRWT5DE+779nu8d5d1VZgRD0BdFbjv6ivqfaYZM6lYyygo3Yu8JhJJ0TBiZqeSzf6
         vctJyRB/tE2euyLMeOyDI7GsIQhtlJMO6lFuQVnE=
Subject: FAILED: patch "[PATCH] ipmi:ipmb: Fix refcount leak in ipmi_ipmb_probe" failed to apply to 5.17-stable tree
To:     linmq006@gmail.com, cminyard@mvista.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 06 Jun 2022 13:47:17 +0200
Message-ID: <1654516037116239@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
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


The patch below does not apply to the 5.17-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From a508e33956b538e034ed5df619a73ec7c15bda72 Mon Sep 17 00:00:00 2001
From: Miaoqian Lin <linmq006@gmail.com>
Date: Thu, 12 May 2022 08:44:45 +0400
Subject: [PATCH] ipmi:ipmb: Fix refcount leak in ipmi_ipmb_probe

of_parse_phandle() returns a node pointer with refcount
incremented, we should use of_node_put() on it when done.
Add missing of_node_put() to avoid refcount leak.

Fixes: 00d93611f002 ("ipmi:ipmb: Add the ability to have a separate slave and master device")
Signed-off-by: Miaoqian Lin <linmq006@gmail.com>
Message-Id: <20220512044445.3102-1-linmq006@gmail.com>
Cc: stable@vger.kernel.org # v5.17+
Signed-off-by: Corey Minyard <cminyard@mvista.com>

diff --git a/drivers/char/ipmi/ipmi_ipmb.c b/drivers/char/ipmi/ipmi_ipmb.c
index 7a83fbb4e379..ab19b4b3317e 100644
--- a/drivers/char/ipmi/ipmi_ipmb.c
+++ b/drivers/char/ipmi/ipmi_ipmb.c
@@ -475,6 +475,7 @@ static int ipmi_ipmb_probe(struct i2c_client *client)
 	slave_np = of_parse_phandle(dev->of_node, "slave-dev", 0);
 	if (slave_np) {
 		slave_adap = of_get_i2c_adapter_by_node(slave_np);
+		of_node_put(slave_np);
 		if (!slave_adap) {
 			dev_notice(&client->dev,
 				   "Could not find slave adapter\n");

