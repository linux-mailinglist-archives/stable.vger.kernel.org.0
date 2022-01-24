Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4D91749913B
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 21:12:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1378837AbiAXUJz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 15:09:55 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:47992 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348481AbiAXUDy (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 15:03:54 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 03253B810AF;
        Mon, 24 Jan 2022 20:03:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 285A3C340E5;
        Mon, 24 Jan 2022 20:03:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643054631;
        bh=LQm4QQc6Vgl5DIjwrQyP6wFXQa7I4UmfCDLYWKaa/SU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=asi5nIvn7/ti63HNTs9rs9D7q6oK59Y8XYvWNZTGLFeLVtQj1p5MUlPUt0VruZcYu
         B5dZLUt97sSN8hWLGOHih7vsYP3HN78b9XEAAhh+ujPF8Ab+TnxZKRrOw85sogPzsZ
         rwR8YCa0vi8wMfhNQw3jJqeoNyY35nGT9GWUfKqg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ilan Peer <ilan.peer@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Subject: [PATCH 5.10 452/563] iwlwifi: mvm: Increase the scan timeout guard to 30 seconds
Date:   Mon, 24 Jan 2022 19:43:37 +0100
Message-Id: <20220124184040.077391893@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184024.407936072@linuxfoundation.org>
References: <20220124184024.407936072@linuxfoundation.org>
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
@@ -2157,7 +2157,7 @@ static int iwl_mvm_check_running_scans(s
 	return -EIO;
 }
 
-#define SCAN_TIMEOUT 20000
+#define SCAN_TIMEOUT 30000
 
 void iwl_mvm_scan_timeout_wk(struct work_struct *work)
 {


