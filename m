Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8C047505081
	for <lists+stable@lfdr.de>; Mon, 18 Apr 2022 14:23:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238720AbiDRM0N (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Apr 2022 08:26:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33520 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238655AbiDRMZg (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 18 Apr 2022 08:25:36 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4662520BEC;
        Mon, 18 Apr 2022 05:19:36 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8EE8A60F0A;
        Mon, 18 Apr 2022 12:19:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 990EFC385A1;
        Mon, 18 Apr 2022 12:19:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1650284375;
        bh=nPwFMTObJZF4cTLhVCXsSyXs7ixQvWyzMUK/7568deg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oifCUZBIJtIaBI0/OLYdQ6/lYfCg5X02ewUSR7DkSIABB2FidCnpljgFswg4+irh0
         OmHLBCK6iXuIegShMPWZAWr0zIoM1l1kyQUtVw0r54PMr+UaVlEYuuv/jwtrD0Ld1d
         CGtIOFcrfkeOn2wF+JvKRhn9Qc+JhR0nmRou/How=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Karsten Graul <kgraul@linux.ibm.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 094/219] net/smc: use memcpy instead of snprintf to avoid out of bounds read
Date:   Mon, 18 Apr 2022 14:11:03 +0200
Message-Id: <20220418121209.336563326@linuxfoundation.org>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <20220418121203.462784814@linuxfoundation.org>
References: <20220418121203.462784814@linuxfoundation.org>
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

From: Karsten Graul <kgraul@linux.ibm.com>

[ Upstream commit b1871fd48efc567650dbdc974e5a2342a03fe0d2 ]

Using snprintf() to convert not null-terminated strings to null
terminated strings may cause out of bounds read in the source string.
Therefore use memcpy() and terminate the target string with a null
afterwards.

Fixes: fa0866625543 ("net/smc: add support for user defined EIDs")
Fixes: 3c572145c24e ("net/smc: add generic netlink support for system EID")
Signed-off-by: Karsten Graul <kgraul@linux.ibm.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/smc/smc_clc.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/net/smc/smc_clc.c b/net/smc/smc_clc.c
index ce27399b38b1..f9f3f59c79de 100644
--- a/net/smc/smc_clc.c
+++ b/net/smc/smc_clc.c
@@ -191,7 +191,8 @@ static int smc_nl_ueid_dumpinfo(struct sk_buff *skb, u32 portid, u32 seq,
 			  flags, SMC_NETLINK_DUMP_UEID);
 	if (!hdr)
 		return -ENOMEM;
-	snprintf(ueid_str, sizeof(ueid_str), "%s", ueid);
+	memcpy(ueid_str, ueid, SMC_MAX_EID_LEN);
+	ueid_str[SMC_MAX_EID_LEN] = 0;
 	if (nla_put_string(skb, SMC_NLA_EID_TABLE_ENTRY, ueid_str)) {
 		genlmsg_cancel(skb, hdr);
 		return -EMSGSIZE;
@@ -252,7 +253,8 @@ int smc_nl_dump_seid(struct sk_buff *skb, struct netlink_callback *cb)
 		goto end;
 
 	smc_ism_get_system_eid(&seid);
-	snprintf(seid_str, sizeof(seid_str), "%s", seid);
+	memcpy(seid_str, seid, SMC_MAX_EID_LEN);
+	seid_str[SMC_MAX_EID_LEN] = 0;
 	if (nla_put_string(skb, SMC_NLA_SEID_ENTRY, seid_str))
 		goto err;
 	read_lock(&smc_clc_eid_table.lock);
-- 
2.35.1



