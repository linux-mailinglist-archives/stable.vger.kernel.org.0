Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 53BDB541DBB
	for <lists+stable@lfdr.de>; Wed,  8 Jun 2022 00:22:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1382004AbiFGWVt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 18:21:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49796 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1384242AbiFGWUT (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 18:20:19 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 358332632AE;
        Tue,  7 Jun 2022 12:20:49 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0DED560907;
        Tue,  7 Jun 2022 19:20:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 16DACC385A5;
        Tue,  7 Jun 2022 19:20:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654629638;
        bh=ZB5KUxuvNQ0yTaFTUxeKiF3Scpi+CLvkddXIlq4z0cY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1gnxW557vtIskEm9smjrUApV4jHbMGZ+RPw1yaXJu8reY133528/nat+oEjncByxy
         vFS5otkmc9RDnAUF+qunUZ+Knr8mI+QWyXoYD5CPCXa/VFby/2mc2+K0VGfrHY6Aor
         Nv4XYRXa7vC/jtrdZ6w40BWJLCVvNTQkg2rhq+LU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Avraham Stern <avraham.stern@intel.com>,
        Gregory Greenman <gregory.greenman@intel.com>,
        Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 5.18 722/879] iwlwifi: mei: clear the sap data header before sending
Date:   Tue,  7 Jun 2022 19:04:00 +0200
Message-Id: <20220607165023.811326528@linuxfoundation.org>
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


