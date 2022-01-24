Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BE51C499219
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 21:19:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1381006AbiAXURZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 15:17:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34406 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344625AbiAXUNq (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 15:13:46 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA60DC0604D6;
        Mon, 24 Jan 2022 11:37:11 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 41C7A61515;
        Mon, 24 Jan 2022 19:37:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 27847C340E5;
        Mon, 24 Jan 2022 19:37:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643053030;
        bh=5vWYp7qQngVJfxFk9KUiSt3vvkHtUkiSXrq/kc/duEM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=clEYfLh8Wbn18xnBz484lDJNaAadC1LG2fsUvQKFTKUGQi/Y3qT6HQP0TQPT3qoPg
         PsaTBeAdKcqkQWyTqjutf2kUliGltWL/MMjfUY6k09d5TxCG8ZApg9OVC83Qhgcy5x
         a8e/ILj3xQvgv1LMOIwwfqmrxou5QspLtRU8c9UY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ilan Peer <ilan.peer@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Subject: [PATCH 5.4 254/320] iwlwifi: mvm: Increase the scan timeout guard to 30 seconds
Date:   Mon, 24 Jan 2022 19:43:58 +0100
Message-Id: <20220124184002.631982996@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124183953.750177707@linuxfoundation.org>
References: <20220124183953.750177707@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ilan Peer <ilan.peer@intel.com>

commit ced50f1133af12f7521bb777fcf4046ca908fb77 upstream.

With the introduction of 6GHz channels the scan guard timeout should
be adjusted to account for the following extreme case:

- All 6GHz channels are scanned passively: 58 channels.
- The scan is fragmented with the following parameters: 3 fragments,
  95 TUs suspend time, 44 TUs maximal out of channel time.

The above would result with scan time of more than 24 seconds. Thus,
set the timeout to 30 seconds.

Cc: stable@vger.kernel.org
Signed-off-by: Ilan Peer <ilan.peer@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
Link: https://lore.kernel.org/r/iwlwifi.20211210090244.3c851b93aef5.I346fa2e1d79220a6770496e773c6f87a2ad9e6c4@changeid
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/wireless/intel/iwlwifi/mvm/scan.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/net/wireless/intel/iwlwifi/mvm/scan.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/scan.c
@@ -1700,7 +1700,7 @@ static int iwl_mvm_check_running_scans(s
 	return -EIO;
 }
 
-#define SCAN_TIMEOUT 20000
+#define SCAN_TIMEOUT 30000
 
 void iwl_mvm_scan_timeout_wk(struct work_struct *work)
 {


