Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6E6974BDED4
	for <lists+stable@lfdr.de>; Mon, 21 Feb 2022 18:47:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347178AbiBUJGH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Feb 2022 04:06:07 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:48328 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234441AbiBUJFh (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 21 Feb 2022 04:05:37 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 706F025C7A;
        Mon, 21 Feb 2022 00:59:02 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0D11461132;
        Mon, 21 Feb 2022 08:59:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E86C0C340F1;
        Mon, 21 Feb 2022 08:59:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1645433941;
        bh=wVBKcepK6ofvfIi4wuqL8gC+94QFVq/5PWNf8Z/HNFM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sBgTiXg9k8eZo+pzcHrnZQr27lj3xKx62d1lIhBW0r3zYaYEZ2m4htWGx++eTZgDf
         vQph05mmfSpB3hPlJeDxaA+YW529NoxrPQGwkl2YAa33x3yTZfPhtwk2In90D+kPbe
         Py3/mCrWZL1BcNMgksvg2oR4DKto7Ip0tNJs74Qc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Johannes Berg <johannes.berg@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>,
        Kalle Valo <kvalo@kernel.org>
Subject: [PATCH 5.4 37/80] iwlwifi: pcie: gen2: fix locking when "HW not ready"
Date:   Mon, 21 Feb 2022 09:49:17 +0100
Message-Id: <20220221084916.785633438@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220221084915.554151737@linuxfoundation.org>
References: <20220221084915.554151737@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Johannes Berg <johannes.berg@intel.com>

commit 4c29c1e27a1e178a219b3877d055e6dd643bdfda upstream.

If we run into this error path, we shouldn't unlock the mutex
since it's not locked since. Fix this in the gen2 code as well.

Fixes: eda50cde58de ("iwlwifi: pcie: add context information support")
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
Signed-off-by: Kalle Valo <kvalo@kernel.org>
Link: https://lore.kernel.org/r/iwlwifi.20220128142706.b8b0dfce16ef.Ie20f0f7b23e5911350a2766524300d2915e7b677@changeid
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/wireless/intel/iwlwifi/pcie/trans-gen2.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/drivers/net/wireless/intel/iwlwifi/pcie/trans-gen2.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/trans-gen2.c
@@ -292,8 +292,7 @@ int iwl_trans_pcie_gen2_start_fw(struct
 	/* This may fail if AMT took ownership of the device */
 	if (iwl_pcie_prepare_card_hw(trans)) {
 		IWL_WARN(trans, "Exit HW not ready\n");
-		ret = -EIO;
-		goto out;
+		return -EIO;
 	}
 
 	iwl_enable_rfkill_int(trans);


