Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6BBAD42DC45
	for <lists+stable@lfdr.de>; Thu, 14 Oct 2021 16:55:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232297AbhJNO5u (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 14 Oct 2021 10:57:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:42606 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232193AbhJNO5e (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 14 Oct 2021 10:57:34 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 85B7360F4A;
        Thu, 14 Oct 2021 14:55:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1634223330;
        bh=VF5lKsLQQsITUR//vef+l4lwrc7TTkYf8hXoH096Z8I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rKZgZRsUJse8u1vMZrmuTRIUi3XIPdgUSao4mqqlSYUogkrBJT/BQVdmvUbsR6WfY
         e4RRkzlpDeocy0iwhGDgTSW8DkZb9e6KyUj0Us4gSQQvu1rw2cGHd0iQZEA3cV7XkE
         eZzNJo2oTCdacI81O2WAVMrqPCm8tsv55pO2fPuM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Stefan Assmann <sassmann@redhat.com>,
        Jiri Benc <jbenc@redhat.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Dave Switzer <david.switzer@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 10/18] i40e: fix endless loop under rtnl
Date:   Thu, 14 Oct 2021 16:53:42 +0200
Message-Id: <20211014145206.653594767@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211014145206.330102860@linuxfoundation.org>
References: <20211014145206.330102860@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jiri Benc <jbenc@redhat.com>

[ Upstream commit 857b6c6f665cca9828396d9743faf37fd09e9ac3 ]

The loop in i40e_get_capabilities can never end. The problem is that
although i40e_aq_discover_capabilities returns with an error if there's
a firmware problem, the returned error is not checked. There is a check for
pf->hw.aq.asq_last_status but that value is set to I40E_AQ_RC_OK on most
firmware problems.

When i40e_aq_discover_capabilities encounters a firmware problem, it will
encounter the same problem on its next invocation. As the result, the loop
becomes endless. We hit this with I40E_ERR_ADMIN_QUEUE_TIMEOUT but looking
at the code, it can happen with a range of other firmware errors.

I don't know what the correct behavior should be: whether the firmware
should be retried a few times, or whether pf->hw.aq.asq_last_status should
be always set to the encountered firmware error (but then it would be
pointless and can be just replaced by the i40e_aq_discover_capabilities
return value). However, the current behavior with an endless loop under the
rtnl mutex(!) is unacceptable and Intel has not submitted a fix, although we
explained the bug to them 7 months ago.

This may not be the best possible fix but it's better than hanging the whole
system on a firmware bug.

Fixes: 56a62fc86895 ("i40e: init code and hardware support")
Tested-by: Stefan Assmann <sassmann@redhat.com>
Signed-off-by: Jiri Benc <jbenc@redhat.com>
Reviewed-by: Jesse Brandeburg <jesse.brandeburg@intel.com>
Tested-by: Dave Switzer <david.switzer@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/i40e/i40e_main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/intel/i40e/i40e_main.c b/drivers/net/ethernet/intel/i40e/i40e_main.c
index d6d4faa5c542..2137c4e7289e 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_main.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_main.c
@@ -6574,7 +6574,7 @@ static int i40e_get_capabilities(struct i40e_pf *pf)
 		if (pf->hw.aq.asq_last_status == I40E_AQ_RC_ENOMEM) {
 			/* retry with a larger buffer */
 			buf_len = data_size;
-		} else if (pf->hw.aq.asq_last_status != I40E_AQ_RC_OK) {
+		} else if (pf->hw.aq.asq_last_status != I40E_AQ_RC_OK || err) {
 			dev_info(&pf->pdev->dev,
 				 "capability discovery failed, err %s aq_err %s\n",
 				 i40e_stat_str(&pf->hw, err),
-- 
2.33.0



