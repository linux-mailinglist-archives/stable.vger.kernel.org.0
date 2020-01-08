Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D4468134C27
	for <lists+stable@lfdr.de>; Wed,  8 Jan 2020 20:53:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727825AbgAHTuI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 8 Jan 2020 14:50:08 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:43424 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730399AbgAHTqB (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 8 Jan 2020 14:46:01 -0500
Received: from [192.168.4.242] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1ipHHB-0006nq-R3; Wed, 08 Jan 2020 19:45:57 +0000
Received: from ben by deadeye with local (Exim 4.93)
        (envelope-from <ben@decadent.org.uk>)
        id 1ipHHB-007dl9-8r; Wed, 08 Jan 2020 19:45:57 +0000
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        "Pawel Wodkowski" <pawelx.wodkowski@intel.com>,
        "Arnd Bergmann" <arnd@arndb.de>,
        "Chuanxiao Dong" <chuanxiao.dong@intel.com>,
        "Ulf Hansson" <ulf.hansson@linaro.org>,
        "Yuan Juntao" <juntaox.yuan@intel.com>
Date:   Wed, 08 Jan 2020 19:43:07 +0000
Message-ID: <lsq.1578512578.553539263@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 09/63] mmc: debugfs: Add a restriction to mmc debugfs
 clock setting
In-Reply-To: <lsq.1578512578.117275639@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.242
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

3.16.81-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Chuanxiao Dong <chuanxiao.dong@intel.com>

commit e5905ff1281f0a0f5c9863c430ac1ed5faaf5707 upstream.

Clock frequency values written to an mmc host should not be less than
the minimum clock frequency which the mmc host supports.

Signed-off-by: Yuan Juntao <juntaox.yuan@intel.com>
Signed-off-by: Pawel Wodkowski <pawelx.wodkowski@intel.com>
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Cc: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/mmc/core/debugfs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/mmc/core/debugfs.c
+++ b/drivers/mmc/core/debugfs.c
@@ -195,7 +195,7 @@ static int mmc_clock_opt_set(void *data,
 	struct mmc_host *host = data;
 
 	/* We need this check due to input value is u64 */
-	if (val > host->f_max)
+	if (val != 0 && (val > host->f_max || val < host->f_min))
 		return -EINVAL;
 
 	mmc_claim_host(host);

