Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C6F8654160E
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 22:46:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1359697AbiFGUpU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 16:45:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35578 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1359731AbiFGUnu (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 16:43:50 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 84BE01F42B3;
        Tue,  7 Jun 2022 11:39:08 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E26F76157B;
        Tue,  7 Jun 2022 18:38:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EFBA9C385A2;
        Tue,  7 Jun 2022 18:38:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654627116;
        bh=ZB5KUxuvNQ0yTaFTUxeKiF3Scpi+CLvkddXIlq4z0cY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=G9DhyQBoOe9XVgzwc6Gh0Y/VMC461s4pqmJtQCicwZ384UEGQCBpbv2Meb2vXVXof
         Sw0B4ilsJlxPg7r+a1CnaPv5qWCWJM3TZQD+rLR4LDuK/hzeHY2WDe9giAgNKMirLw
         +xch6hY+v9X+gV/TdzghqBcdYu2cYBCfwYHc7uqM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Avraham Stern <avraham.stern@intel.com>,
        Gregory Greenman <gregory.greenman@intel.com>,
        Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 5.17 623/772] iwlwifi: mei: clear the sap data header before sending
Date:   Tue,  7 Jun 2022 19:03:35 +0200
Message-Id: <20220607165007.294243307@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607164948.980838585@linuxfoundation.org>
References: <20220607164948.980838585@linuxfoundation.org>
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

From: Avraham Stern <avraham.stern@intel.com>

commit 55cf10488d7a9fa1b1b473a5e44a80666932e094 upstream.

The SAP data header has some fields that are marked as reserved
but are actually in use by CSME. Clear those fields before sending
the data to avoid having random values in those fields.

Cc: stable@vger.kernel.org
Signed-off-by: Avraham Stern <avraham.stern@intel.com>
Signed-off-by: Gregory Greenman <gregory.greenman@intel.com>
Link: https://lore.kernel.org/r/20220517120045.8dd3423cf683.I02976028eaa6aab395cb2e701fa7127212762eb7@changeid
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/wireless/intel/iwlwifi/mei/main.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/net/wireless/intel/iwlwifi/mei/main.c
+++ b/drivers/net/wireless/intel/iwlwifi/mei/main.c
@@ -493,6 +493,7 @@ void iwl_mei_add_data_to_ring(struct sk_
 	if (cb_tx) {
 		struct iwl_sap_cb_data *cb_hdr = skb_push(skb, sizeof(*cb_hdr));
 
+		memset(cb_hdr, 0, sizeof(*cb_hdr));
 		cb_hdr->hdr.type = cpu_to_le16(SAP_MSG_CB_DATA_PACKET);
 		cb_hdr->hdr.len = cpu_to_le16(skb->len - sizeof(cb_hdr->hdr));
 		cb_hdr->hdr.seq_num = cpu_to_le32(atomic_inc_return(&mei->sap_seq_no));


