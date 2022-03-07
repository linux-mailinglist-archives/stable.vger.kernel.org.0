Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 02B224CF831
	for <lists+stable@lfdr.de>; Mon,  7 Mar 2022 10:52:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238395AbiCGJwL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Mar 2022 04:52:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53872 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239337AbiCGJtg (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Mar 2022 04:49:36 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A8D16E54C;
        Mon,  7 Mar 2022 01:43:11 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DD578B8102B;
        Mon,  7 Mar 2022 09:43:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 36EC4C340E9;
        Mon,  7 Mar 2022 09:43:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1646646180;
        bh=kRj+XBMOcfrG227XydWXXvppgPuI8HRuN5RwQWY38uM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QZyX91A9BtzkTdZUy+oZGTwz7SJQYOUGUX0SBYz2mC1qr9TuS6SivOcq/m5YSIdwQ
         XKgZH9k8vFa9l5bBzoyadpK1+or9Eao8DRRdsWmThMzyrshqzizGdd+A2I35N+s95K
         a7kW9dG0F1WdddNNcZlsn6inAr9VjIfOuefU7gGw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Thomas Bogendoerfer <tbogendoerfer@suse.de>,
        Sasha Neftin <sasha.neftin@intel.com>,
        Naama Meir <naamax.meir@linux.intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>
Subject: [PATCH 5.15 158/262] e1000e: Correct NVM checksum verification flow
Date:   Mon,  7 Mar 2022 10:18:22 +0100
Message-Id: <20220307091706.893870394@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220307091702.378509770@linuxfoundation.org>
References: <20220307091702.378509770@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sasha Neftin <sasha.neftin@intel.com>

commit ffd24fa2fcc76ecb2e61e7a4ef8588177bcb42a6 upstream.

Update MAC type check e1000_pch_tgp because for e1000_pch_cnp,
NVM checksum update is still possible.
Emit a more detailed warning message.

Bugzilla: https://bugzilla.opensuse.org/show_bug.cgi?id=1191663
Fixes: 4051f68318ca ("e1000e: Do not take care about recovery NVM checksum")
Reported-by: Thomas Bogendoerfer <tbogendoerfer@suse.de>
Signed-off-by: Sasha Neftin <sasha.neftin@intel.com>
Tested-by: Naama Meir <naamax.meir@linux.intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/intel/e1000e/ich8lan.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/net/ethernet/intel/e1000e/ich8lan.c
+++ b/drivers/net/ethernet/intel/e1000e/ich8lan.c
@@ -4136,9 +4136,9 @@ static s32 e1000_validate_nvm_checksum_i
 		return ret_val;
 
 	if (!(data & valid_csum_mask)) {
-		e_dbg("NVM Checksum Invalid\n");
+		e_dbg("NVM Checksum valid bit not set\n");
 
-		if (hw->mac.type < e1000_pch_cnp) {
+		if (hw->mac.type < e1000_pch_tgp) {
 			data |= valid_csum_mask;
 			ret_val = e1000_write_nvm(hw, word, 1, &data);
 			if (ret_val)


