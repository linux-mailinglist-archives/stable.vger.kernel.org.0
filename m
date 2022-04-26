Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 424F650F8FE
	for <lists+stable@lfdr.de>; Tue, 26 Apr 2022 11:44:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234085AbiDZJGc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 Apr 2022 05:06:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57326 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347115AbiDZJFP (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 26 Apr 2022 05:05:15 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 82AB0FAD9D;
        Tue, 26 Apr 2022 01:44:08 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B87BFB81D1C;
        Tue, 26 Apr 2022 08:44:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 28FAFC385A0;
        Tue, 26 Apr 2022 08:44:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1650962645;
        bh=c4tV8qVMiEPhY0Aru+SR6B5J65uqhDU1LrLy5WMOB+A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qK/Xf17KdKuqOibmMix55OlrU7MDrDHr1Uo5xwX5i51xYgWwDnKP36ct/8J8/KZY6
         eJufuM6Hv/uVnQYzNHEoHsPC0YiN5nQ2WBNkV0PS/iQK29/JgGW5SfItvX3UlQaIXE
         GNomokC63/sV/hszCAD6ElHjUDsTvUm/3Hz8lZzI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kurt Kanzenbach <kurt@linutronix.de>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 041/146] net: dsa: hellcreek: Calculate checksums in tagger
Date:   Tue, 26 Apr 2022 10:20:36 +0200
Message-Id: <20220426081751.223955523@linuxfoundation.org>
X-Mailer: git-send-email 2.36.0
In-Reply-To: <20220426081750.051179617@linuxfoundation.org>
References: <20220426081750.051179617@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kurt Kanzenbach <kurt@linutronix.de>

[ Upstream commit 0763120b090418a5257402754e22a34227ae5f12 ]

In case the checksum calculation is offloaded to the DSA master network
interface, it will include the switch trailing tag. As soon as the switch strips
that tag on egress, the calculated checksum is wrong.

Therefore, add the checksum calculation to the tagger (if required) before
adding the switch tag. This way, the hellcreek code works with all DSA master
interfaces regardless of their declared feature set.

Fixes: 01ef09caad66 ("net: dsa: Add tag handling for Hirschmann Hellcreek switches")
Signed-off-by: Kurt Kanzenbach <kurt@linutronix.de>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
Link: https://lore.kernel.org/r/20220415103320.90657-1-kurt@linutronix.de
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/dsa/tag_hellcreek.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/net/dsa/tag_hellcreek.c b/net/dsa/tag_hellcreek.c
index f64b805303cd..eb204ad36eee 100644
--- a/net/dsa/tag_hellcreek.c
+++ b/net/dsa/tag_hellcreek.c
@@ -21,6 +21,14 @@ static struct sk_buff *hellcreek_xmit(struct sk_buff *skb,
 	struct dsa_port *dp = dsa_slave_to_port(dev);
 	u8 *tag;
 
+	/* Calculate checksums (if required) before adding the trailer tag to
+	 * avoid including it in calculations. That would lead to wrong
+	 * checksums after the switch strips the tag.
+	 */
+	if (skb->ip_summed == CHECKSUM_PARTIAL &&
+	    skb_checksum_help(skb))
+		return NULL;
+
 	/* Tag encoding */
 	tag  = skb_put(skb, HELLCREEK_TAG_LEN);
 	*tag = BIT(dp->index);
-- 
2.35.1



