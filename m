Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7EE054BE2B8
	for <lists+stable@lfdr.de>; Mon, 21 Feb 2022 18:55:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351617AbiBUJtw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Feb 2022 04:49:52 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:42606 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353017AbiBUJsH (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 21 Feb 2022 04:48:07 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 265F3220DC;
        Mon, 21 Feb 2022 01:22:18 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 81F03CE0E95;
        Mon, 21 Feb 2022 09:22:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5EEB7C340E9;
        Mon, 21 Feb 2022 09:22:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1645435334;
        bh=nq4RGDjMqlFVwtDTrTSQfcMRT5Kyveke7zxrDBK+h7U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=S/A35OwUo8AjZas3PpRMYTQErzpfbtDyL+ij4BtfHFwknw3bM6vIAaON4EotfdQPg
         ju1hlGgy6U/WfLJvALyuPVsslzTTXmamwOpz7yqJ5C8pjnsCERpdA+Kig8ItNBHtmN
         ZpISf86Uu3cc3TigxIjukygIHiqyTAdb7S1tXkEg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tom Rix <trix@redhat.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.16 128/227] dpaa2-switch: fix default return of dpaa2_switch_flower_parse_mirror_key
Date:   Mon, 21 Feb 2022 09:49:07 +0100
Message-Id: <20220221084939.106577173@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220221084934.836145070@linuxfoundation.org>
References: <20220221084934.836145070@linuxfoundation.org>
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

From: Tom Rix <trix@redhat.com>

commit 2a36ed7c1cd55742503bed81d2cc0ea83bd0ad0c upstream.

Clang static analysis reports this representative problem
dpaa2-switch-flower.c:616:24: warning: The right operand of '=='
  is a garbage value
  tmp->cfg.vlan_id == vlan) {
                   ^  ~~~~
vlan is set in dpaa2_switch_flower_parse_mirror_key(). However
this function can return success without setting vlan.  So
change the default return to -EOPNOTSUPP.

Fixes: 0f3faece5808 ("dpaa2-switch: add VLAN based mirroring")
Signed-off-by: Tom Rix <trix@redhat.com>
Reviewed-by: Ioana Ciornei <ioana.ciornei@nxp.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/freescale/dpaa2/dpaa2-switch-flower.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/net/ethernet/freescale/dpaa2/dpaa2-switch-flower.c
+++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-switch-flower.c
@@ -532,6 +532,7 @@ static int dpaa2_switch_flower_parse_mir
 	struct flow_rule *rule = flow_cls_offload_flow_rule(cls);
 	struct flow_dissector *dissector = rule->match.dissector;
 	struct netlink_ext_ack *extack = cls->common.extack;
+	int ret = -EOPNOTSUPP;
 
 	if (dissector->used_keys &
 	    ~(BIT(FLOW_DISSECTOR_KEY_BASIC) |
@@ -561,9 +562,10 @@ static int dpaa2_switch_flower_parse_mir
 		}
 
 		*vlan = (u16)match.key->vlan_id;
+		ret = 0;
 	}
 
-	return 0;
+	return ret;
 }
 
 static int


