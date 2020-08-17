Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7222C2469E3
	for <lists+stable@lfdr.de>; Mon, 17 Aug 2020 17:27:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729880AbgHQP1V (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Aug 2020 11:27:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:38532 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729876AbgHQP1T (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 Aug 2020 11:27:19 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2F50F23110;
        Mon, 17 Aug 2020 15:27:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597678038;
        bh=Csng0A6LeL/hjBrrThmxVvQ6iJFty4yTRjf2Pxy9sJI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tJGi2jmPmNmwA+UegkONLJ63dPHSvhW9BM9JmJSb2mfUZVS1sJqriAsCCLYnmsEdL
         cGDeQwNEO/aaOw5MsYuUsSdIvCSU9lbBxNDP4+hero5ww/bOluY2MpPHuHCKTIdO27
         u0iYKv/9MtRic9leP18qpUF9L3cLXo1KEwBNd5Ck=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tony Nguyen <anthony.l.nguyen@intel.com>,
        Andrew Bowers <andrewx.bowers@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.8 198/464] iavf: Fix updating statistics
Date:   Mon, 17 Aug 2020 17:12:31 +0200
Message-Id: <20200817143843.306266537@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200817143833.737102804@linuxfoundation.org>
References: <20200817143833.737102804@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tony Nguyen <anthony.l.nguyen@intel.com>

[ Upstream commit 9358076642f14cec8c414850d5a909cafca3a9d6 ]

Commit bac8486116b0 ("iavf: Refactor the watchdog state machine") inverted
the logic for when to update statistics. Statistics should be updated when
no other commands are pending, instead they were only requested when a
command was processed. iavf_request_stats() would see a pending request
and not request statistics to be updated. This caused statistics to never
be updated; fix the logic.

Fixes: bac8486116b0 ("iavf: Refactor the watchdog state machine")
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Tested-by: Andrew Bowers <andrewx.bowers@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/iavf/iavf_main.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/intel/iavf/iavf_main.c b/drivers/net/ethernet/intel/iavf/iavf_main.c
index bc83e2d999442..d338efe5f3f55 100644
--- a/drivers/net/ethernet/intel/iavf/iavf_main.c
+++ b/drivers/net/ethernet/intel/iavf/iavf_main.c
@@ -1948,7 +1948,10 @@ static void iavf_watchdog_task(struct work_struct *work)
 				iavf_send_api_ver(adapter);
 			}
 		} else {
-			if (!iavf_process_aq_command(adapter) &&
+			/* An error will be returned if no commands were
+			 * processed; use this opportunity to update stats
+			 */
+			if (iavf_process_aq_command(adapter) &&
 			    adapter->state == __IAVF_RUNNING)
 				iavf_request_stats(adapter);
 		}
-- 
2.25.1



