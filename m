Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 309B04BE174
	for <lists+stable@lfdr.de>; Mon, 21 Feb 2022 18:53:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347050AbiBUJDZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Feb 2022 04:03:25 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:59958 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348063AbiBUJCR (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 21 Feb 2022 04:02:17 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 333552AE31;
        Mon, 21 Feb 2022 00:57:30 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6FBA0B80EB0;
        Mon, 21 Feb 2022 08:57:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ADC80C340E9;
        Mon, 21 Feb 2022 08:57:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1645433825;
        bh=ayBA+JOMEhE7qYzAKjNDLAdlwScjlpp/KMXI+tHUAZg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Cy7Q1MIWjDS/I/9NU5xv7de7p03gkNQa8/GOr/bo2YGFT/enau8X/sRnNmEy7kZPB
         HviXBaPI4uO5SeZCu85Ha5k36hZK0HZrUFJxfhBEKoxd5wLxmUtLTqXyfpB7ioevLV
         OkIaVDf/A7e89of7gYQMeR4a1NnzUCcw7Cej4CHQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Johannes Berg <johannes.berg@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>,
        Kalle Valo <kvalo@kernel.org>
Subject: [PATCH 4.19 23/58] iwlwifi: pcie: fix locking when "HW not ready"
Date:   Mon, 21 Feb 2022 09:49:16 +0100
Message-Id: <20220221084912.631412691@linuxfoundation.org>
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

commit e9848aed147708a06193b40d78493b0ef6abccf2 upstream.

If we run into this error path, we shouldn't unlock the mutex
since it's not locked since. Fix this.

Fixes: a6bd005fe92d ("iwlwifi: pcie: fix RF-Kill vs. firmware load race")
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
Signed-off-by: Kalle Valo <kvalo@kernel.org>
Link: https://lore.kernel.org/r/iwlwifi.20220128142706.5d16821d1433.Id259699ddf9806459856d6aefbdbe54477aecffd@changeid
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/wireless/intel/iwlwifi/pcie/trans.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/drivers/net/wireless/intel/iwlwifi/pcie/trans.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/trans.c
@@ -1363,8 +1363,7 @@ static int iwl_trans_pcie_start_fw(struc
 	/* This may fail if AMT took ownership of the device */
 	if (iwl_pcie_prepare_card_hw(trans)) {
 		IWL_WARN(trans, "Exit HW not ready\n");
-		ret = -EIO;
-		goto out;
+		return -EIO;
 	}
 
 	iwl_enable_rfkill_int(trans);


