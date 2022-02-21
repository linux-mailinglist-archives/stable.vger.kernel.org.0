Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E71554BE297
	for <lists+stable@lfdr.de>; Mon, 21 Feb 2022 18:55:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348588AbiBUJWt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Feb 2022 04:22:49 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:36978 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350296AbiBUJWY (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 21 Feb 2022 04:22:24 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 26BCB381A1;
        Mon, 21 Feb 2022 01:09:50 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id CA733CE0E90;
        Mon, 21 Feb 2022 09:09:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BDFE4C340E9;
        Mon, 21 Feb 2022 09:09:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1645434586;
        bh=Z+xi7bC3ntFi0PSLrUt7NI9L/jZSrVX0ZJFPUFi/gSM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZD6fnUnRp1m7wrj9CqUSNFTz2Gi2KMHvrROg789kpYzbo2Jor7mgdCEm3xGrKWBQL
         tY3LvLpgJfYDpKC/EVlNW45u4y4SDh5OceRFrgSluYq64IL2UCFfLHaR+p+T7dllxD
         sb8MSOFaOXYD5P4rNyG2NIKZsnm5fyLVN8X1OGSk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Stefan Agner <stefan@agner.ch>,
        Wolfgang Walter <linux@stwm.de>,
        Jason Self <jason@bluehome.net>,
        Dominik Behr <dominik@dominikbehr.com>,
        =?UTF-8?q?Marek=20Marczykowski-G=C3=B3recki?= 
        <marmarek@invisiblethingslab.com>,
        Johannes Berg <johannes.berg@intel.com>,
        Kalle Valo <kvalo@kernel.org>
Subject: [PATCH 5.15 060/196] iwlwifi: fix use-after-free
Date:   Mon, 21 Feb 2022 09:48:12 +0100
Message-Id: <20220221084932.947082490@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220221084930.872957717@linuxfoundation.org>
References: <20220221084930.872957717@linuxfoundation.org>
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

From: Johannes Berg <johannes.berg@intel.com>

commit bea2662e7818e15d7607d17d57912ac984275d94 upstream.

If no firmware was present at all (or, presumably, all of the
firmware files failed to parse), we end up unbinding by calling
device_release_driver(), which calls remove(), which then in
iwlwifi calls iwl_drv_stop(), freeing the 'drv' struct. However
the new code I added will still erroneously access it after it
was freed.

Set 'failure=false' in this case to avoid the access, all data
was already freed anyway.

Cc: stable@vger.kernel.org
Reported-by: Stefan Agner <stefan@agner.ch>
Reported-by: Wolfgang Walter <linux@stwm.de>
Reported-by: Jason Self <jason@bluehome.net>
Reported-by: Dominik Behr <dominik@dominikbehr.com>
Reported-by: Marek Marczykowski-Górecki <marmarek@invisiblethingslab.com>
Fixes: ab07506b0454 ("iwlwifi: fix leaks/bad data after failed firmware load")
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Kalle Valo <kvalo@kernel.org>
Link: https://lore.kernel.org/r/20220208114728.e6b514cf4c85.Iffb575ca2a623d7859b542c33b2a507d01554251@changeid
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/wireless/intel/iwlwifi/iwl-drv.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/net/wireless/intel/iwlwifi/iwl-drv.c
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-drv.c
@@ -1614,6 +1614,8 @@ static void iwl_req_fw_callback(const st
  out_unbind:
 	complete(&drv->request_firmware_complete);
 	device_release_driver(drv->trans->dev);
+	/* drv has just been freed by the release */
+	failure = false;
  free:
 	if (failure)
 		iwl_dealloc_ucode(drv);


