Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 06A9C4BDCCE
	for <lists+stable@lfdr.de>; Mon, 21 Feb 2022 18:42:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347091AbiBUJD2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Feb 2022 04:03:28 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:58050 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348186AbiBUJCY (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 21 Feb 2022 04:02:24 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EDEF32B248;
        Mon, 21 Feb 2022 00:57:42 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B10ECB80EB7;
        Mon, 21 Feb 2022 08:57:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC602C340E9;
        Mon, 21 Feb 2022 08:57:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1645433836;
        bh=rokptrUqyaAJxAqsK0Nb4wu+vt33Umkfp6lUiUybKu0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cRJs+M3Q0wdbLOH4+POQ6PukS4IMy9E07QLJ1cX8/xY9cYm3Db1PPQDCpqSeTgI1L
         LvS2lutFNLC/3yBAhszntka+pc+31DTFiezJisH+8OgPxUTIN/qjnHlOHg9ZElWilN
         ns3vrY0B5zg7h7MNakprkR4u7RyflP4FXpN2HGyE=
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
Subject: [PATCH 4.19 17/58] iwlwifi: fix use-after-free
Date:   Mon, 21 Feb 2022 09:49:10 +0100
Message-Id: <20220221084912.444718683@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220221084911.895146879@linuxfoundation.org>
References: <20220221084911.895146879@linuxfoundation.org>
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
@@ -1549,6 +1549,8 @@ static void iwl_req_fw_callback(const st
  out_unbind:
 	complete(&drv->request_firmware_complete);
 	device_release_driver(drv->trans->dev);
+	/* drv has just been freed by the release */
+	failure = false;
  free:
 	if (failure)
 		iwl_dealloc_ucode(drv);


