Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DCC3E498B72
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 20:13:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236461AbiAXTNm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 14:13:42 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:41294 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345985AbiAXTLr (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 14:11:47 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5FB0660917;
        Mon, 24 Jan 2022 19:11:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 26F05C340E7;
        Mon, 24 Jan 2022 19:11:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643051504;
        bh=k21YH/uuN8XFtF3EbvXNG34739hKfvE7WtQ6riUioMw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=agBFyL9rMi0VT7+Hr01ACFCZture83+kE1usEUdCzGOpTtHc0EC7YhF/2HP7thZS+
         OgxEsMz05FHfiWDjEdx0ebKKiWtRtkabYXfzy2qbJFtOaBjzZYB1+Ch9ZG4uGJ2Ovs
         2iLzro+bCqm+vBzJrR31VpYOmKv9YVm+vQsNgdU4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ilan Peer <ilan.peer@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Subject: [PATCH 4.14 151/186] iwlwifi: mvm: Increase the scan timeout guard to 30 seconds
Date:   Mon, 24 Jan 2022 19:43:46 +0100
Message-Id: <20220124183941.961355122@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124183937.101330125@linuxfoundation.org>
References: <20220124183937.101330125@linuxfoundation.org>
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
@@ -1364,7 +1364,7 @@ static int iwl_mvm_check_running_scans(s
 	return -EIO;
 }
 
-#define SCAN_TIMEOUT 20000
+#define SCAN_TIMEOUT 30000
 
 void iwl_mvm_scan_timeout_wk(struct work_struct *work)
 {


